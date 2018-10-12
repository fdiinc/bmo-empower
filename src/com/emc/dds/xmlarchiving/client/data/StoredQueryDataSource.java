/*******************************************************************************
 * Copyright (c) 2015 EMC Corporation. All Rights Reserved.
 *******************************************************************************/
package com.emc.dds.xmlarchiving.client.data;

import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.google.gwt.regexp.shared.RegExp;

import com.emc.dds.xmlarchiving.client.configuration.SearchField;
import com.emc.dds.xmlarchiving.client.configuration.SearchSetting;
import com.emc.documentum.xml.dds.gwt.client.AbstractDDSXQueryDataSource;
import com.emc.documentum.xml.dds.gwt.client.rpc.persistence.SerializableElement;
import com.emc.documentum.xml.dds.gwt.client.rpc.persistence.SerializableXDBException;
import com.emc.documentum.xml.dds.gwt.client.rpc.persistence.SerializableXQueryValue;
import com.emc.documentum.xml.dds.gwt.client.ui.LoadingDialog;
import com.emc.documentum.xml.gwt.client.xml.XMLParser;

public class StoredQueryDataSource extends AbstractDDSXQueryDataSource {

    private static final String WHERE_CLAUSE_COMMENT_TO_INSERT = "(: xmlarchiving-insert-where-clause-parameter-values :)";

    private static final String WHERE_CLAUSE_COMMENT_TO_APPEND = "(: xmlarchiving-append-where-clause-parameter-values :)";

    private static final String CURRENT_USER = "currentuser";

    private static final String START_VARIABLE_SECTION = "(: dynamic variables :)";

    private static final String RESTRICTIONS = "restrictions";

    private static final String FIRST = "first";

    private static final String LAST = "last";

    private static final String ARG = "%ARG%";

    private static final String INPUT = "input";

    private String xquery;

    private int count;

    private SearchSetting searchSetting;

    private String currentUserName;

    private Map<String, String> fields;

    private String formInput;

    private boolean insertWhereClause;

    private boolean appendWhereClause;

    private String restrictions;

    public StoredQueryDataSource(String xquery, String formInput, SearchSetting searchSetting, String currentUserName,
            String restrictions) {

        super();
        this.formInput = formInput;
        this.searchSetting = searchSetting;
        this.currentUserName = currentUserName;
        insertWhereClause = xquery.indexOf(WHERE_CLAUSE_COMMENT_TO_INSERT) != -1;
        appendWhereClause = xquery.indexOf(WHERE_CLAUSE_COMMENT_TO_APPEND) != -1;
        this.xquery = injectXFormData(xquery);
        this.restrictions = restrictions;
    }

    private Collection<String> getSearchFieldKeys() {

        return searchSetting.getSearchConfiguration().getSearchFields().keySet();
    }

    private Set<Entry<String, SearchField>> getSearchFieldEntries() {

        return searchSetting.getSearchConfiguration().getSearchFields().entrySet();
    }

    private void setFields() {

        fields = new LinkedHashMap<String, String>();
        Element xformsInstance = XMLParser.parse(formInput).getDocumentElement();
        for (String fieldName : getSearchFieldKeys()) {
            NodeList fieldNodes = xformsInstance.getElementsByTagName(fieldName);
            if (fieldNodes.getLength() > 0) {

                /*
                 * Flatirons fix: XQuery external variables are required to be set, resulting in a fatal exception when not set.
                 *
                 * To address this, the fields map now unconditionally has an entry for each XForm search field, supplying null if
                 * the user doesn't give a value.
                 */
                String userSuppliedText = null;
                Node firstChild = fieldNodes.item(0).getFirstChild();
                if (firstChild != null) {
                    userSuppliedText = firstChild.getNodeValue();
                }
                userSuppliedText = escapeUserSuppliedText(userSuppliedText);
                fields.put(fieldName, userSuppliedText);
            }
        }
        fields.put(INPUT, formInput);
    }

    /**
     * Note: result is non-null, returning the empty string if the input is null.
     *
     * @param userSuppliedText
     * @return
     */
    private static String escapeUserSuppliedText(String userSuppliedText) {

        return userSuppliedText != null ? userSuppliedText.replace("\"", "&quot;").replace("\'", "&quot;") : "";
    }

    public Map<String, String> getFields() {

        if (fields == null) {
            setFields();
        }
        return fields;
    }

    public String getFormInput() {

        return formInput;
    }

    private static Set<String> getPredefinedFields() {

        HashSet<String> set = new HashSet<String>();
        set.add(CURRENT_USER);
        set.add(RESTRICTIONS);
        set.add(FIRST);
        set.add(LAST);
        set.add(INPUT);
        return set;
    }

    private boolean needsWhereClause() {

        if (getFields().isEmpty()) {
            return false;
        }
        Set<String> predefined = getPredefinedFields();
        for (String fieldName : getFields().keySet()) {
            if (!predefined.contains(fieldName)) {
                return true;
            }
        }
        return false;
    }

    private String injectXFormData(final String query) {

        String result = insertWhereClause(query);
        result = insertVariables(result);
        result = injectFlexibleCode(result);
        result = purgeComentFlags(result);
        return result;
    }

    private static String purgeComentFlags(String result) {

        return result.replaceAll("\\(: \\w+ :\\)", "");
    }

    private String insertVariables(String query) {

        String result = query;
        StringBuffer variablesBuffer = new StringBuffer();
        Map<String, String> variables = getFields();
        // Loop through all the fields
        for (Entry<String, SearchField> entry : getSearchFieldEntries()) {
            String fieldName = entry.getKey();
            SearchField field = entry.getValue();
            // If the field is supposed to be added as a variable to the XQuery
            if (field.addAsVariable()) {
                String value = variables.get(fieldName);
                // If the field was undefined, add an empty variable
                if ((value == null) || "".equalsIgnoreCase(value)) {
                    variablesBuffer.append("declare variable $");
                    variablesBuffer.append(fieldName);
                    variablesBuffer.append("Var := '';\n");
                } else {
                    variablesBuffer.append("declare variable $");
                    variablesBuffer.append(fieldName);
                    variablesBuffer.append("Var := '");
                    variablesBuffer.append(value);
                    variablesBuffer.append("';\n");
                }
            }
        }

        int queryIndex = result.indexOf(START_VARIABLE_SECTION);
        if ((queryIndex != -1) && (variablesBuffer.length() > 0)) {
            String firstPart = result.substring(0, queryIndex);
            String lastPart = result.substring(queryIndex + START_VARIABLE_SECTION.length());
            result = firstPart + variablesBuffer.toString() + lastPart;
        }

        return result;
    }

    private String insertWhereClause(String query) {

        String result = query;
        StringBuffer sb = new StringBuffer();
        if (insertWhereClause && needsWhereClause()) {
            sb.append("where ");
        }

        if (insertWhereClause || appendWhereClause) {

            Map<String, String> variables = getFields();
            boolean previous = false;
            if (!needsWhereClause()) {
                return query;
            }
            for (Entry<String, SearchField> entry : getSearchFieldEntries()) {
                String fieldName = entry.getKey();
                String fieldValue = variables.get(fieldName);
                SearchField field = entry.getValue();
                if (variables.containsKey(fieldName)) {
                    if (!"".equals(field.getXQuery()) && !"".equals(fieldValue)) {
                        sb.append(prepareQueryPart(field, fieldValue, fieldName, !previous, appendWhereClause,
                                isFunction(field.getXQuery())));
                        previous = true;
                    }
                }
            }
        }

        // replace all
        while (true) {
            int index = -1;
            if (insertWhereClause) {
                index = result.indexOf(WHERE_CLAUSE_COMMENT_TO_INSERT);
            } else if (appendWhereClause) {
                index = result.indexOf(WHERE_CLAUSE_COMMENT_TO_APPEND);
            }

            if (index != -1) {
                String firstPart = result.substring(0, index);
                String lastPart = "";
                if (insertWhereClause) {
                    lastPart = result.substring(index + WHERE_CLAUSE_COMMENT_TO_INSERT.length());
                } else if (appendWhereClause) {
                    lastPart = result.substring(index + WHERE_CLAUSE_COMMENT_TO_APPEND.length());
                }

                // Flexible code may not have added any items to the where clause
                if ("where ".equalsIgnoreCase(sb.toString())) {
                    result = firstPart + lastPart;
                } else {
                    result = firstPart + sb.toString() + lastPart;
                }
            } else {
                break;
            }
        }
        return result;
    }

    public static String prepareQueryPart(SearchField field, String value, String fieldName, boolean isFirstValue,
            boolean isAppendValues, boolean isFunction) {

        String strType = field.getType();
        String strQuery = field.getXQuery();
        String strOperator = field.getOperator();
        String strPreparedValue = "";

        if ((strType == null) || (strType.length() < 1)) {
            strType = "string";
        }

        strPreparedValue = value;
        // boolean isFlexibleCode = field.getFlexibleCode().length() > 0;
        if (strType.equals("int")) {
            strPreparedValue = value;
        }
        if (strType.equals("string")) {

            if (field.isFullText()) {
                if (strPreparedValue.indexOf(".*") < 1) {
                    strPreparedValue = strPreparedValue + ".*";
                }
                strPreparedValue = field.getXQuery() + " contains text '" + strPreparedValue + "' using wildcards";
            } else if (!strOperator.equals("multi-or")) {
                strPreparedValue = "'" + strPreparedValue + "'";
            }

        } else if (strType.equals("date")) {
            // Check for dates e.g. 2008-02-14T09:45:00
            /*
             * Pattern pDate1 = Pattern.compile("[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]T[0-1][0-9]:[0-5][0-9]:[0-5][0-9]");
             * Matcher m = pDate1.matcher(value);
             */
            RegExp pDate1 = RegExp.compile("[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]T[0-1][0-9]:[0-5][0-9]:[0-5][0-9]");
            boolean match = pDate1.test(value);
            if (match) {
                strPreparedValue = "xs:dateTime('" + value + "')";
            }

            // check for dates e.g., 2008-02-14
            pDate1 = RegExp.compile("[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]");
            match = pDate1.test(value);
            if (match) {

                strPreparedValue = "xs:dateTime('" + value + "T00:00:00')";
            }
        } else if (isFunction) {
            StringBuffer sb2 = new StringBuffer();
            sb2.append('\'');
            sb2.append(value);
            sb2.append('\'');
            strPreparedValue = value.replaceAll(ARG, sb2.toString());
            return strPreparedValue;
        } else {
            strPreparedValue = value;
        }

        if (strOperator.equals("multi-or")) {
            String[] values = value.split(" ");
            StringBuffer sbStmt = new StringBuffer();
            sbStmt.append("(");
            if (values.length == 1) {
                strOperator = "=";
                strPreparedValue = "'" + strPreparedValue + "'";
            } else {
                for (int iAt = 0; iAt < values.length; iAt++) {
                    if (strType.equals("string")) {
                        sbStmt.append(strQuery + " = '" + values[iAt] + "'");
                    } else if (strType.equals("int")) {
                        sbStmt.append(strQuery + " = " + values[iAt]);
                    }

                    if (iAt < (values.length - 1)) {
                        sbStmt.append(" or ");
                    }
                }
                sbStmt.append(")");
                strPreparedValue = sbStmt.toString();
            }
        }

        // boolean needsAnd = (!isFirstValue || isAppendValues) && !strOperator.equals("multi-or");

        if (!isFirstValue || isAppendValues) {
            if ("multi-or".equals(strOperator) || field.isFullText()) {
                strPreparedValue = " and " + strPreparedValue;
            } else {
                strPreparedValue = " and " + strQuery + " " + strOperator + " " + strPreparedValue;
            }
        } else if (isFirstValue && !"multi-or".equals(strOperator) && !field.isFullText()) {
            strPreparedValue = strQuery + " " + strOperator + " " + strPreparedValue;
        }
        return strPreparedValue;
    }

    private String injectFlexibleCode(final String query) {

        String result = query;

        Map<String, String> xformValues = getFields();
        for (Entry<String, SearchField> entry : getSearchFieldEntries()) {
            String fieldName = entry.getKey();
            SearchField field = entry.getValue();

            // if the field supplies a code part, inject it
            String code = field.getFlexibleCode();
            if (xformValues.containsKey(fieldName)) {
                // Replace the arg flags with the xform values
                if ((code == null) || code.isEmpty()) {
                    code = xformValues.get(fieldName);
                } else {
                    code = code.replace(ARG, xformValues.get(fieldName));
                }
                String target = createReplacementPattern(fieldName);
                result = result.replace(target, code);
            }
        }
        return result;
    }

    private static String createReplacementPattern(String fieldName) {

        StringBuilder b = new StringBuilder();
        b.append("(: ");
        b.append(fieldName);
        b.append(" :)");
        return b.toString();
    }

    /**
     * test if the xquery where has a %ARG% in it. If it does it is a function.
     *
     * @param query
     * @return true or false
     */
    private static boolean isFunction(String xquery) {

        if (xquery == null) {
            return false;
        }
        int index = xquery.indexOf(ARG);
        if (index == -1) {
            return false;
        }
        return true;

    }

    @Override
    protected String getURI(SerializableXQueryValue contextValue) {

        return null;
    }

    @Override
    protected Map<String, String> getVariables(SerializableXQueryValue contextValue) {

        return getFields();
    }

    // Made public for Export to Excel
    @Override
    public String getXQuery(SerializableXQueryValue contextValue) {

        Map<String, String> variables = getFields();
        int lastItem = getLast();
        variables.put(FIRST, "" + (getFirst() + 1));
        variables.put(LAST, "" + (lastItem == -1 ? -1 : lastItem + 1));
        variables.put(CURRENT_USER, currentUserName);
        variables.put(RESTRICTIONS, restrictions);
        return xquery;
    }

    // excel surfaced currentUserName
    public String getCurrentUserName() {

        return currentUserName;
    }

    public String getRestrictions() {

        return restrictions;
    }

    @Override
    public StoredQueryDataSource cloneDataSource() {

        return new StoredQueryDataSource(xquery, formInput, searchSetting, currentUserName, restrictions);
    }

    @Override
    public SerializableXQueryValue getParent(SerializableXQueryValue userObject) {

        return null;
    }

    @Override
    public void onSuccess(List<SerializableXQueryValue> result) {
        LoadingDialog.hide("search");

        if (result.size() == 1) {
            SerializableElement element = null;
            try {
                element = (SerializableElement) result.get(0).asNode();
            } catch (SerializableXDBException e) {
                e.printStackTrace();
            }
            String total = element.getAttribute("total");
            count = Integer.parseInt(total);
        } else {
            count = -1;
        }
        setData(result, count);
    }

    @Override
    public void refresh() {

        super.refresh();
    }
}

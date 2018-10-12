/*******************************************************************************
 * Copyright (c) 2015 EMC Corporation. All Rights Reserved.
 *******************************************************************************/
package com.emc.dds.xmlarchiving.client.ui;

import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.emc.dds.xmlarchiving.client.authorization.Role;
import com.emc.dds.xmlarchiving.client.configuration.ApplicationSettings;
import com.emc.dds.xmlarchiving.client.configuration.ApplicationState;
import com.emc.dds.xmlarchiving.client.configuration.ContentViewSetting;
import com.emc.dds.xmlarchiving.client.configuration.NestedSearch;
import com.emc.dds.xmlarchiving.client.configuration.NodeSetting;
import com.emc.dds.xmlarchiving.client.configuration.Report;
import com.emc.dds.xmlarchiving.client.configuration.SearchConfiguration;
import com.emc.dds.xmlarchiving.client.configuration.SearchResultItem;
import com.emc.dds.xmlarchiving.client.configuration.SearchSetting;
import com.emc.dds.xmlarchiving.client.data.StoredQueryDataSource;
import com.emc.dds.xmlarchiving.client.event.ApplicationEvent;
import com.emc.dds.xmlarchiving.client.event.DetailsClearEvent;
import com.emc.dds.xmlarchiving.client.event.NestedSearchSubmitEvent;
import com.emc.dds.xmlarchiving.client.event.SearchResultItemSelectedEvent;
import com.emc.dds.xmlarchiving.client.event.SearchSubmitEvent;
import com.emc.dds.xmlarchiving.client.event.UserLoggedIn;
import com.emc.dds.xmlarchiving.client.i18n.Locale;
import com.emc.dds.xmlarchiving.client.rpc.UserInfoService;
import com.emc.dds.xmlarchiving.client.rpc.UserInfoServiceAsync;
import com.emc.dds.xmlarchiving.client.ui.SearchResultAndDetailsPanel.SearchResultAndDetailsMode;
import com.emc.dds.xmlarchiving.client.ui.image.MainImageBundle;
import com.emc.documentum.xml.dds.gwt.client.LogCenterFailureListener;
import com.emc.documentum.xml.dds.gwt.client.rpc.DDSServices;
import com.emc.documentum.xml.dds.gwt.client.rpc.LogCenterServiceAsync;
import com.emc.documentum.xml.dds.gwt.client.rpc.persistence.SerializableElement;
import com.emc.documentum.xml.dds.gwt.client.rpc.persistence.SerializableXDBException;
import com.emc.documentum.xml.dds.gwt.client.rpc.persistence.SerializableXQueryValue;
import com.emc.documentum.xml.dds.gwt.client.ui.LoadingDialog;
import com.emc.documentum.xml.gwt.client.DataChangeListener;
import com.emc.documentum.xml.gwt.client.Dialog;
import com.emc.documentum.xml.gwt.client.FailureHandler;
import com.emc.documentum.xml.gwt.client.SourcesDataChangeEvents;
import com.emc.documentum.xml.gwt.client.ui.Button;
import com.emc.documentum.xml.gwt.client.ui.DialogBox;
import com.emc.documentum.xml.gwt.client.ui.PagingBar;
import com.emc.documentum.xml.gwt.client.ui.table.FlexTable;
import com.emc.documentum.xml.gwt.client.ui.table.TableSelection;
import com.emc.documentum.xml.gwt.client.xml.XMLParser;
import com.google.gwt.core.client.GWT;
import com.google.gwt.dom.client.Style.TextDecoration;
import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.i18n.shared.DateTimeFormat;
import com.google.gwt.user.client.Timer;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.HTMLTable.RowFormatter;
import com.google.gwt.user.client.ui.HasHorizontalAlignment;
import com.google.gwt.user.client.ui.HorizontalPanel;
import com.google.gwt.user.client.ui.Image;
import com.google.gwt.user.client.ui.Label;
import com.google.gwt.user.client.ui.Panel;
import com.google.gwt.user.client.ui.PopupPanel;
import com.google.gwt.user.client.ui.ScrollPanel;
import com.google.gwt.user.client.ui.VerticalPanel;
import com.google.gwt.user.client.ui.Widget;

/**
 * Abstract search result pane to be used as base class for search result panes. WARNING: This class is experimental and may change
 * in future DDS releases.
 */
public abstract class AbstractSearchResultPane extends ContentPane implements DataChangeListener {

    /**
     * Flatirons: Attribute name for XQuery root results element. Value is a space separated list of column names, identifying which
     * columns to show in the search results UI.
     */
    private static final String ATTR_RESULTS_NESTED_SEARCHES = "nestedSearches";

    /**
     * Flatirons: Attribute name for XQuery root results element. Value is a space separated list of nested search names,
     * identifying which nested search columns to show in the search results UI.
     */
    private static final String ATTR_RESULTS_COLUMNS = "searchResultItems";

    /**
     * Flatirons: Attribute name for XQuery root results element. Value is boolean true/false. When true
     * the first result's details are shown, as if clicked.
     */
    private static final String ATTR_RESULTS_LAUNCH_FIRST_RESULT_DETAILS = "launchFirstResultDetails";

    /**
     * Flatirons: Attribute name for XQuery root results element. Value is boolean true/false. When false
     * this search results pane is hidden from the UI.  This attribute is intended to be used with
     * {@link #ATTR_RESULTS_LAUNCH_FIRST_RESULT_DETAILS} and with exactly one search result because
     * other results will be inaccessible.
     */
    private static final String ATTR_RESULTS_HIDE_SEARCH_RESULT_PANE = "hideSearchResultPane";

    /**
     * Flatirons: Attribute name for XQuery root results element. Value is boolean true/false. When true only
     * the search results pane will be shown, in full width.
     */
    private static final String ATTR_RESULTS_HIDE_DETAILS_PANE = "hideDetailsPane";

    protected class RetrieveReportResult implements AsyncCallback<List<SerializableXQueryValue>> {

        private String configurationId;

        public RetrieveReportResult(String configurationId) {

            this.configurationId = configurationId;
        }

        @Override
        public void onFailure(Throwable caught) {

            FailureHandler.handle(this, caught);
        }

        @Override
        public void onSuccess(List<SerializableXQueryValue> result) {

            ContentViewSetting previewSetting = getApplicationSettings().getContentViewSettings().get(configurationId);
            if (previewSetting == null) {
                Dialog.alert(Locale.getMessages().noContentViewSettingFound(configurationId), MainImageBundle.INSTANCE.error48()
                        .createImage());
            } else {
                SerializableXQueryValue value = result.get(0);
                SerializableElement resultElt = null;
                try {
                    resultElt = (SerializableElement) value.asNode();
                    contentViewPane.displayData(resultElt.toXML(), previewSetting, "Report", true, null);
                } catch (SerializableXDBException e) {
                    FailureHandler.handle(this, e);
                }
            }
        }
    }

    static final String HEADER_TEXT = Locale.getLabels().searchResult();

    static final DateTimeFormat DATE_FORMAT = DateTimeFormat.getFormat("EEEE, MMMM dd, yyyy");

    final ContentViewPane contentViewPane;

    private SearchResultAndDetailsPanel parentContainer;

    private FlexTable searchResults = new FlexTable();

    private PagingBar pagingBar;

    protected static StoredQueryDataSource dataSource;

    private final VerticalPanel listPanel;

    private final ScrollPanel searchResultScrollPanel;

    private int maxListCount = 20;

    private int truncateLabels = 100;

    // This configuration may not be the same as represented by the search pane.
    private SearchSetting currentSearchSetting;

    private String currentLocale;

    private NodeSetting currentSetting;

    private final UserInfoServiceAsync userInfoService = (UserInfoServiceAsync)GWT.create(UserInfoService.class);

    /**
     * Constructs an abstract search result pane.
     *
     * @param applicationSettings
     *            the application settings shared by the panes.
     */
    public AbstractSearchResultPane(ApplicationSettings applicationSettings, ContentViewPane contentViewPane, int maxListCount,
            int truncateLabels) {

        super(applicationSettings);
        searchResultScrollPanel = new ScrollPanel();
        listPanel = new VerticalPanel();
        listPanel.add(searchResults);
        this.pagingBar = new PagingBar(null, getMaxListCount());
//        pagingBar = new PagingBar(null, getMaxListCount()) {
//            /**
//             * {@inheritDoc}
//             */
//            @Override
//            public void onDataChange(SourcesDataChangeEvents sender) {
//
//                UserLoggedIn.cancelTimer();
//                UserLoggedIn.restartTimer();
//                super.onDataChange(sender);
//            }
//        };
        listPanel.add(pagingBar);
        searchResultScrollPanel.add(listPanel);
        this.contentViewPane = contentViewPane;
        searchResults.getSelection().setType(TableSelection.SELECT_MULTIPLE);
        currentSearchSetting = applicationSettings.getState().getCurrentSearchSetting();
        currentLocale = applicationSettings.getState().getCurrentLocale();
        currentSetting = applicationSettings.getState().getCurrentSetting();
        if (maxListCount != -1) {
            this.maxListCount = maxListCount;
        }
        if (truncateLabels != -1) {
            this.truncateLabels = truncateLabels;
        }
        loadTable(null);
    }

    protected PagingBar getPagingBar() {

        return pagingBar;
    }

    @Override
    public NodeSetting getCurrentSetting() {

        return currentSetting;
    }

    public void init() {

    }

    public ContentViewPane getContentViewPane() {

        return contentViewPane;
    }

    @Override
    public String getPaneName() {

        return SEARCH_RESULT_PANE_NAME;
    }

    /**
     * Returns the top panel of this pane. It is called by its sub classes that wrap this panel.
     *
     * @return the top panel of this pane.
     */
    protected Panel getTopPanel() {

        return searchResultScrollPanel;
    }

    /**
     * Returns the height of the header. This information is needed to calculate the size of the search result pane.
     *
     * @return the height of the header.
     */
    protected abstract int getHeaderHeight();

    public int getMaxListCount() {

        return maxListCount;
    }

    public void setMaxListCount(int maxListCount) {

        this.maxListCount = maxListCount;
    }

    public int getTruncateLabels() {

        return truncateLabels;
    }

    public void setTruncateLabels(int truncateLabels) {

        this.truncateLabels = truncateLabels;
    }

    public SearchResultAndDetailsPanel getParentContainer() {
        return parentContainer;
    }

    public void setParentContainer(SearchResultAndDetailsPanel parent) {
        this.parentContainer = parent;
    }

    /**
     * Insert the header with the <code>SearchResultItem</code> names into the table.
     */
    private void insertTableHeader(Map<String, SearchResultItem> searchResultItems, Map<String, NestedSearch> nestedSearches) {

        SearchConfiguration searchSetting = currentSearchSetting.getSearchConfiguration();
        Image image = MainImageBundle.INSTANCE.empty16().createImage();
        searchResults.setWidget(0, 0, image);
        int column = 1;
        searchResults.getRowFormatter().addStyleName(0, "header");
        for (SearchResultItem resultItem : searchResultItems.values()) {

            HTML label = getHeaderLabel(resultItem.getLabel());
            searchResults.setWidget(0, column, label);
            column++;
        }
        Role role = getApplicationSettings().getRole();
        for (NestedSearch nestedSearch : nestedSearches.values()) {

            if (role.hasOperationAuthorization(nestedSearch.getConfigurationId())) {
                HTML label = getHeaderLabel(nestedSearch.getLabel());
                searchResults.setWidget(0, column, label);
                column++;
            }
        }
        for (String key : searchSetting.getReports().keySet()) {
            Report report = searchSetting.getReports().get(key);
            if (role.hasOperationAuthorization(report.getId())) {
                HTML label = getHeaderLabel(report.getLabel());
                searchResults.setWidget(0, column, label);
                column++;
            }
        }
    }

    private HTML getHeaderLabel(String title) {

        HTML label = new HTML(title);
        label.addStyleName(STYLE_TABLE_HEADER_LABEL);
        return label;
    }

    /**
     * Load the search results into the table.
     *
     * @param results
     *            the results to be loaded into the table
     */
    protected int loadTable(List<SerializableXQueryValue> results) {

        if (currentSearchSetting == null) {
            return 0;
        }

        // Flatirons fix for NPE when results are null
        // Also, clear stale search results to indicate no records are loaded.
        searchResults.removeAllRows();
        if (results == null) {
            return 0;
        }
        // End flatirons fix

        SearchConfiguration searchSetting = currentSearchSetting.getSearchConfiguration();
        ApplicationSettings applicationSettings = getApplicationSettings();
        Role role = applicationSettings.getRole();
        // get root element of result
        SerializableXQueryValue rootNodeValue = results.get(0);
        Document doc = XMLParser.parse(rootNodeValue.asString());
        Element root = doc.getDocumentElement();

        // Flatirons Feature: "details only". When active, hide the search results and load the details panel.

        String launchFirstResultDetailsAttr = root.getAttribute(ATTR_RESULTS_LAUNCH_FIRST_RESULT_DETAILS);
        boolean launchFirstResultDetails = Boolean.parseBoolean(launchFirstResultDetailsAttr);

        String hideSearchResultPaneAttr = root.getAttribute(ATTR_RESULTS_HIDE_SEARCH_RESULT_PANE);
        boolean hideSearchResultPane = Boolean.parseBoolean(hideSearchResultPaneAttr); // true iff "true"

        String hideDetailsPaneAttr = root.getAttribute(ATTR_RESULTS_HIDE_DETAILS_PANE);
        boolean hideDetailsPane = Boolean.parseBoolean(hideDetailsPaneAttr);

        if (hideSearchResultPane ) {
            parentContainer.layout(SearchResultAndDetailsMode.DETAILS_ONLY);
        } else if(hideDetailsPane) {
            parentContainer.layout(SearchResultAndDetailsMode.SEARCH_RESULTS_ONLY);
        } else {
          SplitPanelSizing highPrioritySizing = new SplitPanelSizing();
          highPrioritySizing.setLeftSideWidth(root.getAttribute(CustomXmlNames.SEARCH_RESULTS_PANEL_WIDTH));
          highPrioritySizing.setRightSideWidth(root.getAttribute(CustomXmlNames.DETAILS_PANEL_WIDTH));
          SplitPanelSizing lowPrioritySizing = searchSetting.getResultsAndDetailsSizing();
          parentContainer.layout(SearchResultAndDetailsMode.BOTH, highPrioritySizing, lowPrioritySizing);
        }

        // Filter out the search results
        String searchResultItemsAttr = root.getAttribute(ATTR_RESULTS_COLUMNS);
        Map<String, SearchResultItem> searchResultItems;
        if (hasValue(searchResultItemsAttr)) {
            Map<String, SearchResultItem> superset = searchSetting.getSearchResultItems();
            searchResultItems = new LinkedHashMap<String, SearchResultItem>();
            String[] names = searchResultItemsAttr.split("\\s+");
            for (String name : names) {
                SearchResultItem searchResultItem = superset.get(name);
                if (searchResultItem == null) {
                    throw new RuntimeException("XQuery wants to display a regular column '" + name
                            + "' but no column is defined by that name");
                }
                searchResultItems.put(name, searchResultItem);
            }
        } else {
            searchResultItems = searchSetting.getSearchResultItems();
        }

        // Filter out the nested searches
        String nestedSearchesAttr = root.getAttribute(ATTR_RESULTS_NESTED_SEARCHES);
        Map<String, NestedSearch> nestedSearches = null;
        if (hasValue(nestedSearchesAttr)) {
            Map<String, NestedSearch> superset = searchSetting.getNestedSearches();
            nestedSearches = new LinkedHashMap<String, NestedSearch>();
            String[] names = nestedSearchesAttr.split("\\s+");
            for (String name : names) {
                NestedSearch nestedSearch = superset.get(name);
                if (nestedSearch == null) {
                    throw new RuntimeException("XQuery wants to display nested search column '" + name
                            + "' but no nested search defined by that name");
                }
                nestedSearches.put(name, nestedSearch);
            }
        } else {
            nestedSearches = searchSetting.getNestedSearches();
        }

        insertTableHeader(searchResultItems, nestedSearches);

        int totalResult = 0;
        if ((dataSource != null) && (dataSource.getCount() > 0)) {
            try {
                totalResult = dataSource.getCount();

                int row = 1;

                NodeList children = root.getChildNodes();
                final int numChildren = children.getLength();
                for (int k = 0; k < numChildren; k++) {
                    final Element resultElt = (Element) children.item(k);
                    final String uri = resultElt.getAttribute("uri");
                    final String title = resultElt.getAttribute("title");
                    final String type = resultElt.getAttribute("type");

                    Image image = MainImageBundle.INSTANCE.document16().createImage();
                    searchResults.setUserObject(row, resultElt.toString());
                    searchResults.setWidget(row, 0, image);

                    int column = 1;

                    final String locale = currentLocale;

                    final int currentRow = row;
                    final ClickHandler rowClickHandler = new ClickHandler() {
                        @Override
                        public void onClick(ClickEvent event) {

                            // Check if the user is still logged in
                            userInfoService.isUserLoggedIn(new UserLoggedIn() {

                              @Override
                              public void onLoggedIn() {
                            	// The user is still logged in
                                  fireEvent(new DetailsClearEvent(""));

                                  // The type attribute on a result element is technically a schemaId in a transformation configuration
                                  ContentViewSetting contentViewSetting = currentSetting.getContentViewSetting(getApplicationSettings(), type);

                                  boolean isPDF = false;
                                  if (contentViewSetting != null) {
                                    isPDF = contentViewSetting.isPdf();
                                  }

//                                  if (isPDF) {
//                                    LoadingDialog.show("pdf");
//                                  } else {
//                                    LoadingDialog.show("details");
//                                  }
                                  selectItem(currentRow, resultElt, locale);
                                  fireEvent(new SearchResultItemSelectedEvent(uri, type, title, locale));
                              }

                              @Override
                              public void onFailure(Throwable caught) {
                                FailureHandler.handle(this, caught);
                              }
                            });
                        }
                    };

                    // Flatirons: mimic a row click if the XQuery results desire it
                    if ((currentRow == 1) && launchFirstResultDetails && !hideDetailsPane) {
                        new Timer() {

                            @Override
                            public void run() {

                                rowClickHandler.onClick(null);
                            }
                        }.schedule(1);
                    }

                    for (Entry<String, SearchResultItem> entrySet : searchResultItems.entrySet()) {
                        String key = entrySet.getKey();

                        SearchResultItem resultItem = entrySet.getValue();
                        String label = resultElt.getAttribute(key);
                        if (resultItem.isDateInMilliseconds() && (label != null) && !"".equals(label)) {
                            label = DATE_FORMAT.format(new Date(Long.parseLong(label)));
                        }
                        if ((column == 1) && ((label == null) || "".equals(label))) {
                            // there should be at least one label
                            label = "No " + resultItem.getLabel();
                        }
                        String truncatedTitle;
                        if ((label == null) || (label.length() == 0)) {
                            truncatedTitle = " ";
                        } else if (label.length() > getTruncateLabels()) {
                            truncatedTitle = label.substring(0, getTruncateLabels()) + "...";
                        } else {
                            truncatedTitle = label;
                        }
                        Label entry = null;
                        // change to link if the text is download
                        if (key.equals("download")) {
                        	if (label.length() > 0) {
                        		entry = new Label("download");
                                entry.getElement().getStyle().setColor("blue");
                                entry.getElement().getStyle().setTextDecoration(TextDecoration.UNDERLINE);
                        	}
                        } else {
	                        // create a label for each result
                        	entry = new Label(truncatedTitle);
                        }
                        
                        searchResults.setWidget(row, column, entry);

                        // each label has a ClickListener that triggers the XProc display functionality
                    	if (key.equals("download")) {
                    		final Set<Entry<String, SearchResultItem>> result = searchResultItems.entrySet();
                    		final SearchResultItem _resultItem = resultItem;
                    		final String _label = label;
                    		entry.addClickHandler(new ClickHandler() {
								
								@Override
								public void onClick(ClickEvent event) {
									
									String[] l1 = _label.split(";");
									final StringBuffer buffer = new StringBuffer("/bmoglo/") //GWT.getModuleBaseURL()
										.append("bmoglo/BlobDownloader").append('?')
										.append("path=").append(l1[0])
										.append("&mimeType=").append(l1.length > 1 ? l1[1] : "application/octet-stream");
									
									Window.open(buffer.toString(), "_self", "enabled");
									
									LoadingDialog.show("download");
									
									userInfoService.onXProcComplete(new AsyncCallback<Void>() {

								        @Override
								        public void onSuccess(Void result) {
								          LoadingDialog.hide("download");
								        }

								        @Override
								        public void onFailure(Throwable caught) {
								          LoadingDialog.hide("download");
								        }
								  });
								}
							});
                    	} else if (!hideDetailsPane)  {
                    		entry.addClickHandler(rowClickHandler);
                    	}
                        column++;
                    }
                    for (Entry<String, NestedSearch> entry : nestedSearches.entrySet()) {

                        final NestedSearch nestedSearch = entry.getValue();
                        if (role.hasOperationAuthorization(nestedSearch.getConfigurationId())) {

                            final String nodeId = nestedSearch.getNodeId();
                            final String searchConfiguration = nestedSearch.getConfigurationId();
                            final Map<String, String> fields = new LinkedHashMap<String, String>();
                            final String detailedConfiguration = nestedSearch.getTransformationId();
                            final String nestedSearchTitle = nestedSearch.getLabel();
                            if (null != nestedSearch.getFields()) {
                                for (String fieldName : nestedSearch.getFields().keySet()) {
                                    String value = nestedSearch.getFields().get(fieldName);
                                    String searchValue = resultElt.getAttribute(value);
                                    fields.put(fieldName, searchValue);
                                }
                            }

                            Image searchIcon = MainImageBundle.INSTANCE.index22().createImage();
                            searchIcon.setTitle(nestedSearch.getDescription());
                            searchResults.setWidget(row, column, searchIcon);
                            searchResults.getCellFormatter().setHorizontalAlignment(row, column,
                                    HasHorizontalAlignment.ALIGN_CENTER);

                            final ContentViewSetting previewSetting =
                                    currentSetting.getContentViewSetting(applicationSettings, detailedConfiguration);

                            // each label has a ClickListener that triggers the XProc display functionality
                            searchIcon.addClickHandler(new ClickHandler() {

                                @Override
                                public void onClick(ClickEvent event) {

                                    /*
                                     * a click on a nested search event can either trigger a new search or it may trigger the
                                     * execution of an xproc pipeline to display detailed information in the content view pane. if a
                                     * nested search has a non-zero fields map (which implies mapping fields from this search result
                                     * to fields in the nested search, we execute a nested search. Otherwise, we call the
                                     * appropriate xproc pipeline to display more detailed information based on the item that's been
                                     * clicked
                                     */
                                    if (fields.size() > 0) {
                                        final String formInput = generateFormInput(nestedSearch, resultElt);
                                        final String nodeId = nestedSearch.getNodeId();
                                        final String searchConfiguration = nestedSearch.getConfigurationId();
                                        // TODO: handle all this in another way!!!!
                                        NestedSearchSubmitEvent nestedSearchEvent =
                                                new NestedSearchSubmitEvent(formInput, nodeId, searchConfiguration);
                                        handle(nestedSearchEvent);
                                        fireEvent(nestedSearchEvent);
                                    } else {
                                        // need to set the type value to be the name of the transformation
                                        // configuration..
                                        String transConfig = previewSetting.getSchemaIds()[0];
                                        contentViewPane.displayBusinessObject(nestedSearchTitle, transConfig, resultElt,
                                                previewSetting);
                                    }
                                }
                            });
                            column++;
                        }
                    }
                    for (String key : searchSetting.getReports().keySet()) {
                        Report report = searchSetting.getReports().get(key);
                        if (role.hasOperationAuthorization(report.getId())) {
                            final String previewConfiguration = report.getConfigurationId();
                            final Map<String, String> fields = new LinkedHashMap<String, String>();
                            if (report.getFields() != null) {
                                for (String fieldName : report.getFields().keySet()) {
                                    String value = report.getFields().get(fieldName);
                                    String searchValue = resultElt.getAttribute(value);
                                    fields.put(fieldName, searchValue);
                                }
                            }
                            Image reportIcon = MainImageBundle.INSTANCE.pdf22().createImage();
                            final String query = report.getQuery();
                            reportIcon.setTitle(report.getDescription());
                            searchResults.setWidget(row, column, reportIcon);
                            searchResults.getCellFormatter().setHorizontalAlignment(row, column,
                                    HasHorizontalAlignment.ALIGN_CENTER);
                            // each label has a ClickListener that triggers the XProc display functionality
                            reportIcon.addClickHandler(new ClickHandler() {

                                @Override
                                public void onClick(ClickEvent event) {

                                    if ((query != null) && !"".equals(query)) {
                                        DDSServices.getXQueryService().execute(uri, query, fields,
                                                new RetrieveReportResult(previewConfiguration));
                                    } else {

                                        contentViewPane.displayBusinessObject(title, type, resultElt, getApplicationSettings()
                                                .getContentViewSettings().get(previewConfiguration));

                                    }
                                }
                            });
                            column++;
                        }
                    }
                    row++;
                }
            } catch (Exception e) {
                Dialog.alert(Locale.getMessages().unexpectedError(e.getClass().getName() + "\nMessage: " + e.getMessage()), MainImageBundle.INSTANCE.error48()
                        .createImage());
            }
        } else {
            Label entry = new Label(Locale.getLabels().noResults());
            searchResults.setWidget(1, 0, MainImageBundle.INSTANCE.document16().createImage());
            searchResults.setWidget(1, 1, entry);
        }
        return totalResult;
    }

    private static boolean hasValue(String value) {

        return (value != null) && (value.length() > 0);
    }

    public void setTableItem(int row, int column, String value) {

        searchResults.setWidget(row, column, new Label(value));
    }

    public int getColumnWithHeaderName(String headerName) {

        for (int k = 0; k < searchResults.getCellCount(0); k++) {
            Widget widget = searchResults.getWidget(0, k);
            if ((widget instanceof Label) && ((Label) widget).getText().equals(headerName)) {
                return k;
            }
        }
        return -1;
    }

    /**
     * This function is called when the search is finished.
     */
    @Override
    public void onDataChange(SourcesDataChangeEvents sender) {

        List<SerializableXQueryValue> results = ((StoredQueryDataSource) sender).getList();
        loadTable(results);
    }

    protected StoredQueryDataSource getDataSource() {

        return dataSource;
    }

    protected TableSelection getTableSelection() {

        return searchResults.getSelection();
    }

    /**
     * Unselect items in the table.
     */
    protected void unselectItems() {

        RowFormatter rowFormatter = searchResults.getRowFormatter();
        for (int k = 1; k < searchResults.getRowCount(); k++) {
            rowFormatter.removeStyleName(k, "displayed");
        }
    }

    /**
     * Select item in table.
     *
     * @param row
     *            the row of the selected item
     */
    protected void selectItem(int row, Element resultElem, String locale) {

        searchResults.getRowFormatter().addStyleName(row, "displayed");
        contentViewPane.displayObject(resultElem, currentSetting);
    }

    /**
     * Show loading image during execution of search.
     */
    private void addLoadingItem() {

        Image image = new Image(GWT.getModuleBaseURL() + "core/standard/images/wait16.gif");
        searchResults.setWidget(1, 0, image);
        searchResults.setHTML(1, 1, Locale.getLabels().loading());
    }

    protected void clearItems() {
        searchResults.removeAllRows();
    }

    /**
     * Handles events.
     *
     * @param event
     *            to handle
     */
    @Override
    public void handle(final ApplicationEvent event) {

        super.handle(event);
        final ApplicationState state = getApplicationSettings().getState();
        switch (event.getType()) {
            case ApplicationEvent.SEARCH_SUBMIT_EVENT:
            	// Check if the user is still logged in
                userInfoService.isUserLoggedIn(new UserLoggedIn() {

                    @Override
                    public void onLoggedIn() {

                		// The user is still logged in
		                currentLocale = state.getCurrentLocale();
		                currentSearchSetting = state.getCurrentSearchSetting();
		                currentSetting = state.getCurrentSetting();
		                pagingBar = new PagingBar(null, getMaxListCount());
		                handleSearchSubmitEvent((SearchSubmitEvent) event, true);
                    }
                });
                break;
            case ApplicationEvent.NESTED_SEARCH_SUBMIT_EVENT:
            	// Check if the user is still logged in
                userInfoService.isUserLoggedIn(new UserLoggedIn() {

                    @Override
                    public void onLoggedIn() {

		                ApplicationSettings applicationSettings = getApplicationSettings();
		                NestedSearchSubmitEvent submitEvent = (NestedSearchSubmitEvent) event;
		                String searchConfig = submitEvent.getSearchConfiguration();
		                NodeSetting nodeSetting = applicationSettings.getNodeSettings().get(submitEvent.getNodeId());
		                for (SearchSetting searchSetting : nodeSetting.getSearchSettings().values()) {
		                    if (searchSetting.getSearchConfigurationId().equals(searchConfig)) {
		                        getState().setCurrentSearchSetting(searchSetting.getName());
		                        break;
		                    }
		                }
		                getState().setCurrentSetting(nodeSetting);
		                currentSearchSetting = state.getCurrentSearchSetting();
		                currentSetting = state.getCurrentSetting();
		                pagingBar = new PagingBar(null, getMaxListCount());
		                handleSearchSubmitEvent(submitEvent, true);
                    }
                });
                break;
            case ApplicationEvent.DIALOG_CLOSE_EVENT:
                unselectItems();
                break;
        }
    }

    protected void resubmit() {

        SearchSubmitEvent submitEvent = new SearchSubmitEvent(dataSource.getFormInput());
        handle(submitEvent);
    }

    private void handleSearchSubmitEvent(final SearchSubmitEvent submitEvent, final boolean clearContentView) {
    	userInfoService.isUserLoggedIn(new UserLoggedIn() {

            @Override
            public void onLoggedIn() {
		        ApplicationSettings applicationSettings = getApplicationSettings();
		        Role role = applicationSettings.getRole();

		        String xquery = currentSearchSetting.getSearchConfiguration().getXquery();
		        if ((xquery != null) && !"".equals(xquery)) {
		            String formInput = submitEvent.getFormInput();
		            dataSource =
		                    new StoredQueryDataSource(xquery, formInput, currentSearchSetting, applicationSettings.getUserName(), role
		                            .getUnauthorizedFields());

		            logRequest(applicationSettings.getHierarchy().getTitle(), currentSearchSetting, dataSource.getFields(),
		                    applicationSettings.getUserName(), "");
		        }

		        dataSource.addDataChangeListener(AbstractSearchResultPane.this);
		        searchResults.getSelection().clear();
		        searchResults.removeAllRows();
		        listPanel.add(searchResults);
		        // insertTableHeader();
		        addLoadingItem();
		        pagingBar.setDataSource(dataSource);
		        if (contentViewPane.isAttached() && clearContentView) {
		            showEmptyContentView();
		        }
            }

        });
    }

    private String generateFormInput(NestedSearch nestedSearch, Element sourceElt) {

        StringBuffer sb = new StringBuffer();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        sb.append("<data>\n");
        for (String fieldName : nestedSearch.getFields().keySet()) {
            String value = nestedSearch.getFields().get(fieldName);
            String searchValue = sourceElt.getAttribute(value);
            appendElement(sb, value, searchValue);
        }
        sb.append("</data>");
        return sb.toString();
    }

    private void appendElement(StringBuffer sb, String key, String value) {

        sb.append('<');
        sb.append(key);
        sb.append('>');
        sb.append(value);
        sb.append('<');
        sb.append('/');
        sb.append(key);
        sb.append('>');
        sb.append("\n");
    }

    void showEmptyContentView() {

        AbstractSearchResultPane.this.contentViewPane.displayData("<empty></empty>", getApplicationSettings()
                .getContentViewSettings().get("empty"), "", true, null);
    }

    // TODO CAS: replace this code with Dialog.alert method when
    // PDF frame no longer hides a popup dialog.
    void showErrorDialogWithPosition() {

        final DialogBox dialogBox = new DialogBox(false, true, false);
        dialogBox.addStyleName("core-Dialog-alert");
        VerticalPanel verticalPanel = new VerticalPanel();
        Button okButton = new Button(Locale.getLabels().ok());
        okButton.addClickHandler(new ClickHandler() {

            @Override
            public void onClick(ClickEvent event) {

                dialogBox.hide();
            }
        });
        okButton.addStyleName("core-Dialog-alert-ok");
        verticalPanel.add(new Label(Locale.getMessages().noDateAndDuration()));

        verticalPanel.add(okButton);
        verticalPanel.setCellHorizontalAlignment(okButton, HasHorizontalAlignment.ALIGN_RIGHT);

        HorizontalPanel horizontalPanel = new HorizontalPanel();
        horizontalPanel.add(MainImageBundle.INSTANCE.error48().createImage());
        horizontalPanel.add(verticalPanel);
        dialogBox.setWidget(horizontalPanel);
        dialogBox.setPopupPositionAndShow(new PopupPanel.PositionCallback() {

            @Override
            public void setPosition(int offsetWidth, int offsetHeight) {

                int left = (Window.getClientWidth() - offsetWidth) / 3;
                int top = (Window.getClientHeight() - offsetHeight) / 3;
                dialogBox.setPopupPosition(left, top);
            }
        });
        okButton.setFocus(true);
    }

    protected void logRequest(String appName, SearchSetting searchSetting, Map<String, String> fields, String currentUserName,
            String restrictions, String searchID) {

        // build up the string we'll put in the audit log
        //String searchID = searchSetting.getSearchConfigurationId();
        StringBuilder auditLogEntry = new StringBuilder();
        auditLogEntry.append("app : '");
        auditLogEntry.append(appName);
        auditLogEntry.append("', IRM_CODE : E10, user : ");
        auditLogEntry.append(currentUserName);
        auditLogEntry.append(", searchConfiguration : '");
        auditLogEntry.append(searchID);
        auditLogEntry.append("', fields : ");
        // Do work here on the formInput
        // build up the string we'll put in the audit log
        Iterator<String> params = fields.keySet().iterator();
        Iterator<String> values = fields.values().iterator();
        while (params.hasNext()) {
            auditLogEntry.append(params.next() + " = " + values.next());
            if (params.hasNext()) {
                auditLogEntry.append(", ");
            }
        }
        auditLogEntry.append(", role restrictions = '");
        auditLogEntry.append(restrictions);
        auditLogEntry.append("'");

        // String auditLogEntry = "app : '" + appName + "', IRM_CODE : E10, " + " user : " +
        // currentUserName + ", searchConfiguration : '" + searchID + "', fields : " + formInput +
        // ", role restrictions = '" + restrictions + "'";
        LogCenterServiceAsync logger = DDSServices.getLogCenterService();
        logger.log(auditLogEntry.toString(), loggerListener);
        System.out.println("==[AuditLog]: " + auditLogEntry.toString());
    }

    private void logRequest(String appName, SearchSetting searchSetting, Map<String, String> fields, String currentUserName,
            String restrictions) {

        // build up the string we'll put in the audit log
        String searchID = searchSetting.getSearchConfigurationId();
        StringBuilder auditLogEntry = new StringBuilder();
        auditLogEntry.append("app : '");
        auditLogEntry.append(appName);
        auditLogEntry.append("', IRM_CODE : E10, user : ");
        auditLogEntry.append(currentUserName);
        auditLogEntry.append(", searchConfiguration : '");
        auditLogEntry.append(searchID);
        auditLogEntry.append("', fields : ");
        // Do work here on the formInput
        // build up the string we'll put in the audit log
        Iterator<String> params = fields.keySet().iterator();
        Iterator<String> values = fields.values().iterator();
        while (params.hasNext()) {
            auditLogEntry.append(params.next() + " = " + values.next());
            if (params.hasNext()) {
                auditLogEntry.append(", ");
            }
        }
        auditLogEntry.append(", role restrictions = '");
        auditLogEntry.append(restrictions);
        auditLogEntry.append("'");

        // String auditLogEntry = "app : '" + appName + "', IRM_CODE : E10, " + " user : " +
        // currentUserName + ", searchConfiguration : '" + searchID + "', fields : " + formInput +
        // ", role restrictions = '" + restrictions + "'";
        LogCenterServiceAsync logger = DDSServices.getLogCenterService();
        logger.log(auditLogEntry.toString(), loggerListener);
    }

    LogCenterFailureListener loggerListener = new LogCenterFailureListener();

}

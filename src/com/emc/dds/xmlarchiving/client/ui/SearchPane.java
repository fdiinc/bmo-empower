/*******************************************************************************
 * Copyright (c) 2015 EMC Corporation. All Rights Reserved.
 *******************************************************************************/
package com.emc.dds.xmlarchiving.client.ui;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.Text;

import com.google.gwt.event.logical.shared.SelectionEvent;
import com.google.gwt.event.logical.shared.SelectionHandler;
import com.google.gwt.user.client.ui.DecoratedTabBar;
import com.google.gwt.user.client.ui.FlowPanel;
import com.google.gwt.user.client.ui.ScrollPanel;
import com.google.gwt.user.client.ui.TabBar;
import com.emc.dds.xmlarchiving.client.authorization.Role;
import com.emc.dds.xmlarchiving.client.configuration.ApplicationSettings;
import com.emc.dds.xmlarchiving.client.configuration.SearchSetting;
import com.emc.dds.xmlarchiving.client.configuration.SearchSettings;
import com.emc.dds.xmlarchiving.client.data.DynamicQueryDataSource;
import com.emc.dds.xmlarchiving.client.event.ApplicationEvent;
import com.emc.dds.xmlarchiving.client.event.DetailsClearEvent;
import com.emc.dds.xmlarchiving.client.event.PaneLoadedEvent;
import com.emc.dds.xmlarchiving.client.event.SearchClearEvent;
import com.emc.dds.xmlarchiving.client.event.SearchSubmitEvent;
import com.emc.dds.xmlarchiving.client.event.UserLoggedIn;
import com.emc.documentum.xml.dds.DDS;
import com.emc.documentum.xml.dds.gwt.client.rpc.LogCenterService;
import com.emc.documentum.xml.dds.gwt.client.ui.DDSXFormsPanel;
import com.emc.documentum.xml.dds.gwt.client.util.DDSURI;
import com.emc.documentum.xml.gwt.client.ui.SimpleDecoratorPanel;
import com.emc.documentum.xml.gwt.client.xml.XMLParser;
import com.emc.documentum.xml.xforms.gwt.client.XFormsObject;
import com.emc.documentum.xml.xforms.gwt.client.XFormsSubmissionHandler;
import com.emc.documentum.xml.xforms.gwt.client.event.XFormsEvent;
import com.emc.documentum.xml.xforms.gwt.client.event.XFormsEventListener;
import com.emc.documentum.xml.xforms.gwt.client.model.XFormsSubmission;
import com.emc.documentum.xml.xforms.gwt.client.model.impl.XFormsSubmissionImpl;

/**
 * Pane containing an XForm. When the form is submitted, an event is fired containing the user
 * input. Other panes can listen to this event and process the result. WARNING: This class is
 * experimental and may change in future DDS releases.
 */
public class SearchPane extends ContentPane implements XFormsEventListener,
XFormsSubmissionHandler, SelectionHandler<Integer> {

  private Map<String, DDSXFormsPanel> xformsPanels = new HashMap<String, DDSXFormsPanel>();
  private final FlowPanel queryPanel;
  private DDSXFormsPanel xformsPanel;
  private final TabBar searchButtons;
  private final ScrollPanel scrollPanel;
// private final DecoratedTabBar searchButtons;
  private final ArrayList<String> searchNames;

  public SearchPane(ApplicationSettings applicationSettings) {

    super(applicationSettings);
    applicationSettings.getState().addListener(this);

    queryPanel = new FlowPanel();
    queryPanel.addStyleName(getPaneStyle());

    searchNames = new ArrayList<String>();
    searchButtons = new DecoratedTabBar();
// this.searchButtons = new TabBar();
    searchButtons.addSelectionHandler(this);
    SimpleDecoratorPanel borderDecorator =
        new SimpleDecoratorPanel("core-TabBarBorder", searchButtons);
    borderDecorator.setWidth("100%");
    queryPanel.add(borderDecorator);

    scrollPanel = new ScrollPanel();
    scrollPanel.setAlwaysShowScrollBars(false);
    scrollPanel.setHeight("100%"); // Important
    scrollPanel.addStyleName(STYLE_SCROLL_BORDER);
    queryPanel.add(scrollPanel);

    LDMBorderDecorator decorator = new LDMBorderDecorator("Search", queryPanel);
    // Having the query panel have 200% height causes the scrollpanel to maximize to content
    queryPanel.setHeight(""); // Important
    initWidget(decorator);
    updateSearchButtons();
  }

  @Override
  public int getPaneType() {
    return SEARCH_PANE;
  }

  @Override
  public String getPaneName() {
    return SEARCH_PANE_NAME;
  }

  @Override
  public void loadData() {
    SearchSetting searchSetting = getState().getCurrentSearchSetting();
    Role role = getApplicationSettings().getRole();
    if ((searchSetting != null)
        && role.hasOperationAuthorization(searchSetting.getSearchConfigurationId())) {
      DDSURI xformCollectionURI = new DDSURI(searchSetting.getSearchConfiguration().getXformURI());
      xformCollectionURI.setAttribute(DDSURI.ATTRIBUTE_DOMAIN, DDSURI.DOMAIN_RESOURCE);
      String uri = xformCollectionURI.toString();
      xformsPanel = xformsPanels.get(uri);
      if (xformsPanel == null) {
        xformsPanel = new DDSXFormsPanel(uri);
        xformsPanel.setUIHandler(new LDMUIHandler());
        xformsPanels.put(uri, xformsPanel);
        xformsPanel.addXFormsEventListener(this);
        xformsPanel.setSubmissionHandler(this);
        xformsPanel.setStylePrimaryName("XFormsPanel");
      }
      scrollPanel.setWidget(xformsPanel);
    }
  }

  @Override
  public void handle(ApplicationEvent event) {
    super.handle(event);
    switch (event.getType()) {
      case ApplicationEvent.NODE_SELECTED_EVENT:
        updateSearchButtons();
        if (xformsPanel != null) {
          scrollPanel.remove(xformsPanel);
        }
        fireEvent(new SearchClearEvent(""));
        fireEvent(new DetailsClearEvent(""));
        setLoaded(false);
        loadData();
        break;
      case ApplicationEvent.SEARCH_SELECTED_EVENT:
        if (xformsPanel != null) {
          scrollPanel.remove(xformsPanel);
        }
        fireEvent(new SearchClearEvent(""));
        fireEvent(new DetailsClearEvent(""));
        setLoaded(false);
        loadData();
        // if the right tab is not selected, then select
        String searchName = getState().getCurrentSearchSetting().getName();
        int index = 0;
        for (String key : getState().getCurrentSetting().getSearchSettings().keySet()) {
          if (key.equals(searchName)) {
            if (searchButtons.getSelectedTab() != index) {
              searchButtons.selectTab(index);
            }
            break;
          }
          index++;
        }
        break;
      default:
        break;
    }
  }

  @Override
  public void onXFormsEvent(XFormsEvent event) {
//	System.out.println("------event:" + event.getNameAsString());
//	System.out.println("------setting:" + getApplicationSettings().getState().getCurrentSearchSetting().getName());
    if (event.getNameAsString().equals("xforms-ready")) {
      if (!isLoaded()) {
        setLoaded(true);
        fireEvent(new PaneLoadedEvent(SEARCH_PANE));
      }
    } else if (event.getNameAsString().equals("dds-clear-search-results")) {
      UserLoggedIn.cancelTimer();
      UserLoggedIn.restartTimer();
      fireEvent(new SearchClearEvent(""));
    } else if (event.getNameAsString().equals("dds-clear-search-details")) {
      UserLoggedIn.cancelTimer();
      UserLoggedIn.restartTimer();
      fireEvent(new DetailsClearEvent(""));
    } else if (event.getNameAsString().equals("dds-populate-dropdown")) {
    	XFormsObject j = event.getTarget();
    	Node k = j.getContext();
    	Text text = k.getOwnerDocument().createTextNode("test");
    	k.appendChild(text);
    }
  }

  @Override
  public boolean onSubmit(XFormsSubmission submission, String submissionBody) {

    // Capture submissions where the model needs to be updated (replace=="instance") and
    // use the value of the "class" attribute as an XPath expression to use to access the database
    String replace = submission.getReplace();
    String temp = submission.getInstanceData(null);
    if (!replace.equalsIgnoreCase("none")) { // if not "none", assume a model instance is being
// replaced

      // Get the form path data and the application
      SearchSetting searchSetting = getState().getCurrentSearchSetting();
      String XformURI = searchSetting.getSearchConfiguration().getXformURI();
      String appName = getApplicationSettings().getApplicationContext().getApplicationName();

      // get the name of the module file and the function to be executed
      String xqSrcFile = ((XFormsSubmissionImpl)submission).getAttribute("xqsrcfile");
      String xqNamespace = ((XFormsSubmissionImpl)submission).getAttribute("xqnamespace");
      String xqParams = ((XFormsSubmissionImpl)submission).getAttribute("xqparams");
      String xqFunction = ((XFormsSubmissionImpl)submission).getAttribute("xqfunction");
      String xqString;
      if ((xqSrcFile == null) && (xqNamespace == null) && (xqFunction == null)) {
        // no Query data defined - so ignore
        return false; // signifies that onSubmitDone will be called at a later time for this
// submission
      }

      // xqparams specifies a variable name to store instance data
      String xqParamsDecl = "";
      if (xqParams != null) {
        String instanceDataXML = submission.getInstanceData(null);
        Element instanceData = XMLParser.parse(instanceDataXML).getDocumentElement();
        xqParamsDecl = "declare variable " + xqParams + " as element(data) := " +
            instanceData + ";";
      }

      // If there is no namespace then we assume any file reference is a pure xquery - not a module
      // if there is no srcfile and no namespace then the function is assumed to be a pure xquery
// string
      // Otherwise it is a module so we wrap the import stuff around it.
      if (xqNamespace == null) {
        // Not a module reference so see if this is file reference or just an XQ string
        if (xqSrcFile == null) {
          // This is just an xpath or an xq string
          xqString = xqParamsDecl + " " + xqFunction;
        } else {
          // There is a file reference so look it up - it is assumed to be in the same folder as the
// form
          xqString =
              "xhive:evaluate(doc('/APPLICATIONS/" + appName + "/resources/" + XformURI + "/"
                  + xqSrcFile + "')//expression)";
        }

      } else {
        // Module file so import it and execute the function
        xqString = "import module namespace " + xqNamespace + " = '" + xqNamespace + "' at '" + xqSrcFile
              + "'; " + xqParamsDecl + " " + xqFunction;
      }

      UserLoggedIn.cancelTimer();
      UserLoggedIn.restartTimer();
      DynamicQueryDataSource dqds = new DynamicQueryDataSource(submission);
      dqds.processRequest(xqString, null);
      return false; // signifies that onSubmitDone will be called at a later time for this
// submission
    } else {
      UserLoggedIn.cancelTimer();
      UserLoggedIn.restartTimer();
      fireEvent(new SearchSubmitEvent(submission.getInstanceData(null)));
      submission.onSubmitDone("", -1, null, null);
      return true;
    }
  }

  private void updateSearchButtons() {
    Role role = getApplicationSettings().getRole();
    searchNames.clear();
    SearchSettings searchSettings =
        getApplicationSettings().getState().getCurrentSetting().getSearchSettings();
    List<SearchSetting> authorizedSettings = new ArrayList<SearchSetting>();
    for (SearchSetting searchSetting : searchSettings.values()) {
      if (role.hasOperationAuthorization(searchSetting.getSearchConfigurationId())) {
        authorizedSettings.add(searchSetting);
      }
    }
    if (authorizedSettings.size() == 0) {
      queryPanel.setVisible(false);
    } else {
      while (searchButtons.getTabCount() > 0) {
        searchButtons.removeTab(0);
      }
      for (SearchSetting searchSetting : authorizedSettings) {
        if (role.hasOperationAuthorization(searchSetting.getSearchConfigurationId())) {
          String searchName = searchSetting.getName();
          searchButtons.addTab(searchName);
          searchNames.add(searchName);
        }
      }
      searchButtons.selectTab(0);
      queryPanel.setVisible(true);
    }
  }

  @Override
  public void onSelection(SelectionEvent<Integer> event) {
    String searchName = searchNames.get(event.getSelectedItem());
    getApplicationSettings().getState().setCurrentSearchSetting(searchName);
  }
}

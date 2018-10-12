/*******************************************************************************
 * Copyright (c) 2015 EMC Corporation. All Rights Reserved.
 *******************************************************************************/
package com.emc.dds.xmlarchiving.client.configuration;

import java.util.Map;
import java.util.Set;

import com.emc.dds.xmlarchiving.client.ui.SplitPanelSizing;

/**
 * A search configuration object stores all information required for a search. This information
 * defines how queries are generated and how the result is shown in a pane. WARNING: This class is
 * experimental and may change in future DDS releases.
 */
public class SearchConfiguration {

  private final String xformURI;

  private final String xquery;

  private final Map<String, SearchField> searchFields;

  private final Map<String, SearchResultItem> searchResultItems;

  private final Map<String, NestedSearch> nestedSearches;

  private final Map<String, Report> reports;

  private final Set<String> operations;

  private final SplitPanelSizing resultsAndDetailsSizing;

  public SearchConfiguration(String xformURI, String xquery, Map<String, SearchField> searchFields,
      Map<String, SearchResultItem> searchResultItems, Map<String, NestedSearch> nestedSearches,
      Map<String, Report> reports, Set<String> operations, SplitPanelSizing resultsAndDetailsSizing) {
    super();
    this.searchFields = searchFields;
    this.searchResultItems = searchResultItems;
    this.nestedSearches = nestedSearches;
    this.xformURI = xformURI;
    this.reports = reports;
    this.xquery = xquery;
    this.operations = operations;
    this.resultsAndDetailsSizing = resultsAndDetailsSizing;
  }

  public String getXformURI() {
    return xformURI;
  }

  public String getXquery() {
    return xquery;
  }

  public Map<String, SearchField> getSearchFields() {
    return searchFields;
  }

  public Map<String, SearchResultItem> getSearchResultItems() {
    return searchResultItems;
  }

  public Map<String, NestedSearch> getNestedSearches() {
    return nestedSearches;
  }

  public Map<String, Report> getReports() {
    return reports;
  }

  public Set<String> getOperations() {
    return operations;
  }

  public SplitPanelSizing getResultsAndDetailsSizing() {
    return resultsAndDetailsSizing;
  }

}

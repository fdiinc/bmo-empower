/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.ui;

import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.ui.SimplePanel;
import com.google.gwt.user.client.ui.SplitLayoutPanel;

/**
 * Layout of the left-hand search results pane and the right-hand details pane.
 * Supports "hiding" the panels.
 *
 * @author Curtis Fleming
 */
/**
 *
 * @author Curtis Fleming
 */
public class SearchResultAndDetailsPanel extends SimplePanel {

  private SearchResultPane searchResultPane;

  private ContentViewPane detailsPane;

  private SearchResultAndDetailsMode currentMode;

  public SearchResultAndDetailsPanel() {

  }

  /**
   * @return the searchResultPane
   */
  public SearchResultPane getSearchResultPane() {

    return searchResultPane;
  }

  /**
   * @param searchResultPane
   *          the searchResultPane to set
   */
  public void setSearchResultPane(SearchResultPane searchResultPane) {

    this.searchResultPane = searchResultPane;
    this.searchResultPane.setParentContainer(this);
  }

  /**
   * @return the detailsPane
   */
  public ContentViewPane getDetailsPane() {

    return detailsPane;
  }

  /**
   * @param detailsPane
   *          the detailsPane to set
   */
  public void setDetailsPane(ContentViewPane detailsPane) {

    this.detailsPane = detailsPane;
  }

  /**
   * @param mode
   * @param sizing
   *          Sizing configuration, from highest priority to lowest priority.
   *          According to {@link SplitPanelSizing} the default is equal
   *          splitting.
   */
  public void layout(final SearchResultAndDetailsMode mode, SplitPanelSizing... sizing) {

    switch (mode) {
    case DETAILS_ONLY:
      // Avoid re-layout when before/after is identical
      if (currentMode != mode) {
        setWidget(detailsPane);
      }
      break;

    case SEARCH_RESULTS_ONLY:
      // Avoid re-layout when before/after is identical
      if (currentMode != mode) {
        setWidget(searchResultPane);
      }
      break;

    case BOTH:
    default:

        // Always rebuild the split pane to apply the sizing
      	SplitPanelSizing size = new SplitPanelSizing();
          size.setLeftSideWidth("50%");

          //size = (sizing == null || sizing.length == 0) ? size : sizing[0];

      	SplitLayoutPanel splitPanel = SplitPanelSizing.createSplitPanelLayout(searchResultPane, detailsPane, getPanelWidthPixels(),
      	          size);
        setWidget(splitPanel);
      break;
    }

    currentMode = mode;
  }

  private static int getPanelWidthPixels() {
    // FIXME Flatirons: We can approximate the width of this
    // "search results and details panel" by using the browser's width
    return Window.getClientWidth();
  }

  public static enum SearchResultAndDetailsMode {
    BOTH, DETAILS_ONLY, SEARCH_RESULTS_ONLY
  }

}

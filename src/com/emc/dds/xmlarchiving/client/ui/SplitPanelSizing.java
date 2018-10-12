/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.ui;

import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.ui.SplitLayoutPanel;
import com.google.gwt.user.client.ui.Widget;

/**
 * Simple object containing sizing hints for a split panel. Rules are as
 * follows:
 *
 * <ul>
 * <li>
 * At most the left hand side or right hand side should be supplied.</li>
 * <li>
 * If both sides are defined, the left hand side takes precedence.</li>
 * <li>
 * If neither side is defined (or a {@link SplitPanelSizing} reference is
 * <code>null</code>), the two sides are split equally.</li>
 * </ul>
 *
 * <p>
 * See the factory method
 * {@link #createSplitPanelLayout(Widget, Widget, int, SplitPanelSizing...)}
 * </p>
 *
 * @author Curtis Fleming
 */
public class SplitPanelSizing {

  private String leftSideWidth;

  private String rightSideWidth;

  /**
   *
   */
  public SplitPanelSizing() {

  }

  /**
   * @return the leftSideWidth
   */
  public String getLeftSideWidth() {
    return leftSideWidth;
  }

  /**
   *
   * @param leftSideWidth
   *          When Optional sizing of the left-hand-side panel, a.k.a. the
   *          search results. Supports "px" and "%" units.
   */
  public void setLeftSideWidth(String leftSideWidth) {
    this.leftSideWidth = leftSideWidth;
  }

  /**
   * @return the rightSideWidth
   */
  public String getRightSideWidth() {
    return rightSideWidth;
  }

  /**
   * @param rightSideWidth
   *          Optional sizing of the right-hand-side panel, a.k.a. the details
   *          panel. Supports "px" and "%" units.
   */
  public void setRightSideWidth(String rightSideWidth) {
    this.rightSideWidth = rightSideWidth;
  }

  /**
   * Factory method to create a split panel.
   *
   * @param leftWidth
   * @param rightWiget
   * @param newPanelWidth
   * @param sizing
   *          Sizing configuration, from highest priority to lowest priority
   *
   * @return A new split panel
   */
  public static SplitLayoutPanel createSplitPanelLayout(Widget leftWidth,
      Widget rightWiget, int newPanelWidth, SplitPanelSizing... sizing) {
    boolean isLeftDefined = true;
    String complexSize = "50%";

    if (sizing != null) {
      String leftSideWidth = null;
      String rightSideWidth = null;
      // Loop through the configurations, locking in the highest priority sizes
      for (SplitPanelSizing sizeConfig : sizing) {
        if (!hasValue(leftSideWidth)) {
          leftSideWidth = sizeConfig.getLeftSideWidth();
        }
        if (!hasValue(rightSideWidth)) {
          rightSideWidth = sizeConfig.getRightSideWidth();
        }
      }

      if (hasValue(leftSideWidth)) {
        complexSize = leftSideWidth;
      } else if (hasValue(rightSideWidth)) {
        isLeftDefined = false;
        complexSize = rightSideWidth;
      }
    }

    int pixelSize = SplitPanelSizing.asPixels(complexSize, newPanelWidth);

    SplitLayoutPanel splitPanel = new SplitLayoutPanel();
    splitPanel.setHeight("100%");
    splitPanel.setWidth("100%");
    if (isLeftDefined) {
      splitPanel.addWest(leftWidth, pixelSize);
      splitPanel.add(rightWiget);
    } else {
      splitPanel.addEast(rightWiget, pixelSize);
      splitPanel.add(leftWidth);
    }

    return splitPanel;
  }

  private static boolean hasValue(String value) {
    return (value != null) && !value.isEmpty();
  }

  /**
   * The GWT {@link SplitLayoutPanel} does not support percent sizing, so this
   * method interprets "px" and "%" suffixed numbers as pixels.
   *
   * @param complexSize
   * @param parentSizePixels
   * @return The complex size as pixels.
   */
  public static int asPixels(String complexSize, int parentSizePixels) {

    if (hasValue(complexSize)) {
      try {
        Integer percentSize = interpretComplexSize(complexSize, "%");
        if (percentSize != null) {
          return (percentSize.intValue() * parentSizePixels) / 100;
        }

        Integer pxSize = interpretComplexSize(complexSize, "px");
        if (pxSize != null) {
          return pxSize.intValue();
        }

        return Integer.parseInt(complexSize);

      } catch (NumberFormatException e) {
        // Bad input
        GWT.log(e.getMessage());
      }
    }

    return parentSizePixels / 2;
  }

  private static Integer interpretComplexSize(String complexSize, String suffix) {
    int suffixIndex = complexSize.indexOf(suffix);
    if (suffixIndex >= 0) {
      return Integer.valueOf(complexSize.substring(0, suffixIndex));
    }
    return null;
  }

}

/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.event;

/**
 * Event fired when a search is submitted. WARNING: This class is experimental and may change in
 * future DDS releases.
 * @author <a href="mailto:Alexander.Jones@flatironssolutions.com">Alex Jones</a>
 */
public class DetailsClearEvent implements ApplicationEvent {

  private String formInput;

  /**
   * Constructs a details clear event.
   * @param fields the search fields used in the search
   */
  public DetailsClearEvent(String formInput) {
    super();
    this.formInput = formInput;
  }

  /**
   * Returns the type of the event.
   * @return the type of the event.
   */
  @Override
  public int getType() {
    return DETAILS_PANE_CLEAR_EVENT;
  }

  /**
   * Gets the complete XForm input
   * @return the complete XForm input
   */
  public String getFormInput() {
    return formInput;
  }
}

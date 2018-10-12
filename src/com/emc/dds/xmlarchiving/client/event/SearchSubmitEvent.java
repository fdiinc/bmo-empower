/*******************************************************************************
 * Copyright (c) 2015 EMC Corporation. All Rights Reserved.
 *******************************************************************************/
package com.emc.dds.xmlarchiving.client.event;

/**
 * Event fired when a search is submitted. WARNING: This class is experimental and may change in
 * future DDS releases.
 */
public class SearchSubmitEvent implements ApplicationEvent {

  private String formInput;

  /**
   * Constructs a search submit event.
   * @param fields the search fields used in the search
   */
  public SearchSubmitEvent(String formInput) {
    super();
    this.formInput = formInput;
  }

  /**
   * Returns the type of the event.
   * @return the type of the event.
   */
  @Override
  public int getType() {
    return SEARCH_SUBMIT_EVENT;
  }

  /**
   * Gets the complete XForm input
   * @return the complete XForm input
   */
  public String getFormInput() {
    return formInput;
  }
}

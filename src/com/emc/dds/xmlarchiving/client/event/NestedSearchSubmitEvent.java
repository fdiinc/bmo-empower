/*******************************************************************************
 * Copyright (c) 2015 EMC Corporation. All Rights Reserved.
 *******************************************************************************/
package com.emc.dds.xmlarchiving.client.event;

public class NestedSearchSubmitEvent extends SearchSubmitEvent {

  private String nodeId;

  private String searchConfiguration;

  public NestedSearchSubmitEvent(String formInput, String nodeId, String searchConfiguration) {
    super(formInput);
    this.nodeId = nodeId;
    this.searchConfiguration = searchConfiguration;
  }

  @Override
  public int getType() {
    return NESTED_SEARCH_SUBMIT_EVENT;
  }

  public String getNodeId() {
    return nodeId;
  }

  public String getSearchConfiguration() {
    return searchConfiguration;
  }

}

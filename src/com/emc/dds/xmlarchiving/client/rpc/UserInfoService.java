/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.rpc;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;

import com.emc.documentum.xml.gwt.client.rpc.SerializableException;

/**
 *
 * @author <a href="mailto:Alexander.Jones@flatironssolutions.com">Alexander Jones</a>
 * @see UserInfoServiceImpl
 */
@RemoteServiceRelativePath("UserInfoService")
public interface UserInfoService extends RemoteService {

  public Boolean isUserLoggedIn() throws SerializableException;

  public void onXProcComplete() throws SerializableException;
}

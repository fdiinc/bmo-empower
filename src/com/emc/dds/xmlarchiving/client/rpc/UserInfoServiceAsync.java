/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.rpc;

import com.google.gwt.user.client.rpc.AsyncCallback;

/**
 *
 * @author <a href="mailto:Alexander.Jones@flatironssolutions.com">Alexander Jones</a>
 * @see UserInfoServiceImpl
 */
public interface UserInfoServiceAsync {

  void isUserLoggedIn(AsyncCallback<Boolean> callback);
  
  void onXProcComplete(AsyncCallback<Void> callback);
}

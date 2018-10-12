/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.ui;

import java.util.Date;

import com.google.gwt.user.client.Cookies;
import com.google.gwt.user.client.Window;
import com.emc.dds.xmlarchiving.client.Main;
import com.emc.dds.xmlarchiving.client.util.SessionCookieMgr;
import com.emc.documentum.xml.dds.gwt.client.LogCenterFailureListener;
import com.emc.documentum.xml.dds.gwt.client.rpc.DDSServices;
import com.emc.documentum.xml.dds.gwt.client.rpc.LogCenterServiceAsync;

/**
 *
 * @author <a href="mailto:alexander.jones@flatironssolutions.com">Alexander Jones</a>
 */
public class LogoutMessage {

  /**
   *
   */
  public static void show() {
    // The users session has expired!
    // Log the expiration and send them back to the login screen
    LogCenterServiceAsync logger = DDSServices.getLogCenterService();
    logger.log(
        "app : 'FSC Decomm', IRM_CODE : E10, user : NA, searchConfiguration : 'logout', fields : <data><successfulLogout>true</successfulLogout></data>"
        , new LogCenterFailureListener() {
      /**
       * {@inheritDoc}
       */
      @Override
      public void onSuccess(final Object result) {
        Cookies.setCookie("userTimedOut", "true", new Date(System.currentTimeMillis() + 60000));
        Main.getSessionCookieMgr().removeSessionCookie();
        Window.Location.reload();
      }
    });
  }

}

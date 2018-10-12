/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.server.service;

import java.util.Enumeration;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;

import com.emc.dds.xmlarchiving.client.rpc.UserInfoService;
import com.emc.documentum.xml.dds.DDS;
import com.emc.documentum.xml.dds.gwt.server.AbstractDDSService;
import com.emc.documentum.xml.dds.operation.exception.OperationFailedException;
import com.emc.documentum.xml.dds.user.User;
import com.emc.documentum.xml.gwt.client.rpc.SerializableException;
import com.flatironssolutions.decomm.servlet.xproc.XProcServletWrapper;

/**
 *
 * @author <a href="mailto:Alexander.Jones@flatironssolutions.com">Alexander Jones</a>
 *
 * <p>
 * This class contains useful service calls relating to the user.
 * </p>
 *
 * @see #isUserLoggedIn()
 */
public class UserInfoServiceImpl extends AbstractDDSService implements UserInfoService {
  /**
   * This version was automatically generated
   */
  private static final long serialVersionUID = -935285035114070399L;

  /**
   * Checks if the current user is logged in
   */
  @Override
  public Boolean isUserLoggedIn() throws SerializableException {
    try {
      User user = getUserFromRequest(getThreadLocalRequest());
      if (user == null) {
        return Boolean.FALSE;
      }
      // user was found
      return Boolean.TRUE;
    } catch (OperationFailedException e) {
      // user not found
      return Boolean.FALSE;
    }
  }
  
  /**
   * {@inheritDoc}
   */
  @Override
  public void onXProcComplete() throws SerializableException {
    try {
      String sessionId = getThreadLocalRequest().getRequestedSessionId();
      //LogCenter.log("--Waiting session id: " + sessionId);
      int i = 0;
      while (!XProcServletWrapper.sessionTracked(sessionId) && (i < 10)) {
    	  Thread.sleep(1000);
    	  i ++;
      }
      while (XProcServletWrapper.sessionTracked(sessionId)) {
        Thread.sleep(1000);
      }
      return;
    } catch (InterruptedException e) {
      //e.printStackTrace();
    }
  }
}

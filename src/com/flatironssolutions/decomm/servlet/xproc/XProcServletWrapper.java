/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.flatironssolutions.decomm.servlet.xproc;

import java.util.HashMap;
import java.util.concurrent.atomic.AtomicInteger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.emc.documentum.xml.dds.logging.LogCenter;
import com.emc.documentum.xml.dds.servlet.xproc.XProcServlet;

/**
 *
 * @author <a href="mailto:alexander.jones@flatironssolutions.com">Alexander Jones</a>
 *
 * <p>
 * This class is just a wrapper to keep track of the users requests
 * </p>
 */
public class XProcServletWrapper extends XProcServlet {

  private static final long serialVersionUID = -2599535989343176643L;
  private static volatile HashMap<String, AtomicInteger> xprocTrackers = new HashMap<String, AtomicInteger>();
  private static volatile Object trackerLock = new Object();

  private static void addTracker(String sessionId, HttpServletRequest request) {
    LogCenter.log("Adding user request to tracker");
    synchronized (trackerLock) {
      if (sessionTracked(sessionId)) {
        XProcServletWrapper.xprocTrackers.get(sessionId).getAndIncrement();
      } else {
        XProcServletWrapper.xprocTrackers.put(sessionId, new AtomicInteger(1));
      }
    }
  }

  private static void removeTracker(String sessionId, HttpServletRequest request) {
    LogCenter.log("Adding user request to tracker");
    synchronized (trackerLock) {
      if (sessionTracked(sessionId)) {
        if (XProcServletWrapper.xprocTrackers.get(sessionId).decrementAndGet() == 0) {
          XProcServletWrapper.xprocTrackers.remove(sessionId);
        }
      }
    }
  }

  public static boolean sessionTracked(String sessionId) {
    synchronized (trackerLock) {
      if (XProcServletWrapper.xprocTrackers.containsKey(sessionId)) {
        if (XProcServletWrapper.xprocTrackers.get(sessionId).get() > 0) {
          return true;
        }
      }
      return false;
    }
  }

  /**
   * {@inheritDoc}
   */
  @Override
  protected void doXProc(HttpServletRequest request, HttpServletResponse response) {
    String sessionId = request.getRequestedSessionId();
    //LogCenter.log("--Request session id: " + sessionId);
    try {
      addTracker(sessionId, request);
    } catch (Exception e) {
      LogCenter.exception("Error while tracking an XProc pipeline", e);
    }
    try {
    	super.doXProc(request, response);
    } finally {
      removeTracker(sessionId, request);
    }
  }

}

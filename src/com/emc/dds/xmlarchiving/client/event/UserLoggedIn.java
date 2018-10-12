/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.event;

import com.google.gwt.user.client.Cookies;
import com.google.gwt.user.client.Timer;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.TextBox;
import com.emc.dds.xmlarchiving.client.ui.LogoutMessage;
import com.emc.dds.xmlarchiving.shared.UIConstants;
import com.emc.documentum.xml.gwt.client.FailureHandler;

/**
 *
 * @author <a href="mailto:alexander.jones@flatironssolutions.com">Alexander Jones</a>
 */
public abstract class UserLoggedIn implements AsyncCallback<Boolean> {

    private static final TextBox loginMessage = new TextBox() {{
        setText("You have been logged out due to inactivity.");
        setStylePrimaryName("loginMessage");
        setEnabled(false);
        String userTimedOut = Cookies.getCookie("userTimedOut");
        if ((userTimedOut == null) || userTimedOut.equals("false")) {
            Cookies.setCookie("userTimedOut", "false");
            setVisible(false);
        } else {
            setVisible(true);
        }
    }};

    private static final Timer timer = new Timer() {

        @Override
        public void run() {

            LogoutMessage.show();
        }
    };

    public static TextBox getLoginMessage() {
        return loginMessage;
    }

    public static void cancelTimer() {
        timer.cancel();
    }

    public static void restartTimer() {
        //System.out.println("--Timer restarted");
        timer.schedule(UIConstants.SESSION_TIMEOUT_SECONDS * 1000);
    }

  /**
   * {@inheritDoc}
   */
  @Override
  public void onFailure(final Throwable caught) {
    FailureHandler.handle(this, caught);
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void onSuccess(final Boolean result) {
    if (result.booleanValue()) {
      cancelTimer();
      restartTimer();
      onLoggedIn();
    } else {
      LogoutMessage.show();
    }
  }

  public abstract void onLoggedIn();

}

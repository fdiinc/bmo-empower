/*******************************************************************************
 * Copyright (c) 2015 EMC Corporation. All Rights Reserved.
 *******************************************************************************/
package com.emc.dds.xmlarchiving.client;

import java.util.ArrayList;
import java.util.List;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.core.client.Scheduler;
import com.google.gwt.core.client.Scheduler.ScheduledCommand;
import com.google.gwt.dom.client.Style.Position;
import com.google.gwt.dom.client.Style.Unit;
import com.google.gwt.event.logical.shared.CloseEvent;
import com.google.gwt.event.logical.shared.CloseHandler;
import com.google.gwt.user.client.Cookies;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.HasHorizontalAlignment;
import com.google.gwt.user.client.ui.HasVerticalAlignment;
import com.google.gwt.user.client.ui.HasVerticalAlignment.VerticalAlignmentConstant;
import com.google.gwt.user.client.ui.HorizontalPanel;
import com.google.gwt.user.client.ui.Panel;
import com.google.gwt.user.client.ui.PopupPanel;
import com.google.gwt.user.client.ui.RootLayoutPanel;
import com.google.gwt.user.client.ui.RootPanel;
import com.emc.dds.xmlarchiving.client.authorization.Role;
import com.emc.dds.xmlarchiving.client.configuration.ApplicationSettings;
import com.emc.dds.xmlarchiving.client.event.UserLoggedIn;
import com.emc.dds.xmlarchiving.client.ui.ErrorDialogue;
import com.emc.dds.xmlarchiving.client.ui.LoginPanel;
import com.emc.dds.xmlarchiving.client.ui.MainClientBundle;
import com.emc.dds.xmlarchiving.client.util.SessionCookieMgr;
import com.emc.dds.xmlarchiving.client.util.UserSessionMgr;
import com.emc.documentum.xml.dds.gwt.client.LogCenterFailureListener;
import com.emc.documentum.xml.dds.gwt.client.rpc.DDSServices;
import com.emc.documentum.xml.dds.gwt.client.rpc.LogCenterServiceAsync;
import com.emc.documentum.xml.dds.gwt.client.rpc.application.SerializableApplicationContext;
import com.emc.documentum.xml.dds.gwt.client.ui.LoadingDialog;
import com.emc.documentum.xml.dds.gwt.client.util.ApplicationContext;
import com.emc.documentum.xml.dds.gwt.client.util.DDSURI;
import com.emc.documentum.xml.gwt.client.Dialog;
import com.emc.documentum.xml.gwt.client.FailureHandler;
import com.emc.documentum.xml.gwt.client.FailureHandler.FailureListener;
import com.emc.documentum.xml.gwt.client.ui.DialogBox;

/**
 * Entry point class. First loads the application context object that stores all information about locales and data sets. Then the
 * template configuration documents are loaded. Based on this information, the application is composed. WARNING: This class is
 * experimental and may change in future DDS releases.
 */
public class Main implements EntryPoint, FailureListener {

    private ApplicationSettings applicationSettings;
    private Role role;
    private String[] roleIds;
    private String userName;
    private static SessionCookieMgr m_sessionCookieMgr;
    private UserSessionMgr m_userSession;
    private Panel mainPanel;

    /**
     * If the user has not logged in before display the login page. If
     * {@inheritDoc}
     */
    @Override
    public void onModuleLoad() {

//        MainClientBundle.INSTANCE.bootstrap().ensureInjected();
        FailureHandler.addFailureListener(this);

        //Note the CHI implementation requires a USER service. The original 3.2 code appeared to support accessing
        //the system with no roles configured. However, supporting this logic added unecessary complexity.
        m_sessionCookieMgr = new SessionCookieMgr(this);
        m_userSession = new UserSessionMgr(this);
        m_userSession.initUserSession();

    }


    public void onLogout() {

        getSessionCookieMgr().removeSessionCookie();

        /*
         * Flatirons: OOTB logout followed by login fails to load the main UI - the DOM isn't built. Fix: The entire UI is reloaded
         * as a simple solution. This has an added benefit of clearing Javascript state, which is more secure.
         */
        logRequest("FSC Decomm", "logout", userName, "true", new LogCenterFailureListener() {
            /**
             * {@inheritDoc}
             */
            @Override
            public void onSuccess(final Object result) {
                Window.Location.reload();
            }
        });

    }

    public void logRequest(final String appName, final String loginType, final String currentUserName,
            final String successfulLogin, final AsyncCallback<Object> callback) {

        // build up the string we'll put in the audit log
        StringBuilder auditLogEntry = new StringBuilder();
        auditLogEntry.append("app : '");
        auditLogEntry.append(appName);
        auditLogEntry.append("', IRM_CODE : E10, user : ");
        auditLogEntry.append(currentUserName);
        auditLogEntry.append(", searchConfiguration : '");
        auditLogEntry.append(loginType);
        auditLogEntry.append("', fields : ");
        auditLogEntry.append("<data><successfulLogin>");
        auditLogEntry.append(successfulLogin);
        auditLogEntry.append("</successfulLogin></data>");

        LogCenterServiceAsync logger = DDSServices.getLogCenterService();
        logger.log(auditLogEntry.toString(), callback);
    }

    /**
     * When the User has been created, show the Login Panel.
     */
    public void showLogin() {

        RootPanel rootPanel = RootPanel.get();
        HorizontalPanel hpanel = new HorizontalPanel();
        hpanel.getElement().getStyle().setPosition(Position.ABSOLUTE);
        hpanel.getElement().getStyle().setTop(87.1875, Unit.PX);
        hpanel.setWidth("100%");
        hpanel.setVerticalAlignment(HasVerticalAlignment.ALIGN_MIDDLE);
        hpanel.setHorizontalAlignment(HasHorizontalAlignment.ALIGN_CENTER);
        rootPanel.addStyleName("login");
        rootPanel.clear();
        LoadingDialog.show("login");
        final LoginPanel loginPanel = new LoginPanel(this);
        hpanel.add(loginPanel);
        rootPanel.add(hpanel);
        Scheduler.get().scheduleDeferred(new ScheduledCommand() {

            @Override
            public void execute() {

                loginPanel.setFocus(true);
                LoadingDialog.hide("login");
            }
        });
//    	HorizontalPanel loginPanel = new HorizontalPanel();
//        loginPanel.setWidth("100%");
//        loginPanel.setHorizontalAlignment(HasHorizontalAlignment.ALIGN_CENTER);
//        final LoginPanel dialog = new LoginPanel(this);
//        loginPanel.add(dialog);
//        RootLayoutPanel.get().clear();
//        RootLayoutPanel.get().add(loginPanel);
//        RootLayoutPanel.get().setWidgetTopHeight(loginPanel, 10, Unit.PCT, 50, Unit.PCT);
//        Scheduler.get().scheduleDeferred(new ScheduledCommand() {
//          @Override
//          public void execute() {
//            dialog.setFocus(true);
////            LoadingDialog.hide("login");
//          }
//        });
    }

    /**
     * Instantiate page after authenticating and retrieving role configuration.
     *
     * @param userNameResult
     * @param primaryRole
     * @param ldapRoleIds
     */
    public void onLoginSuccess(final String userNameResult, final Role primaryRole, final String[] ldapRoleIds) {

        setRole(primaryRole);
        setUserName(userNameResult);
        setRoleIds(ldapRoleIds);

        m_sessionCookieMgr.setSessionCookie(getUserName());

        RootPanel rootPanel = RootPanel.get();
        rootPanel.removeStyleName("login");
        rootPanel.clear();
        
        UserLoggedIn.getLoginMessage().setVisible(false);
        UserLoggedIn.cancelTimer();
        UserLoggedIn.restartTimer();
        Cookies.removeCookie("userTimedOut");

        LoadingDialog.show("appContext");

        DDSServices.getApplicationService().getApplicationContext(new RetrieveApplicationContextCallback());

    }


    public ApplicationSettings getApplicationSettings2() {

        return applicationSettings;
    }

    public void setApplicationSettings(final ApplicationSettings applicationSettings) {

        this.applicationSettings = applicationSettings;
    }

    @Override
    public void onFailure(final AsyncCallback sender, final Throwable caught) {

        if (caught != null) {
            if ((caught.getMessage() != null) && caught.getMessage().equals("Session timed out")) {
                onLogout();
            } else {
                final DialogBox confirm =
                        Dialog.confirm("An unexpected error occurred. The page will be refreshed.", "", "Details");
                confirm.addCloseHandler(new CloseHandler<PopupPanel>() {

                    @Override
                    public void onClose(final CloseEvent<PopupPanel> event) {

                        if (!confirm.isCanceled()) {
                            ErrorDialogue.displayError(caught);
                        } else {
                            Window.Location.reload();
                        }
                    }
                });
            }
        }
    }

    private class RetrieveApplicationContextCallback implements
    AsyncCallback<SerializableApplicationContext> {

        @Override
        public void onFailure(final Throwable caught) {
            FailureHandler.handle(this, caught);
        }

        @Override
        public void onSuccess(final SerializableApplicationContext result) {
            ApplicationContext applicationContext = new ApplicationContext(result);
            // Main.this.applicationSettings = new ApplicationSettings(applicationContext);
            applicationSettings = new ApplicationSettings(applicationContext);

            applicationSettings.setRole(getRole());
            applicationSettings.setUserName(getUserName());
            applicationSettings.setUserServiceConfigured(true);

            DDSURI templateContentURI = new DDSURI("template/template-content.xml");
            templateContentURI.setAttribute(DDSURI.ATTRIBUTE_DOMAIN, DDSURI.DOMAIN_RESOURCE);
            DDSURI templatePanesURI = new DDSURI("template/template-panes.xml");
            templatePanesURI.setAttribute(DDSURI.ATTRIBUTE_DOMAIN, DDSURI.DOMAIN_RESOURCE);

            List<String> config = new ArrayList<String>();
            config.add(templateContentURI.toString());
            config.add(templatePanesURI.toString());

            DDSServices.getXMLPersistenceService().getContentsAsString(config,  new RetrieveContentConfigurationCallback());
        }
    }

    private class RetrieveContentConfigurationCallback implements AsyncCallback<List<String>> {

        @Override
        public void onFailure(final Throwable caught) {
            FailureHandler.handle(this, caught);
        }

        @Override
        public void onSuccess(final List<String> result) {
            LoadingDialog.hide("appContext");
            mainPanel = new ConfigurationLoader(result).load(Main.this);
        }
    }


    /**
     * @return the userSession
     */
    public UserSessionMgr getUserSession() {

        return m_userSession;
    }


    /**
     * @param userSession the userSession to set
     */
    public void setUserSession(final UserSessionMgr userSession) {

        m_userSession = userSession;
    }



    /**
     * @return the sessionCookieMgr
     */
    public static SessionCookieMgr getSessionCookieMgr() {

        return m_sessionCookieMgr;
    }

    /**
     * @return the role
     */
    public Role getRole() {

        return role;
    }


    /**
     * @param role the role to set
     */
    public void setRole(final Role role) {

        this.role = role;
    }


    /**
     * @param userName the userName to set
     */
    public void setUserName(final String userName) {

        this.userName = userName;
    }

    /**
     * @return the userName
     */
    public String getUserName() {

        return userName;
    }


    /**
     * @return the roleIds
     */
    public String[] getRoleIds() {

        return roleIds;
    }

    /**
     * @param roleIds the roleIds to set
     */
    public void setRoleIds(final String[] roleIds) {

        this.roleIds = roleIds;
    }
}

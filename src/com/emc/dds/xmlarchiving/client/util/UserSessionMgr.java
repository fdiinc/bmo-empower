/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.util;

import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.rpc.AsyncCallback;

import com.emc.dds.xmlarchiving.client.Main;
import com.emc.dds.xmlarchiving.client.RoleLoader;
import com.emc.dds.xmlarchiving.client.authorization.Role;
import com.emc.dds.xmlarchiving.client.i18n.Locale;
import com.emc.dds.xmlarchiving.client.i18n.Messages;
import com.emc.dds.xmlarchiving.client.rpc.auth.RoleService;
import com.emc.dds.xmlarchiving.client.rpc.auth.RoleServiceAsync;
import com.emc.documentum.xml.dds.gwt.client.LogCenterFailureListener;
import com.emc.documentum.xml.dds.gwt.client.rpc.DDSServices;
import com.emc.documentum.xml.dds.gwt.client.rpc.LogCenterServiceAsync;
import com.emc.documentum.xml.dds.gwt.client.rpc.application.UserServiceAsync;
import com.emc.documentum.xml.dds.gwt.client.rpc.persistence.SerializableXQueryValue;
import com.emc.documentum.xml.gwt.client.Dialog;
import com.emc.documentum.xml.gwt.client.FailureHandler;

/**
 * Class retrieves user session details such as LDSP roles, xDB role, etc.
 *
 * @author Lauren Ward
 *
 */
public class UserSessionMgr {

    private LogCenterFailureListener m_loggerListener = new LogCenterFailureListener();
    private final RoleServiceAsync m_roleService = (RoleServiceAsync) GWT.create(RoleService.class);
    private String m_userName;
    private String m_password;
    private String m_primaryRoleId;
    private Role m_primaryRole;
    private String[] m_roleIds;
    private Main m_main;

    public UserSessionMgr(final Main main) {
        m_main = main;
    }

    /**
     * Init without a username or password.
     */
    public void initUserSession() {

        if (!GWT.isProdMode()) {
            // Note: Hack for development quality of life
            initUserSession("admin", "secret");
        } else {
            initUserSession("", "");
        }
    }


    /**
     * Init withou user name and password from LoginPanel
     *
     * @param userName
     * @param password
     */
    public void initUserSession(final String userName, final String password) {

        setUserName(userName);
        setPassword(password);

        Queue<PromiseQueue> promise = new LinkedList<PromiseQueue>();
        promise.add(new LoginUserPromise(this, promise));
        promise.add(new UserNamePromise(this, promise));
        promise.add(new PrimaryRoleIdPromise(this, promise));
        promise.add(new RoleIdsPromise(this, promise));
        promise.add(new PrimaryRolePromise(this, promise));
        promise.add(new DisplayMainViewPromise(this));
        promise.poll().invoke();
    }


    /**
     * @return the roleService
     */
    public RoleServiceAsync getRoleService() {

        return m_roleService;
    }

    /**
     * @return the userName
     */
    public String getUserName() {

        return m_userName;
    }
    /**
     * @param userName the userName to set
     */
    public void setUserName(final String userName) {

        m_userName = userName;
    }
    /**
     * @return the password
     */
    public String getPassword() {

        return m_password;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(final String password) {

        m_password = password;
    }


    /**
     * @return the primaryRoleId
     */
    public String getPrimaryRoleId() {

        return m_primaryRoleId;
    }
    /**
     * @param primaryRoleId the primaryRoleId to set
     */
    public void setPrimaryRoleId(final String primaryRoleId) {

        m_primaryRoleId = primaryRoleId;
    }
    /**
     * @return the primaryRole
     */
    public Role getPrimaryRole() {

        return m_primaryRole;
    }
    /**
     * @param primaryRole the primaryRole to set
     */
    public void setPrimaryRole(final Role primaryRole) {

        m_primaryRole = primaryRole;
    }
    /**
     * @return the roleIds
     */
    public String[] getRoleIds() {

        return m_roleIds;
    }
    /**
     * @param roleIds the roleIds to set
     */
    public void setRoleIds(final String[] roleIds) {

        m_roleIds = roleIds;
    }

    /**
     * @return the main
     */
    public Main getMain() {

        return m_main;
    }


    public void logRequest(final String appName, final String loginType, final String currentUserName,
        final String successfulLogin) {
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
      logger.log(auditLogEntry.toString(), m_loggerListener);
    }

    /**
     * Login user based on configured UserService
     *
     * @author Lauren Ward
     *
     */
    private static class LoginUserPromise implements PromiseQueue {
        protected UserSessionMgr m_userMgr;
        protected Queue<PromiseQueue> m_promise;
        protected Messages messages = Locale.getMessages();
        public LoginUserPromise(final UserSessionMgr userSessionMgr, final Queue<PromiseQueue> promise) {
            m_userMgr = userSessionMgr;
            m_promise = promise;
        }

      @Override
        public void invoke() {

            UserServiceAsync service = DDSServices.getUserService();
            service.login(m_userMgr.getUserName(), m_userMgr.getPassword(), new AsyncCallback<Boolean>() {

                @Override
                public void onFailure(final Throwable caught) {
                    FailureHandler.handle(this, caught);
                    m_userMgr.getMain().showLogin();
                }

                @Override
                public void onSuccess(final Boolean result) {
                    if (result.booleanValue()) {
                        if (m_promise.peek() != null) {
                            m_promise.poll().invoke();
                        }
                    } else {
                        m_userMgr.logRequest(GWT.getModuleName(), "login", "Unsuccessful", "false");
                        m_userMgr.getMain().showLogin();
                        if (!m_userMgr.getUserName().isEmpty() || !m_userMgr.getPassword().isEmpty()) {
                          Dialog.alert(messages.loginFailed());
                        }
                    }
                }
            });
        }
    }



    /**
     * Get primary xDB role for current from RoleService
     *
     * @author Lauren Ward
     *
     */
    private static class PrimaryRoleIdPromise implements PromiseQueue {
        protected UserSessionMgr m_userMgr;
        protected Queue<PromiseQueue> m_promise;
        public PrimaryRoleIdPromise(final UserSessionMgr userSessionMgr, final Queue<PromiseQueue> promise) {
            m_userMgr = userSessionMgr;
            m_promise = promise;
        }

        @Override
        public void invoke() {
            m_userMgr.getRoleService().getRoleId(new AsyncCallback<String>() {

                @Override
                public void onFailure(final Throwable caught) {
                    FailureHandler.handle(this, caught);
                }

                @Override
                public void onSuccess(final String primaryRoleId) {
                    if (primaryRoleId != null) {
                        m_userMgr.setPrimaryRoleId(primaryRoleId);
                        if (m_promise.peek() != null) {
                            m_promise.poll().invoke();
                        }
                    } else {
                        m_userMgr.getMain().showLogin();
                        Dialog.alert("Unable to locate role for user " + m_userMgr.getUserName());
                    }
                }
            });
        }
    }

    /**
     * Get the user name if incase we are using cookies or SSO
     *
     * @author Lauren Ward
     *
     */
    private static class UserNamePromise implements PromiseQueue {
        protected UserSessionMgr m_userMgr;
        protected Queue<PromiseQueue> m_promise;
        public UserNamePromise(final UserSessionMgr userSessionMgr, final Queue<PromiseQueue> links) {
            m_userMgr = userSessionMgr;
            m_promise = links;
        }

        @Override
        public void invoke() {
            m_userMgr.getRoleService().getUserId(new AsyncCallback<String>() {

                @Override
                public void onFailure(final Throwable caught) {
                    FailureHandler.handle(this, caught);
                }

                @Override
                public void onSuccess(final String userId) {
                    m_userMgr.setUserName(userId);
                    if (m_promise.peek() != null) {
                        m_promise.poll().invoke();
                    }
                }
            });
        }
    }



    /**
     * Get the list of role IDs from LDAP
     *
     * @author Lauren Ward
     *
     */
    private static class RoleIdsPromise implements PromiseQueue {
        protected UserSessionMgr m_userMgr;
        protected Queue<PromiseQueue> m_promise;
        public RoleIdsPromise(final UserSessionMgr userSessionMgr, final Queue<PromiseQueue> promise) {
            m_userMgr = userSessionMgr;
            m_promise = promise;
        }

        @Override
        public void invoke() {
            m_userMgr.getRoleService().getRoleIds(new AsyncCallback<String[]>() {

                @Override
                public void onFailure(final Throwable caught) {
                    FailureHandler.handle(this, caught);
                }

                @Override
                public void onSuccess(final String[] roleIds) {
                    m_userMgr.setRoleIds(roleIds);
                    if (m_promise.peek() != null) {
                        m_promise.poll().invoke();
                    }
                }
            });
        }
    }

    /**
     * Get the primary role from xDB. This should be a single value for most applications.
     *
     * @author Lauren Ward
     *
     */
    private static class PrimaryRolePromise implements PromiseQueue {
        protected UserSessionMgr m_userMgr;
        protected Queue<PromiseQueue> m_promise;
        public PrimaryRolePromise(final UserSessionMgr userSessionMgr, final Queue<PromiseQueue> promise) {
            m_userMgr = userSessionMgr;
            m_promise = promise;
        }

        @Override
        public void invoke() {
            Locale.getMessages();
            final String appName = GWT.getModuleName();

            final String xquery =
                    "<result>\n" + " {\n" + "   doc('/APPLICATIONS/" + appName + "/roles')[/role/id = '" + m_userMgr.getPrimaryRoleId() + "']\n" + " }\n"
                            + "</result>";
            DDSServices.getXQueryService().execute(null, xquery, new AsyncCallback<List<SerializableXQueryValue>>() {

                @Override
                public void onFailure(final Throwable caught) {
                    FailureHandler.handle(this, caught);
                }

                @Override
                public void onSuccess(final List<SerializableXQueryValue> result) {
                    if (result.size() > 0) {
                        final String value = result.get(0).asString();
                        m_userMgr.setPrimaryRole(new RoleLoader().getRole(value));
                    }

                    if (m_promise.peek() != null) {
                        m_promise.poll().invoke();
                    }
                }
            });
        }
    }


    /**
     * Display the main page
     *
     * @author Lauren Ward
     *
     */
    private static class DisplayMainViewPromise implements PromiseQueue {
        private UserSessionMgr m_userMgr;
        public DisplayMainViewPromise(final UserSessionMgr userSessionMgr) {
            m_userMgr = userSessionMgr;
        }

        @Override
        public void invoke() {
            m_userMgr.logRequest(GWT.getModuleName(), "login", m_userMgr.getUserName(), "true");
                m_userMgr.getMain().onLoginSuccess(m_userMgr.getUserName(), m_userMgr.getPrimaryRole(), m_userMgr.getRoleIds());
        }
    }
}

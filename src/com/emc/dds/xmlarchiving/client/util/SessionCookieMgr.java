/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.util;

import java.util.Date;
import java.util.LinkedList;
import java.util.Queue;

import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.Cookies;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.rpc.AsyncCallback;

import com.emc.dds.xmlarchiving.client.Main;
import com.emc.dds.xmlarchiving.client.rpc.auth.CryptoService;
import com.emc.dds.xmlarchiving.client.rpc.auth.CryptoServiceAsync;
import com.emc.dds.xmlarchiving.client.ui.ErrorDialogue;
import com.emc.dds.xmlarchiving.shared.AppSessionCookie;
import com.emc.dds.xmlarchiving.shared.ServerException;
import com.emc.documentum.xml.gwt.client.FailureHandler;

/**
 * Class manages the session cookie used to avoid multiple logins if you access the application from the landing page.
 *
 * @author Lauren Ward
 *
 */
public class SessionCookieMgr {
    public static final String IA_APPLICATION_COOKIE = "IAApplicationSession";
    private static final int IA_APPLICATION_COOKIE_DURATION = 1000 * 60 * 60 * 24 * 7 * 1;
    private static CryptoServiceAsync CRYPTO_SERVICE = GWT.create(CryptoService.class);
    private Main m_main;
    private String m_userName;
    private String m_iaAppCookie;


    public SessionCookieMgr(final Main main) {

        m_main = main;
    }

    public void setSessionCookie(final String userName) {
        AppSessionCookie appSessionCookie = new AppSessionCookie();
        appSessionCookie.setUserName(userName);
        Queue<PromiseQueue> promise = new LinkedList<PromiseQueue>();
        promise.add(new CryptoEncryptPromise(this, appSessionCookie, promise));
        promise.poll().invoke();
    }


    /**
     * Delete the session cookie
     */
    public void removeSessionCookie() {
        //The definitive way to remove cookies is to create them with identical parameters but with expired date.
        Date expires = new Date(System.currentTimeMillis() - 10000);
        Cookies.setCookie(SessionCookieMgr.IA_APPLICATION_COOKIE, "", expires, Window.Location.getHostName(), "/", false);
    }

    /**
     * @return the userName
     */
    public String getUserName() {

        return m_userName;
    }

    /**
     * @param userName
     *            the userName to set
     */
    public void setUserName(final String userName) {

        m_userName = userName;
    }

    /**
     * @return the main
     */
    public Main getMain() {

        return m_main;
    }

    /**
     * @return the iaAppCookie
     */
    public String getIaAppCookie() {

        return m_iaAppCookie;
    }

    /**
     * @param iaAppCookie
     *            the iaAppCookie to set
     */
    public void setIaAppCookie(final String iaAppCookie) {

        m_iaAppCookie = iaAppCookie;
    }

    public CryptoServiceAsync getCryptoService() {
        return CRYPTO_SERVICE;
    }

    /**
     *
        Cookies.setCookie(SessionCookieMgr.IA_APPLICATION_COOKIE, "", expires);
     * Decrypt the cookie so that it can be read.
     *
     * @author Lauren Ward
     *
     */
    @SuppressWarnings("unused")
    private static class CryptoDecryptPromise implements PromiseQueue {
        protected SessionCookieMgr m_sessionCookieMgr;
        protected Queue<PromiseQueue> m_promise;

        public CryptoDecryptPromise(final SessionCookieMgr sessionCookieMgr, final Queue<PromiseQueue> promise) {
            m_sessionCookieMgr = sessionCookieMgr;
            m_promise = promise;
        }

        @Override
        public void invoke() {

            try {
                m_sessionCookieMgr.getCryptoService().decrypt(m_sessionCookieMgr.getIaAppCookie(),  new AsyncCallback<AppSessionCookie>() {
                    @Override
                    public void onFailure(final Throwable caught) {

                        ErrorDialogue.displayError(caught);
                        m_sessionCookieMgr.getMain().showLogin();
                    }

                    @Override
                    public void onSuccess(final AppSessionCookie appSessionCookie) {

                        UserSessionMgr userSession = new UserSessionMgr(m_sessionCookieMgr.getMain());
                        userSession.initUserSession(appSessionCookie.getUserName(), "");
                        if (m_promise.peek() != null) {
                            m_promise.poll().invoke();
                        }
                    }
                });
            } catch (ServerException e) {
                ErrorDialogue.displayError(e);
            }
        }
    }

    /**
     * Encrypt the ticket.
     *
     * @author Lauren Ward
     *
     */
    private static class CryptoEncryptPromise implements PromiseQueue {
        protected SessionCookieMgr m_sessionCookieMgr;
        protected AppSessionCookie m_appSessionCookie;
        protected Queue<PromiseQueue> m_promise;

        public CryptoEncryptPromise(final SessionCookieMgr sessionCookieMgr, final AppSessionCookie appSessionCookie, final Queue<PromiseQueue> promise) {
            m_sessionCookieMgr = sessionCookieMgr;
            m_appSessionCookie = appSessionCookie;
            m_promise = promise;
        }

        @Override
        public void invoke() {

            try {
                m_sessionCookieMgr.getCryptoService().encrypt(m_appSessionCookie,  new AsyncCallback<String>() {
                    @Override
                    public void onFailure(final Throwable caught) {
                        ErrorDialogue.displayError(caught);
                        FailureHandler.handle(this, caught);
                    }


                    @Override
                    public void onSuccess(final String encryptedText) {
                        Date expires = new Date(System.currentTimeMillis() + IA_APPLICATION_COOKIE_DURATION);
                        Cookies.setCookie(SessionCookieMgr.IA_APPLICATION_COOKIE, encryptedText, expires, Window.Location.getHostName(), "/", false);
                        if (m_promise.peek() != null) {
                            m_promise.poll().invoke();
                        }
                    }
                });
            } catch (ServerException e) {
                ErrorDialogue.displayError(e);
            }
        }
    }

}

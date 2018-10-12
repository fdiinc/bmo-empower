/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.ui;

import com.google.gwt.event.logical.shared.CloseEvent;
import com.google.gwt.event.logical.shared.CloseHandler;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.ui.PopupPanel;

import com.emc.dds.xmlarchiving.client.i18n.Locale;
import com.emc.documentum.xml.gwt.client.Dialog;
import com.emc.documentum.xml.gwt.client.ui.DialogBox;

/**
 * Display RPC exceptions through the UI.
 *
 * @author Lauren Ward
 *
 */
public class ErrorDialogue {


    /**
     * Display the error message
     *
     * @param e
     */
    public static void displayError(final Throwable e) {
        StringBuilder builder = new StringBuilder();
        String headMessage = e.getMessage();
        if (headMessage == null) {
            headMessage = Locale.getErrors().unexpectedException(e.getClass().getName());
        }
        builder.append(headMessage);
        buildErrorMessage(builder, e, 2);

        DialogBox details = Dialog.alert(builder.toString());
        details.addCloseHandler(new CloseHandler<PopupPanel>() {

            @Override
            public void onClose(final CloseEvent<PopupPanel> event) {

                Window.Location.reload();
            }
        });
    }



    /**
     * Builds the error message.
     *
     * @param sb
     * @param error
     * @param maxStackTraceElements
     */
    private static void buildErrorMessage(final StringBuilder sb, final Throwable error, final int maxStackTraceElements) {

        Throwable t = error;
        if (t == null) {
            sb.append("null throwable");
        } else {
            boolean isCause = false;
            do {
                if (isCause) {
                    sb.append("\nCaused by: \n");
                } else {
                    sb.append("\n");
                }
                sb.append(t.getClass().getName() + ": " + t.getMessage());

                StackTraceElement[] stackTrace = t.getStackTrace();
                int i = 0;
                for (; (i < stackTrace.length) && (i < maxStackTraceElements); i++) {
                    sb.append("\n");
                    StackTraceElement element = stackTrace[i];
                    sb.append(element.toString());
                }
                if (i < stackTrace.length) {
                    sb.append("\n...");
                }

                // Recursive logging of cause
                Throwable cause = t.getCause();
                t = (cause == t) ? null : cause;
                isCause = true;
            } while (t != null);
        }
    }
}

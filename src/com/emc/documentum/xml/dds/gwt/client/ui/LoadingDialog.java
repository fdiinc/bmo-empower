/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.documentum.xml.dds.gwt.client.ui;

import java.util.HashSet;

import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.ui.DecoratedPopupPanel;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.HorizontalPanel;
import com.google.gwt.user.client.ui.Image;

/**
 *
 * @author <a href="mailto:alexander.jones@flatironssolutions.com">Alexander Jones</a>
 *
 * <p>
 * This class adds a modal popup to indicate loading status.
 * </p>
 *
 * @see #LoadingDialog.show()
 * @see #LoadingDialog.hide()
 *
 */
public class LoadingDialog {

    private static final DecoratedPopupPanel loadingPopup = new DecoratedPopupPanel(false, true) {{

        setWidget(new HorizontalPanel() {{
            add(new Image(GWT.getModuleBaseURL() + "core/standard/images/wait16.gif"));
            add(new HTML(" Loading..."));
        }});
        setHeight("20px");
        setGlassEnabled(true);
        setAnimationEnabled(true);

        registerNativeHide();
    }};

    private static volatile HashSet<String> active = new HashSet<String>();

    /**
     *
     */
    public LoadingDialog() {}

    /**
     * @return
     */
    public static DecoratedPopupPanel getDefault() {

        return loadingPopup;
    }

    public static HashSet<String> getActive() {

        return active;
    }

    /**
     * Makes the popup visible
     */
    public static void show(String name) {

        getDefault().center(); // Centers and shows
        active.add(name);
    }

    /**
     * Tells the popup to become invible</br>
     * </br>
     * Note: The popup will remain visible unless there
     * is a hide request for each show request.
     */
    public static void hide(String name) {

        if (active.remove(name) && active.isEmpty()) {
            DecoratedPopupPanel loadingPopup = getDefault();
            loadingPopup.hide();
            loadingPopup.removeFromParent();
        }
    }

    private static native void registerNativeHide() /*-{
        top.hideLoadingDialog = function(name) {
            @com.emc.documentum.xml.dds.gwt.client.ui.LoadingDialog::hide(Ljava/lang/String;)(name);
        };
    }-*/;

}

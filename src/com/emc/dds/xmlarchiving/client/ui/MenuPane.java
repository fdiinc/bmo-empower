/*******************************************************************************
 * Copyright (c) 2015 EMC Corporation. All Rights Reserved.
 *******************************************************************************/
package com.emc.dds.xmlarchiving.client.ui;

import java.util.Collection;
import java.util.Map;

import com.emc.dds.xmlarchiving.client.configuration.ApplicationSettings;
import com.emc.dds.xmlarchiving.client.event.ApplicationEvent;
import com.emc.dds.xmlarchiving.client.event.PaneLoadedEvent;
import com.emc.dds.xmlarchiving.client.i18n.Locale;
import com.emc.dds.xmlarchiving.client.ui.image.MainImageBundle;
import com.emc.documentum.xml.dds.gwt.client.rpc.DDSServices;
import com.emc.documentum.xml.dds.gwt.client.util.ApplicationContext;
import com.emc.documentum.xml.gwt.client.FailureHandler;
import com.emc.documentum.xml.gwt.client.ui.MenuBar;
import com.google.gwt.user.client.Command;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.AbstractImagePrototype;
import com.google.gwt.user.client.ui.MenuItem;

/**
 * Pane that represents a menu bar. The current implementation only has sub menu's for languages and
 * locales. WARNING: This class is experimental and may change in future DDS releases.
 */
public class MenuPane extends ContentPane {

  private Map<String, String> languageByLocale;

  private final boolean showLanguages;
// Not needed for LDM demo
// private final boolean showDatasets;

  private MenuBar languagesMenu;

// Not needed for LDM demo
// private MenuBar dataSetsMenu;

  public MenuPane(ApplicationSettings applicationSettings, boolean showLanguages,
      boolean showDatasets) {
    super(applicationSettings);
    applicationSettings.getState().addListener(this);
    this.showLanguages = showLanguages;
// Not needed for LDM demo
// this.showDatasets = showDatasets;
    MenuBar menuBar = new MenuBar();

// Not needed for LDM demo
// if (showDatasets) {
// this.dataSetsMenu = new MenuBar(true);
// menuBar.addItem(new MenuItem(Locale.getLabels().dataSet(), this.dataSetsMenu));
// initDataSetsMenuBar();
// }

    if (showLanguages) {
      languagesMenu = new MenuBar(true);
      menuBar.addItem(new MenuItem(Locale.getLabels().language(), languagesMenu));
    }
    initWidget(menuBar);
    this.setVisible(false);
    addStyleName(getPaneStyle());
  }

  @Override
  public int getPaneType() {
    return MENU_PANE;
  }

  @Override
  public String getPaneName() {
    return MENU_PANE_NAME;
  }

  @Override
  public void loadData() {
    if (showLanguages) {
      initLanguagesMenuBar();
    }
  }

  private void initLanguagesMenuBar() {

    DDSServices.getI18NService().getISO3Languages("eng", new AsyncCallback<Map<String, String>>() {

      @Override
      public void onFailure(Throwable caught) {
        FailureHandler.handle(this, caught);
      }

      @Override
      public void onSuccess(Map<String, String> result) {

        languageByLocale = result;

        if (!isLoaded()) {
          setLoaded(true);
          fireEvent(new PaneLoadedEvent(getPaneType()));
        }
      }
    });
  }

  private void addLanguageMenuItem(final MenuBar menuBar, final String newLocale) {
    final String currentLocale = getApplicationSettings().getState().getCurrentLocale();
    boolean selected = currentLocale.equals(newLocale);
    String newLanguage = languageByLocale.get(newLocale);
    AbstractImagePrototype image =
        selected ? MainImageBundle.INSTANCE.check16() : MainImageBundle.INSTANCE.empty16();
    String text = selected ? "<b>" + newLanguage + "</b>" : newLanguage;

    menuBar.addItem(image, text, true, new Command() {

      @Override
      public void execute() {
        if (!currentLocale.equals(newLocale)) {
          getApplicationSettings().getState().setCurrentLocale(newLocale);
          refreshMenuItems();
        }
      }
    });
  }

  private void refreshMenuItems() {
    if (showLanguages) {
      languagesMenu.clearItems();
      ApplicationContext applicationContext = getApplicationSettings().getApplicationContext();
      Collection<String> locales = applicationContext.getLocaleCollection();
      if (locales != null && locales.size() > 0) {
        for (String locale : applicationContext.getLocaleCollection()) {
          addLanguageMenuItem(languagesMenu, locale);
        }
        this.setVisible(true);
      } else {
        this.setVisible(false);
      }
    }
  }

  @Override
  public void handle(ApplicationEvent event) {
    super.handle(event);
    switch (event.getType()) {
      case ApplicationEvent.NODE_SELECTED_EVENT:
        refreshMenuItems();
        break;
    }
  }

}

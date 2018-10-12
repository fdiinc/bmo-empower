/*******************************************************************************
 * Copyright (c) 2015 EMC Corporation. All Rights Reserved.
 *******************************************************************************/
package com.emc.dds.xmlarchiving.client.ui;

import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.event.dom.client.KeyDownEvent;
import com.google.gwt.event.dom.client.KeyDownHandler;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.FlexTable;
import com.google.gwt.user.client.ui.FlowPanel;
import com.google.gwt.user.client.ui.HasHorizontalAlignment;
import com.google.gwt.user.client.ui.HasVerticalAlignment;
import com.google.gwt.user.client.ui.Label;
import com.google.gwt.user.client.ui.PasswordTextBox;
import com.google.gwt.user.client.ui.SimplePanel;
import com.google.gwt.user.client.ui.TextBox;
import com.google.gwt.user.client.ui.VerticalPanel;
import com.google.gwt.user.client.ui.Widget;
import com.emc.dds.xmlarchiving.client.Main;
import com.emc.dds.xmlarchiving.client.event.UserLoggedIn;
import com.emc.dds.xmlarchiving.client.i18n.Labels;
import com.emc.dds.xmlarchiving.client.i18n.Locale;
import com.emc.dds.xmlarchiving.client.ui.image.MainImageBundle;
import com.emc.documentum.xml.gwt.client.ui.Button;

/**
 * Login panel. This panel displays the login dialog.
 */
public class LoginPanel extends Composite implements ClickHandler, KeyDownHandler {

  private TextBox tbUser = new TextBox();
  private PasswordTextBox tbPassword = new PasswordTextBox();
  protected Main main;


  /**
   * Creates a new instance.
   *
   * @param main
   *            {@link Main} instance
   */
  public LoginPanel(final Main main) {
    this.main = main;

    VerticalPanel mainPanel = new VerticalPanel();
    initWidget(mainPanel);

    Widget loginWidget = createLoginWidget();
    mainPanel.setPixelSize(480, 160);

//    FlowPanel container = new FlowPanel();
//    container.addStyleName("login-form-container");
//    container.add(MainImageBundle.INSTANCE.infoarchive().createImage());
//    container.add(new SimplePanel(loginWidget));
//    loginWidget.getParent().addStyleName("form-signin");
//    Label copyrightLabel = new Label(Locale.getLabels().copyrightEMC());
//    copyrightLabel.addStyleName("text-center");
//    copyrightLabel.addStyleName("muted");
//    container.add(copyrightLabel);
//
//    mainPanel.add(container);
    LDMBorderDecorator decorator = new LDMBorderDecorator(loginWidget);
    mainPanel.add(decorator);

    mainPanel.setCellVerticalAlignment(decorator, HasVerticalAlignment.ALIGN_MIDDLE);
    mainPanel.setCellHorizontalAlignment(decorator, HasHorizontalAlignment.ALIGN_CENTER);
//    mainPanel.addStyleName("container");
  }

  private Widget createLoginWidget() {
//    VerticalPanel panel = new VerticalPanel();
//    Labels labels = Locale.getLabels();
//    FlowPanel loginPanel = new FlowPanel();
//
//    Label heading = new Label(Locale.getLabels().pleaseSignIn());
//    heading.addStyleName("form-signin-heading");
//    loginPanel.add(heading);
//
//    tbUser.getElement().setAttribute("placeholder", labels.username());
//    tbPassword.getElement().setAttribute("placeholder", labels.password());
//    loginPanel.add(UserLoggedIn.getLoginMessage());
//    loginPanel.add(tbUser);
//    loginPanel.add(tbPassword);
//
//    Button button = new Button(labels.signIn(), this);
//    button.setStylePrimaryName("btn");
//    button.addStyleDependentName("large");
//    button.addStyleDependentName("primary");
//    loginPanel.add(button);
//
//    panel.add(loginPanel);
//    tbUser.addKeyDownHandler(this);
//    tbPassword.addKeyDownHandler(this);
	  VerticalPanel panel = new VerticalPanel();
//	  panel.addStyleName("form-signin-heading");
	    Labels labels = Locale.getLabels();
	    FlexTable table = new FlexTable();
	    table.setText(0, 0, labels.username());
	    table.setWidget(0, 1, this.tbUser);
	    table.setText(1, 0, labels.password());
	    table.setWidget(1, 1, this.tbPassword);
	    Button button = new Button(labels.logIn(), this);
	    table.setWidget(2, 1, button);
	    panel.add(table);
	    panel.setCellVerticalAlignment(table, HasVerticalAlignment.ALIGN_MIDDLE);
	    panel.setCellHorizontalAlignment(table,
	        HasHorizontalAlignment.ALIGN_CENTER);
	    this.tbUser.addKeyDownHandler(this);
	    this.tbPassword.addKeyDownHandler(this);
    return panel;
  }

  public void setFocus(final boolean value) {
    tbUser.setFocus(value);
  }

  @Override
  public void onClick(final ClickEvent event) {
    submit();
  }

  @Override
  public void onKeyDown(final KeyDownEvent event) {
    int nativeKeyCode = event.getNativeKeyCode();
    if ((nativeKeyCode == KeyCodes.KEY_ENTER) || (nativeKeyCode == ' ')) {
      submit();
    }
  }

  private void submit() {
    main.getUserSession().initUserSession(getTbUser().getText(), getTbPassword().getText());
  }

  /**
   * @return the tbUser
   */
  public TextBox getTbUser() {

      return tbUser;
  }

  /**
   * @param tbUser the tbUser to set
   */
  public void setTbUser(final TextBox tbUser) {

      this.tbUser = tbUser;
  }

  /**
   * @return the tbPassword
   */
  public PasswordTextBox getTbPassword() {

      return tbPassword;
  }

  /**
   * @param tbPassword the tbPassword to set
   */
  public void setTbPassword(final PasswordTextBox tbPassword) {

      this.tbPassword = tbPassword;
  }

}

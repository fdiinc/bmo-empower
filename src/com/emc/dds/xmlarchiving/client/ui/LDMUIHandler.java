/*******************************************************************************
 * Copyright (c) 2015 EMC Corporation. All Rights Reserved.
 *******************************************************************************/
package com.emc.dds.xmlarchiving.client.ui;

import com.emc.documentum.xml.gwt.client.FailureHandler;
import com.emc.documentum.xml.xforms.gwt.client.control.XFormsControl;
import com.emc.documentum.xml.xforms.gwt.client.control.core.XFormsCoreControl;
import com.emc.documentum.xml.xforms.gwt.client.ext.xhtml.ui.XHTMLGWTUIHandler;
import com.emc.documentum.xml.xforms.gwt.client.ui.XFormsCoreWidget;

public class LDMUIHandler extends XHTMLGWTUIHandler {

  public LDMUIHandler() {
    super();
  }

  @Override
  public XFormsCoreWidget create(XFormsCoreControl control) {
    if (control.getType() == XFormsControl.TYPE_INPUT) {
      String suggestionsAttr = control.getElement().getAttribute("class");

      String prefix = "suggestions-";
      if (suggestionsAttr != null && suggestionsAttr.contains(prefix)) {
        int indexPathIndex = suggestionsAttr.lastIndexOf("---");

        String indexName = suggestionsAttr.substring(prefix.length(), indexPathIndex);
        // String indexName = suggestionsAttr;
        String indexPath = suggestionsAttr.substring(indexPathIndex + 3);
        if (indexPath.substring(indexPath.length() - 1).equals("-")) {
          indexPath = indexPath.substring(1, indexPath.length() - 1);
        }

        XFormsCoreWidget result = new LDMInputSuggestWidget(control, indexName, indexPath);
        return result;
      }
      /**
      // NOTE: The following code is superseded by changes to SearchPane.java
      // customize select1 widget to pre-populate choices from xDB
      } else if (control.getType() == XFormsControl.TYPE_SELECT1) {
        String xquery = control.getElement().getAttribute("class");
        //System.out.println("class xquery is " + xquery);
        if (xquery != null) {
          XFormsCoreWidget result = new LDMChoicesWidget(control, xquery);
          return result;
        }
      **/
    }
    return super.create(control);
  }

  @Override
  public void onException(final Throwable t) {
    FailureHandler.handle(null, t);
  }
}

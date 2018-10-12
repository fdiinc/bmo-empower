package com.flatironssolutions.decomm.server.xproc.impl;

import com.emc.documentum.xml.dds.logging.LogCenter;
import com.emc.documentum.xml.dds.service.exception.ServiceNotAvailableException;
import com.emc.documentum.xml.dds.user.User;
import com.emc.documentum.xml.dds.xproc.DDSXProc;
import com.emc.documentum.xml.dds.xproc.exception.DDSXProcConfigurationException;
import com.emc.documentum.xml.dds.xproc.impl.XProcServiceImpl;
import com.emc.documentum.xml.xproc.io.Resolver;
import com.emc.documentum.xml.xproc.io.Writer;
import com.emc.documentum.xml.xproc.plugin.PluginManager;
import com.emc.documentum.xml.xproc.plugin.fop.FOPPlugin;
import com.flatironssolutions.decomm.xprocplugin.CSVPlugin;
import com.flatironssolutions.decomm.xprocplugin.Logger;

public class CustomXProcServiceImpl extends XProcServiceImpl {

	  @Override
	  public DDSXProc newXProc(final User user, boolean readOnly) throws DDSXProcConfigurationException,
	      ServiceNotAvailableException {

		LogCenter.log("ENTERING CustomXProcServiceImpl.newXProc");

//	    final DDSXProc ddsXProc = super.newXProc(user, readOnly);
	    final DDSXProc ddsXProc = super.newXProc(user, false);

	    final com.emc.documentum.xml.xproc.XProc xproc = ddsXProc.getXProc();
	    com.emc.documentum.xml.xproc.XProcConfiguration xprocConfig = xproc.getXProcConfiguration();

	    // register our rtf plugin
//        LogCenter.log("Calling Register for RtfPlugin.newXProc");
	    PluginManager pm = xprocConfig.getPluginManager();
//        pm.registerPlugin(RtfPlugin.class, null);
//        LogCenter.log("Registered RtfPlugin.newXProc");

	    // register our csv plugin
        LogCenter.log("Calling Register for CSVPlugin.newXProc");
        pm.registerPlugin(CSVPlugin.class, null);
        LogCenter.log("Registered CSVPlugin.newXProc");

	    // register our xslt2 plugin
//        LogCenter.log("Calling Register for xslt2Plugin.newXProc");
//        pm.registerPlugin(xslt2Plugin.class, null);
//        LogCenter.log("Registered xslt2Plugin.newXProc");
        
     // register our fop plugin
        LogCenter.log("Calling Register for FOPPlugin.newXProc");
        pm.registerPlugin(FOPPlugin.class, null);
        LogCenter.log("Registered FOPPlugin.newXProc");
        
 
       // register our custom writer resolvers for our fscpdf protocol
//        LMRWriterHandler lmrWriter = new LMRWriterHandler();
//        Writer writer = xprocConfig.getWriter();
//        writer.registerHandler(lmrWriter);
//        LogCenter.log("Registered lmr pdf  writer resolvers");
        
        // register our lmr plugin
//        LogCenter.log("Calling Register for LMRPlugin.newXProc");
//        pm.registerPlugin(LMRPlugin.class, null);
//        LogCenter.log("Registered LMRPlugin.newXProc");
        
        

        LogCenter.log("CustomXProcServiceImpl finished registering plugins and resolvers");

        return ddsXProc;
	  }
}


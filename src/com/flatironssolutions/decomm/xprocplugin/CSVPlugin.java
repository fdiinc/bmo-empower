package com.flatironssolutions.decomm.xprocplugin;

import com.emc.documentum.xml.xproc.pipeline.model.step.StepRegistry;
import com.emc.documentum.xml.xproc.plugin.GenericPlugin;
import com.emc.documentum.xml.xproc.plugin.PluginConfig;

import javax.xml.namespace.QName;

import com.emc.documentum.xml.xproc.XProcConfiguration;
import com.emc.documentum.xml.xproc.XProcException;
import com.emc.documentum.xml.xproc.io.Source;
public class CSVPlugin extends GenericPlugin {

	@Override
	public void plugin() throws Exception {
		Logger.log("entering plugin() method for CSVPlugin");

		PluginConfig config = getPluginConfig();
		XProcConfiguration xprocConfiguration = config.getXProcConfiguration();
		StepRegistry stepRegistry = xprocConfiguration.getStepRegistry();
		// register the custom step
		stepRegistry.registerStepImplementation(new QName("http://flatironssolutions.com/decomm/xproc", "csv"),
				CSVStep.class);

		// register the built-in XProc library
		xprocConfiguration.addBuiltInLibrary(
		new Source("dds://DOMAIN=resource/xproc/CSVStep.xpl"));
		
		
		Logger.log("leaving plugin() method for CSVPlugin");
	}

}

package com.flatironssolutions.decomm.xprocplugin;
import java.util.ArrayList;



import java.util.List;
import javax.xml.namespace.QName;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;

import com.emc.documentum.xml.xproc.io.Source;
import com.emc.documentum.xml.xproc.io.Target;
import com.emc.documentum.xml.xproc.io.Writer;

import com.emc.documentum.xml.xproc.pipeline.model.Binding;
import com.emc.documentum.xml.xproc.pipeline.model.Environment;

import com.emc.documentum.xml.xproc.pipeline.model.DocumentBinding;
import com.emc.documentum.xml.xproc.pipeline.model.PipelineOutput;

import com.emc.documentum.xml.xproc.pipeline.model.impl.PipelineOutputImpl;
import com.emc.documentum.xml.xproc.pipeline.model.step.AbstractAtomicStepBody;
import com.ibm.icu.text.MessagePatternUtil.Node;
import com.xhive.XhiveDriverFactory;

import com.xhive.core.interfaces.XhiveDriverIf;
import com.xhive.core.interfaces.XhivePageCacheIf;
import com.xhive.federationset.interfaces.XhiveFederationSetFactory;
import com.xhive.federationset.interfaces.XhiveFederationSetIf;

import com.xhive.util.interfaces.XhiveTransformerIf;
import org.w3c.dom.Document;


import java.io.OutputStream;

/*
 * This class extends an xProc pipeline step.  It's a custom step that takes as input the results of an xQuery
 * and transforms it to comma delimited text for use in MS Excel.  
 * This step produces a file  in transient memory that is passed back as an external document binding for the end user to download.
 * 
 */
public class CSVStep extends AbstractAtomicStepBody {

	@Override
	public void run(Environment environment) throws Exception {
		// TODO Auto-generated method stub
		Logger.log("entering CSVStep.run()");
		
		List<Source> sources = getPrimaryInputPortSources(environment);
		
		//this input contains the reference to the stylesheet which is stored in xDB
		Source styleSheet = getInputPortSource("stylesheet", environment);
		
		//these are debugging parameters.  You turn them off in the *.xpl file
		//boolean stdout = getOptionValueAsBoolean(new QName("stdout"),
		//environment);
		
		//boolean stderr = getOptionValueAsBoolean(new QName("stderr"),
		//environment);
	
		
		 //Get the driver for xHive so we can use the transformer
//		XhivePageCacheIf pageCacheIf = 
//				XhiveDriverFactory.getFederationFactory().createPageCache(4096);
//		XhiveFederationSetIf xhiveFederationSetIf = XhiveFederationSetFactory.getFederationSet("xhive://localhost:1235", pageCacheIf);
//		
//	    XhiveDriverIf driver = xhiveFederationSetIf.getFederation("mids");
//	    XhiveDriverIf driver = XhiveDriverFactory.getDriver();
//	    
//	   //initialize it if for some reason it's not already
//	    if (driver.isInitialized()== false)
//	    	driver.init();
	   
	    //this guys does the xslt transfrom on the results from the source input using the stylesheet input
	    //source input contains the xml results from the query
	    //stylesheet input contains the stylesheet
	  	XhiveTransformerIf transformer = XhiveDriverFactory.getDriver().getTransformer();
	  	//cast the node so we can use it

	  	//cast the node so we can use it
	  	Document xslDocument = (Document)styleSheet.getNode();
	  	

	   
	    
		try{
		
		//this sets up where we write out new generate CSV file to
		//transient means it's put in a temporary space that's clean up automatically so we don't have to deal with file maintenance
		
		//writer for the step
		Writer writ = getWriter();
		
		//target for the uri type
		//use the line below to write to local disk if running a junit test:
		//Target tar = writ.getTarget(null,"ExcelExport.csv");
		
		//use the line below to when fully integrate into the decomm framework to local disk if running a junit test:
		Target tar = writ.getTarget(null,"transient:ExcelExport.csv");
		
		//stream to push bytes to
		OutputStream cOut = tar.getOutputStream();
		
		//convert the xml to csv...string of bytes that contains the new comma delimited csv data
		String csvOut = transformer.transformToString(sources.get(0).getNode(), xslDocument);
		
//		byte[] csvBytes = csvOut.getBytes();
//		String minus3bytes = csvOut.substring(0, csvOut.length()- 3);
//		byte[] minusbytes = minus3bytes.getBytes();
		
		cOut.write(csvOut.getBytes("UTF-8"));
//		cOut.write(minus3bytes.getBytes());
//		cOut.write(20);
		
		 //Close the output stream and target
		cOut.close();
		tar.close();
		}
		catch (Exception e)
		{
			String errMsg = "Exception in CSVStep! Error message is: " + e.getMessage();
			Logger.log(errMsg);
		}
		
		//put the csv reference in the result port for the pipeline
		List<Binding> result = new ArrayList<Binding>();
		
		//use the line below when testing with junit on local disk
		//result.add(new DocumentBinding("ExcelExport.csv"));

		//use the line below when integrating with the app decomm framework
		result.add(new DocumentBinding("transient:ExcelExport.csv"));
		setPrimaryOutputPortBindings(result, environment);
		
		//shutdown the driver
//		driver.close();
		
	 
		Logger.log("exiting CSVStep.run()");
		
	}

}

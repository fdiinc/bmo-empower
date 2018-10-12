<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:x="http://www.emc.com/documentum/xml/xproc"
	name="main"
	xmlns:dds="http://www.emc.com/documentum/xml/dds"
	xmlns:ext="http://flatironssolutions.com/decomm/xproc"
	version="1.0">
	
	<p:input port="query"/>
	<p:input port="stylesheet"/>
	
	<!--
		<p:serialization port="result" omit-xml-declaration="false"/>
	-->
	<p:import href="dds://DOMAIN=resource/xproc/CSVStep.xpl"/>
	
	<p:add-attribute name="add-attr" match="dds:expression" attribute-name="c:content-type" attribute-value="application/xquery">
		<p:input port="source" select="//dds:expression">
			<p:pipe step="main" port="query"/>
		</p:input>
	</p:add-attribute>
	
	<p:xquery>
		<p:input port="query">
			<p:pipe step="add-attr" port="result"/>
		</p:input>
	</p:xquery>
	
	<ext:csv stdout="true" stderr="false" href="transient:ExcelExport.csv">
		<p:input port="stylesheet">
			<p:document href="dds://DOMAIN=resource/xslt/exportExcelCSV.xsl"/>
		</p:input>
	</ext:csv>
	
	<!--
		<p:identity>
	    	<p:input port="source">
	      		<p:pipe step="csv" port="result"/>
	    	</p:input>
  		</p:identity>
  	-->
</p:pipeline>
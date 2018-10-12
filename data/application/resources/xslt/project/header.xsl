<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="../demographicsDetails.xsl" />
	
	<xsl:template name="header">
		<xsl:param name="headerData"/>
		<!-- Demographics -->
		
		<span class="title14">Demographics</span>
		<xsl:for-each select="//demographics_result">
			<xsl:call-template name="demographics">
				<xsl:with-param name="demographicData" select="." />
			</xsl:call-template>
		</xsl:for-each>
		<hr/>
	</xsl:template>
	
</xsl:stylesheet>

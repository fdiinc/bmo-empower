<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:html="http://www.w3.org/1999/xhtml">
  <!-- Project customizations for project PDF -->
  

  <xsl:import href="../common/xhtml2fo.xsl"/>
  <xsl:import href="xhtml2fo_attrs.xsl"/>

  <xsl:param name="page-extent-bottom">0.5in</xsl:param>
  <xsl:param name="page-extent-left">0.5in</xsl:param>
  <xsl:param name="page-extent-right">0.5in</xsl:param>
  <xsl:param name="page-extent-top">0</xsl:param>
  <xsl:param name="page-margin-bottom">0.5in</xsl:param>
  <xsl:param name="page-margin-left">0.5in</xsl:param>
  <xsl:param name="page-margin-right">0.5in</xsl:param>
  <xsl:param name="page-margin-top">0.8in</xsl:param>

  <xsl:param name="header-margin-top">0.25in</xsl:param>
<!--
  <xsl:template match="fo:*">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
    </xsl:template>
    -->
<!--
  <xsl:template match="fo:*" mode="copy">
        <xsl:copy>
          <xsl:apply-templates select="@* | node()"/>
	</xsl:copy>
	</xsl:template>
-->

  <xsl:template match="/html:html/html:div[@id='footerBlock']">
  </xsl:template>

  <xsl:template match="/html:html/html:div[@id='headerBlock']">
  </xsl:template>

  <xsl:template name="makeFooter">
    <xsl:comment>In project makeFooter</xsl:comment>
    <xsl:apply-templates select="//html:div[@id='footerBlock']"/>
  </xsl:template>


  <xsl:template name="makeHeader">
    <xsl:comment>In project makeHeader</xsl:comment>
    <xsl:apply-templates select="//html:div[@id='headerBlock']"/>
  </xsl:template>
 
  <!-- style settings -->

  <!-- Can't use attribute-sets as they are already set in a parent template handling. -->
  <!-- Using xsl:if so that the class attribute can contain multiple classes
       camelCase should also be used, so that label and colLabel can be distingoused.
  -->

  <xsl:template name="class-template">
    <xsl:param name="class"/>
    <xsl:if test="contains($class, 'tableBorder')">
	<xsl:attribute name="border-collapse">collapse</xsl:attribute>
	<xsl:attribute name="border-spacing">0</xsl:attribute>
	<xsl:attribute name="border-style">solid</xsl:attribute>
    </xsl:if>

    <xsl:if test="contains($class, 'borderBottom')">
	<xsl:attribute name="border-collapse">collapse</xsl:attribute>
	<xsl:attribute name="border-spacing">0</xsl:attribute>
	<xsl:attribute name="border-bottom-style">solid</xsl:attribute>

    </xsl:if>

    <xsl:if test="contains($class, 'borderTop')">
	<xsl:attribute name="border-collapse">collapse</xsl:attribute>
	<xsl:attribute name="border-spacing">1px</xsl:attribute>
	<xsl:attribute name="border-top-style">solid</xsl:attribute>
    </xsl:if>

      <xsl:if test="contains($class, 'dataValue')">
	<xsl:attribute name="vertical-align">top</xsl:attribute>
		<xsl:attribute name="padding">0.2em</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'cellLeft')">
	<xsl:attribute name="text-align">left</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'cellCenter')">
	<xsl:attribute name="text-align">center</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'cellRight')">
	<xsl:attribute name="text-align">right</xsl:attribute>
      </xsl:if>

      

      <xsl:if test="contains($class, 'moneyValue')">
	<xsl:attribute name="vertical-align">top</xsl:attribute>
	<xsl:attribute name="text-align">right</xsl:attribute>
	<xsl:attribute name="padding">0.2em</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'label')">
	<xsl:attribute name="vertical-align">top</xsl:attribute>
	<xsl:attribute name="text-align">right</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
	<xsl:attribute name="padding">0.2em</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'inlineLabel')">
	<xsl:attribute name="vertical-align">top</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
	<xsl:attribute name="padding">0.2em</xsl:attribute>
      </xsl:if>

      <xsl:if test="contains($class, 'inlineLabel')">
	<xsl:attribute name="vertical-align">top</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
	<xsl:attribute name="padding">0.2em</xsl:attribute>
      </xsl:if>

      <xsl:if test="contains($class, 'colLabel')">
	<xsl:attribute name="text-align">center</xsl:attribute>
	<xsl:attribute name="vertical-align">top</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
	<xsl:attribute name="padding">0.2em</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, '100width')">
	<xsl:attribute name="width">50%</xsl:attribute>
      </xsl:if>

      <xsl:if test="contains($class, 'indent')">
	<xsl:attribute name="margin-left">1em</xsl:attribute>
      </xsl:if>

      <xsl:if test="contains($class, 'panelTitle')">
	<xsl:attribute name="background-color">#DDD</xsl:attribute>
	<xsl:attribute name="padding">0.2em</xsl:attribute>
      </xsl:if>

      <xsl:if test="contains($class, 'title16')">
	<xsl:attribute name="keep-with-next">always</xsl:attribute>
	<xsl:attribute name="font-size">1.6em</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'title14')">
	<xsl:attribute name="keep-with-next">always</xsl:attribute>
	<xsl:attribute name="font-size">1.4em</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'title12')">
	<xsl:attribute name="keep-with-next">always</xsl:attribute>
	<xsl:attribute name="font-size">1.2em</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
      </xsl:if>
      <xsl:if test="contains($class, 'title11')">
	<xsl:attribute name="keep-with-next">always</xsl:attribute>
	<xsl:attribute name="font-size">1.1em</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'title10')">
	<xsl:attribute name="keep-with-next">always</xsl:attribute>
	<xsl:attribute name="font-size">1.0em</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'title08')">
	<xsl:attribute name="keep-with-next">always</xsl:attribute>
	<xsl:attribute name="font-size">0.8em</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'size11')">
	<xsl:attribute name="font-size">1.1em</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'size09')">
	<xsl:attribute name="font-size">0.9em</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'size08')">
	<xsl:attribute name="font-size">0.8em</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="contains($class, 'size07')">
	<xsl:attribute name="font-size">0.7em</xsl:attribute>
      </xsl:if>

      <xsl:if test="contains($class, 'deceased')">
	<xsl:attribute name="color">red</xsl:attribute>
	<xsl:attribute name="font-weight">700</xsl:attribute>
      </xsl:if>

      <xsl:if test="contains($class, 'demographics')">
	<xsl:attribute name="font-size">0.9em</xsl:attribute>
      </xsl:if>

  </xsl:template>

</xsl:stylesheet>

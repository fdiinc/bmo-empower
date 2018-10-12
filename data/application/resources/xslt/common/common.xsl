<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fo="http://www.w3.org/1999/XSL/Format"
>

  <xsl:import href="panels.xsl"/>
  <xsl:import href="formatUtils.xsl"/>
  <!-- default css styles -->
  <xsl:template name="cssStyles"/>

  <xsl:template name="Title">NO TITLE DEFINED</xsl:template>

  <xsl:template name="makeMetaData"/>
  
  <xsl:template match='/'>
    <html>
<head>
      <xsl:call-template name="makeHead"/>
</head>
      <body>
	<xsl:call-template name="matchRecords"/>
      </body>
    </html>
  </xsl:template>



  
  <!-- Generate the HTML head element content -->
  <xsl:template name="makeHead">
        <title>
          <!-- Title template must be provided by including stylesheet -->
          <xsl:call-template name="Title" />
        </title>
	<xsl:call-template name="makeMetaData"/>
	<xsl:call-template name="panelsHead" />
	<xsl:call-template name="cssStyles" />
    </xsl:template>

</xsl:stylesheet>

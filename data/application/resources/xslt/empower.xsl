<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- XHTML output with XML syntax -->
    <xsl:output method="xml" encoding="utf-8" indent="no"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
        doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />
    <xsl:output method="html" />
    <xsl:param name="data-base-uri" />

    <!-- Include common ECP structure xsl -->
    <xsl:include href="common/ecpCommonStructure.xsl" />

    <xsl:template match="results">
        <xsl:call-template name="makeHead" />
        <xsl:call-template name="makeBody" />
    </xsl:template>

    <!-- Generate the HTML body element content -->
    <xsl:template name="makeBody">
        <body>
            <xsl:call-template name="header" />
            <xsl:call-template name="details" />
        </body>
    </xsl:template>

</xsl:stylesheet>
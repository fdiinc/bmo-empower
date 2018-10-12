<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Include common ECP xsl -->
    <xsl:include href="ecpCommon.xsl" />
    
    <xsl:template match="/">
        <!-- always emit at least an empty HTML element -->
        <html>
            <!-- and look at the rest of the file -->
            <xsl:apply-templates select="results" />
        </html>
    </xsl:template>

    <xsl:template name="makeHead">
        <head>
            <title>Record Details</title>
            <style type="text/css">
                body{
                font-family: 'Lucida Sans Unicode',
                'Lucida Grande', sans-serif;
                font-size: 12px;
                }
                .header{
                padding: 0px 0px 20px 0px;
                }
                table{
                border-collapse:
                collapse;
                }
                td{
                vertical-align:top;
                padding: 10px;
                }
                .panelContent{
                overflow:auto;
                }
                .panel{
                border-left: solid
                1px #CCC;
                border-right: solid 1px #999;
                border-top: solid
                1px #999;
                border-bottom: solid 1px #CCC;
                }
                .panelHeader{
                padding-top: 20px;
                }
                .contentHeader{
                background-color:
                #EEE;
                border-bottom: solid 1px #CCC;
                }
                .pre{
                white-space:
                pre-wrap;
                }
            </style>
        </head>
    </xsl:template>

    <xsl:template name="details">
        <xsl:for-each select="detailSections/detailSection">
            <!-- Display section type heading2 -->
            <xsl:if test="@type = 'heading2'">
                <div>
                    <h2>
                        <xsl:value-of select="@label" />
                    </h2>
                </div>
            </xsl:if>

            <!-- Display section type heading3 -->
            <xsl:if test="@type = 'heading3'">
                <div>
                    <h3>
                        <xsl:value-of select="@label" />
                    </h3>
                </div>
            </xsl:if>

            <!-- Display section type record -->
            <xsl:if test="@type = 'record'">
                <xsl:call-template name="printDataRow">
                    <xsl:with-param name="data" select="record" />
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

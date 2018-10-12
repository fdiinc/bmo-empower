<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../common/common.xsl"/>

  <xsl:import href="header.xsl"/>
  <xsl:import href="pageHeader.xsl"/>
  <xsl:import href="pageFooter.xsl"/>

  <xsl:param name="is-lmr" select="false()"/>
  <xsl:param name="is-pdf" select="false()"/>

  <!--  
       Project wide xml to XHTML master xslt.
       Includes the panel, formatUtil xslt libraries.
       
  -->
  <xsl:template match="/">
    <html>
<head>
<xsl:call-template name="makeHead"/>
      <xsl:call-template name="pageHeader"/>
      <xsl:call-template name="pageFooter"/>
</head>
<body>
        <xsl:call-template name="header">
          <xsl:with-param name="headerData" select="//header[1]"/>
        </xsl:call-template>
        <xsl:call-template name="matchRecords"/>
      </body>
    </html>
  </xsl:template>


	<xsl:template name="formattedAddress">
	  <xsl:param name="address" />
	  <xsl:if test="string-length(translate($address/@address1,' ',''))">
	  <span class="formattedAddress">
          <xsl:value-of select="$address/@address1"/><br/>
	  <xsl:if test="string-length(translate($address/@address2,' ',''))">
          <xsl:value-of select="$address/@address2"/><br/>
	  </xsl:if>
	  <xsl:if test="string-length(translate($address/@address3,' ',''))">
            <xsl:value-of select="$address/@address3"/><br/>
	  </xsl:if>
	  <xsl:if test="string-length(translate($address/@city,' ',''))">
            <xsl:value-of select="$address/@city"/><xsl:text>, </xsl:text><xsl:value-of select="$address/@state"/><xsl:text>&#160;</xsl:text><xsl:value-of select="$address/@zip"/><br/>
	    <xsl:value-of select="$address/@country"/>
	  </xsl:if>
	  </span>
	  </xsl:if>
	</xsl:template>


  <xsl:template name="date-formatter">
    <xsl:param name="date-time"/>
    <xsl:param name="date-format" select="'dd-MMM-yyyy'"/>
    <xsl:param name="time-format" select="'HH:mm A'" />
    <xsl:param name="empty-date" select="'0000-00-00'" />
    <xsl:param name="no-date" select="''" />
    <xsl:param name="display-date" select="true()"/>
    <xsl:param name="display-time" select="false()" />
    <xsl:param name="short-date" select="true()"/>

    <xsl:call-template name="generic-date-formatter">
      <xsl:with-param name="date-time" select="$date-time"/>
      <xsl:with-param name="date-format" select="$date-format"/>
      <xsl:with-param name="time-format" select="$time-format"/>
      <xsl:with-param name="empty-date" select="$empty-date"/>
      <xsl:with-param name="no-date" select="$no-date"/>
      <xsl:with-param name="display-date" select="$display-date"/>
      <xsl:with-param name="display-time" select="$display-time"/>
      <xsl:with-param name="short-date" select="$short-date"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="phone-formatter">
    <xsl:param name="phone"/>
    <xsl:param name="useParens" select="false()"/>
    <xsl:call-template name="generic-phone-formatter">
      <xsl:with-param name="phone" select="$phone"/>
      <xsl:with-param name="useParens" select="$useParens"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="ssn-formatter">
    <xsl:param name="ssn"/>
    <xsl:param name="shroud" select="false()"/>
    <xsl:call-template name="generic-ssn-formatter">
      <xsl:with-param name="ssn" select="$ssn"/>
      <xsl:with-param name="shroud" select="$shroud"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="cssStyles">
    <style type="text/css">

      #footerBlock {
      display: none;
      }
      #headerBlock {
      display: none;
      }
      .customCollapsiblePanelTab {
      background-color: #DDD;
      border-bottom: solid 1px #CCC;
      margin: 0px;
      padding: 2px;
      cursor: pointer;
      -moz-user-select: none;
      -khtml-user-select: none;
      }
      .header{
      font-weight:
      bold;
      padding:0px 30px 0px 10px;
      vertical-align:top;
      }
      pre{
      margin:0;
      }
      body {
      font-family : 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
 
      font-size : 9pt;
      }
      .header {
      font-weight : bold;
      padding : 0px 30px 0px 10px;
      vertical-align : top;
      }
      table {
      border-collapse: collapse;

      }
      .tableBorder {
      border-collapse: collapse;
      border: 1px solid black;
      }
      .headerTable {
      padding: 0em;
//      border: 1px solid black;
      }
      th {
      text-align : left;
      }
      .smallerBox {

      }

      .inlineLabel {
      font-weight: bold;
      vertical-align : top;
      padding:0.2em;
      }

      .label {
      font-weight: bold;
      text-align: right;
      vertical-align : top;
      padding:0.2em;
      }
      .colLabel {
      font-weight: bold;
      text-align: center;
      //		    font-size: 0.8em;
      vertical-align : top;
      padding:0.2em;
      }
      .dataValue {
      vertical-align : top;
      padding:0.2em;
      }
      .moneyValue {
      vertical-align : top;
      text-align: right;
      padding:0.2em;
      }

      .cellRight {
      text-align: right;
      }

      .centeredValue {
      vertical-align : top;
      padding:0.2em;
      align:center;
      }
      .indent {
      margin-left: 1em;
      }
      .panelTitle {
      background-color: #DDD;
      }
      .title16 {
      font-weight: bold;
      font-size: 1.6em;
      }
      .title14 {
      font-weight: bold;
      font-size: 1.4em;
      }
      .title12 {
      font-weight: bold;
      font-size: 1.2em;
      }
      .title11 {
      font-weight: bold;
      font-size: 1.1em;
      }
      .title10 {
      font-weight: bold;
      font-size: 1.0em;
      }
      .title08 {
      font-weight: bold;
      font-size: 0.8em;
      }
      .size12 {
      font-size: 1.2em;
      }
      .size10 {
      font-size: 1.0em;
      }
      .size09 {
      font-size: 0.9em;
      }
      .size08 {
      font-size: 0.8em;
      }
      .size07 {
      font-size: 0.7em;
      }

      
      .formattedAddress {
      text-align: left;
      }
      hr {
      //		    display:none;
      }
      .show {
      border: 1px inset
      }
      .deceased {
      color: red;
      font-weight:bold;
      }
      .abnormalValue{
      color: red;
      font-weight:bold;
      }
    </style>
  </xsl:template>
  
  <xsl:template name="facility">
    <xsl:variable name="appCode" select="//demographics_result/@appCode"/>
    <xsl:choose>
      <xsl:when test="$appCode = 'JHD'">Jewish Health Downtown</xsl:when>
      <xsl:when test="$appCode = 'SHL'">Jewish Health Shelbyville</xsl:when>
      <xsl:when test="$appCode = 'FRZ'">Frazier Rehab Institute</xsl:when>
      <xsl:when test="$appCode = 'SOIN'">Southern Indiana Rehab Hospital</xsl:when>
      <xsl:when test="$appCode = 'default'">Jewish Health Invision - Development</xsl:when>
      <xsl:otherwise>Jewish Health Invision</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="makeAllScriptsMetaData">
    <xsl:param name="title"/>
    <xsl:param name="patientName"/>
    <xsl:param name="mrn"/>
    <xsl:param name="requestedUserId"/>
    <xsl:param name="requestedDate"/>
    <xsl:call-template name="makeMetaDataItem">
      <xsl:with-param name="name" select="'title'"/>
      <xsl:with-param name="value" select="$title"/>
    </xsl:call-template>

    <xsl:call-template name="makeMetaDataItem">
      <xsl:with-param name="name" select="'patientName'"/>
      <xsl:with-param name="value" select="$patientName"/>
    </xsl:call-template>
    <xsl:call-template name="makeMetaDataItem">
      <xsl:with-param name="name" select="'mrn'"/>
      <xsl:with-param name="value" select="$mrn"/>
    </xsl:call-template>
    <!--    <xsl:call-template name="requestedUserId">
      <xsl:with-param name="name" select="'requestedUserId'"/>
      <xsl:with-param name="value" select="$requestedUserId"/>
    </xsl:call-template>
    <xsl:call-template name="requestedDate">
      <xsl:with-param name="name" select="'requestedDate'"/>
      <xsl:with-param name="value" select="$requestedDate"/>
      </xsl:call-template>
-->
  </xsl:template>
  <!-- this looks like it has been refactored out -->
  <xsl:template name="makeMetaData">
    <meta/>
    <xsl:call-template name="makeAllScriptsMetaData">
      <xsl:with-param name="title">
        <xsl:call-template name="Title"/>
      </xsl:with-param>
      <xsl:with-param name="patientName" select="//header/@name"/>
      <xsl:with-param name="mrn" select="//header/@mrn"/>
      <xsl:with-param name="requestedUserId" select="''"/>
      <xsl:with-param name="requestedDate" select="''"/>
    </xsl:call-template>

  </xsl:template>


</xsl:stylesheet>

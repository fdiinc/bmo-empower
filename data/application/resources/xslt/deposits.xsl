<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- XHTML output with XML syntax -->
    <xsl:output method="xml" encoding="utf-8" indent="no"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
        doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />
    <xsl:output method="html" />
    <xsl:param name="data-base-uri" />

    <!-- Include common ECP xsl -->
    <xsl:include href="common/empowerCommon.xsl" />

    <xsl:template match="/">
        <!-- always emit at least an empty HTML element -->
        <html>
            <!-- and look at the rest of the file -->
            <xsl:apply-templates select="results" />
        </html>
    </xsl:template>

    <xsl:template name="makeHead">
        <head>
            <title>Deposit Details</title>
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
                padding: 2px;
                }
                th{
                background-color: #d9d9d9;
                }
                .panelContent{
                overflow:auto;
                }
                .panel{
                border-left: solid
                1px #CCC;
                border-right: solid
                1px #999;
                border-top: solid
                1px #999;
                border-bottom: solid
                1px #CCC;
                }
                .panelHeader{
                padding-top: 20px;
                }
                .contentHeader{
                background-color:
                #EEE;
                border-bottom:
                solid 1px #CCC;
                }
                .pre{
                white-space:
                pre-wrap;
                }
            </style>
        </head>
    </xsl:template>

   <xsl:template name="borrInfo">

        <xsl:variable name="borrData"
            select="accountInfo/borrowers" />

        <xsl:variable name="propData"
            select="accountInfo/PROPINFO-ROW" />
 
            <h2>
                Account Info
            </h2>
		<table >
		<tr>
			<td  colspan='2' ><b>Loan Number:</b><xsl:value-of select="concat(' ', $borrData/BORRINFO-ROW[1]/LNKEY)"/> </td>
		</tr> 
		<xsl:for-each select="$borrData/BORRINFO-ROW">
		<tr ><td cellpadding='1px' cellspacing='0px'>
			<xsl:if test="WHICHBORR = 1">
				<b>Borrower:</b> 
			</xsl:if>	
			<xsl:if test="WHICHBORR != 1">
				<b>Co-Borrower:</b> 
			</xsl:if>
				
						<xsl:value-of select="concat(
						./BORR_FIRST,
						' ',
						./BORR_MIDDLE,
						' ',
						./BORR_LAST
						)" 
						/>
			</td>
			<td cellpadding='1px'  cellspacing='0px'>
						<b>SSN/ITIN:</b>
						<xsl:value-of select="concat(' ',
						./BORR_SSN)"/>
			</td>
			</tr>
		</xsl:for-each>
		<tr>
		
		<td colspan='2' ><b>Property Address:</b> 	<xsl:value-of select="concat(
							' ', 
							$propData/PROP_ADDR, 
							' ',
							$propData/PROP_ADDR2, 
							',  ', 
							$propData/PROP_CITY,
							',  ', 
							$propData/PROP_STATE,
							'  ', 
							$propData/PROP_ZIP)"
							/>
		</td></tr>
		</table>

   </xsl:template>

    <xsl:template name="depositDetails">

        <xsl:variable name="depositsData"
            select="depositsSection/U_GL_DEPOSITS-ROW" />
 
            <h2>
                Deposit Details
            </h2>
		<table border='3'>
			<tr>
				<th>Deposit Name</th>
				<th>Total Deposit<br/>Collected</th>
				<th>Deposit<br/>Confirmed</th>
				<th>Date Deposit<br/>Collected (MM/DD/YYYY)</th>
				<th>Date Deposit<br/>Confirmed (MM/DD/YYYY)</th>
				<th>Amount<br/>Reversed</th>
				<th>Deposit<br/>Reversed</th>
			</tr>
			<tr>
				<td>Application Deposit</td>
				<td align='right'><xsl:value-of select="$depositsData/APP_DEP_AMT"/></td>
				<td align='center'><xsl:value-of select="$depositsData/APP_DEP_CONFIRMED"/></td>
				<td><xsl:value-of select="$depositsData/APP_LASTPD_DT"/></td>
				<td><xsl:value-of select="$depositsData/APP_DEP_CONFIRMED_DT"/></td>
				<td align='right'><xsl:value-of select="$depositsData/APP_DEP_REVERSED_AMT"/></td>
				<td align='center'><xsl:value-of select="$depositsData/APP_DEP_REVERSED"/></td>
			</tr>
			<tr>
				<td>Lock-In Deposit</td>
				<td align='right'><xsl:value-of select="$depositsData/LOCK_DEP_AMT"/></td>
				<td align='center'><xsl:value-of select="$depositsData/LOCK_DEP_CONFIRMED"/></td>
				<td><xsl:value-of select="$depositsData/LOCK_LASTPD_DT"/></td>
				<td><xsl:value-of select="$depositsData/LOCK_DEP_CONFIRMED_DT"/></td>
				<td align='right'><xsl:value-of select="$depositsData/LOCK_DEP_REVERSED_AMT"/></td>
				<td align='center'><xsl:value-of select="$depositsData/LOCK_DEP_REVERSED"/></td>
			</tr>
			<tr>
				<td><xsl:value-of select="$depositsData/MISC1_DEP_DESC"/></td>
				<td align='right'><xsl:value-of select="$depositsData/MISC1_DEP_AMT"/></td>
				<td align='center'><xsl:value-of select="$depositsData/MISC1_DEP_CONFIRMED"/></td>
				<td><xsl:value-of select="$depositsData/MISC1_LASTPD_DT"/></td>
				<td><xsl:value-of select="$depositsData/MISC1_DEP_CONFIRMED_DT"/></td>
				<td align='right'><xsl:value-of select="$depositsData/MISC1_DEP_REVERSED_AMT"/></td>
				<td align='center'><xsl:value-of select="$depositsData/MISC1_DEP_REVERSED"/></td>
			</tr>
			<tr>
				<td><xsl:value-of select="$depositsData/MISC2_DEP_DESC"/></td>
				<td align='right'><xsl:value-of select="$depositsData/MISC2_DEP_AMT"/></td>
				<td align='center'><xsl:value-of select="$depositsData/MISC2_DEP_CONFIRMED"/></td>
				<td><xsl:value-of select="$depositsData/MISC2_LASTPD_DT"/></td>
				<td><xsl:value-of select="$depositsData/MISC2_DEP_CONFIRMED_DT"/></td>
				<td align='right'><xsl:value-of select="$depositsData/MISC2_DEP_REVERSED_AMT"/></td>
				<td align='center'><xsl:value-of select="$depositsData/MISC2_DEP_REVERSED"/></td>
			</tr>
			<tr>
				<td><xsl:value-of select="$depositsData/MISC3_DEP_DESC"/></td>
				<td align='right'><xsl:value-of select="$depositsData/MISC3_DEP_AMT"/></td>
				<td align='center'><xsl:value-of select="$depositsData/MISC3_DEP_CONFIRMED"/></td>
				<td><xsl:value-of select="$depositsData/MISC3_LASTPD_DT"/></td>
				<td><xsl:value-of select="$depositsData/MISC3_DEP_CONFIRMED_DT"/></td>
				<td align='right'><xsl:value-of select="$depositsData/MISC3_DEP_REVERSED_AMT"/></td>
				<td align='center'><xsl:value-of select="$depositsData/MISC3_DEP_REVERSED"/></td>
			</tr>
		</table>
<br/>
		<table width='600'>
			<tr>
			<th>Total App Dep Outstanding: <xsl:value-of select="$depositsData/TOTAL_APP_DEPOSIT_OUT"/></th><th>Dispositioned Money: <xsl:value-of select="$depositsData/DISPOSITIONED_MONEY"/></th>
			</tr>
		</table>

    </xsl:template>

    <xsl:template match="results">
        <xsl:call-template name="makeHead" />
        <xsl:call-template name="makeBody" />
    </xsl:template>

    <!-- Generate the HTML body element content -->
    <xsl:template name="makeBody">
        <body>
            <xsl:call-template name="borrInfo" /> 
            <xsl:call-template name="depositDetails" />
        </body>
    </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- XHTML output with XML syntax -->
    <xsl:output method="xml" encoding="utf-8" indent="no"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
        doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />
    <xsl:output method="html" />
    <xsl:param name="data-base-uri" />

    <!-- Include common empower xsl -->
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
            <title>Payment Details</title>
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

    <xsl:template name="paymentDetails">


        <xsl:variable name="paymentsData"
            select="paymentsSection/U_GL_PAYMENTS-ROW" />
 
            <h2>
                Payment Details
            </h2>

		<table border='3'>
			<tr>
				<th>Description</th>
				<th>Standard<br/>Fee Amount</th>
				<th>Amount<br/>Paid</th>
				<th>Current<br/>Balance</th>
				<th>Payee</th>
				<th>Confirmed</th>
				<th>Payment<br/>Confirmed Date<br/>(MM/DD/YYYY)</th>
				<th>Internal<br/>Charge</th>
				<th>BUC</th>
				<th>GL Account<br/>Number</th>
			</tr>
			<tr>
				<td>Application Deposit</td>
				<td align='right'><xsl:value-of select="$paymentsData/APP_DEP_STD_FEE"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/APP_DEP_AMT_PD"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/APP_DEP_CURR_BAL"/></td>
				<td><xsl:value-of select="$paymentsData/APP_DEP_FEE_PAYEE"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/APP_DEP_PD_CONFIRMED"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/APP_DEP_PD_CONFIRMED_DT"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/APP_DEP_INTERNAL_CHG"/></td>
				<td ><xsl:value-of select="$paymentsData/APP_DEP_COST_CENTER"/></td>
				<td ><xsl:value-of select="$paymentsData/APP_DEP_FEE_GL_ACCOUNT"/>&#160;</td>
			</tr>
			<tr>
				<td>Appraisal Fee</td>
				<td align='right'><xsl:value-of select="$paymentsData/APPR_STD_FEE"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/APPR_AMT_PD"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/APPR_CURR_BAL"/></td>
				<td><xsl:value-of select="$paymentsData/APPR_FEE_PAYEE"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/APPR_PD_CONFIRMED"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/APPR_PD_CONFIRMED_DT"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/APPR_INTERNAL_CHG"/></td>
				<td ><xsl:value-of select="$paymentsData/APPR_COST_CENTER"/></td>
				<td ><xsl:value-of select="$paymentsData/APPR_FEE_GL_ACCOUNT"/>&#160;</td>
			</tr>
			<tr>
				<td>Credit Report Fee</td>
				<td align='right'><xsl:value-of select="$paymentsData/CREDIT_STD_FEE"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/CREDIT_AMT_PD"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/CREDIT_CURR_BAL"/></td>
				<td><xsl:value-of select="$paymentsData/CREDIT_FEE_PAYEE"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/CREDIT_PD_CONFIRMED"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/CREDIT_PD_CONFIRMED_DT"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/CREDIT_INTERNAL_CHG"/></td>
				<td ><xsl:value-of select="$paymentsData/CREDIT_COST_CENTER"/></td>
				<td ><xsl:value-of select="$paymentsData/CREDIT_FEE_GL_ACCOUNT"/>&#160;</td>
			</tr>
			<tr>
				<td>LP Fee</td>
				<td align='right'><xsl:value-of select="$paymentsData/LP_STD_FEE"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/LP_AMT_PD"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/LP_CURR_BAL"/></td>
				<td><xsl:value-of select="$paymentsData/LP_FEE_PAYEE"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/LP_PD_CONFIRMED"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/LP_PD_CONFIRMED_DT"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/LP_INTERNAL_CHG"/></td>
				<td ><xsl:value-of select="$paymentsData/LP_COST_CENTER"/></td>
				<td ><xsl:value-of select="$paymentsData/LP_FEE_GL_ACCOUNT"/>&#160;</td>
			</tr>
			<tr>
				<td>Flood Cert Fee</td>
				<td align='right'><xsl:value-of select="$paymentsData/FLOOD_STD_FEE"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/FLOOD_AMT_PD"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/FLOOD_CURR_BAL"/></td>
				<td><xsl:value-of select="$paymentsData/FLOOD_FEE_PAYEE"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/FLOOD_PD_CONFIRMED"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/FLOOD_PD_CONFIRMED_DT"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/FLOOD_INTERNAL_CHG"/></td>
				<td ><xsl:value-of select="$paymentsData/FLOOD_COST_CENTER"/></td>
				<td ><xsl:value-of select="$paymentsData/FLOOD_FEE_GL_ACCOUNT"/>&#160;</td>
			</tr>
			<tr>
				<td>Inspection Fee</td>
				<td align='right'><xsl:value-of select="$paymentsData/INSP_STD_FEE"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/INSP_AMT_PD"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/INSP_CURR_BAL"/></td>
				<td><xsl:value-of select="$paymentsData/INSP_FEE_PAYEE"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/INSP_PD_CONFIRMED"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/INSP_PD_CONFIRMED_DT"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/INSP_INTERNAL_CHG"/></td>
				<td ><xsl:value-of select="$paymentsData/INSP_COST_CENTER"/></td>
				<td ><xsl:value-of select="$paymentsData/INSP_FEE_GL_ACCOUNT"/>&#160;</td>
			</tr>
			<tr>
				<td><xsl:value-of select="$paymentsData/MISC1_FEE_DESC"/></td>
				<td align='right'><xsl:value-of select="$paymentsData/MISC1_FEE_AMT"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/MISC1_AMT_PD"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/MISC1_CURR_BAL"/></td>
				<td><xsl:value-of select="$paymentsData/MISC1_FEE_PAYEE"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/MISC1_PD_CONFIRMED"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/MISC1_PD_CONFIRMED_DT"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/MISC1_INTERNAL_CHG"/></td>
				<td ><xsl:value-of select="$paymentsData/MISC1_COST_CENTER"/></td>
				<td ><xsl:value-of select="$paymentsData/MISC1_FEE_GL_ACCOUNT"/>&#160;</td>
			</tr>
			<tr>
				<td><xsl:value-of select="$paymentsData/MISC2_FEE_DESC"/></td>
				<td align='right'><xsl:value-of select="$paymentsData/MISC2_FEE_AMT"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/MISC2_AMT_PD"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/MISC2_CURR_BAL"/></td>
				<td><xsl:value-of select="$paymentsData/MISC2_FEE_PAYEE"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/MISC2_PD_CONFIRMED"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/MISC2_PD_CONFIRMED_DT"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/MISC2_INTERNAL_CHG"/></td>
				<td ><xsl:value-of select="$paymentsData/MISC2_COST_CENTER"/></td>
				<td ><xsl:value-of select="$paymentsData/MISC2_FEE_GL_ACCOUNT"/>&#160;</td>
			</tr>
			<tr>
				<td><xsl:value-of select="$paymentsData/MISC3_FEE_DESC"/></td>
				<td align='right'><xsl:value-of select="$paymentsData/MISC3_FEE_AMT"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/MISC3_AMT_PD"/></td>
				<td  align='right'><xsl:value-of select="$paymentsData/MISC3_CURR_BAL"/></td>
				<td><xsl:value-of select="$paymentsData/MISC3_FEE_PAYEE"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/MISC3_PD_CONFIRMED"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/MISC3_PD_CONFIRMED_DT"/></td>
				<td align='center'><xsl:value-of select="$paymentsData/MISC3_INTERNAL_CHG"/></td>
				<td ><xsl:value-of select="$paymentsData/MISC3_COST_CENTER"/></td>
				<td ><xsl:value-of select="$paymentsData/MISC3_FEE_GL_ACCOUNT"/>&#160;</td>
			</tr>

			<!-- Now process all the CONT rcords -->
			<xsl:for-each select="paymentsSection/U_GL_PAYMENTSCONT/U_GL_PAYMENTSCONT-ROW">
			<tr >
				<td><xsl:value-of select="./MISC_FEE_DESC"/></td>
				<td align='right'><xsl:value-of select="./MISC_FEE_AMT"/></td>
				<td  align='right'><xsl:value-of select="./MISC_AMT_PAID"/></td>
				<td  align='right'><xsl:value-of select="./MISC_CURR_BAL"/></td>
				<td><xsl:value-of select="./MISC_FEE_PAYEE"/></td>
				<td align='center'><xsl:value-of select="./MISC_PD_CONFIRMED"/></td>
				<td align='center'><xsl:value-of select="./MISC_PD_CONFIRMED_DT"/></td>
				<td align='center'><xsl:value-of select="./MISC_INTERNAL_CHG"/></td>
				<td ><xsl:value-of select="./MISC_COST_CENTER"/></td>
				<td ><xsl:value-of select="./MISC_FEE_GL_ACCOUNT"/>&#160;</td>

			</tr>
			</xsl:for-each>

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
            <xsl:call-template name="paymentDetails" />
        </body>
    </xsl:template>

</xsl:stylesheet>

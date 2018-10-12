<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template name="pageFooter">
	  <xsl:param name="footerData"/>
	  <noscript>
	  <div id="footerBlock">

		<table width="100%" class="footerTable pdfFooter borderTop " >
			<colgroup>
			  <col width="40%"/>
			  <col width="20%"/>
			  <col width="40%"/>
			</colgroup>

			<tr>
			  <td class="cellLeft">
			    <xsl:call-template name="leftFooter"/>
			  </td>
			  <td class="cellCenter"><page-number/> of
			  <page-number-citation-last/>
			  </td>
			<td class="cellRight">
			  <xsl:call-template name="rightFooter"/>
			</td>

			</tr>
		</table>
	  </div>
	  </noscript>
	</xsl:template>

	<xsl:template name="leftFooter">
	
	</xsl:template>
	
	<xsl:template name="rightFooter">

	</xsl:template>
	
</xsl:stylesheet>

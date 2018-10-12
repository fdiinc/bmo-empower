<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <!--  Trick, first row is two column, second is 3 column, make 6 cells and use colspans -->
  <xsl:template name="pageHeader">
    <noscript>
      <div id="headerBlock">
	<table width="100%" class="headerTable pdfHeader borderBottom">
	  <colgroup>
	    <col width="16.7%"/>
	    <col width="16.7%"/>
	    <col width="16.6%"/>
	    <col width="16.6%"/>
	    <col width="16.7%"/>
	    <col width="16.7%"/>
	  </colgroup>

	  <tr>
	    <td colspan="3" class="cellLeft title12">
	    	<xsl:call-template name="facility"/>
	    </td>
	    <td colspan="3" class="cellRight title12">
	      <xsl:call-template name="Title"/>
	    </td>
	  </tr>
	  <tr>
	    <td colspan="2" class="cellLeft">
	      <xsl:value-of select="//demographics_result/@name"/>&#160;
	    </td>
	    <td colspan="2" class="cellCenter">
	      MRN:&#160;

	      <xsl:value-of select="//demographics_result/@mrn"/>
	      
	    </td>
	    <td colspan="2" class="cellRight">
	      DOB:&#160;
				  <xsl:call-template name="date-formatter">
				    <xsl:with-param name="date-time"
						    select="//demographics_result/@dob"/>
				  </xsl:call-template>
	    </td>
	  </tr>
	</table>
      </div>
    </noscript>
  </xsl:template>

</xsl:stylesheet>

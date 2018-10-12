<?xml version="1.0" encoding="UTF-8"?>
<!--
Override any project wide xhtml2fo element attribute-sets.    Note table doesn't seem to work.
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:html="http://www.w3.org/1999/xhtml">

  <!--======================================================================
      Attribute Sets
      =======================================================================-->
  <!-- Override any attribute sets globally for the project PDFs -->
  
  <xsl:attribute-set name="body">
    <xsl:attribute name="font-size">8pt</xsl:attribute>
 <xsl:attribute name="font-family">'Lucida Sans Unicode', 'Lucida Grande', sans-serif</xsl:attribute> 

  </xsl:attribute-set>

  
  <xsl:attribute-set name="table">
    <xsl:attribute name="border-collapse">collapse</xsl:attribute>
    <xsl:attribute name="border-spacing">0</xsl:attribute>
    <xsl:attribute name="border">1px</xsl:attribute>
    <xsl:attribute name="margin-top">0.5em</xsl:attribute>
    <xsl:attribute name="margin-bottom">0.5em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="page-header">
        <xsl:attribute name="width">100%</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="page-footer">
    <xsl:attribute name="width">100%</xsl:attribute>
  </xsl:attribute-set>



  
</xsl:stylesheet>

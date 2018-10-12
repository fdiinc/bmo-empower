<?xml version="1.0" encoding="UTF-8"?>
<!--

Copyright Antenna House, Inc. (http://www.antennahouse.com) 2001, 2002.

Since this stylesheet is originally developed by Antenna House to be used with XSL Formatter, it may not be compatible with another XSL-FO processors.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, provided that the above copyright notice(s) and this permission notice appear in all copies of the Software and that both the above copyright notice(s) and this permission notice appear in supporting documentation.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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
    <xsl:attribute name="font-size">9pt</xsl:attribute>
 <xsl:attribute name="font-family">'Lucida Sans Unicode', 'Lucida Grande', sans-serif</xsl:attribute>
  </xsl:attribute-set>

  
  <xsl:attribute-set name="table">
    <xsl:attribute name="border-collapse">separate</xsl:attribute>
    <xsl:attribute name="border-spacing">0</xsl:attribute>
    <xsl:attribute name="border">1px</xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!--
Override Elements specific elements across all InfoArchive projects.

Table: Remove the caption handling
Add Yes/No for Html input checkbox.

Add class handling, via a class-templates templates that sets attributes on the element with the class attribute

-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:html="http://www.w3.org/1999/xhtml">

  <xsl:import href="antennahouse/xhtml2fo.xsl"/>
<!-- Override top html to include entities -->

  <xsl:param name="page-width">8.5in</xsl:param>
  <xsl:param name="page-height">11in</xsl:param>

  <xsl:param name="page-extent-bottom">0</xsl:param>
  <xsl:param name="page-extent-left">0</xsl:param>
  <xsl:param name="page-extent-right">0</xsl:param>
  <xsl:param name="page-extent-top">0</xsl:param>
  <xsl:param name="page-margin-bottom">0.5in</xsl:param>
  <xsl:param name="page-margin-left">0.5in</xsl:param>
  <xsl:param name="page-margin-right">0.5in</xsl:param>
  <xsl:param name="page-margin-top">0.5in</xsl:param>

    <xsl:param name="header-margin-top">0</xsl:param>

  <xsl:template match="html:noscript"/>

  <xsl:template match="noscript"/>

  <xsl:template match="html:body">
    <fo:page-sequence master-reference="all-pages">
      <fo:title>
        <xsl:value-of select="/html:html/html:head/html:title"/>
      </fo:title>
      <fo:static-content flow-name="page-header">
        <fo:block space-before.conditionality="retain"
                  space-before="{$header-margin-top}"
                  xsl:use-attribute-sets="page-header">
	  <xsl:call-template name="makeHeader"/>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="page-footer">
        <fo:block space-after.conditionality="retain"
                  space-after="{$page-footer-margin}"
                  xsl:use-attribute-sets="page-footer">
	  <xsl:call-template name="makeFooter"/>
	  <xsl:comment>Calling master common footer</xsl:comment>
	    
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block xsl:use-attribute-sets="body">
          <xsl:call-template name="process-common-attributes"/>
          <xsl:apply-templates/>
        </fo:block>
<fo:block id="last-page"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>


  <!-- footer handling, -->
<xsl:template name="makeFooter">
          <xsl:if test="$page-number-print-in-footer = 'true'">
            <xsl:text>- </xsl:text>
            <fo:page-number/>
            <xsl:text> -</xsl:text>
          </xsl:if>
</xsl:template>

  <!-- footer handling, -->
<xsl:template name="makeHeader">
NO HEADER DEFINED
</xsl:template>
  
  <!-- footer handling, -->
  <xsl:template match="html:page-number-citation-last">
    <fo:page-number-citation ref-id="last-page"/>
</xsl:template>

<xsl:template match="html:page-number">
    <fo:page-number/>
</xsl:template>

<!-- bugfix, br in xhtml can be a container (I think) -->
  
  <xsl:template match="html:br">
    <fo:block>
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>
  

<xsl:template match="html:htmlxxx">
  <!-- entity support taken from: -->
  <!-- ============================================
    This stylesheet transforms most of the common
    HTML elements into XSL formatting objects.  

    This version written 1 November 2002 by
    Doug Tidwell, dtidwell@us.ibm.com.

    Last updated 2 December 2012 by Doug Tidwell for
    compatibility with FOP 1.1.

    Brought to you by your friends at developerWorks:
    ibm.com/developerWorks.
    =============================================== -->
  
  <!-- ============================================
    Because character entities aren't built into 
    the XSL-FO vocabulary, they're included here.  
    =============================================== -->

  <xsl:text disable-output-escaping="yes">
&lt;!DOCTYPE fo:root [
  &lt;!ENTITY tilde  "&amp;#126;"&gt;
  &lt;!ENTITY florin "&amp;#131;"&gt;
  &lt;!ENTITY elip   "&amp;#133;"&gt;
  &lt;!ENTITY dag    "&amp;#134;"&gt;
  &lt;!ENTITY ddag   "&amp;#135;"&gt;
  &lt;!ENTITY cflex  "&amp;#136;"&gt;
  &lt;!ENTITY permil "&amp;#137;"&gt;
  &lt;!ENTITY uscore "&amp;#138;"&gt;
  &lt;!ENTITY OElig  "&amp;#140;"&gt;
  &lt;!ENTITY lsquo  "&amp;#145;"&gt;
  &lt;!ENTITY rsquo  "&amp;#146;"&gt;
  &lt;!ENTITY ldquo  "&amp;#147;"&gt;
  &lt;!ENTITY rdquo  "&amp;#148;"&gt;
  &lt;!ENTITY bullet "&amp;#149;"&gt;
  &lt;!ENTITY endash "&amp;#150;"&gt;
  &lt;!ENTITY emdash "&amp;#151;"&gt;
  &lt;!ENTITY trade  "&amp;#153;"&gt;
  &lt;!ENTITY oelig  "&amp;#156;"&gt;
  &lt;!ENTITY Yuml   "&amp;#159;"&gt;
  &lt;!ENTITY nbsp   "&amp;#160;"&gt;
  &lt;!ENTITY iexcl  "&amp;#161;"&gt;
  &lt;!ENTITY cent   "&amp;#162;"&gt;
  &lt;!ENTITY pound  "&amp;#163;"&gt;
  &lt;!ENTITY curren "&amp;#164;"&gt;
  &lt;!ENTITY yen    "&amp;#165;"&gt;
  &lt;!ENTITY brvbar "&amp;#166;"&gt;
  &lt;!ENTITY sect   "&amp;#167;"&gt;
  &lt;!ENTITY uml    "&amp;#168;"&gt;
  &lt;!ENTITY copy   "&amp;#169;"&gt;
  &lt;!ENTITY ordf   "&amp;#170;"&gt;
  &lt;!ENTITY laquo  "&amp;#171;"&gt;
  &lt;!ENTITY not    "&amp;#172;"&gt;
  &lt;!ENTITY shy    "&amp;#173;"&gt;
  &lt;!ENTITY reg    "&amp;#174;"&gt;
  &lt;!ENTITY macr   "&amp;#175;"&gt;
  &lt;!ENTITY deg    "&amp;#176;"&gt;
  &lt;!ENTITY plusmn "&amp;#177;"&gt;
  &lt;!ENTITY sup2   "&amp;#178;"&gt;
  &lt;!ENTITY sup3   "&amp;#179;"&gt;
  &lt;!ENTITY acute  "&amp;#180;"&gt;
  &lt;!ENTITY micro  "&amp;#181;"&gt;
  &lt;!ENTITY para   "&amp;#182;"&gt;
  &lt;!ENTITY middot "&amp;#183;"&gt;
  &lt;!ENTITY cedil  "&amp;#184;"&gt;
  &lt;!ENTITY sup1   "&amp;#185;"&gt;
  &lt;!ENTITY ordm   "&amp;#186;"&gt;
  &lt;!ENTITY raquo  "&amp;#187;"&gt;
  &lt;!ENTITY frac14 "&amp;#188;"&gt;
  &lt;!ENTITY frac12 "&amp;#189;"&gt;
  &lt;!ENTITY frac34 "&amp;#190;"&gt;
  &lt;!ENTITY iquest "&amp;#191;"&gt;
  &lt;!ENTITY Agrave "&amp;#192;"&gt;
  &lt;!ENTITY Aacute "&amp;#193;"&gt;
  &lt;!ENTITY Acirc  "&amp;#194;"&gt;
  &lt;!ENTITY Atilde "&amp;#195;"&gt;
  &lt;!ENTITY Auml   "&amp;#196;"&gt;
  &lt;!ENTITY Aring  "&amp;#197;"&gt;
  &lt;!ENTITY AElig  "&amp;#198;"&gt;
  &lt;!ENTITY Ccedil "&amp;#199;"&gt;
  &lt;!ENTITY Egrave "&amp;#200;"&gt;
  &lt;!ENTITY Eacute "&amp;#201;"&gt;
  &lt;!ENTITY Ecirc  "&amp;#202;"&gt;
  &lt;!ENTITY Euml   "&amp;#203;"&gt;
  &lt;!ENTITY Igrave "&amp;#204;"&gt;
  &lt;!ENTITY Iacute "&amp;#205;"&gt;
  &lt;!ENTITY Icirc  "&amp;#206;"&gt;
  &lt;!ENTITY Iuml   "&amp;#207;"&gt;
  &lt;!ENTITY ETH    "&amp;#208;"&gt;
  &lt;!ENTITY Ntilde "&amp;#209;"&gt;
  &lt;!ENTITY Ograve "&amp;#210;"&gt;
  &lt;!ENTITY Oacute "&amp;#211;"&gt;
  &lt;!ENTITY Ocirc  "&amp;#212;"&gt;
  &lt;!ENTITY Otilde "&amp;#213;"&gt;
  &lt;!ENTITY Ouml   "&amp;#214;"&gt;
  &lt;!ENTITY times  "&amp;#215;"&gt;
  &lt;!ENTITY Oslash "&amp;#216;"&gt;
  &lt;!ENTITY Ugrave "&amp;#217;"&gt;
  &lt;!ENTITY Uacute "&amp;#218;"&gt;
  &lt;!ENTITY Ucirc  "&amp;#219;"&gt;
  &lt;!ENTITY Uuml   "&amp;#220;"&gt;
  &lt;!ENTITY Yacute "&amp;#221;"&gt;
  &lt;!ENTITY THORN  "&amp;#222;"&gt;
  &lt;!ENTITY szlig  "&amp;#223;"&gt;
  &lt;!ENTITY agrave "&amp;#224;"&gt;
  &lt;!ENTITY aacute "&amp;#225;"&gt;
  &lt;!ENTITY acirc  "&amp;#226;"&gt;
  &lt;!ENTITY atilde "&amp;#227;"&gt;
  &lt;!ENTITY auml   "&amp;#228;"&gt;
  &lt;!ENTITY aring  "&amp;#229;"&gt;
  &lt;!ENTITY aelig  "&amp;#230;"&gt;
  &lt;!ENTITY ccedil "&amp;#231;"&gt;
  &lt;!ENTITY egrave "&amp;#232;"&gt;
  &lt;!ENTITY eacute "&amp;#233;"&gt;
  &lt;!ENTITY ecirc  "&amp;#234;"&gt;
  &lt;!ENTITY euml   "&amp;#235;"&gt;
  &lt;!ENTITY igrave "&amp;#236;"&gt;
  &lt;!ENTITY iacute "&amp;#237;"&gt;
  &lt;!ENTITY icirc  "&amp;#238;"&gt;
  &lt;!ENTITY iuml   "&amp;#239;"&gt;
  &lt;!ENTITY eth    "&amp;#240;"&gt;
  &lt;!ENTITY ntilde "&amp;#241;"&gt;
  &lt;!ENTITY ograve "&amp;#242;"&gt;
  &lt;!ENTITY oacute "&amp;#243;"&gt;
  &lt;!ENTITY ocirc  "&amp;#244;"&gt;
  &lt;!ENTITY otilde "&amp;#245;"&gt;
  &lt;!ENTITY ouml   "&amp;#246;"&gt;
  &lt;!ENTITY oslash "&amp;#248;"&gt;
  &lt;!ENTITY ugrave "&amp;#249;"&gt;
  &lt;!ENTITY uacute "&amp;#250;"&gt;
  &lt;!ENTITY ucirc  "&amp;#251;"&gt;
  &lt;!ENTITY uuml   "&amp;#252;"&gt;
  &lt;!ENTITY yacute "&amp;#253;"&gt;
  &lt;!ENTITY thorn  "&amp;#254;"&gt;
  &lt;!ENTITY yuml   "&amp;#255;"&gt;
  &lt;!ENTITY euro   "&amp;#x20AC;"&gt;
]&gt;
    </xsl:text>

    <fo:root xsl:use-attribute-sets="root">
      <xsl:call-template name="process-common-attributes"/>
      <xsl:call-template name="make-layout-master-set"/>
      <xsl:apply-templates/>
    </fo:root>
  </xsl:template>

  <xsl:template name="make-layout-master-set">
    <fo:layout-master-set>
      <fo:simple-page-master master-name="all-pages"
                             xsl:use-attribute-sets="page">
        <fo:region-body margin-top="{$page-margin-top}"
                        margin-right="{$page-margin-right}"
                        margin-bottom="{$page-margin-bottom}"
                        margin-left="{$page-margin-left}"
                        column-count="{$column-count}"
                        column-gap="{$column-gap}"/>
            <fo:region-before region-name="page-header"
                              extent="{$page-extent-top}"
                              display-align="before"/>
            <fo:region-after  region-name="page-footer"
                              extent="{$page-extent-bottom}"
                              display-align="after"/>
            <fo:region-start  extent="{$page-extent-left}"/>
            <fo:region-end    extent="{$page-extent-right}"/>

      </fo:simple-page-master>
    </fo:layout-master-set>
  </xsl:template>


  
  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Table
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->

  <xsl:template match="html:table">
    <fo:table xsl:use-attribute-sets="table">
      <xsl:call-template name="process-table"/>
    </fo:table>
  </xsl:template>

   <xsl:template match="html:input">
     <xsl:choose>
       <xsl:when test="@checked">Yes</xsl:when>
       <xsl:otherwise>No</xsl:otherwise>
     </xsl:choose>
   </xsl:template>


  <xsl:template name="process-common-attributes">
    <xsl:attribute name="role">
      <xsl:value-of select="concat('html:', local-name())"/>
    </xsl:attribute>

    <xsl:choose>
      <xsl:when test="@xml:lang">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="@xml:lang"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@lang">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="@lang"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="self::html:a/@name">
        <xsl:attribute name="id">
          <xsl:value-of select="@name"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>

    <xsl:if test="@align">
      <xsl:choose>
        <xsl:when test="self::html:caption">
        </xsl:when>
        <xsl:when test="self::html:img or self::html:object">
          <xsl:if test="@align = 'bottom' or @align = 'middle' or @align = 'top'">
            <xsl:attribute name="vertical-align">
              <xsl:value-of select="@align"/>
            </xsl:attribute>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="process-cell-align">
            <xsl:with-param name="align" select="@align"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="@valign">
      <xsl:call-template name="process-cell-valign">
        <xsl:with-param name="valign" select="@valign"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="@style">
      <xsl:call-template name="process-style">
        <xsl:with-param name="style" select="@style"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="@class">
      <xsl:call-template name="process-class">
        <xsl:with-param name="class" select="@class"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

      <!-- adapted from:
	   https://github.com/jeffrafter/xhtml2fo
	   -->
      
  <xsl:template name="process-class">
    <xsl:param name="class"/>
    <!-- e.g., Breaking logic (for table cells and block level objects) 'break-before' 
         and 'break-after' converted to break-before="<context>" or break-after="<context>" 
         where <context> is column if it is within a table otherwise page -->

    <!-- e.g., Keeping logic (for table cells and block level objects) 'keep-together' 
         and 'keep-with-next' and 'keep-with-previous' and converted to 
         keep-together.within-<context>="always" etc. where <context> is line if 
         the declaration is found on an inline level element, column if within a 
         table cell otherwise page -->

    <xsl:variable name="name" select="normalize-space(substring-before(concat($class, ' '), ' '))" />
    <xsl:if test="$name">
      <xsl:choose>
        <xsl:when test="($name = 'break-before' or $name = 'break-after') and 
                        (self::html:col or 
                         self::html:colgroup or 
                         self::html:th or 
                         self::html:td)">
          <xsl:attribute name="{$name}">column</xsl:attribute>
        </xsl:when>
        
        <xsl:when test="($name = 'keep-together' or $name = 'keep-with-next' or $name = 'keep-with-previous') and 
                        (self::html:a or 
                         self::html:abbr or 
                         self::html:acronym or 
                         self::html:b or 
                         self::html:basefont or 
                         self::html:bdo or 
                         self::html:big or 
                         self::html:br or 
                         self::html:cite or 
                         self::html:code or 
                         self::html:dfn or 
                         self::html:em or 
                         self::html:font or 
                         self::html:i or 
                         self::html:img or 
                         self::html:input or 
                         self::html:kbd or 
                         self::html:label or 
                         self::html:q or 
                         self::html:s or 
                         self::html:samp or 
                         self::html:select or 
                         self::html:small or 
                         self::html:span or 
                         self::html:strike or 
                         self::html:strong or 
                         self::html:sub or 
                         self::html:sup or 
                         self::html:textarea or 
                         self::html:tt or 
                         self::html:u or 
                         self::html:var)">
          <xsl:attribute name="{$name}.within-line">always</xsl:attribute>
        </xsl:when>
        
        <xsl:when test="($name = 'keep-together' or $name = 'keep-with-next' or $name = 'keep-with-previous') and 
                        (self::html:col or 
                         self::html:colgroup or 
                         self::html:th or 
                         self::html:td)">
          <xsl:attribute name="{$name}.within-column">always</xsl:attribute>
        </xsl:when>

        <xsl:when test="($name = 'keep-together' or $name = 'keep-with-next' or $name = 'keep-with-previous')"> 
          <xsl:attribute name="{$name}.within-page">always</xsl:attribute>
        </xsl:when>
        
        <xsl:when test="($name = 'break-before' or $name = 'break-after')">
          <xsl:attribute name="{$name}">page</xsl:attribute>
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:call-template name="class-template">
            <xsl:with-param name="class" select="$name"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:variable name="rest" select="normalize-space(substring-after($class, ' '))" />
    <xsl:if test="$rest">
      <xsl:call-template name="process-class">
        <xsl:with-param name="class" select="$rest"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Example -->
  <xsl:template name="class-template">
    <xsl:param name="class"/>
    <xsl:choose>
      <xsl:when test="contains($class, 'small-column')">
	<xsl:attribute name="background-color">red</xsl:attribute>
      </xsl:when>
      <xsl:when test="contains($class, 'numeric')">
	<xsl:attribute name="text-align">right</xsl:attribute>
      </xsl:when>
      <xsl:when test="contains($class, 'line')">
	<xsl:attribute name="border-top">1px dotted #AAA</xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>


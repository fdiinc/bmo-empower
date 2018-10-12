<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="makeMetaDataItem">
    <xsl:param name="name"/>
    <xsl:param name="value"/>
    <xsl:if test="$value">
      <meta name="{$name}" content="{$value}"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="PrettyPhone">
    <xsl:param name="area"/>
    <xsl:param name="exchange"/>
    <xsl:param name="last4"/>
    <xsl:param name="extension"/>

    <xsl:if test="string-length($area) > 1">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$area"/>
      <xsl:text>) </xsl:text>
    </xsl:if>

    <xsl:if test="string-length($exchange) > 1" >
      <xsl:value-of select="$exchange"/>
      <xsl:text>-</xsl:text>
    </xsl:if>
    
    <xsl:if test="string-length($last4) > 1" >
      <xsl:value-of select="substring(concat('000',$last4),string-length(concat('000',$last4)) - 3, 4)"/>
    </xsl:if>
    
    <xsl:variable name="ext">
      <xsl:value-of select="normalize-space($extension)"/>
    </xsl:variable>

    <xsl:if test="string-length($ext) > 0" >
      <xsl:choose>
	<xsl:when test="number($ext) = $ext">
	  <xsl:text> x</xsl:text>
	  <xsl:value-of select="$ext"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$ext"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>

  </xsl:template>

  <xsl:template name="generic-phone-formatter">
    <xsl:param name="phone"/>
    <xsl:param name="useParens" select="true()"/>

    <xsl:variable name="area" select="substring($phone,1,3)"/>
    <xsl:variable name="exchange" select="substring($phone,5,3)"/>
    <xsl:variable name="number" select="substring($phone,9,4)"/>
<xsl:if test="$exchange">
    <xsl:choose>
      <xsl:when test="$useParens">
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$area"/>
	<xsl:text>) </xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$area"/><xsl:text>-</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$exchange"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="$number"/>
</xsl:if>
  </xsl:template>

  <xsl:template name="generic-ssn-formatter">
    <xsl:param name="ssn"/>
    <xsl:param name="shroud" select="true()"/>
    <xsl:variable name="area" select="substring($ssn,1,3)"/>
    <xsl:variable name="group" select="substring($ssn,4,2)"/>
    <xsl:variable name="serial" select="substring($ssn,6,4)"/>
    <xsl:choose>
      <xsl:when test="$shroud">
	<xsl:value-of select="'XXX'"/><xsl:text>-</xsl:text>
	<xsl:value-of select="'XX'"/><xsl:text>-</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$area"/><xsl:text>-</xsl:text>
	<xsl:value-of select="$group"/><xsl:text>-</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$serial"/>
  </xsl:template>


  <xsl:template name="money-formatter">
    <xsl:param name="amount"/>
    <xsl:param name="format"/>
    <xsl:if test="$amount">
      <xsl:value-of select="format-number($amount, '0.00;-0.00')"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="value-formatter">
    <xsl:param name="amount"/>
    <xsl:param name="format"/>
    <xsl:value-of select="format-number($amount, '0;-0')"/><br/>
  </xsl:template>

  <xsl:template name="generic-date-formatter">
    <xsl:param name="date-time"/>
    <xsl:param name="date-format" select="'dd-MMM-yyyy'"/>
    <xsl:param name="time-format" select="'HH:mm A'" />
    <xsl:param name="empty-date" select="'1900-01-01 00:00:00.0'" />
    <xsl:param name="no-date" select="'(none)'" />
    <xsl:param name="display-date" select="true()"/>
    <xsl:param name="display-time" select="true()" />
    <xsl:param name="short-date" select="false()"/>
    
    <xsl:choose>
      <xsl:when test="$date-time = $empty-date or $date-time = substring($empty-date,1,10) or string-length($date-time) = 0">
	<xsl:value-of select="$no-date"/>
      </xsl:when>
      <xsl:when test="translate($date-time, '0123456789:-. ', '') != '' or translate($date-time, '0123456789', '') = ''">
	<!-- Does not match parsable date so just echo it out -->
	<xsl:value-of select="$date-time"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="dateVal">
	  <xsl:choose>
	    <xsl:when test="contains($date-time, ' ')">
	      <xsl:value-of select="substring-before($date-time, ' ')"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$date-time"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:variable name="timeVal">
	  <xsl:choose>
	    <xsl:when test="contains($date-time, ' ')">
	      <xsl:value-of select="substring-after($date-time, ' ')"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="'00:00:00.000'"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:if test="$display-date = true() and $short-date = false() and string-length($dateVal) > 0">
	  <xsl:call-template name="parse-datetime">
	    <xsl:with-param name="dt-str" select="$dateVal"/>
	    <xsl:with-param name="dt-format" select="$date-format"/>
	  </xsl:call-template>
	</xsl:if>
	<xsl:if test="$display-date = true() and $short-date = true() and string-length($dateVal) > 0">
	  <xsl:value-of  select="$dateVal"/>

	</xsl:if>

	<!-- removed non breaking space -->
	<xsl:if test="$display-date = true() and $display-time = true() and string-length($dateVal) > 0 and translate($timeVal,'0:. ', '') != ''"><xsl:value-of select="' '"/></xsl:if>
	<xsl:if test="$display-time = true() and translate($timeVal,'0:. ', '') != ''">
	  <xsl:call-template name="parse-datetime">
	    <xsl:with-param name="dt-str" select="$timeVal"/>
	    <xsl:with-param name="dt-format" select="$time-format" />
	  </xsl:call-template>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="parse-datetime">
    <xsl:param name="dt-str"/>
    <xsl:param name="dt-format"/>
    
    <xsl:if test="string-length($dt-format) > 0">
      <xsl:variable name="dt-token">
	<xsl:choose>
	  <xsl:when test="translate($dt-format,'yMdhHmsA','') = ''">-</xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="substring(translate($dt-format,'yMdhHmsA',''),1,1)"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:variable name="dt-part">
	<xsl:choose>
	  <xsl:when test="contains($dt-format,$dt-token)">
	    <xsl:value-of select="substring-before($dt-format,$dt-token)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$dt-format"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:variable name="dt-remainder">
	<xsl:choose>
	  <xsl:when test="contains($dt-format,$dt-token)">
	    <xsl:value-of select="substring-after($dt-format,$dt-token)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="''"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:choose>
	<xsl:when test="substring($dt-part,1,1) = 'y'">
	  <xsl:call-template name="format-year">
	    <xsl:with-param name="year-format" select="$dt-part"/>
	    <xsl:with-param name="year-val" select="substring($dt-str,1,4)"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="substring($dt-part,1,1) = 'M'">
	  <xsl:call-template name="format-month">
	    <xsl:with-param name="month-format" select="$dt-part"/>
	    <xsl:with-param name="month-val" select="substring($dt-str,6,2)"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="substring($dt-part,1,1) = 'd'">
	  <xsl:call-template name="format-day">
	    <xsl:with-param name="day-format" select="$dt-part"/>
	    <xsl:with-param name="day-val" select="substring($dt-str,9,2)"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="substring($dt-part,1,1) = 'h'">
	  <xsl:call-template name="format-hour">
	    <xsl:with-param name="hour-format" select="$dt-part"/>
	    <xsl:with-param name="hour-val" select="substring($dt-str,1,2)"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="substring($dt-part,1,1) = 'H'">
	  <xsl:call-template name="format-hour">
	    <xsl:with-param name="hour-format" select="$dt-part"/>
	    <xsl:with-param name="hour-val" select="substring($dt-str,1,2)"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="substring($dt-part,1,1) = 'm'">
	  <xsl:call-template name="format-minute">
	    <xsl:with-param name="minute-format" select="$dt-part"/>
	    <xsl:with-param name="minute-val" select="substring($dt-str,4,2)"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="substring($dt-part,1,1) = 's'">
	  <xsl:call-template name="format-second">
	    <xsl:with-param name="second-format" select="$dt-part"/>
	    <xsl:with-param name="second-val" select="substring($dt-str,7,2)"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="substring($dt-part,1,1) = 'A'">
	  <xsl:call-template name="format-ampm">
	    <xsl:with-param name="hour-val" select="substring($dt-str,1,2)"/>
	  </xsl:call-template>
	</xsl:when>

      </xsl:choose>
      <xsl:if test="string-length($dt-remainder) > 0">
	<xsl:value-of select="$dt-token"/>
	<xsl:call-template name="parse-datetime">
	  <xsl:with-param name="dt-token" select="$dt-token"/>
	  <xsl:with-param name="dt-format" select="$dt-remainder"/>
	  <xsl:with-param name="dt-str" select="$dt-str"/>
	</xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="format-month">
    <xsl:param name="month-val" />
    <xsl:param name='month-format' />
    <xsl:choose>
      <xsl:when test="$month-format = 'M'">
	<!--			  <xsl:value-of select="number($month-val)"/> -->
	<xsl:value-of select="$month-val"/>
      </xsl:when>
      <xsl:when test="$month-format = 'MMM' or $month-format = 'MMMM'">
	<xsl:variable name="long-month">
	  <xsl:choose>
	    <xsl:when test="$month-val = '12'">December</xsl:when>
	    <xsl:when test="$month-val = '11'">November</xsl:when>
	    <xsl:when test="$month-val = '10'">October</xsl:when>
	    <xsl:when test="$month-val = '09'">September</xsl:when>
	    <xsl:when test="$month-val = '08'">August</xsl:when>
	    <xsl:when test="$month-val = '07'">July</xsl:when>
	    <xsl:when test="$month-val = '06'">June</xsl:when>
	    <xsl:when test="$month-val = '05'">May</xsl:when>
	    <xsl:when test="$month-val = '04'">April</xsl:when>
	    <xsl:when test="$month-val = '03'">March</xsl:when>
	    <xsl:when test="$month-val = '02'">February</xsl:when>
	    <xsl:otherwise>January</xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:choose>
	  <xsl:when test="$month-format = 'MMM'"><xsl:value-of select="substring($long-month,1,3)"/></xsl:when>
	  <xsl:otherwise><xsl:value-of select="$long-month"/></xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$month-val"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="format-day">
    <xsl:param name="day-val"/>
    <xsl:param name="day-format"/>
    <xsl:choose>
      <xsl:when test="$day-format = 'd'">
	<xsl:value-of select="number($day-val)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$day-val"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="format-year">
    <xsl:param name="year-val"/>
    <xsl:param name="year-format"/>
    <xsl:choose>
      <xsl:when test="$year-format = 'yy'">
	<xsl:value-of select="substring($year-val, 3, 2)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$year-val"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="format-hour">
    <xsl:param name="hour-val"/>
    <xsl:param name="hour-format"/>
    <xsl:choose>
      <xsl:when test="$hour-format = 'H' or $hour-format = 'HH'">
	<xsl:variable name="hour12">
	  <xsl:choose>
	    <xsl:when test="number($hour-val) mod 12 = 0">
	      <xsl:value-of select="12"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="number($hour-val) mod 12"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable> 
	<xsl:choose>
	  <xsl:when test="$hour-format = 'HH'">
	    <xsl:choose>
	      <xsl:when test="string-length($hour12) = 1">
		<xsl:value-of select="concat('0',$hour12)"/>
	      </xsl:when>
	      <xsl:otherwise><xsl:value-of select="$hour12"/></xsl:otherwise>
	    </xsl:choose>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$hour12"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:when test="$hour-format = 'h'">
	<xsl:value-of select="number($hour-val)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$hour-val"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="format-minute">
    <xsl:param name="minute-val"/>
    <xsl:param name="minute-format"/>
    <xsl:choose>
      <xsl:when test="$minute-format = 'm'">
	<xsl:value-of select="number($minute-val)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$minute-val"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="format-second">
    <xsl:param name="second-val"/>
    <xsl:param name="second-format"/>
    <xsl:choose>
      <xsl:when test="$second-format = 's'">
	<xsl:value-of select="number($second-val)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$second-val"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="format-ampm">
    <xsl:param name="hour-val"/>
    <xsl:choose>
      <xsl:when test="number($hour-val) > 11">PM</xsl:when>
      <xsl:otherwise>AM</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get-days-in-month">
    <xsl:param name="year"/>
    <xsl:param name="month"/>
    <xsl:choose>
      <xsl:when test="$month = 2 and not($year mod 4) and ($year mod 100 or not($year mod 400))">
	<xsl:value-of select="29"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="substring('312831303130313130313031',2 * $month - 1,2)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

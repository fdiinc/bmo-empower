<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="header">
        <div>
            <h2>Account Information</h2>
        </div>
        <table width="100%" class="indent">
            <tr>
                <td width="390px">
                    <b>Account Number: </b>
                </td>
                <td>
                    <xsl:value-of
                        select="./accountHeaderSection/account_number" />
                </td>
            </tr>
            <tr>
                <td>
                    <b>Primary Customer Name: </b>
                </td>
                <td>
                    <xsl:value-of
                        select="./accountHeaderSection/primary_customer_name" />
                </td>
            </tr>
            <tr>
                <td>
                    <b>Secondary Customer Name: </b>
                </td>
                <td class="pre">
                    <xsl:value-of
                        select="./accountHeaderSection/secondary_customer_name" />
                </td>
            </tr>
            <xsl:if test="count(./accountHeaderSection/dob) > 0">
                <tr>
                    <td>
                        <b>DOB (CCYYMMDD): </b>
                    </td>
                    <td>
                        <xsl:value-of select="./accountHeaderSection/dob" />
                    </td>
                </tr>
            </xsl:if>
        </table>
    </xsl:template>

    <xsl:template name="printDataRow">
        <xsl:param name="data" />

        <xsl:variable name="count" select="count($data)" />

        <xsl:choose>
            <xsl:when test="$count &gt; '0'">
                <!-- Loop through each record in section -->
                <xsl:for-each select="$data">
                    <!-- Display "Record X" before record if more than 1 
                        record in section -->
                    <xsl:if test="$count &gt; '1'">
                        <div class="dataValue">
                            <h3>
                                Record
                                <xsl:value-of select="position()" />
                            </h3>
                        </div>
                    </xsl:if>

                    <!-- Display record's table -->
                    <table width="100%" class="indent">
                        <xsl:for-each select="column">
                            <tr>
                                <td width='390px'>
                                    <b>
                                        <xsl:value-of
                                            select="name" />
                                        :
                                    </b>
                                </td>
                                <td>
                                    <xsl:choose>
                                        <xsl:when test="./@pre = 'true'">
                                            <div class="pre">
                                                <xsl:value-of
                                                    select="value" />
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="value" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                No Records to Display
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
</xsl:stylesheet>

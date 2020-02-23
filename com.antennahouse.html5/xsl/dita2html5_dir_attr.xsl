<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Dir Attribute Templates
    **************************************************************
    File Name : dita2html5_dir_domain_element.xsl
    **************************************************************
    Copyright © 2008-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:style="http://www.antennahouse.com/names/XSLT/Document/Layout"
    exclude-result-prefixes="xs ahf style"
    version="3.0">

    <!-- This template preceeds any other template by specifying priority="50"
         Also if override template handles @dir, this template do nothing.
         This mechanizm is implemented by $prmBidiProcessed.
         Once @dir attribute is processed, it is turned $false for the further BIDI processing
         in the xsl:next-match phase.
         2020-02-22 t.makita
     -->

    <!--
    function:   @dir="ltr" template
    param:      prmBidiProcessed
    return:     span
    note:       
    -->
    <xsl:template match="*[@dir => string() eq 'ltr']" priority="50">
        <xsl:param name="prmBidiProcessed" as="xs:boolean" required="no" select="false()"/>
        <xsl:choose>
            <xsl:when test="$prmBidiProcessed">
                <xsl:next-match/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$cLeftToRightEmbedding"/>
                <xsl:next-match>
                    <xsl:with-param name="prmBidiProcessed" as="xs:boolean" select="true()"/>
                </xsl:next-match>
                <xsl:value-of select="$cPopDirectionalFormatting"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   @dir="rtl" template
    param:      prmBidiProcessed
    return:     span
    note:       
    -->
    <xsl:template match="*[@dir => string() eq 'rtl']" priority="50">
        <xsl:param name="prmBidiProcessed" as="xs:boolean" required="no" select="false()"/>
        <xsl:choose>
            <xsl:when test="$prmBidiProcessed">
                <xsl:next-match/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$cRightToLeftEmbedding"/>
                <xsl:next-match>
                    <xsl:with-param name="prmBidiProcessed" as="xs:boolean" select="true()"/>
                </xsl:next-match>
                <xsl:value-of select="$cPopDirectionalFormatting"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   lro template
    param:      prmBidiProcessed
    return:     span
    note:       
    -->
    <xsl:template match="*[@dir => string() eq 'lro']" priority="50">
        <xsl:param name="prmBidiProcessed" as="xs:boolean" required="no" select="false()"/>
        <xsl:choose>
            <xsl:when test="$prmBidiProcessed">
                <xsl:next-match/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$cLeftToRightOverride"/>
                <xsl:next-match>
                    <xsl:with-param name="prmBidiProcessed" as="xs:boolean" select="true()"/>
                </xsl:next-match>
                <xsl:value-of select="$cPopDirectionalFormatting"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
    function:   rlo template
    param:      prmBidiProcessed
    return:     span
    note:       
    -->
    <xsl:template match="*[@dir => string() eq 'rlo']" priority="50">
        <xsl:param name="prmBidiProcessed" as="xs:boolean" required="no" select="false()"/>
        <xsl:choose>
            <xsl:when test="$prmBidiProcessed">
                <xsl:next-match/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$cRightToLeftOverride"/>
                <xsl:next-match>
                    <xsl:with-param name="prmBidiProcessed" as="xs:boolean" select="true()"/>
                </xsl:next-match>
                <xsl:value-of select="$cPopDirectionalFormatting"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
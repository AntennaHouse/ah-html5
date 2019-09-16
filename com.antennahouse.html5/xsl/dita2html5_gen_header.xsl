<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Header Templates
    **************************************************************
    File Name : dita2html5_gen_header.xsl
    **************************************************************
    Copyright © 2008-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs ahf"
    version="3.0">

    <!--
    function:   Generate Css Link
    param:      none
    return:     meta, etc
    note:       
    -->
    <xsl:template name="genCssLink">
       
        <!-- Preserved CSS -->
        <xsl:choose>
            <xsl:when test="$isRtl">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',concat($path2ProjUri,$gpOutputCssPathRelative,$PRM_DITA_BIDI_CSS_FILE))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',concat($path2ProjUri,$gpOutputCssPathRelative,$PRM_DITA_CSS_FILE))"/>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- AH CSS -->
        <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',concat($path2ProjUri,$gpOutputCssPathRelative,$gpAhCssFile))"/>
        
        <!-- User CSS -->
        <xsl:if test="$gpUserCssFile => string() => boolean()">
            <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',concat($path2ProjUri,$gpOutputCssPathRelative,$gpUserCssFile))"/>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>

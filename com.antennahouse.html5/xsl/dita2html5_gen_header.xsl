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
        <xsl:variable name="isUrl" as="xs:boolean" select="ahf:isUrl($gpCssPath)"/>
        
        <!-- Preserved CSS -->
        <xsl:choose>
            <xsl:when test="$isRtl and $isUrl">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',concat($gpCssPath,$PRM_DITA_BIDI_CSS_FILE))"/>
            </xsl:when>
            <xsl:when test="$isRtl and not($isUrl)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',concat($path2ProjUri,$gpCssPath,$PRM_DITA_BIDI_CSS_FILE))"/>
            </xsl:when>
            <xsl:when test="$isUrl">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',concat($gpCssPath,$PRM_DITA_CSS_FILE))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',concat($path2ProjUri,$gpCssPath,$PRM_DITA_CSS_FILE))"/>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- AH CSS -->
        <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',concat($path2ProjUri,$gpCssPath,$gpAhCssFile))"/>
        
        <!-- User CSS -->
        <xsl:if test="$gpUserCssPath => string() => boolean()">
            <xsl:variable name="isUrl" as="xs:boolean" select="ahf:isUrl($gpUserCssPath)"/>
            <xsl:choose>
                <xsl:when test="$isUrl">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',$gpUserCssPath)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCssLink','%css-path',concat($path2ProjUri,$gpUserCssPath))"/>
                </xsl:otherwise>
            </xsl:choose>            
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>

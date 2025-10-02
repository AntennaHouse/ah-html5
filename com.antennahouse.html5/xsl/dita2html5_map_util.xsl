<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Map Utility Templates
    **************************************************************
    File Name : dita2html5_map_util.xsl
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
    
    <!--
    function:   Generate Navtitle Template
    param:      prmTopicRef
    return:     xs:string
    note:       
    -->
    <xsl:template name="getNavTitle" as="xs:string">
        <xsl:param name="prmTopicRef" as="element()" required="no" select="."/>
        
        <xsl:choose>
            <xsl:when test="$prmTopicRef/*[contains-token(@class, 'map/topicmeta')]/*[contains-token(@class, 'topic/navtitle')]">
                <xsl:variable name="navTitleTemp" as="xs:string*">
                    <xsl:apply-templates select="$prmTopicRef/*[contains-token(@class, 'map/topicmeta')]/*[contains-token(@class, 'topic/navtitle')]" mode="TEXT_ONLY"/>
                </xsl:variable>
                <xsl:sequence select="$navTitleTemp => string-join('') => normalize-space()"/>
            </xsl:when>
            <xsl:when test="$prmTopicRef/@navtitle">
                <xsl:sequence select="$prmTopicRef/@navtitle => string() => normalize-space()"/>
            </xsl:when>
            <xsl:when test="$prmTopicRef/*[contains-token(@class, 'map/topicmeta')]/*[contains-token(@class, 'map/linktext')]">
                <xsl:variable name="linkTextTemp" as="xs:string*">
                    <xsl:apply-templates select="$prmTopicRef/*[contains-token(@class, 'map/topicmeta')]/*[contains-token(@class, 'map/linktext')]" mode="TEXT_ONLY"/>
                </xsl:variable>
                <xsl:sequence select="$linkTextTemp => string-join('') => normalize-space()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$prmTopicRef/@href => normalize-space()"/>
                <xsl:call-template name="warningContinue">
                    <xsl:with-param name="prmMes" select="ahf:replace($stMes200,('%xpath','%href'),(ahf:getHistoryXpathStr($prmTopicRef),$prmTopicRef/@href => string()))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>

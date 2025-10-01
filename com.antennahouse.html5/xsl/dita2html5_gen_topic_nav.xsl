<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Topic Navigation Templates
    **************************************************************
    File Name : dita2html5_gen_topic_nav.xsl
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

    <xsl:variable name="pathToMapDir" select="ahf:getPathToMapDirFromTopic($gpMapUrl, base-uri())" />

    <!--
    function:   Generate Topic Navigation
    param:      none
    return:     nav
    note:       
    -->
    <xsl:template name="genTopicNavi">
        <xsl:choose>
            <xsl:when test="$gpOutputNavTocFull">
                <nav>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsNavToc'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="$gpMapDoc" mode="MODE_TOC">
                        <xsl:with-param name="prmPathToMapDirFromTopic" as="xs:string" select="$pathToMapDir"/>
                    </xsl:apply-templates>
                </nav>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Utility Domain Element Templates
    **************************************************************
    File Name : dita2html5_utility_domain.xsl
    **************************************************************
    Copyright © 2008-2020 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:style="http://www.antennahouse.com/names/XSLT/Document/Layout"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="xs ahf style ditaarch dita-ot svg"
    version="3.0">
    
    <!--
    function:   imagemap template
    param:      none
    return:     img
    note:       The browser does not support the SVG file path that have fragment mark (#).
    -->
    <xsl:template match="*[contains-token(@class, 'ut-d/imagemap')]" priority="5">
        <xsl:variable name="imageMap" as="element()" select="."/>
        <xsl:apply-templates select="$imageMap/*[@class => contains-token('topic/image')]">
            <xsl:with-param name="prmMapName" as="xs:string" tunnel="yes" select="(:ahf:getHistoryStr($imageMap):)generate-id($imageMap)"/>
        </xsl:apply-templates>
        <map>
            <xsl:call-template name="genCommonAtts"/>
            <!--xsl:call-template name="genIdAtt"/-->
            <xsl:attribute name="id" select="(:ahf:getHistoryStr($imageMap):)generate-id($imageMap)"/>
            <xsl:attribute name="name" select="(:ahf:getHistoryStr($imageMap):)generate-id($imageMap)"/>
            <xsl:apply-templates select="node() except $imageMap/*[@class => contains-token('topic/image')]"/>
        </map>
    </xsl:template>
    
    <!--
    function:   area for imagemap template
    param:      none
    return:     area
    note:       
    -->
    <xsl:template match="*[@class => contains-token('ut-d/area')]" priority="5">
        <area>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:attribute name="shape"  select="*[@class => contains-token('ut-d/shape')]  => string()"/>
            <xsl:attribute name="coords" select="*[@class => contains-token('ut-d/coords')] => string()"/>
            <xsl:variable name="xref" as="element()" select="*[@class => contains-token('topic/xref')][1]"/>
            <xsl:variable name="destAttr" as="attribute()?">
                <xsl:call-template name="ahf:genHrefAtt">
                    <xsl:with-param name="prmLinkElem" select="$xref"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:sequence select="$destAttr"/>
        </area>
    </xsl:template>
    
</xsl:stylesheet>

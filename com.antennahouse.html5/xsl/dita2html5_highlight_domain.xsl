<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Highlight Domain Element Templates
    **************************************************************
    File Name : dita2html5_highlight_domain.xsl
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
    function:   b template
    param:      none
    return:     strong
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'hi-d/b')]" priority="5">
        <strong>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
    
    <!--
    function:   i template
    param:      none
    return:     em
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'hi-d/i')]" priority="5">
        <em>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <!--
    function:   u template
    param:      none
    return:     u
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'hi-d/u')]" priority="5">
        <u>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </u>
    </xsl:template>

    <!--
    function:   tt template
    param:      none
    return:     span
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'hi-d/tt')]" priority="5">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsTt'"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!--
    function:   sup template
    param:      none
    return:     sup
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'hi-d/sup')]" priority="5">
        <sup>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <!--
    function:   sub template
    param:      none
    return:     sub
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'hi-d/sub')]" priority="5">
        <sub>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>
    
    <!--
    function:   line-through
    param:      none
    return:     sub
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'hi-d/line-through')]" priority="5">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsLineThrough'"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--
    function:   line-through
    param:      none
    return:     sub
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'hi-d/overline')]" priority="5">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsOverLine'"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    

</xsl:stylesheet>

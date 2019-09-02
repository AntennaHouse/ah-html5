<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    User Interface Domain Element Templates
    **************************************************************
    File Name : dita2html5_user_interface_domain_element.xsl
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
    function:   uicontrol template
    param:      none
    return:     abbr?,span
    note:              
    -->
    <xsl:template match="*[contains-token(@class,'ui-d/uicontrol')]" priority="5">
        <xsl:if test="parent::*[contains-token(@class, 'ui-d/menucascade')]">
            <!-- Child of menucascade -->
            <xsl:if test="preceding-sibling::*[contains-token(@class, 'ui-d/uicontrol')]">
                <!-- preceding uicontrol -->
                <abbr>
                    <!-- append '>' -->
                    <xsl:call-template name="getVarValueWithLangAsText">
                        <xsl:with-param name="prmVarName" select="'MenuCascade_Symbol'"/>
                    </xsl:call-template>
                </abbr>
            </xsl:if>
        </xsl:if>
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:call-template name="getVarValueWithLangAsText">
                <xsl:with-param name="prmVarName" select="'UiControl_Prefix'"/>
            </xsl:call-template>
            <xsl:apply-templates/>
            <xsl:call-template name="getVarValueWithLangAsText">
                <xsl:with-param name="prmVarName" select="'UiControl_Suffix'"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    
    <!--
    function:   wintitle template
    param:      none
    return:     span
    note:       
    -->
    <xsl:template match="*[contains-token(@class,'ui-d/wintitle')]" priority="5">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!--
    function:   menucascade template
    param:      none
    return:     span
    note:              
    -->
    <xsl:template match="*[contains-token(@class,'ui-d/menucascade')]" priority="5">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- ignore text inside menucascade -->
    <xsl:template match="*[contains-token(@class,'ui-d/menucascade')]/text()" priority="5"/>

    <!--
    function:   shortcut template
    param:      none
    return:     span
    note:              
    -->
    <xsl:template match="*[contains-token(@class,'ui-d/shortcut')]" priority="5">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
</xsl:stylesheet>

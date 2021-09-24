<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to HTML5 Stylesheet
Module: Text mode templates
Copyright © 2009-2019 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="3.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 exclude-result-prefixes="xs ahf" 
>
    
    <!--
    function:   Normalized Text Get Function
    param:      prmNode
    return:     xs:string*
    note:       
    -->
    <xsl:function name="ahf:getNormalizedText" as="xs:string?">
        <xsl:param name="prmNode" as="node()*"/>
        <xsl:for-each select="$prmNode">
            <xsl:variable name="tempText" as="xs:string*">
                <xsl:apply-templates select="." mode="TEXT_ONLY"/>
            </xsl:variable>
            <xsl:variable name="tempResultText" as="xs:string" select="normalize-space(string-join($tempText,''))"/>
            <xsl:sequence select="if (string($tempResultText)) then $tempResultText else ()"/>
        </xsl:for-each>
    </xsl:function>
    
    <!-- * -->
    <xsl:template match="*" mode="TEXT_ONLY">
        <xsl:apply-templates mode="TEXT_ONLY"/>
    </xsl:template>
    
    <!-- any attribute -->
    <xsl:template match="@*" mode="TEXT_ONLY">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- text -->
    <xsl:template match="text()" mode="TEXT_ONLY">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <!-- shortdesc -->
    <xsl:template match="*[contains-token(@class,'topic/ahortdesc')]" mode="TEXT_ONLY">
        <xsl:if test="ancestor::*[contains-token(@class,'topic/abstract')]">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="#current"/>
    </xsl:template>

    <!-- fn -->
    <xsl:template match="*[contains-token(@class,'topic/fn')]" mode="TEXT_ONLY">
    </xsl:template>
    
    <!-- tm -->
    <xsl:template match="*[contains-token(@class,'topic/tm')]" mode="TEXT_ONLY">
        <xsl:apply-templates mode="TEXT_ONLY"/>
        <xsl:variable name="tmType" as="xs:string" select="string(@tmtype)"/>
        <xsl:choose>
            <xsl:when test="$tmType eq 'tm'">
                <xsl:variable name="tmSymbolTmText" as="xs:string">
                    <xsl:call-template name="getVarValueWithLang">
                        <xsl:with-param name="prmVarName" select="'Tm_Symbol_Tm_Text'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$tmSymbolTmText"/>
            </xsl:when>
            <xsl:when test="$tmType eq 'reg'">
                <xsl:variable name="tmSymbolRegText" as="xs:string">
                    <xsl:call-template name="getVarValueWithLang">
                        <xsl:with-param name="prmVarName" select="'Tm_Symbol_Reg_Text'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$tmSymbolRegText"/>
            </xsl:when>
            <xsl:when test="$tmType eq 'service'">
                <xsl:variable name="tmSymbolServiceText" as="xs:string">
                    <xsl:call-template name="getVarValueWithLang">
                        <xsl:with-param name="prmVarName" select="'Tm_Symbol_Service_Text'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$tmSymbolServiceText"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- data-about -->
    <xsl:template match="*[contains-token(@class,'topic/data-about')]" mode="TEXT_ONLY">
    </xsl:template>
    
    <!-- data -->
    <xsl:template match="*[contains-token(@class,'topic/data')]" mode="TEXT_ONLY">
    </xsl:template>
    
    <!-- foreign -->
    <xsl:template match="*[contains-token(@class,'topic/foreign')]" mode="TEXT_ONLY">
    </xsl:template>
    
    <!-- unknown -->
    <xsl:template match="*[contains-token(@class,'topic/unknown')]" mode="TEXT_ONLY">
    </xsl:template>
    
    <!-- no-topic-nesting -->
    <xsl:template match="*[contains-token(@class,'topic/no-topic-nesting')]" mode="TEXT_ONLY">
    </xsl:template>
    
    <xsl:template match="*[contains-token(@class,'topic/indexterm')]" mode="TEXT_ONLY">
    </xsl:template>
    
    <!-- required-cleanup -->
    <xsl:template match="*[contains-token(@class,'topic/required-cleanup')]" mode="TEXT_ONLY"/>
    
    <!-- state -->
    <xsl:template match="*[contains-token(@class,'topic/state')]" mode="TEXT_ONLY">
        <xsl:value-of select="@name"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="@value"/>
    </xsl:template>
    
    <!-- boolean -->
    <xsl:template match="*[contains-token(@class,'topic/boolean')]" mode="TEXT_ONLY">
        <xsl:value-of select="@state"/>
    </xsl:template>

    <!-- xref -->
    <xsl:template match="*[contains-token(@class,'topic/xref')]" mode="TEXT_ONLY">
        <xsl:param name="prmIgnoreXref" as="xs:boolean" tunnel="yes" required="no" select="false()"/>
        <xsl:choose>
            <xsl:when test="$prmIgnoreXref"/>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
    function:   ltr template
    param:      none
    return:     text node
    note:       
    -->
    <xsl:template match="*[@dir => string() eq 'ltr']"  mode="TEXT_ONLY" priority="50">
        <xsl:value-of select="$cLeftToRightEmbedding"/>
        <xsl:next-match/>
        <xsl:value-of select="$cPopDirectionalFormatting"/>
    </xsl:template>
    
    <!--
    function:   rtl template
    param:      none
    return:     text node
    note:       
    -->
    <xsl:template match="*[@dir => string() eq 'rtl']" mode="TEXT_ONLY" priority="50">
        <xsl:value-of select="$cRightToLeftEmbedding"/>
        <xsl:next-match/>
        <xsl:value-of select="$cPopDirectionalFormatting"/>
    </xsl:template>
    
    <!--
    function:   lro template
    param:      none
    return:     text node
    note:       
    -->
    <xsl:template match="*[@dir => string() eq 'lro']" mode="TEXT_ONLY" priority="50">
        <xsl:value-of select="$cLeftToRightOverride"/>
        <xsl:next-match/>
        <xsl:value-of select="$cPopDirectionalFormatting"/>
    </xsl:template>
    
    <!--
    function:   rlo template
    param:      none
    return:     text node
    note:       
    -->
    <xsl:template match="*[@dir => string() eq 'rlo']" mode="TEXT_ONLY" priority="50">
        <xsl:value-of select="$cRightToLeftOverride"/>
        <xsl:next-match/>
        <xsl:value-of select="$cPopDirectionalFormatting"/>
    </xsl:template>
    
</xsl:stylesheet>

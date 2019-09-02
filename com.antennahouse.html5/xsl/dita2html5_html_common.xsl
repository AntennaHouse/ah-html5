<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    HTML5 Common Templates
    **************************************************************
    File Name : dita2html5_html5_common.xsl
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
    function:   Generate Common Attribute For HTML5 Element
    param:      prmDefaultOutputClass
    return:     attribute()*
    note:       
    -->
    <xsl:template name="genCommonAtts">
        <xsl:param name="prmElement" as="element()?" required="no" select="."/>
        <xsl:param name="prmDefaultOutputClass" as="xs:string?" required="no" select="()"/>
        <xsl:param name="prmApplyDefaultFrameAtt" as="xs:boolean" required="no" select="true()"/>
        
        <!-- @lang -->
        <xsl:variable name="xmlLang" as="attribute()?" select="$prmElement/@xml:lang"/>
        <xsl:if test="exists($xmlLang)">
            <xsl:attribute name="lang" select="ahf:nomalizeXmlLang($xmlLang)"/>
        </xsl:if>

        <!-- @dir -->
        <xsl:if test="$prmElement/@dir">
            <xsl:copy select="$prmElement/@dir"/>
        </xsl:if>

        <!-- @class -->
        <xsl:call-template name="genClassAtt">
            <xsl:with-param name="prmElement" select="$prmElement"/>
            <xsl:with-param name="prmDefaultOutputClass" select="$prmDefaultOutputClass"/>
            <xsl:with-param name="prmApplyDefaultFrameAtt" select="$prmApplyDefaultFrameAtt"/>
        </xsl:call-template>

        <!-- Passthrough Attributes -->
        <xsl:if test="exists($glPassThroughAttsProp)">
            <xsl:for-each select="@*">
                <xsl:variable name="elemAtt" as="attribute()" select="."/>
                <xsl:if test="$glPassThroughAttsProp[string(@att) eq name($elemAtt) and (empty(@val) or (some $elemAttVal in tokenize(string($elemAtt), '\s+') satisfies ($elemAttVal eq string(@val))))]">
                    <xsl:attribute name="data-{name($elemAtt)}" select="string($elemAtt)"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!--
    function:   Generate @class Attribute For HTML Element
    param:      prmElement, prmDefaultOutputClass
    return:     attribute()
    note:       
    -->
    <xsl:template name="genClassAtt" as="attribute()">
        <xsl:param name="prmElement" as="element()?" required="no" select="."/>
        <xsl:param name="prmDefaultOutputClass" as="xs:string?" required="no" select="()"/>
        <xsl:param name="prmApplyDefaultFrameAtt" as="xs:boolean" required="no" select="true()"/>

        <!-- @outputclass handling -->
        <xsl:variable name="outputClass" as="xs:string*">
            <xsl:variable name="outputClass" as="xs:string?" select="$prmElement/@outputclass/normalize-space(string())"/>
            <xsl:sequence select="tokenize($outputClass,'\s')"/>
            <xsl:variable name="defaultOutputClass" as="xs:string?" select="normalize-space($prmDefaultOutputClass)"/>
            <xsl:sequence select="tokenize($defaultOutputClass,'\s')"/>
        </xsl:variable>

        <!-- @scale handling -->
        <xsl:variable name="scaleAtt" as="xs:string?" select="$prmElement/@scale => string() => normalize-space()"/>
        <xsl:variable name="scaleClass" select="if (string($scaleAtt)) then concat('scale-',$scaleAtt) else ()"/>

        <!-- @frame handling -->
        <xsl:variable name="frameAtt" as="xs:string?" select="$prmElement/@frame => string() => normalize-space()"/>
        <xsl:variable name="frameClass" select="if (string($frameAtt) and $prmApplyDefaultFrameAtt) then concat('frame-',$frameAtt) else ()"/>
        
        <!-- DITA @class attribute of $prmElement -->
        <xsl:variable name="classAtt" as="xs:string" select="$prmElement/@class => string() => normalize-space()"/>
        <xsl:variable name="tokenizedClassAtt" as="xs:string*">
            <xsl:for-each select="tokenize($classAtt,'[\s]+')">
                <xsl:if test="contains(.,'/')">
                    <xsl:sequence select="substring-after(.,'/')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="empty($tokenizedClassAtt)">
            <xsl:message select="'[genClassAtt] elemet=',$prmElement"/>
        </xsl:if>
        
        <!-- HTML @class attribute -->
        <xsl:variable name="htmlClassAttr" as="xs:string" select="string-join(($tokenizedClassAtt, $scaleClass, $frameClass, $outputClass),' ')"/>
        <xsl:attribute name="class" select="$htmlClassAttr"/>
    </xsl:template>

    <!--
    function:   Generate Id Attribute For HTML5 Element
    param:      prmElement
    return:     attribute()?
    note:       $prmElement belongs topic
    -->
    <xsl:function name="ahf:genIdAtt" as="attribute()?">
        <xsl:param name="prmElement" as="element()"/>
        <xsl:param name="prmForce" as="xs:boolean"/>
        
        <xsl:call-template name="genIdAtt">
            <xsl:with-param name="prmElement" select="$prmElement"/>
            <xsl:with-param name="prmForce" select="$prmForce"/>
            <xsl:with-param name="prmWithNoId" tunnel="yes" select="false()"/>
        </xsl:call-template>
    </xsl:function>
    
    <xsl:template name="genIdAtt" as="attribute()?">
        <xsl:param name="prmElement" as="element()" required="no" select="."/>
        <xsl:param name="prmForce" as="xs:boolean" required="no" select="false()"/>
        <xsl:param name="prmWithNoId" as="xs:boolean" tunnel="yes" required="no" select="false()"/>
        
        <xsl:choose>
            <xsl:when test="$prmWithNoId">
                <xsl:sequence select="()"/>
            </xsl:when>
            <xsl:when test="exists($prmElement/@id)">
                <xsl:choose>
                    <xsl:when test="$prmElement[contains-token(@class,'topic/topic')]">
                        <xsl:copy select="$prmElement/@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="topic" as="element()" select="$prmElement/ancestor::*[contains-token(@class,'topic/topic')][1]"/>
                        <xsl:attribute name="id" select="concat(string($topic/@id),$cIdSep,string($prmElement/@id))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$prmForce">
                <xsl:attribute name="id" select="ahf:getHistoryStr($prmElement)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   Get content mode template
    param:      none
    return:     see probe
    note:       
    -->
    <xsl:template match="node()" mode="MODE_GET_CONTENTS">
        <xsl:apply-templates select=".">
            <xsl:with-param name="prmWithNoId" tunnel="yes" select="true()"/>
        </xsl:apply-templates>
    </xsl:template>

</xsl:stylesheet>

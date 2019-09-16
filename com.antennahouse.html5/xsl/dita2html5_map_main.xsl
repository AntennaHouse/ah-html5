<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Map Main Templates
    **************************************************************
    File Name : dita2html5_map_main.xsl
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
    function:   Root Element template
    param:      none
    return:     html element, etc
    note:       
    -->
    <xsl:template match="/*[1]">
        <xsl:choose>
            <xsl:when test="$gpOutputAsXml">
                <xsl:variable name="xmlDec" as="xs:string" select="ahf:getVarValue('XmlDeclaration')"/>
                <xsl:value-of select="$xmlDec" disable-output-escaping="yes"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="html5DocType" as="xs:string" select="ahf:getVarValue('Html5DocType')"/>
                <xsl:value-of select="$html5DocType" disable-output-escaping="yes"/>
            </xsl:otherwise>
        </xsl:choose>
        <html>
            <xsl:attribute name="lang" select="$documentLang"/>
            <xsl:if test="ahf:isRtl($documentLang)">
                <xsl:call-template name="getAttributeSet">
                    <xsl:with-param name="prmAttrSetName" select="'atsRtl'"/>
                </xsl:call-template>
            </xsl:if>
            <head>
                <xsl:call-template name="genMapHeader"/>
            </head>
            <body>
                <xsl:call-template name="genCommonAtts"/>
                <xsl:if test="string($gpBodyOutputClass)">
                    <xsl:attribute name="class" select="$gpBodyOutputClass"/>
                </xsl:if>
                <xsl:if test="descendant::*[ahf:outputTopicref(.)] => exists()">
                    <nav>
                        <ul>
                            <xsl:apply-templates select="*[contains-token(@class, 'map/topicref')]" mode="MODE_NAV_PAGE"/>
                        </ul>
                    </nav>
                </xsl:if>
            </body>
        </html>
    </xsl:template>

    <!--
    function:   Generate Header Contents
    param:      none
    return:     meta, etc
    note:       
    -->
    <xsl:template name="genMapHeader">
        <xsl:copy-of select="ahf:getXmlObject('xmlMetaCharset')"/>
        <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaDefaultCopyright','%year',$gpYear)"/>
        <xsl:if test="$gpGenDefaultMeta">
            <xsl:copy-of select="ahf:getXmlObject('xmlMetaDefaultMeta')"/>
        </xsl:if>
        <xsl:call-template name="genCssLink"/>
        <xsl:call-template name="genMapTitle"/>
        <xsl:call-template name="genMapMetadata"/>
        <!-- For User Customization -->
        <xsl:call-template name="genUserHeader"/>
        <xsl:call-template name="genUserScripts"/>
        <xsl:call-template name="genUserStyles" />
    </xsl:template>

    <!--
    function:   Generate Map Title
    param:      none
    return:     title
    note:       
    -->
    <xsl:template name="genMapTitle">
        <xsl:choose>
            <xsl:when test="$map/*[contains-token(@class,'topic/title')]/*[contains-token(@class,'bookmap/mainbooktitle')]">
                <xsl:variable name="mainbookTitle" as="xs:string*">
                    <xsl:apply-templates select="$map/*[contains-token(@class,'topic/title')]/*[contains-token(@class,'bookmap/mainbooktitle')]" mode="TEXT_ONLY"/>
                </xsl:variable>
                <title>
                    <xsl:value-of select="normalize-space(string-join($mainbookTitle,''))"/>
                </title>
            </xsl:when>
            <xsl:when test="$map/*[contains-token(@class,'topic/title')]">
                <xsl:variable name="title" as="xs:string*">
                    <xsl:apply-templates select="$map/*[contains-token(@class,'topic/title')]" mode="TEXT_ONLY"/>
                </xsl:variable>
                <title>
                    <xsl:value-of select="normalize-space(string-join($title,''))"/>
                </title>
            </xsl:when>
            <xsl:when test="$map/@title">
                <title>
                    <xsl:value-of select="normalize-space($map/@title)"/>
                </title>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   User Custmization template
    param:      none
    return:     Header contents
    note:       
    -->
    <xsl:template name="genUserHeader"/>
    <xsl:template name="genUserScripts"/>
    <xsl:template name="genUserStyles" />

    <!--
    function:   Topicref Template
    param:      none
    return:     li
    note:       
    -->
    <xsl:template match="*[ahf:outputTopicref(.)]" mode="MODE_NAV_PAGE">
        <xsl:variable name="navTitle" as="xs:string">
            <xsl:call-template name="getNavTitle"/>    
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string($navTitle)">
                <li>
                    <xsl:call-template name="genCommonAtts"/>
                    <xsl:choose>
                        <xsl:when test="string(@href/normalize-space())">
                            <a>
                                <xsl:call-template name="getHrefFromTopicRef"/>
                                <xsl:if test="@scope/string() eq 'external' or not(empty(@format) or @format/string() = ('dita','ditamap'))">
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$navTitle"/>
                            </a>                            
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$navTitle"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="*[ahf:outputTopicref(.)] => exists()">
                        <ul>
                            <xsl:apply-templates select="*[contains-token(@class, 'map/topicref')]" mode="#current"/>
                        </ul>
                    </xsl:if>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*[contains-token(@class, 'map/topicref')]" mode="#current"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[ahf:outputTopicref(.) => not()]" mode="MODE_NAV_PAGE">
    </xsl:template>

    <xsl:template match="*[contains-token(@class, 'mapgroup-d/topicgroup')]" priority="5" mode="MODE_NAV_PAGE">
        <xsl:apply-templates select="*[contains-token(@class, 'map/topicref')]" mode="#current"/>
    </xsl:template>

    <xsl:template match="*[contains-token(@class, 'mapgroup-d/keydef')]" priority="5" mode="MODE_NAV_PAGE">
    </xsl:template>

    <xsl:template match="*[contains-token(@class, 'bookmap/booklists')]" priority="5" mode="MODE_NAV_PAGE">
        <xsl:apply-templates select="*[contains-token(@class, 'map/topicref')]" mode="#current"/>
    </xsl:template>

    <xsl:template match="*[contains-token(@class, 'bookmap/booklists')]/*[contains-token(@class, 'bookmap/toc')]" priority="5" mode="MODE_NAV_PAGE">
    </xsl:template>

    <xsl:template match="*[contains-token(@class, 'bookmap/booklists')]/*[contains-token(@class, 'bookmap/indexlist')]" priority="5" mode="MODE_NAV_PAGE">
    </xsl:template>
    
    <xsl:template match="*[contains-token(@class, 'bookmap/frontmatter')]" priority="10" mode="MODE_NAV_PAGE">
        <xsl:apply-templates select="*[contains-token(@class, 'map/topicref')]" mode="#current"/>
    </xsl:template>

    <xsl:template match="*[contains-token(@class, 'bookmap/backmatter')]" priority="10" mode="MODE_NAV_PAGE">
        <xsl:apply-templates select="*[contains-token(@class, 'map/topicref')]" mode="#current"/>
    </xsl:template>

    <!--
    function:   Determine to process topicref
    param:      prmTopicRef
    return:     xs:boolean
    note:       
    -->
    <xsl:function name="ahf:outputTopicref" as="xs:boolean">
        <xsl:param name="prmTopicref" as="element()"/>
        <xsl:sequence select="$prmTopicref[contains-token(@class, 'map/topicref')][ahf:isToc(.)][not(ahf:isResourceOnly(.))] => exists()"/>
    </xsl:function>
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
                    <xsl:with-param name="prmMes" select="ahf:replace($stMes200,('%xpath','%href'),(ahf:getHistoryXpathStr($prmTopicRef),$prmTopicRef/@href/string()))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   Generate Navtitle Template
    param:      prmTopicRef
    return:     xs:string
    note:       
    -->
    <xsl:template name="getHrefFromTopicRef" as="attribute()">
        <xsl:param name="prmTopicRef" as="element()" required="no" select="."/>
        <xsl:variable name="hrefTemp" as="xs:string*">
            <xsl:choose>
                <xsl:when test="exists($prmTopicRef/@copy-to) and not(contains-token($prmTopicRef/@chunk, 'to-content')) and (empty($prmTopicRef/@format) or $prmTopicRef/@format/string() = ('dita','ditamap')) ">
                    <xsl:if test="not($prmTopicRef/@scope/string() eq 'external')">
                        <xsl:sequence select="$path2ProjUri"/>
                    </xsl:if>
                    <xsl:sequence select="ahf:replaceExtension($prmTopicRef/@copy-to,$gpOutputExtension)"/>
                    <xsl:if test="not(contains($prmTopicRef/@copy-to, '#')) and contains($prmTopicRef/@href, '#')">
                        <xsl:sequence select="concat('#', substring-after(@href, '#'))"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="not($prmTopicRef/@scope/string() eq 'external') and (empty($prmTopicRef/@format) or $prmTopicRef/@format/string() = ('dita','ditamap'))">
                    <xsl:if test="not($prmTopicRef/@scope/string() eq 'external')">
                        <xsl:sequence select="$path2ProjUri"/>
                    </xsl:if>
                    <xsl:sequence select="ahf:replaceExtensionWithFragment($prmTopicRef/@href,$gpOutputExtension)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="not(@scope = 'external')">
                        <xsl:sequence select="$path2ProjUri"/>
                    </xsl:if>
                    <xsl:sequence select="@href/string()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="href" select="string-join($hrefTemp,'')"/>
    </xsl:template>
</xsl:stylesheet>

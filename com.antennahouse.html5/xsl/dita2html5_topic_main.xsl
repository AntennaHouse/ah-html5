<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Topic Main Templates
    **************************************************************
    File Name : dita2html5_topic_main.xsl
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
    function:   Root topic template
    param:      none
    return:     html element, etc
    note:       If topicref/@chunk="to-content" is specified, DITA-OT generates <dita> element at the top of merged topic file.
    -->
    <xsl:template match="/">
        <xsl:apply-templates select="$topic"/>
    </xsl:template>
    
    <xsl:template match="*[. is $topic]">
        <xsl:variable name="topic" as="element()" select="."/>
        <xsl:variable name="topicRef" as="element()?" select="ahf:getTopicref()"/>
        <xsl:message select="'*----------------------------------------------------*'"/>
        <xsl:message select="'$gpProcessingFileName=' || $gpProcessingFileName"/>
        <xsl:message select="'$gpProcessingFileDir=' || $gpProcessingFileDir"/>
        <xsl:message select="'$gpMapUrl=' || $gpMapUrl"/>
        
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
                <xsl:call-template name="genTopicHeader"/>
            </head>
            <body>
                <xsl:call-template name="genCommonAtts"/>
                <xsl:call-template name="genIdAtt"/>
                <!-- Insert navigation -->
                <main>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsMain'"/>
                    </xsl:call-template>
                    <article>
                        <xsl:call-template name="getAttributeSet">
                            <xsl:with-param name="prmAttrSetName" select="'atsArticle'"/>
                        </xsl:call-template>
                        <xsl:call-template name="genAriaLabeledByAttr"/>
                        <xsl:apply-templates select="*[contains-token(@class,'topic/title')]"/>
                        <xsl:if test="(*[contains-token(@class,'topic/shortdesc')] |*[contains-token(@class,'topic/abstract')] |*[contains-token(@class,'topic/body')] | *[contains-token(@class,'topic/related-links')]) => exists()">
                            <div>
                                <xsl:call-template name="getAttributeSet">
                                    <xsl:with-param name="prmAttrSetName" select="'atsTopicContent'"/>
                                </xsl:call-template>
                                <xsl:apply-templates select="*[contains-token(@class,'topic/shortdesc')]|*[contains-token(@class,'topic/abstract')]"/>
                                <xsl:apply-templates select="*[contains-token(@class,'topic/body')]"/>
                                <xsl:if test="$gpOutputFnAtEndOfTopic">
                                    <xsl:call-template name="genFootNoteList">
                                        <xsl:with-param name="prmElement" select="$topic"/>
                                    </xsl:call-template>
                                </xsl:if>
                                <xsl:apply-templates select="*[contains-token(@class,'topic/related-links')]"/>
                            </div>
                        </xsl:if>
                        <xsl:apply-templates select="*[contains-token(@class,'topic/topic')]"/>
                    </article>
                </main>
            </body>
        </html>
    </xsl:template>
    
    <!--
    function:   Generate Topic Header Contents
    param:      none
    return:     meta, etc
    note:       
    -->
    <xsl:template name="genTopicHeader">
        <xsl:copy-of select="ahf:getXmlObject('xmlMetaCharset')"/>
        <!--xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaDefaultCopyright','%year',$gpYear)"/-->
        <xsl:if test="$gpGenDefaultMeta">
            <xsl:copy-of select="ahf:getXmlObject('xmlMetaDefaultMeta')"/>
        </xsl:if>
        <xsl:call-template name="genCssLink"/>
        <xsl:call-template name="genTopicTitleInHeader"/>
        <xsl:call-template name="genTopicShortDescMeta"/>
        <xsl:call-template name="genTopicAbstractMeta"/>
        <xsl:call-template name="genTopicMetadata"/>
        <!-- For User Customization -->
        <xsl:call-template name="genTopicUserHeader"/>
        <xsl:call-template name="genTopicUserScripts"/>
        <xsl:call-template name="genTopicUserStyles" />
    </xsl:template>
    
    <!--
    function:   Generate Topic Title
    param:      none
    return:     title
    note:       
    -->
    <xsl:template name="genTopicTitleInHeader">
        <xsl:variable name="title" as="xs:string*">
            <xsl:apply-templates select="$topic/*[contains-token(@class,'topic/title')]" mode="TEXT_ONLY"/>
        </xsl:variable>
        <xsl:variable name="titleNormalized" as="xs:string" select="normalize-space(string-join($title,''))"/>
        <title>
            <xsl:value-of select="if (string($titleNormalized)) then $titleNormalized else $NBSP"/>
        </title>
    </xsl:template>

    <!--
    function:   Generate Shortdesc
    param:      none
    return:     meta
    note:       
    -->
    <xsl:template name="genTopicShortDescMeta">
        <xsl:variable name="shortdescTemp" as="xs:string*">
            <xsl:apply-templates select="$topic/*[contains-token(@class,'topic/shortdesc')]" mode="TEXT_ONLY"/>
        </xsl:variable>
        <xsl:variable name="shortdesc" as="xs:string" select="normalize-space(string-join($shortdescTemp,''))"/>
        <xsl:if test="string($shortdesc)">
            <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaShortdesc','%shortdesc',$shortdesc)"/>
        </xsl:if>
    </xsl:template>

    <!--
    function:   Generate Abstract
    param:      none
    return:     meta
    note:       
    -->
    <xsl:template name="genTopicAbstractMeta">
        <xsl:variable name="abstractTemp" as="xs:string*">
            <xsl:apply-templates select="$topic/*[contains-token(@class,'topic/abstract')]" mode="TEXT_ONLY"/>
        </xsl:variable>
        <xsl:variable name="abstract" as="xs:string" select="normalize-space(string-join($abstractTemp,''))"/>
        <xsl:if test="string($abstract)">
            <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaAbstract','%abstract',$abstract)"/>
        </xsl:if>
    </xsl:template>

    <!--
    function:   Generate aria-labeledby attribute
    param:      prmTopic
    return:     @aria-labeledby
    note:       
    -->
    <xsl:template name="genAriaLabeledByAttr">
        <xsl:param name="prmTopic" as="element()" required="no" select="."/>
        <xsl:variable name="idAtt" as="attribute(id)">
            <xsl:choose>
                <xsl:when test="$prmTopic/*[contains-token(@class, 'topic/title')]/@id => exists()">
                    <xsl:call-template name="genIdAtt">
                        <xsl:with-param name="prmElement" select="$prmTopic/*[contains-token(@class, 'topic/title')]"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="topicCount" as="xs:integer">
                        <xsl:for-each select="$prmTopic">
                            <xsl:number count="*[contains-token(@class, 'topic/topic')]" level="any"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:attribute name="id" select="concat($topicTitleIdPrefix,$topicCount)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="aria-labelledby" select="string($idAtt)"/>
    </xsl:template>
    
    <!--
    function:   User Custmization template
    param:      none
    return:     Header contents
    note:       
    -->
    <xsl:template name="genTopicUserHeader"/>
    <xsl:template name="genTopicUserScripts"/>
    <xsl:template name="genTopicUserStyles" />
    
</xsl:stylesheet>

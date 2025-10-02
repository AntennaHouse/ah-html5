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

    <xsl:variable name="pathToMapDir" as="xs:string" select="ahf:getPathToMapDirFromTopic($gpMapUrl, base-uri()) => string()"/>
    <xsl:variable name="pathToFile" as="xs:string" select="ahf:getPathToFile($gpMapUrl, base-uri(), $gpProcessingFileName)"/>
    <xsl:variable name="currentFile" as="xs:string" select="ahf:normalizeHref($pathToFile)"/>
    <xsl:variable name="currentTopicRef" as="element()?" select="$gpMapDoc/descendant::*[contains(@class, ' map/topicref ')][ahf:getPathFromTopicRef($path2ProjUri, .) eq $currentFile][1]"/>
    
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
                        <xsl:with-param name="prmAttrSetName" select="'atsNaviToc'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="$gpMapDoc" mode="MODE_TOC">
                        <xsl:with-param name="prmPathToMapDirFromTopic" as="xs:string" select="$pathToMapDir"/>
                    </xsl:apply-templates>
                </nav>
            </xsl:when>
            <xsl:when test="$gpOutputNavTocPartial">
                <!--nav>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsNavToc'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="$currentTopicRef" mode="MODE_TOC_PULL">
                        <xsl:with-param name="prmPathToMapDirFromTopic" as="xs:string" select="$pathToMapDir"/>
                        <xsl:with-param name="prmChildElements" as="element()*">
                            <xsl:apply-templates select="$currentTopicRef/*[contains-token(@class, 'map/topicref')]" mode="MODE_TOC">
                                <xsl:with-param name="prmPathToMapDirFromTopic" as="xs:string" select="$pathToMapDir"/>
                            </xsl:apply-templates>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </nav-->
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   mode="MODE_TOC" templates
    param:      none
    return:     
    note:       
    -->
    <xsl:mode name="MODE_TOC" on-no-match="shallow-skip"/>
    
    <xsl:template match="@*" mode="MODE_TOC"/>
    
    <xsl:template match="*" mode="MODE_TOC">
        <xsl:param name="prmPathToMapDirFromTopic" required="yes" as="xs:string"/>
        <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="#current">
            <xsl:with-param name="prmPathToMapDirFromTopic" select="$prmPathToMapDirFromTopic"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' map/topicref ')]
                          [not(@toc = 'no')]
                          [not(@processing-role = 'resource-only')]"
                          mode="MODE_TOC" priority="10">
        <xsl:param name="prmPathToMapDirFromTopic" required="yes" as="xs:string"/>
        <xsl:param name="prmChildElements" required="no" select="if ($gpOutputNavTocFull) then *[contains(@class, ' map/topicref ')] else ()" as="element()*"/>

        <xsl:variable name="title" as="xs:string">
            <xsl:call-template name="getNavTitle"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="normalize-space($title)">
                <li>
                    <xsl:if test=". is $currentTopicRef">
                        <xsl:call-template name="getAttributeSet">
                            <xsl:with-param name="prmAttrSetName" select="'atsNaviActive'"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="normalize-space(@href)">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:if test="not(@scope = 'external')">
                                        <xsl:value-of select="$prmPathToMapDirFromTopic"/>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and 
                                            (empty(@format) or @format = 'dita' or @format = 'ditamap') ">
                                            <xsl:value-of select="ahf:replaceExtension(string(@copy-to),$gpOutputExtension)"/>
                                            <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                                                <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="not(@scope = 'external') and (empty(@format) or @format = 'dita' or @format = 'ditamap')">
                                            <xsl:value-of select="ahf:replaceExtension(string(@href),$gpOutputExtension)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@href"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:value-of select="$title"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <span>
                                <xsl:value-of select="$title"/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="exists($prmChildElements)">
                        <ul>
                            <xsl:apply-templates select="$prmChildElements" mode="#current">
                                <xsl:with-param name="prmPathToMapDirFromTopic" select="$prmPathToMapDirFromTopic"/>
                            </xsl:apply-templates>
                        </ul>
                    </xsl:if>
                </li>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   mode="MODE_TOC_PULL" templates
    param:      none
    return:     
    note:       
    -->
    











    <!--
    function:   Get path from topicref
    param:      prmTopicRef
    return:     xs:string
    note:       
    -->
    <xsl:function name="ahf:getPathFromTopicRef" as="xs:string">
        <xsl:param name="prmPathFromMap" as="xs:string"/>
        <xsl:param name="prmTopicRef" as="element()"/>
        <xsl:variable name="results" as="xs:string*">
            <xsl:if test="not($prmTopicRef/@scope = 'external')">
                <xsl:sequence select="ahf:stripLeadingParent($prmPathFromMap)"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="exists($prmTopicRef/@copy-to) and not(contains($prmTopicRef/@chunk, 'to-content')) and
                    (empty($prmTopicRef/@format) or $prmTopicRef/@format = 'dita' or $prmTopicRef/@format = 'ditamap') ">
                    <xsl:sequence select="$prmTopicRef/@copy-to => string()"/>
                </xsl:when>
                <xsl:when test="contains($prmTopicRef/@chunk, 'to-content')">
                    <xsl:sequence select="substring-before($prmTopicRef/@href,'#')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$prmTopicRef/@href => string()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="string-join($results,'')"/>
    </xsl:function>
    
    <xsl:function name="ahf:stripLeadingParent" as="xs:string">
        <xsl:param name="prmPath" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="starts-with($prmPath, '../')">
                <xsl:sequence select="ahf:stripLeadingParent(substring($prmPath, 4))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$prmPath"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>

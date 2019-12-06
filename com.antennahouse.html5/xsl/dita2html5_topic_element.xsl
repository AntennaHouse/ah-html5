<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Topic Element Templates
    **************************************************************
    File Name : dita2html5_topic_element.xsl
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
    
    <!-- HTML Heading Class value -->
    <xsl:variable name="topicTitleHeadingClass" as="xs:string" select="ahf:getVarValue('Topic_Title_Heading_Class')"/>
    <!-- HTML Title ID Prefix -->
    <xsl:variable name="topicTitleIdPrefix" as="xs:string" select="ahf:getVarValue('Topic_Title_Id_Prefix')"/>
    
    <!--
    function:   nested topic template
    param:      none
    return:     article
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/topic')][ancestor::*[contains-token(@class, 'topic/topic')] => exists()]">
        <xsl:variable name="topic" as="element()" select="."/>
        <xsl:variable name="nestLevel" as="xs:integer">
            <xsl:variable name="level" as="xs:integer" select="count(ancestor::*[contains-token(@class, 'topic/topic')])"/>
            <xsl:sequence select="if ($level gt $cHeadingLevelMax) then $cHeadingLevelMax else $level"/>
        </xsl:variable>
        <article>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="concat('nested', $nestLevel)"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
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
    </xsl:template>
    
    <!--
    function:   topic title template
    param:      none
    return:     h[N] element, etc
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/topic')]/*[contains-token(@class, 'topic/title')]">
        <xsl:variable name="headingLevel" as="xs:integer">
            <xsl:variable name="level" as="xs:integer" select="count(ancestor::*[contains-token(@class, 'topic/topic')])"/>
            <xsl:sequence select="if ($level gt $cHeadingLevelMax) then $cHeadingLevelMax else $level"/>
        </xsl:variable>
        <xsl:element name="h{$headingLevel}">
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$topicTitleHeadingClass || $headingLevel"/>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="exists(@id)">
                    <xsl:call-template name="genIdAtt"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="topicCount" as="xs:integer">
                        <xsl:number count="*[contains-token(@class, 'topic/title')][parent::*[contains-token(@class,'topic/topic')]]" level="any"/>
                    </xsl:variable>
                    <xsl:attribute name="id" select="concat($topicTitleIdPrefix,$topicCount)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!--
    function:   topic titlealts template
    param:      none
    return:     none
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/titlealts')]"/>

    <!--
    function:   topic shortdesc template
    param:      none
    return:     p or span
    note:       If it is a child of abstract, treat as inline as long as tehre is no block level elements
    -->
    <xsl:template match="*[contains-token(@class, 'topic/shortdesc')]">
        <p>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="*[contains-token(@class, 'topic/shortdesc')][parent::*[contains-token(@class, 'topic/abstract')]]" priority="5">
        <xsl:choose>
            <xsl:when test="exists(preceding-sibling::*[not(contains-token(@class, 'topic/shortdesc'))][ahf:isBlockLevelElement(.)] | following-sibling::*[not(contains-token(@class, 'topic/shortdesc'))][ahf:isBlockLevelElement(.)])">
                <p>
                    <xsl:call-template name="genCommonAtts"/>
                    <xsl:call-template name="genIdAtt"/>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="preceding-sibling::* | preceding-sibling::text()">
                    <xsl:text> </xsl:text>
                </xsl:if>
                <span>
                    <xsl:call-template name="genCommonAtts"/>
                    <xsl:call-template name="genIdAtt"/>
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   topic abdtract template
    param:      none
    return:     div
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/abstract')]">
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!--
    function:   topic body template
    param:      none
    return:     div
    note:       Include shortdesc/abstract as child       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/body')]">
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!--
    function:   bodydiv template
    param:      none
    return:     none
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/bodydiv')]">
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

</xsl:stylesheet>

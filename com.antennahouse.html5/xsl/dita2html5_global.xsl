<?xml version="1.0" encoding="UTF-8" ?>
<!--
****************************************************************
DITA to HTML5 Stylesheet
Module: Stylesheet global variables.
Copyright © 2009-2019 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="3.0" 
 xmlns:fo="http://www.w3.org/1999/XSL/Format" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
>
    <!-- *************************************** 
            Constants
         ***************************************-->
    
    <xsl:variable name="idSeparator" select="'_'" as="xs:string"/>
    
    <!-- ************************************************ 
            Words depending on language ($map/@xml:lang)
         ************************************************-->
    <xsl:variable name="cPartTitlePrefix"  select="ahf:getVarValue('Part_Title_Prefix')" as="xs:string"/>
    <xsl:variable name="cPartTitleSuffix"  select="ahf:getVarValue('Part_Title_Suffix')" as="xs:string"/>
    <xsl:variable name="cChapterTitlePrefix"  select="ahf:getVarValue('Chapter_Title_Prefix')" as="xs:string"/>
    <xsl:variable name="cChapterTitleSuffix"  select="ahf:getVarValue('Chapter_Title_Suffix')" as="xs:string"/>
    
    <xsl:variable name="cTocTitle"         select="ahf:getVarValue('Toc_Title')" as="xs:string"/>
    <xsl:variable name="cFigureListTitle"  select="ahf:getVarValue('Figure_List_Title')" as="xs:string"/>
    <xsl:variable name="cTableListTitle"   select="ahf:getVarValue('Table_List_Title')" as="xs:string"/>
    <xsl:variable name="cAppendicesTitle"  select="ahf:getVarValue('Appendices_Title')" as="xs:string"/>
    <xsl:variable name="cAppendixTitle"    select="ahf:getVarValue('Appendix_Title')" as="xs:string"/>
    <xsl:variable name="cGlossaryListTitle" select="ahf:getVarValue('Glossary_List_Title')" as="xs:string"/>
    <xsl:variable name="cIndexTitle"       select="ahf:getVarValue('Index_Title')" as="xs:string"/>
    <xsl:variable name="cNoticeTitle"      select="ahf:getVarValue('Notice_Title')" as="xs:string"/>
    <xsl:variable name="cPrefaceTitle"     select="ahf:getVarValue('Preface_Title')" as="xs:string"/>
    
    <xsl:variable name="cTableTitle"       select="ahf:getVarValue('Table_Title')" as="xs:string"/>
    <xsl:variable name="cFigureTitle"      select="ahf:getVarValue('Figure_Title')" as="xs:string"/>

    <!-- *************************************** 
            Related-links variable
         ***************************************-->
    <xsl:variable name="cDeadLinkPDF"           select="ahf:getVarValue('Dead_Link_PDF')" as="xs:string"/>
    <xsl:variable name="cDeadLinkColor"         select="ahf:getVarValue('Dead_Link_Color')" as="xs:string"/>
    
    <!-- *************************************** 
            Variables depending on document
         ***************************************-->
    <!-- Top level element -->
    <xsl:variable name="root"  as="element()" select="/*[1]"/>
    <xsl:variable name="map" as="element()?" select="$root[contains-token(@class,'map/map')]"/>
    <xsl:variable name="topic" as="element()?" select="if ($root/self::dita) then $root/*[contains-token(@class,'topic/topic')][1] else $root"/>
    
    <!-- Map class -->
    <xsl:variable name="classMap" select="'map'" as="xs:string"/>
    <xsl:variable name="classBookMap" select="'bookmap'" as="xs:string"/>
    <xsl:variable name="classTopic" select="'topic'" as="xs:string"/>
    <xsl:variable name="classUnknown" select="'unknown'" as="xs:string"/>
    <xsl:variable name="ditamapClass" as="xs:string">
        <xsl:choose>
            <xsl:when test="$root[contains-token(@class, 'map/map')][contains-token(@class,'bookmap/bookmap')]">
                <xsl:sequence select="$classBookMap"/>
            </xsl:when>
            <xsl:when test="$root[contains-token(@class, 'map/map')]">
                <xsl:sequence select="$classMap"/>
            </xsl:when>
            <xsl:when test="$root[contains-token(@class, 'topic/topic')]">
                <xsl:sequence select="$classMap"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="errorExit">
                    <xsl:with-param name="prmMes">
                        <xsl:value-of select="ahf:replace($stMes100,('%class','%file'),(string($root/*[1]/@class),string($root/*[1]/@xtrf)))"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="isMap"     select="boolean($ditamapClass eq $classMap)"     as="xs:boolean"/>
    <xsl:variable name="isBookMap" select="boolean($ditamapClass eq $classBookMap)" as="xs:boolean"/>
    <xsl:variable name="isTopic"   select="boolean($ditamapClass eq $classTopic)"   as="xs:boolean"/>
    
    <!-- Document language -->
    <xsl:variable name="documentLang" as="xs:string">
        <xsl:variable name="defaultLang" as="xs:string" select="'en-US'"/>
        <xsl:choose>
            <xsl:when test="string($gpLang)">
                <xsl:sequence select="ahf:nomalizeXmlLang($gpLang)"/>
            </xsl:when>
            <xsl:when test="$root/@xml:lang">
                <xsl:sequence select="ahf:nomalizeXmlLang($root/@xml:lang)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="warningContinue">
                    <xsl:with-param name="prmMes">
                        <xsl:value-of select="ahf:replace($stMes101,('%lang'),($defaultLang))"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:sequence select="$defaultLang"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- Direction -->
    <xsl:variable name="isRtl" as="xs:boolean" select="ahf:isRtl($documentLang)"/>
    
    <!-- Working directory that contains the document being transformed
         (e.g) <?workdir-uri file:/D:/DITA-OT/dita-ot-3.3.2/docsrc/samples/temp/html5/tasks/?>
     -->
    <xsl:variable name="workDirUri" as="xs:string" select="/processing-instruction('workdir-uri')[1]/string()"/>

    <!-- Path back to project
         (e.g) <?path2project-uri ../?>
     -->
    <xsl:variable name="path2ProjUri" as="xs:string">
        <xsl:variable name="piContent" as="xs:string" select="/processing-instruction('path2project-uri')[1]/string()"/>
        <xsl:sequence select="if ($piContent eq './') then '' else $piContent"/>
    </xsl:variable>


    <!-- Elements by id -->
    <xsl:key name="elementById" match="/descendant::*[exists(@id)]" use="@id"/>
    
    <!-- *************************************** 
            Document variables
         ***************************************-->
    <!-- Title -->
    <xsl:variable name="bookTitle" as="node()*">
        <xsl:choose>
            <xsl:when test="$isMap">
                <xsl:choose>
                    <xsl:when test="$root/*[contains-token(@class, 'topic/title')]">
                        <xsl:apply-templates select="$root/*[contains-token(@class, 'topic/title')]"/>
                    </xsl:when>
                    <xsl:when test="$root//@title">
                        <xsl:value-of select="$root/@title"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$isBookMap">
                <xsl:choose>
                    <xsl:when test="$root/*[contains-token(@class, 'bookmap/booktitle')]">
                        <xsl:apply-templates select="$root/*[contains-token(@class, 'bookmap/booktitle')]/*[contains-token(@class, 'bookmap/mainbooktitle')]"/>
                    </xsl:when>
                    <xsl:when test="$root/*[contains-token(@class, 'topic/title')]">
                        <xsl:apply-templates select="$root/*[contains-token(@class, 'topic/title')]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$isTopic">
                <xsl:apply-templates select="$root/*[contains-token(@class, 'topic/title')]"/>
            </xsl:when>
        </xsl:choose>
    </xsl:variable>

</xsl:stylesheet>

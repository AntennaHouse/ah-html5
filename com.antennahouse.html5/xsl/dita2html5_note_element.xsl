<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Note Element Templates
    **************************************************************
    File Name : dita2html5_note_element.xsl
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
    function:   note template
    param:      none
    return:     div
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/note')]">
        <xsl:variable name="note" as="element()" select="."/>
        <xsl:variable name="noteType" as="xs:string">
            <xsl:choose>
                <xsl:when test="$note/@type => exists()">
                    <xsl:variable name="tempType" as="xs:string" select="$note/@type => string()"/>
                    <xsl:choose>
                        <xsl:when test="$tempType eq 'other'">
                            <xsl:sequence select="$note/@othertype => string()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="$tempType"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="'note'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <span>
                <xsl:call-template name="genCommonAtts">
                    <xsl:with-param name="prmElement" select="()"/>
                    <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('Note_Title')"/>
                </xsl:call-template>
                <xsl:call-template name="getVarValueWithLangAsText">
                    <xsl:with-param name="prmVarName" select="'Note_' || substring($noteType,1,1) => upper-case() || substring($noteType,2)"/>
                </xsl:call-template>
            </span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

</xsl:stylesheet>

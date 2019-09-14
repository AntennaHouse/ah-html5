<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    DITA Utility Templates
    **************************************************************
    File Name : dita2html5_dita_util_html_only.xsl
    **************************************************************
    Copyright © 2009-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.co.jp/
    **************************************************************
-->

<xsl:stylesheet version="3.0" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs ahf" >

    <!--
     function:  Get topicref from $gpProcessingFileName and $gpProcessingFileDir
     param:     none
     return;    element()?
     note:      Specific to topic processing
                If input file is chunked, the root element become 'dita'.
    -->
    <xsl:function name="ahf:getTopicref" as="element()?">
        <xsl:variable name="href" as="xs:string">
            <xsl:choose>
                <xsl:when test="$root instance of element(dita)">
                    <xsl:variable name="topicId" as="xs:string" select="$topic/@id => string()"/>
                    <xsl:sequence select="$gpProcessingFileDir || '/' || $gpProcessingFileName || '#' || $topicId"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$gpProcessingFileDir || '/' || $gpProcessingFileName"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$gpMapDoc/descendant::*[contains-token(@class,'map/topicref')][ancestor::*[contains-token(@class,'map/reltable')] => empty()][(if (@copy-to => exists()) then @copy-to => string() else @href => string()) eq $href]"/>
    </xsl:function>

    <!-- end of stylesheet -->
</xsl:stylesheet>

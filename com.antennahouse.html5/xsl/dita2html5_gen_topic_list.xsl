<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Topic Main Templates
    **************************************************************
    File Name : dita2html5_gen_topic_list.xsl
    **************************************************************
    Copyright © 2008-2025 Antenna House, Inc. All rights reserved.
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
    
    <!-- This stylesheet generates topic list
         from .job.xml in temporary folder.
         The output will be used as the xslt task's @includesfile attribute.
     -->
    
    <xsl:output method="text" encoding="UTF-8" byte-order-mark="no"/>
    
    <xsl:param name="PRM_LINE_SEPARATOR" as="xs:string" required="yes"/>
    <xsl:variable name="gpLineSeparator" as="xs:string" select="$PRM_LINE_SEPARATOR"/>
    
    <!--
    function:   .job.xml document node template
    param:      none
    return:     topic file path list
    note:       
    -->
    <xsl:template match="/">
        <xsl:for-each select="descendant::file[string(@format) eq 'dita'][string(@resource-only) ne 'true']">
            <xsl:variable name="file" as="element()" select="."/>
            <xsl:value-of select="$file/@uri"/>
            <xsl:value-of select="$gpLineSeparator"/>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>

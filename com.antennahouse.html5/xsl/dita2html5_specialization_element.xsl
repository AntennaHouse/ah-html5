<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Specialization Element Templates
    **************************************************************
    File Name : dita2html5_specialization_element.xsl
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
    function:   itemgroup template
    param:      none
    return:     div
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/itemgroup')]">
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
</xsl:stylesheet>

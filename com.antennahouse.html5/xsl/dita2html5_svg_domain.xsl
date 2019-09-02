<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    SVG Domain Element Templates
    **************************************************************
    File Name : dita2html5_svg_domain.xsl
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
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="xs ahf style ditaarch dita-ot svg"
    version="3.0">
    
    <!--
    function:   svgref template
    param:      none
    return:     img
    note:       The browser does not support the SVG file path that have fragment mark (#).
    -->
    <xsl:template match="*[contains-token(@class, 'svg-d/svgref')]" priority="5">
        <xsl:variable name="svgRef" as="element()" select="."/>
        <img>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:attribute name="src" select="$svgRef/@href  => string()"/>
        </img>
    </xsl:template>
    
    <!--
    function:   svg-container template
    param:      none
    return:     span
    note:       content of svg-container: (svg:svg | <data> | <data-about> | <sort-as> | <svgref> )*
    -->
    <xsl:template match="*[contains-token(@class, 'svg-d/svg-container')]" priority="5">
        <xsl:variable name="svgContiner" as="element()" select="."/>
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--
    function:   SVG in svg-container
    param:      none
    return:     svg element
    note:       
    -->
    <xsl:template match="svg:svg">
        <xsl:element name="{local-name()}" namespace="http://www.w3.org/2000/svg">
            <xsl:apply-templates select="@* | node()" mode="MODE_COPY_SVG"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="svg:*" mode="MODE_COPY_SVG">
        <xsl:element name="{local-name()}" namespace="http://www.w3.org/2000/svg">
            <xsl:apply-templates select="@* | node()" mode="MODE_COPY_SVG"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*" mode="MODE_COPY_SVG">
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="node()" mode="MODE_COPY_SVG">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

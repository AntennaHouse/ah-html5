<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Constant Templates
    **************************************************************
    File Name : dita2html5_const.xsl
    **************************************************************
    Copyright © 2008-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- *************************************** 
            Constants
         ***************************************-->
    
    <!-- External Parameter yes/no value -->
    <xsl:variable name="cYes" select="'yes'" as="xs:string"/>
    <xsl:variable name="cNo" select="'no'" as="xs:string"/>
    
    <!-- Inner flag/attribute value: true/false -->
    <xsl:variable name="true" select="'true'" as="xs:string"/>
    <xsl:variable name="false" select="'false'" as="xs:string"/>
    
    <xsl:variable name="NaN" select="'NaN'" as="xs:string"/>
    <xsl:variable name="NBSP" select="'&#xA0;'" as="xs:string"/>
    <xsl:variable name="lf" select="'&#x0A;'" as="xs:string"/>
    <xsl:variable name="doubleApos" as="xs:string">
        <xsl:text>''</xsl:text>
    </xsl:variable>
    
    <!-- ID Separator (Compatible with DITA-OT HTML5 plug-in) -->
    <xsl:variable name="cIdSep" as="xs:string" select="'__'"/>
    
    <!-- HTML Heading Max -->
    <xsl:variable name="cHeadingLevelMax" as="xs:integer" select="9"/>

    <!-- BIDI Control Characters -->
    <xsl:variable name="cLeftToRightEmbedding"     as="xs:string" select="'&#x202A;'"/>
    <xsl:variable name="cRightToLeftEmbedding"     as="xs:string" select="'&#x202B;'"/>
    <xsl:variable name="cPopDirectionalFormatting" as="xs:string" select="'&#x202C;'"/>
    <xsl:variable name="cLeftToRightOverride"      as="xs:string" select="'&#x202D;'"/>
    <xsl:variable name="cRightToLeftOverride"      as="xs:string" select="'&#x202E;'"/>
    
</xsl:stylesheet>
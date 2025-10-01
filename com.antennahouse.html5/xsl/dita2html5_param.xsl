<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Parameter Templates
    **************************************************************
    File Name : dita2html5_param.xsl
    **************************************************************
    Copyright © 2008-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">

    <!-- Default style definition file: Plug-in relative path -->
    <xsl:param name="PRM_STYLE_DEF_FILE" required="no" as="xs:string" select="'config/default_style.xml'"/>
    
    <!-- Debug parameter -->
    <xsl:param name="PRM_DEBUG" required="no" as="xs:string" select="$cNo"/>
    <xsl:variable name="gpDebug" as="xs:boolean" select="$PRM_DEBUG eq $cYes"/>

    <!-- Langauge Tag -->
    <xsl:param name="PRM_LANG" required="no" as="xs:string" select="''"/>
    <xsl:variable name="gpLang" as="xs:string" select="$PRM_LANG"/>
    
    <!-- Output parameter -->
    <xsl:param name="PRM_OUTPUT_AS_XML" as="xs:string" required="no" select="$cYes"/>
    <xsl:variable name="gpOutputAsXml" as="xs:boolean" select="$PRM_OUTPUT_AS_XML eq $cYes"/>
    <xsl:variable name="gpOutputAsHtml" as="xs:boolean" select="not($gpOutputAsXml)"/>
    
    <!-- Copyright Year -->
    <xsl:param name="PRM_YEAR" as="xs:string" required="no" select="format-date(current-date(), '[Y]')"/>
    <xsl:variable name="gpYear" as="xs:string" select="$PRM_YEAR"/>
    
    <!-- Generate Default Metadata -->
    <xsl:param name="PRM_GEN_DEFAULT_META" as="xs:string" required="no" select="$cNo"/>
    <xsl:param name="gpGenDefaultMeta" as="xs:boolean" select="$PRM_GEN_DEFAULT_META eq $cYes"/>
    
    <!-- Plug-in CSS Files Parameter -->
    <xsl:param name="PRM_PLUGIN_CSS_FILES" as="xs:string" required="no" select="''"/>
    <xsl:variable name="gpPluginCssFiles" as="xs:string*" select="tokenize($PRM_PLUGIN_CSS_FILES,'[\s]+')"/>
    
    <!-- Standard CSS File Parameter -->
    <xsl:param name="PRM_DITA_CSS_FILE" as="xs:string" required="no" select="'commonltr.css'"/>
    <xsl:variable name="gpDitaCssFile" as="xs:string" select="$PRM_DITA_CSS_FILE"/>
    <xsl:param name="PRM_DITA_BIDI_CSS_FILE" as="xs:string" required="no" select="'commonrtl.css'"/>
    <xsl:variable name="gpDitaBidiCssFile" as="xs:string" select="$PRM_DITA_BIDI_CSS_FILE"/>
    
    <!-- CSS file path in output directory (relative) -->
    <xsl:param name="PRM_OUTPUT_CSS_PATH_RELATIVE" as="xs:string" required="no" select="''"/>
    <xsl:variable name="gpOutputCssPathRelative" as="xs:string" select="$PRM_OUTPUT_CSS_PATH_RELATIVE"/>
    
    <!-- User Supplied CSS path -->
    <xsl:param name="PRM_USER_CSS_FILE" as="xs:string" select="''"/>
    <xsl:variable name="gpUserCssFile"/>

    <!-- Body Outputclass -->
    <xsl:param name="PRM_BODY_OUTPUTCLASS" as="xs:string" required="no" select="''"/>
    <xsl:variable name="gpBodyOutputClass" as="xs:string" select="$PRM_BODY_OUTPUTCLASS"/>

    <!-- Filter File -->
    <xsl:param name="PRM_FILTER_FILE_URL" as="xs:string" required="no" select="''"/>
    <xsl:variable name="gpFilterFileUrl" as="xs:string" select="$PRM_FILTER_FILE_URL"/>
    <xsl:variable name="glFilterDoc" as="document-node()?" select="if (string($gpFilterFileUrl)) then doc($gpFilterFileUrl) else ()"/>

    <!-- prop elements that have passthrough attribute -->
    <xsl:variable name="glPassThroughAttsProp" as="element()*" select="$glFilterDoc/val/prop[string(@action) eq 'passthrough']"/>

    <!-- Output Extension -->
    <xsl:param name="PRM_OUTPUT_EXTENSION" as="xs:string" required="no" select="'.html'"/>
    <xsl:variable name="gpOutputExtension" as="xs:string" select="$PRM_OUTPUT_EXTENSION"/>

    <!-- Processing File Information Passed From XSLT Task-->
    <xsl:param name="PRM_PROCESSING_FILE_NAME" as="xs:string" required="yes"/>
    <xsl:variable name="gpProcessingFileName" as="xs:string" select="$PRM_PROCESSING_FILE_NAME"/>
    <xsl:param name="PRM_PROCESSING_FILE_DIR" as="xs:string" required="yes"/>
    <xsl:variable name="gpProcessingFileDir" as="xs:string" select="$PRM_PROCESSING_FILE_DIR"/>

    <!-- Map Url
         This parameter will *NOT* referenced in map processing.
     -->
    <xsl:param name="PRM_MAP_URL" as="xs:string" required="yes"/>
    <xsl:variable name="gpMapUrl" as="xs:string" select="$PRM_MAP_URL"/>
    <xsl:variable name="gpMapDoc" as="document-node()?" select="doc($PRM_MAP_URL)"/>
    
    <!-- Make Parent Link (from related-links) -->
    <xsl:param name="PRM_NO_PARENT_LINK" as="xs:string" required="no" select="$cNo"/>
    <xsl:variable name="gpNoParentLink" as="xs:boolean" select="$PRM_NO_PARENT_LINK eq $cNo"/>
    <xsl:variable name="gpMakeParentLink" as="xs:boolean" select="not($gpNoParentLink)"/>
    
    <!-- Output footonote at the end of topic -->
    <xsl:param name="PRM_OUTPUT_FN_AT_END_OF_TOPIC" as="xs:string" required="no" select="$cYes"/>
    <xsl:variable name="gpOutputFnAtEndOfTopic" as="xs:boolean" select="$PRM_OUTPUT_FN_AT_END_OF_TOPIC eq $cYes"/>
    <xsl:variable name="gpOutputFnAtEndOfEachElement" as="xs:boolean" select="$gpOutputFnAtEndOfTopic => not()"/>

    <!-- Output dir URL -->
    <xsl:param name="PRM_OUTPUT_DIR_URL" as="xs:string" required="yes"/>
    <xsl:variable name="gpOutputDirUrl" as="xs:string" select="$PRM_OUTPUT_DIR_URL"/>
    
    <!-- Generating navigation in each topic -->
    <xsl:param name="PRM_NAV_TOC" as="xs:string" required="no" select="'none'"/>
    <xsl:variable name="gpNavToc" as="xs:string" select="$PRM_NAV_TOC"/>
    <xsl:variable name="gpOutputNavTocFull" as="xs:boolean" select="$gpNavToc eq 'full'"/>
    <xsl:variable name="gpOutputNavTocPartial" as="xs:boolean" select="$gpNavToc eq 'partial'"/>
    <xsl:variable name="gpOutputNavTocNone" as="xs:boolean" select="not($gpOutputNavTocFull) and not($gpOutputNavTocPartial)"/>

</xsl:stylesheet>

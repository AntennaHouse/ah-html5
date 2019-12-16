<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Error processing Templates
    **************************************************************
    File Name : dita2html5_error_util.xsl
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
    ===============================================
     Error processing
    ===============================================
    -->
    <!-- 
     function:  Error Exit routine
     param:     prmMes: message body
     return:    none
     note:      none
    -->
    <xsl:template name="errorExit">
    	<xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:message terminate="yes"><xsl:value-of select="'[ERROR]' || $prmMes"/></xsl:message>
    </xsl:template>
    
    <!-- 
     function:  Warning display routine
     param:     prmMes: message body
     return:    none
     note:      none
    -->
    <xsl:template name="warningContinue">
    	<xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:message terminate="no"><xsl:value-of select="'[WARNING]' || $prmMes"/></xsl:message>
    </xsl:template>
    
    <!-- 
     function:  Message generation
     param:     prmMes: message body
                prmSrc: Replacement source
                prmDst: Replacement destination
     return:    xs:string
     note:      for xsl:assert, xsl:message instruction
    -->
    <xsl:function name="ahf:genErrMsg" as="xs:string">
        <xsl:param name="prmMes" as="xs:string"/>
        <xsl:param name="prmSrc" as="xs:string*"/>
        <xsl:param name="prmDst" as="xs:string*"/>
        <xsl:sequence select="'[ERROR]' || ahf:replace($prmMes,$prmSrc,$prmDst)"/>        
    </xsl:function>

    <xsl:function name="ahf:genWarnMsg" as="xs:string">
        <xsl:param name="prmMes" as="xs:string"/>
        <xsl:param name="prmSrc" as="xs:string*"/>
        <xsl:param name="prmDst" as="xs:string*"/>
        <xsl:sequence select="'[WARNING]' || ahf:replace($prmMes,$prmSrc,$prmDst)"/>        
    </xsl:function>

    <xsl:function name="ahf:genInfoMsg" as="xs:string">
        <xsl:param name="prmMes" as="xs:string"/>
        <xsl:param name="prmSrc" as="xs:string*"/>
        <xsl:param name="prmDst" as="xs:string*"/>
        <xsl:sequence select="'[INFO]' || ahf:replace($prmMes,$prmSrc,$prmDst)"/>        
    </xsl:function>

    <!-- end of stylesheet -->
</xsl:stylesheet>

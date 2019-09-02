<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Software Domain Element Templates
    **************************************************************
    File Name : dita2html5_software_domain_element.xsl
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
    function:   msgph template
    param:      none
    return:     samp
    note:              
    -->
    <xsl:template match="*[contains-token(@class,'sw-d/msgph')]" priority="5">
        <samp>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </samp>
    </xsl:template>
    
    <!--
    function:   msgblock template
    param:      none
    return:     div
    note:       same as <pre>       
    -->
    <xsl:template match="*[contains-token(@class,'sw-d/msgblock')]" priority="5">
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!--
    function:   msgnum template
    param:      none
    return:     span
    note:       same as <keyword>       
    -->
    <xsl:template match="*[contains-token(@class,'sw-d/msgnum')]" priority="5">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--
    function:   cmdname template
    param:      none
    return:     span
    note:       same as <keyword>       
    -->
    <xsl:template match="*[contains-token(@class,'sw-d/cmdname')]" priority="5">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!--
    function:   varname template
    param:      none
    return:     var
    note:              
    -->
    <xsl:template match="*[contains-token(@class,'sw-d/cmdname')]" priority="5">
        <var>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </var>
    </xsl:template>

    <!--
    function:   filepath template
    param:      none
    return:     span
    note:       same as <ph>          
    -->
    <xsl:template match="*[contains-token(@class,'sw-d/filepath')]" priority="5">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--
    function:   userinput template
    param:      none
    return:     kbd
    note:                 
    -->
    <xsl:template match="*[contains-token(@class,'sw-d/userinput')]" priority="5">
        <kbd>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </kbd>
    </xsl:template>
    
    <!--
    function:   systemoutput template
    param:      none
    return:     samp
    note:                 
    -->
    <xsl:template match="*[contains-token(@class,'sw-d/systemoutput')]" priority="5">
        <samp>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </samp>
    </xsl:template>
    
</xsl:stylesheet>
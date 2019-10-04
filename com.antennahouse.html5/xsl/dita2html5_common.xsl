<?xml version='1.0' encoding="UTF-8" ?>
<!--
    ****************************************************************
    DITA to HTML5 Stylesheet
    Module: Common templates
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
     xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
     xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
     exclude-result-prefixes="xs ahf" 
    >
    <!-- =======================
          Debug templates
         =======================
     -->
    
    <!-- 
     function:  General template for debug
     param:     none	    
     return:    debug message
     note:		
     -->
    <xsl:template match="*" priority="-3">
        <xsl:call-template name="warningContinue">
            <xsl:with-param name="prmMes"
             select="ahf:replace($stMes001,('%elem','%file'),(name(.),string(@xtrf)))"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- ========================
          Get contenst as inline
         ========================
     -->
    <!-- 
     function:  Get target contents copy as inline
     param:     none
     return:    fo:inline
     note:      ** DOES NOT GENERATE @id & PROCESS INDEXTERM. **
     -->
    <xsl:template match="*" mode="MODE_GET_CONTENTS">
        <fo:inline>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmApplyDefaultFrameAtt" select="false()"/>
            </xsl:call-template>
            <xsl:for-each select="child::node()">
                <xsl:variable name="node" as="node()" select="."/>
                <xsl:choose>
                    <xsl:when test="$node instance of element()">
                        <xsl:choose>
                            <xsl:when test="ahf:isInlineElement($node treat as element())">
                                <xsl:apply-templates select="$node">
                                    <xsl:with-param name="prmTopicRef" tunnel="yes" select="()"/>
                                    <xsl:with-param name="prmWithNoId" tunnel="yes" select="true()"/>
                                    <xsl:with-param name="prmGetContent" tunnel="yes" select="true()"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:when test="ahf:isIgnorebleElement($node treat as element())">
                                <xsl:sequence select="()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Possible non-inline element -->
                                <xsl:apply-templates select="$node" mode="#current"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$node instance of text()">
                        <xsl:copy-of select="$node"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </fo:inline>
    </xsl:template>
    
    <xsl:template match="text()" mode="MODE_GET_CONTENTS">
        <xsl:value-of select="."/>
    </xsl:template>
    
</xsl:stylesheet>

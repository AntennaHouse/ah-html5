<?xml version="1.0" encoding="UTF-8" ?>
<!--
    ****************************************************************
    DITA to HTML5 Stylesheet
    Module: Stylesheet for getting variable & style.
    Copyright © 2009-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL    : http://www.antennahouse.com/
    E-mail : info@antennahouse.com
    ****************************************************************
-->
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:ahp="http://www.antennahouse.com/names/XSLT/Document/PageControl"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:style="http://www.antennahouse.com/names/XSLT/Document/Layout"
    xmlns:saxon="http://saxon.sf.net/" 
    exclude-result-prefixes="xs style xlink ahf saxon"
    >
    <!--============================================
	     External dependencies:
	     $documentLang (dita2fo_global.xsl)
	     $pPaperSize   (dita2fo_param.xsl)
	     $pOutputType  (dita2fo_param.xsl)
	     $pBrandType   (dita2fo_param.xsl)
	    ============================================-->
    
    <!-- Default parameter
         This value should be specified according to the user customization.
         $defaultDocType: any document type string such as "UM" (User's manual), "IM" (Installation manual)
         $defaultPaperSize: any paper size such as "A4", "B5"
         $defaultOutputType: any output condition such as "print-color", "print-mono", "web"
         $defaultBrandType: any brand identifier such as "own-brand", "oem-a", "oem-b"
     -->
    <xsl:variable name="defaultXmlLang" as="xs:string" select="ahf:nomalizeXmlLang($documentLang)"/>
    <xsl:variable name="defaultDocType" as="xs:string?" select="()"/>
    <xsl:variable name="defaultPaperSize" as="xs:string?" select="()"/>
    <xsl:variable name="defaultOutputType" as="xs:string?" select="()"/>
    <xsl:variable name="defaultBrandType" as="xs:string?" select="()"/>
    
    <!-- root variables -->
    <xsl:variable name="rootXmlLang" as="xs:string" select="$defaultXmlLang"/>

    <!-- 
        ahf:getCurrentXmlLang function
        function: Get current xml:lang as string
        parameter: prmElem
        notes: Refers to $map/@xml:lang when $prmElem belongs topic.
               BugFix: Complement $rootXmlLang when $map/xml:lang is absent.
               2015-09-01 t.makita
     -->
    <xsl:function name="ahf:getCurrentXmlLang" as="xs:string">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="tempXmlLangSeq" as="xs:string+">
            <xsl:choose>
                <xsl:when test="$prmElem/ancestor-or-self::*[contains-token(@class,'topic/topic')]">
                    <xsl:sequence select="$rootXmlLang"/>
                </xsl:when>
                <xsl:when test="empty($map/@xml:lang)">
                    <xsl:sequence select="$rootXmlLang"/>
                </xsl:when>
            </xsl:choose>
            <xsl:for-each select="$prmElem/ancestor-or-self::*/@xml:lang">
                <xsl:sequence select="ahf:nomalizeXmlLang(string(.))"/>    
            </xsl:for-each>
        </xsl:variable>
        <xsl:sequence select="$tempXmlLangSeq[last()]"/>
    </xsl:function>

    <!-- 
         ahf:isXmlLangChanged function
         function: Return true() is xml:lang has been changed from the nearest ancestor xml:lang.
         parameter: prmElem: Current document element.
         notes: BugFix: Complement $rootXmlLang when $map/xml:lang is absent.
                2015-09-01 t.makita
      -->
    <xsl:function name="ahf:isXmlLangChanged" as="xs:boolean">
        <xsl:param name="prmElem" as="element()"/>
        <!--xsl:variable name="curXmlLang" as="xs:string?" select="if (exists($prmElem/@xml:lang)) then ahf:nomalizeXmlLang(string($prmElem/@xml:lang)) else ()"/-->
        <xsl:variable name="ancestorOrSelfXmlLang" as="xs:string+">
            <xsl:choose>
                <xsl:when test="$prmElem/ancestor-or-self::*[contains-token(@class,'topic/topic')]">
                    <xsl:sequence select="$rootXmlLang"/>
                </xsl:when>
                <xsl:when test="empty($map/@xml:lang)">
                    <xsl:sequence select="$rootXmlLang"/>
                </xsl:when>
            </xsl:choose>
            <xsl:for-each select="$prmElem/ancestor-or-self::*/@xml:lang">
                <xsl:sequence select="ahf:nomalizeXmlLang(string(.))"/>
            </xsl:for-each>
        </xsl:variable>
        <!--xsl:message select="'$prmElem=',$prmElem"/>
        <xsl:message select="'$ancestorOrSelfXmlLang=',$ancestorOrSelfXmlLang"/-->
        <xsl:variable name="result" as="xs:boolean">
            <xsl:choose>
                <xsl:when test="count($ancestorOrSelfXmlLang) gt 1">
                    <xsl:sequence select="$ancestorOrSelfXmlLang[last() - 1] ne $ancestorOrSelfXmlLang[last()]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$result"/>
    </xsl:function>

    <!-- 
         ahf:getAncestStyleNames template
         function:  Return ancestor style names from $prmElem.
         parameter: prmElem: Current document elemenmt.
         notes:     Temporary solution ⇒ add document-node() to handle glossentry temporary tree.
      -->
    <xsl:template name="ahf:getAncestorStyleNames" as="xs:string+">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="style" as="xs:string*">
            <xsl:for-each select="$prmElem/ancestor::*|$prmElem/ancestor::document-node()">
                <xsl:apply-templates select="." mode="MODE_GET_STYLE"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:sequence select="$style"/>
        <xsl:if test="$pDebug">
            <xsl:message select="'ahf:getAncestorStyleNames()=',$style"/>
        </xsl:if>
    </xsl:template>

    <!-- 
         ahf:isFontSizeAttr
         function:  Judge the given attribute is font-size
         parameter: prmAttr: attribute()?
         notes:     
      -->
    <xsl:function name="ahf:isFontSizeAttr" as="xs:boolean">
        <xsl:param name="prmAttr" as="attribute()?"/>
        <xsl:choose>
            <xsl:when test="empty($prmAttr)">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="name($prmAttr) eq 'font-size'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
         ahf:isRelativeFontSizeAttr
         function:  Judge the given attribute is relative font-size
         parameter: prmAttr: attribute()?
         notes:     See font-size definition on XSL1.1
                    https://www.w3.org/TR/xsl11/#font-size
                    Support DITA-OT 2.x and 3.x both.
      -->
    <xsl:function name="ahf:isRelativeFontSizeAttr" as="xs:boolean">
        <xsl:param name="prmAttr" as="attribute()?"/>
        <xsl:variable name="attVal" as="xs:string" select="string($prmAttr)"/>
        <xsl:choose>
            <xsl:when test="empty($prmAttr)">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:when test="name($prmAttr) ne 'font-size'">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:when test="matches($attVal,'larger|smaller|\d+(\.\d+)?em|\d+(\.\d+)?%')" use-when="starts-with(system-property('ot.version'),'2') or starts-with(system-property('ot.version'),'1')">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="matches($attVal,'larger|smaller|\d+(?:\.\d+)?em|\d+(?:\.\d+)?%')" use-when="not(starts-with(system-property('ot.version'),'2') or starts-with(system-property('ot.version'),'1'))">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="ahf:isAbsoluteFontSizeAttr" as="xs:boolean">
        <xsl:param name="prmAttr" as="attribute()?"/>
        <xsl:choose>
            <xsl:when test="empty($prmAttr)">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="not(ahf:isRelativeFontSizeAttr($prmAttr))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
         ahf:filterAttrs function
         function: Return attribute filtered by $prmFilter.
         parameter: prmAtts: attribute()*
                    prmFilter: xs:string+ filter attribute name
         notes: 
      -->
    <xsl:function name="ahf:filterAttrs" as="attribute()*">
        <xsl:param name="prmAttrs" as="attribute()*"/>
        <xsl:param name="prmFilter" as="xs:string+"/>
        <xsl:for-each select="$prmAttrs">
            <xsl:variable name="att" as="attribute()" select="."/>
            <xsl:if test="name($att) = $prmFilter">
                <xsl:sequence select="$att"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>

    <!-- 
         getAttributeSet template
         function: Get attribute-set specified by $prmAttrSetName.
         parameter: prmAttrSetName: Attributeset name (Can be specified multiple names by delimiting using white-space.
         notes:     $glStyleDefs/* has @xml:lang attributes certainly.
                    ahf:getAttributeSet is used to get style in context free mode and use $map/@xml:lang for $prmXmlLang
                    parameter.
      -->
    <xsl:function name="ahf:getAttributeSet" as="attribute()*">
        <xsl:param name="prmAttrSetname" as="xs:string"/>
        <xsl:call-template name="getAttributeSet">
            <xsl:with-param name="prmAttrSetName" select="$prmAttrSetname"/>
        </xsl:call-template>
    </xsl:function>
        
    <xsl:template name="getAttributeSet" as="attribute()*">
        <xsl:param name="prmAttrSetName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="normalizedAtrSetName" select="normalize-space($prmAttrSetName)"/>
        <xsl:for-each select="tokenize($normalizedAtrSetName, '[\s]+')">
            <xsl:variable name="attrSetName" select="string(.)"/>
            <xsl:variable name="attrSetElements" as="element()*" select="$glStyleDefs/*[string(@name) eq $attrSetName][string(@xml:lang) eq string($prmXmlLang)]"/>
            <xsl:if test="empty ($attrSetElements)">
                <xsl:call-template name="errorExit">
                    <xsl:with-param name="prmMes">
                        <xsl:value-of select="ahf:replace($stMes005,('%attrsetname','%file'),($attrSetName,$allStyleDefFile))"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <!-- Get attribute from looser condition. 
                 Attributes are returned from first to last.
                 If there is N'th conditions, there are 2**N th patterns are needed.
             -->
            <!-- Matches only xml:lang -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[empty(@doc-type)]
                                                           [empty(@paper-size)]
                                                           [empty(@output-type)]
                                                           [empty(@brand-type)]
                                                           "/>
            </xsl:call-template>
            <!-- Matches only doc-type (1-1) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                                                           [exists(@doc-type)]
                                                           [empty(@paper-size)]
                                                           [empty(@output-type)]
                                                           [empty(@brand-type)]
                                                           "/>
            </xsl:call-template>
            <!-- Matches only paper-size (1-2) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                    			select="$attrSetElements[empty(@doc-type)]
                    			                           [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
									                       [exists(@paper-size)]
									                       [empty(@output-type)]
									                       [empty(@brand-type)]
									                       "/>
            </xsl:call-template>
            <!-- Matches only output-type (1-3) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[empty(@doc-type)]
                                                           [empty(@paper-size)]
                                                           [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                                                           [exists(@output-type)]
                                                           [empty(@brand-type)]
                                                           "/>
            </xsl:call-template>
            <!-- Matches only brand-type (1-4) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[empty(@doc-type)]
                                                            [empty(@paper-size)]
                                                            [empty(@output-type)]
                                                            [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                                                            [exists(@brand-type)]
                                                            "/>
            </xsl:call-template>
            <!-- Matches doc-type and paper-size (2-1) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                                                           [exists(@doc-type)]
                                                           [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                                                           [exists(@paper-size)]
                                                           [empty(@output-type)]
                                                           [empty(@brand-type)]
                                                           "/>
            </xsl:call-template>
            <!-- Matches doc-type and output-type (2-2) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                                                           [exists(@doc-type)]
                                                           [empty(@paper-size)]
                                                           [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                                                           [exists(@output-type)]
                                                           [empty(@brand-type)]
                                                           "/>
            </xsl:call-template>
            <!-- Matches doc-type and brand-type (2-3) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                                                            [exists(@doc-type)]
                                                            [empty(@paper-size)]
                                                            [empty(@output-type)]
                                                            [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                                                            [exists(@brand-type)]
                                                            "/>
            </xsl:call-template>
            <!-- Matches paper-size and output-type (2-4) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[empty(@doc-type)]
                                                           [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                                                           [exists(@paper-size)]
                                                           [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                                                           [exists(@output-type)]
                                                           [empty(@brand-type)]
                                                           "/>
            </xsl:call-template>
            <!-- Matches paper-size and brand-type (2-5) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[empty(@doc-type)]
                                                            [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                                                            [exists(@paper-size)]
                                                            [empty(@output-type)]
                                                            [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                                                            [exists(@brand-type)]
                                                            "/>
            </xsl:call-template>
            <!-- Matches output-type and brand-type (2-6) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[empty(@doc-type)]
                                                            [empty(@paper-size)]
                                                            [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                                                            [exists(@output-type)]
                                                            [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                                                            [exists(@brand-type)]
                                                            "/>
            </xsl:call-template>
            <!-- Matches doc-type, paper-size and output-type (3-1) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                                                           [exists(@doc-type)]
                                                           [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                                                           [exists(@paper-size)]
                                                           [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                                                           [exists(@output-type)]
                                                           [empty(@brand-type)]
                                                           "/>
            </xsl:call-template>
            <!-- Matches doc-type, paper-size and brand-type (3-2) -->
            <xsl:call-template name="getAttributeInner">
                   <xsl:with-param name="prmAttrSetElement" 
                                   select="$attrSetElements[ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                                                           [exists(@doc-type)]
                                                           [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                                                           [exists(@paper-size)]
                                                           [empty(@output-type)]
                                                           [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                                                           [exists(@brand-type)]
                                                           "/>
            </xsl:call-template>
            <!-- Matches doc-type, output-type and brand-type (3-3) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                                                            [exists(@doc-type)]
                                                            [empty(@paper-size)]
                                                            [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                                                            [exists(@output-type)]
                                                            [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                                                            [exists(@brand-type)]
                                                            "/>
            </xsl:call-template>
            <!-- Matches paper-size, output-type and brand-type (3-4) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                select="$attrSetElements[empty(@doc-type)]
                                                            [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                                                            [exists(@paper-size)]
                                                            [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                                                            [exists(@output-type)]
                                                            [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                                                            [exists(@brand-type)]
                                                            "/>
            </xsl:call-template>
            <!-- Matches doc-type, paper-size, output-type and brand-type (4) -->
            <xsl:call-template name="getAttributeInner">
                <xsl:with-param name="prmAttrSetElement" 
                                    select="$attrSetElements[ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                                                            [exists(@doc-type)]
                                                            [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                                                            [exists(@paper-size)]
                                                            [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                                                            [exists(@output-type)]
                                                            [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                                                            [exists(@brand-type)]
                                                            "/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- 
         getAttributeInner template
         function: return attribute()* from $prmAttrSetElem
         parameter: prmAttrSetElem: Childlen of $glStyleDefs
         notes: 
      -->
    <xsl:template name="getAttributeInner" as="attribute()*">
        <xsl:param name="prmAttrSetElement" as="element()*"/>
        <xsl:for-each select="$prmAttrSetElement">
            <xsl:for-each select="./*[1]/@*">
                <xsl:attribute name="{name()}" select="string(.)"/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 
         getAttributeSet template
         function: Get attribute-set specified by $prmAttrSetName.
         parameter: prmAttrSetName: Attributeset name (Can be specified multiple names by delimiting using white-space.
         notes:     $glStyleDefs/* has @xml:lang attributes certainly.
                    ahf:getAttributeSet is used to get style in context free mode and use $map/@xml:lang for $prmXmlLang
                    parameter.
      -->
    <xsl:function name="ahf:getAttributeSetAsCssStyle" as="attribute()*">
        <xsl:param name="prmAttrSetname" as="xs:string"/>
        <xsl:call-template name="getAttributeSetAsCssStyle">
            <xsl:with-param name="prmAttrSetName" select="$prmAttrSetname"/>
        </xsl:call-template>
    </xsl:function>
    
    <xsl:template name="getAttributeSetAsCssStyle" as="attribute()*">
        <xsl:param name="prmAttrSetName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="attributes" as="attribute()*">
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="$prmAttrSetName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="dummy" as="element()">
            <dummy>
                <xsl:copy-of select="$attributes"/>
            </dummy>
        </xsl:variable>
        
        <xsl:variable name="cssStr" as="xs:string" select="ahf:attributeToCss($dummy/@*)"/>

        <xsl:if test="string($cssStr)">
            <xsl:attribute name="style" select="$cssStr"/>
        </xsl:if>
    </xsl:template>

    <!-- 
         attributeSetToCss function
         function: Convert attributes to CSS notation
         parameter: prmAttributes: attribute()*
         note: This function does not handle axf namespace attributes
               because it is intended for instream object.
    -->
    <xsl:function name="ahf:attributeToCss" as="xs:string">
        <xsl:param name="prmAttributes" as="attribute()*"/>
        
        <xsl:variable name="first" select="subsequence($prmAttributes,1,1)" as="attribute()*"/>
        <xsl:variable name="restString" select="if (empty(subsequence($prmAttributes,2))) then '' else  (ahf:attributeToCss(subsequence($prmAttributes,2)))" as="xs:string"/>
        
        <xsl:variable name="firstString">
            <xsl:choose>
                <xsl:when test="empty($first)">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="name" select="name($first)"/>
                    <xsl:variable name="value" select="string($first)"/>
                    <xsl:value-of select="$name"/>
                    <xsl:text>:</xsl:text>
                    <xsl:value-of select="$value"/>
                    <xsl:text>;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="concat($firstString, $restString)"/>
    </xsl:function>

    <!-- 
         getAttributeSetReplacing template
         function: Get attributes specified by $prmAttrSetName replacing $prmSrc by $prmDst.
         parameter: prmAttrSetName: attribute-set name (space delimitored)
                    prmSrc: source string 
                    prmDst: destination string
         note: The count of $prmSrc and $prmDst must be the same.
               Example:
               Define following attribute.
               <attribute name="top">$index_1_top + $index_1_height + (0.7mm * %n) + ($index_2_height * (%n - 1))</attribute>
               Call this template:
               <xsl:call-template name="getAttributeSetReplacing">
                 <xsl:with-param name="prmAttrSetName" select="'...'"/>
                 <xsl:with-param name="prmSrc" select="('%n')"/>
                 <xsl:with-param name="prmDst" select="('1')"/>
               </xsl:call-template>
              This will result following attribute
              <xsl:attribute name="height">$index_1_top + $index_1_height + (0.7mm * 1) + ($index_2_height * (1 - 1))</xsl:attribute>
              $index_1_top,$index_1_height,$index_2_height will be replaced by the actual variable value.
      -->
    <xsl:function name="ahf:getAttributeSetReplacing" as="attribute()*">
        <xsl:param name="prmAttrSetName" as="xs:string"/>
        <xsl:param name="prmSrc" as="xs:string+"/>
        <xsl:param name="prmDst" as="xs:string+"/>
        <xsl:call-template name="getAttributeSetReplacing">
            <xsl:with-param name="prmAttrSetName" select="$prmAttrSetName"/>
            <xsl:with-param name="prmSrc" select="$prmSrc"/>
            <xsl:with-param name="prmDst" select="$prmDst"/>
        </xsl:call-template>
    </xsl:function>
    
    <xsl:template name="getAttributeSetReplacing" as="attribute()*">
        <xsl:param name="prmAttrSetName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        <xsl:param name="prmSrc" as="xs:string+" required="yes"/>
        <xsl:param name="prmDst" as="xs:string+" required="yes"/>
        
        <xsl:variable name="attrs" as="attribute()*">
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="$prmAttrSetName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:for-each select="$attrs">
            <xsl:variable name="att" as="attribute()" select="."/>
            <xsl:attribute name="{name($att)}">
                <xsl:value-of select="ahf:replace(string($att),$prmSrc,$prmDst)"/>
            </xsl:attribute>
        </xsl:for-each>
        
    </xsl:template>

    <!-- 
         getAttribute template
         function: Get attribute specified by $prmAttrName from attribute-set specified by $prmAttrSetName.
         parameter：prmAttrSetName：An attribute name
                    prmAttrName：Attribute name
         note: You can specify multiple attribute name in $prmAttrName delimiting by white-space.
      -->
    <xsl:function name="ahf:getAttribute" as="attribute()?">
        <xsl:param name="prmAttrSetName" as="xs:string"/>
        <xsl:param name="prmAttrName" as="xs:string+"/>
        <xsl:call-template name="getAttribute">
            <xsl:with-param name="prmAttrSetName" select="$prmAttrSetName"/>
            <xsl:with-param name="prmAttrName" select="$prmAttrName"/>
        </xsl:call-template>
        
    </xsl:function>

    <xsl:template name="getAttribute" as="attribute()*">
        <xsl:param name="prmAttrSetName" as="xs:string" required="yes"/>
        <xsl:param name="prmAttrName" as="xs:string+" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="attrs" as="attribute()*">
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="$prmAttrSetName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="normalizedAttrName" select="normalize-space($prmAttrName)"/>
        <xsl:for-each select="tokenize($normalizedAttrName, '[\s]+')">
            <xsl:variable name="attrName" select="string(.)"/>
            <xsl:if test="empty($attrs[name() eq $attrName])">
                <xsl:call-template name="errorExit">
                    <xsl:with-param name="prmMes">
                        <xsl:value-of select="ahf:replace($stMes006,('%attrname','%attrsetname','%file'),($attrName,$prmAttrSetName,$allStyleDefFile))"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:variable name="attr" as="attribute()" select="$attrs[name() eq $attrName][position() eq last()]"/>
            <xsl:attribute name="{name($attr)}" select="string($attr)"/>
            <xsl:if test="$pDebug">
                <xsl:message select="concat('[getAttribute] attribute-name=',name($attr),' value=',string($attr))"/>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <!-- 
         getAttributeAs template
         function: Get attribute specified by $prmAttrName in attribute-set $prmAttrSetName as attribute name $prmAltAttrName.
         parameter：prmAttrSetName: An attribute-set name
                    prmAttrName: An attribute name
                    prmAltAttrName: The alternate attribute name
         note: 
      -->
    <xsl:template name="getAttributeAs" as="attribute()?">
        <xsl:param name="prmAttrSetName" as="xs:string" required="yes"/>
        <xsl:param name="prmAttrName" as="xs:string" required="yes"/>
        <xsl:param name="prmAltAttrName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="attrs" as="attribute()*">
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="$prmAttrSetName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="empty($attrs[name() eq $prmAttrName])">
            <xsl:call-template name="errorExit">
                <xsl:with-param name="prmMes">
                    <xsl:value-of select="ahf:replace($stMes006,('%attrname','%attrsetname','%file'),($prmAttrName,$prmAttrSetName,$allStyleDefFile))"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:variable name="attr" as="attribute()" select="$attrs[name() eq $prmAttrName][position() eq last()]"/>
        <xsl:attribute name="{$prmAltAttrName}" select="string($attr)"/>
        <xsl:if test="$pDebug">
            <xsl:message select="concat('[getAttributeAs]      attribute-name=',$prmAltAttrName,' value=',string($attr))"/>
        </xsl:if>
    </xsl:template>

    <!-- 
         getAttributeValue template
         function: Get attribute value from attribute-set specified by $prmAttrSetName and attribute name specified by $prmAttrName as xs:string．
         parameter: prmAttrSetName: attribute-set name
                    prmAttrName: attribute name
                    prmXmlLang: Language code
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type.
                    prmBrandType: Brand type.
         notes: 
      -->
    <xsl:function name="ahf:getAttributeValue" as="xs:string">
        <xsl:param name="prmAttrSetName" as="xs:string"/>
        <xsl:param name="prmAttrName" as="xs:string"/>
        <xsl:call-template name="getAttributeValue">
            <xsl:with-param name="prmAttrSetName" select="$prmAttrSetName"/>
            <xsl:with-param name="prmAttrName" select="$prmAttrName"/>
        </xsl:call-template>
    </xsl:function>

    <xsl:template name="getAttributeValue" as="xs:string">
        <xsl:param name="prmAttrSetName" as="xs:string" required="yes"/>
        <xsl:param name="prmAttrName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="attrs" as="attribute()*">
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="$prmAttrSetName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="empty($attrs[name() eq $prmAttrName])">
            <xsl:call-template name="errorExit">
                <xsl:with-param name="prmMes">
                    <xsl:value-of select="ahf:replace($stMes007,('%attrname','%attrsetname','%file'),($prmAttrName,$prmAttrSetName,$allStyleDefFile))"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:variable name="attr" select="$attrs[name() eq $prmAttrName][position() eq last()]"/>
        <xsl:sequence select="string($attr)"/>
        <xsl:if test="$pDebug">
            <xsl:message select="concat('[getAttributeValue]   attribute-name=',name($attr),' value=',string($attr))"/>
        </xsl:if>
    </xsl:template>

    <!-- 
         getVarValueWithLang template
         function: Get variable specified by $prmVarName considering $prmElem/@xml:lang as key.
         parameter: prmVarName: An variable name
                    prmElem: The relevant element
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
         note: This template get @xml:lang from $prmElem/ancestor-or-self::* and 
               return the specific variable value associated with @xml:lang.
      -->
    <xsl:template name="getVarValueWithLang" as="xs:string">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmElem" as="element()" required="no" select="."/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="curXmlLang" as="xs:string" select="ahf:getCurrentXmlLang($prmElem)"/>
        <xsl:call-template name="getVarValue">
            <xsl:with-param name="prmVarName" select="$prmVarName"/>
            <xsl:with-param name="prmXmlLang" select="$curXmlLang"/>
            <xsl:with-param name="prmDocType" select="$prmDocType"/>
            <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
            <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
            <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
        </xsl:call-template>
    </xsl:template>    

    <!-- 
         getVarValue template
         function: Get variable value specified by $prmVarName, $prmXmlLang, $prmDocType, $prmPaperSize.
         parameter: prmVarName：Variable name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
         note: 
      -->
    <xsl:function name="ahf:getVarValue" as="xs:string">
        <xsl:param name="prmVarName" as="xs:string"/>
        <xsl:call-template name="getVarValue">
            <xsl:with-param name="prmVarName" select="$prmVarName"/>
        </xsl:call-template>
    </xsl:function>

    <xsl:template name="getVarValue" as="xs:string">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <!--xsl:message select="'[getVarValue] $prmVarName=',$prmVarName"/>
        <xsl:message select="'[getVarValue] $prmXmlLang=',$prmXmlLang"/-->
        <xsl:variable name="vars" as="element()*" select="$glVarDefs/*[string(@name) eq $prmVarName]"/>
        <xsl:if test="empty($vars)">
            <xsl:call-template name="errorExit">
                <xsl:with-param name="prmMes">
                    <xsl:value-of select="ahf:replace($stMes008,('%var','%file'),($prmVarName,$allStyleDefFile))"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:variable name="filteredVars" as="element()+">
            <xsl:call-template name="filterElements">
                <xsl:with-param name="prmTargetElem" select="$vars"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:sequence select="string($filteredVars[last()])"/>
        <xsl:if test="count($vars) gt 1">
            <!--xsl:message select="'$vars=',$vars"/-->
        </xsl:if>
    </xsl:template>

    <!-- 
         getVarValueAsText template
         function: Get variable value specified by $prmVarName, $prmXmlLang, $prmDocType, $prmPaperSize as text()
         parameter: prmVarName：Variable name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
         note: 
      -->
    <xsl:template name="getVarValueAsText" as="text()">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="varValue" as="xs:string">
            <xsl:call-template name="getVarValue">
                <xsl:with-param name="prmVarName" select="$prmVarName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$varValue"/>
    </xsl:template>

    <!-- 
         getVarValueWithLangAsText template
         function: Get variable as text() specified by $prmVarName considering $prmElem/@xml:lang as key.
         parameter: prmVarName: An variable name
                    prmElem: The relevant element
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
         note: 
      -->
    <xsl:template name="getVarValueWithLangAsText" as="text()">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmElem" as="element()" required="no" select="."/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="curXmlLang" as="xs:string" select="ahf:getCurrentXmlLang($prmElem)"/>
        <xsl:variable name="varValue" as="xs:string">
            <xsl:call-template name="getVarValue">
                <xsl:with-param name="prmVarName" select="$prmVarName"/>
                <xsl:with-param name="prmXmlLang" select="$curXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$varValue"/>
    </xsl:template>

    <!-- 
         getVarValueAsDouble template
         function: Get variable value specified by $prmVarName, $prmXmlLang, $prmDocType, $prmPaperSize as xs:double
         parameter: prmVarName：Variable name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
         note: 
      -->
    <xsl:template name="getVarValueAsDouble" as="xs:double">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="varValue" as="xs:string">
            <xsl:call-template name="getVarValue">
                <xsl:with-param name="prmVarName" select="$prmVarName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$varValue castable as xs:double">
                <xsl:sequence select="xs:double($varValue)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="errorExit">
                    <xsl:with-param name="prmMes" select="ahf:replace($stMes010,('%var','%value','%file'),($prmVarName,$varValue,$allStyleDefFile))"/>
                </xsl:call-template>
                <xsl:sequence select="xs:double(0)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getVarValueWithLangAsDouble" as="xs:double">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmElem" as="element()" required="no" select="."/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="curXmlLang" as="xs:string" select="ahf:getCurrentXmlLang($prmElem)"/>
        <xsl:variable name="varValueAsDouble" as="xs:double">
            <xsl:call-template name="getVarValueAsDouble">
                <xsl:with-param name="prmVarName" select="$prmVarName"/>
                <xsl:with-param name="prmXmlLang" select="$curXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:sequence select="$varValueAsDouble"/>
    </xsl:template>
    

    <!-- 
         getVarValueAsInteger template
         function: Get variable value specified by $prmVarName, $prmXmlLang, $prmDocType, $prmPaperSize as xs:integer
         parameter: prmVarName：Variable name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
         note: 
      -->
    <xsl:function name="ahf:getVarValueAsInteger" as="xs:integer">
        <xsl:param name="prmVarName" as="xs:string"/>
        <xsl:call-template name="getVarValueAsInteger">
            <xsl:with-param name="prmVarName" select="$prmVarName"/>
        </xsl:call-template>
    </xsl:function>

    <xsl:template name="getVarValueAsInteger" as="xs:integer">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="varValue" as="xs:string">
            <xsl:call-template name="getVarValue">
                <xsl:with-param name="prmVarName" select="$prmVarName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$defaultBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$varValue castable as xs:integer">
                <xsl:sequence select="xs:integer($varValue)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="errorExit">
                    <xsl:with-param name="prmMes" select="ahf:replace($stMes012,('%var','%value','%file'),($prmVarName,$varValue,$allStyleDefFile))"/>
                </xsl:call-template>
                <xsl:sequence select="xs:integer(0)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
         getVarValueAsStringSequence template
         function: Get variable value specified by $prmVarName, $prmXmlLang, $prmDocType, $prmPaperSize as xs:string*
         parameter: prmVarName：Variable name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
                    prmDelim: Delimiter character
         note: 
    -->
    <xsl:function name="ahf:getVarValueAsStringSequence" as="xs:string*">
        <xsl:param name="prmVarName" as="xs:string"/>
        
        <xsl:call-template name="getVarValueAsStringSequence">
            <xsl:with-param name="prmVarName" select="$prmVarName"/>
        </xsl:call-template>
    </xsl:function>
    
    <xsl:template name="getVarValueWithLangAsStringSequence" as="xs:string*">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmElem" as="element()" required="no" select="."/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="curXmlLang" as="xs:string" select="ahf:getCurrentXmlLang($prmElem)"/>
        <xsl:call-template name="getVarValueAsStringSequence">
            <xsl:with-param name="prmVarName" select="$prmVarName"/>
            <xsl:with-param name="prmXmlLang" select="$curXmlLang"/>
            <xsl:with-param name="prmDocType" select="$prmDocType"/>
            <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
            <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
            <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="getVarValueAsStringSequence" as="xs:string*">
        <xsl:param name="prmVarName" required="yes" as="xs:string"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        <xsl:param name="prmDelim" as="xs:string" required="no" select="','"/>

        <xsl:variable name="stringAndDelim" as="xs:string+">
            <xsl:call-template name="getVarValueWithDelim">
                <xsl:with-param name="prmVarName" select="$prmVarName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="stringValue" as="xs:string" select="$stringAndDelim[1]"/>
        <xsl:variable name="delim" as="xs:string" select="$stringAndDelim[2]"/>
        <xsl:variable name="tempDelim" as="xs:string" select="if (string(normalize-space($delim))) then $delim else $prmDelim"/>
        <xsl:for-each select="tokenize($stringValue,$tempDelim)">
            <xsl:variable name="token" as="xs:string" select="."/>
            <xsl:choose>
                <xsl:when test="not(string($token))"/>
                <xsl:otherwise>
                    <xsl:sequence select="$token"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>    

    <xsl:template name="getVarValueWithDelim" as="xs:string+">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="vars" as="element()*" select="$glVarDefs/*[string(@name) eq $prmVarName]"/>
        <xsl:if test="empty($vars)">
            <xsl:call-template name="errorExit">
                <xsl:with-param name="prmMes">
                    <xsl:value-of select="ahf:replace($stMes008,('%var','%file'),($prmVarName,$allStyleDefFile))"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:variable name="filteredVars" as="element()+">
            <xsl:call-template name="filterElements">
                <xsl:with-param name="prmTargetElem" select="$vars"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:sequence select="string($filteredVars[last()])"/>
        <xsl:sequence select="string($filteredVars[last()]/@delim)"/>
    </xsl:template>

    <!-- 
         getVarValueAsBoolean template
         function: Get variable value specified by $prmVarName as xs:boolean
         parameter: prmVarName：Variable name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
                    prmDelim: Delimiter character
         note: 
    -->
    <xsl:function name="ahf:getVarValueAsBoolean" as="xs:boolean">
        <xsl:param name="prmVarName" as="xs:string"/>
        
        <xsl:call-template name="getVarValueAsBoolean">
            <xsl:with-param name="prmVarName" select="$prmVarName"/>
        </xsl:call-template>
    </xsl:function>

    <xsl:template name="getVarValueWithLangAsBoolean" as="xs:boolean">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmElem" as="element()" required="no" select="."/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="curXmlLang" as="xs:string" select="ahf:getCurrentXmlLang($prmElem)"/>
        
        <xsl:variable name="varValue" as="xs:boolean">
            <xsl:call-template name="getVarValueAsBoolean">
                <xsl:with-param name="prmVarName" select="$prmVarName"/>
                <xsl:with-param name="prmXmlLang" select="$curXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:sequence select="$varValue"/>
    </xsl:template>

    <xsl:template name="getVarValueAsBoolean" as="xs:boolean">
        <xsl:param name="prmVarName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="varValue" as="xs:string">
            <xsl:call-template name="getVarValue">
                <xsl:with-param name="prmVarName" select="$prmVarName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:sequence select="$varValue = ('1','true','yes')"/>
    </xsl:template>

    <!-- 
         enumVariable template
         function: Get series of variable & value pair that satisfies criteria $prmSelectFunc.
         parameter: prmFilterFunc: Function that selects variable.
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output Type
                    prmBrandType: Brand Type
         note: 
      -->
    <xsl:function name="ahf:enumVariable" saxon:as="tuple(name: xs:string, value: xs:string)*">
        <xsl:call-template name="enumVariable"/>
    </xsl:function>
    
    <xsl:template name="enumVariable" saxon:as="tuple(name: xs:string, value: xs:string)*">
        <xsl:param name="prmFilterFunc" as="function(xs:string) as xs:boolean"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="varNames" as="xs:string*" select="$glVarDefs/*/@name ! string(.) => distinct-values()"/>
        <xsl:for-each select="$varNames">
            <xsl:variable name="varName" as="xs:string" select="."/>
            <xsl:if test="$prmFilterFunc($varName)">
                <xsl:variable name="vars" as="element()*" select="$glVarDefs/*[string(@name) eq $varName]"/>
                <xsl:if test="empty($vars)">
                    <xsl:call-template name="errorExit">
                        <xsl:with-param name="prmMes">
                            <xsl:value-of select="ahf:replace($stMes008,('%var','%file'),($varName,$allStyleDefFile))"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:variable name="filteredVars" as="element()+">
                    <xsl:call-template name="filterElements">
                        <xsl:with-param name="prmTargetElem" select="$vars"/>
                        <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                        <xsl:with-param name="prmDocType" select="$prmDocType"/>
                        <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                        <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                        <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="filteredVar" as="element()" select="$filteredVars[last()]"/>
                <xsl:sequence select="map{'name':$filteredVar/@name => string(), 'value':$filteredVar => string()}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- 
         getInstreamObject tempalte
         function: Get instream object specified by $prmObjName as node()*.
         parameter: prmObjName: Object name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
         note: 
      -->
    <xsl:function name="ahf:getInstreamObject" as="node()*">
        <xsl:param name="prmObjName" as="xs:string"/>
        <xsl:call-template name="getInstreamObject">
            <xsl:with-param name="prmObjName" select="$prmObjName"/>
        </xsl:call-template>        
    </xsl:function>

    <xsl:template name="getInstreamObject" as="node()*">
        <xsl:param name="prmObjName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="objects" as="element()*" select="$glInstreamObjects/*[string(@name) eq $prmObjName]"/>
        <xsl:if test="empty($objects)">
            <xsl:call-template name="errorExit">
                <xsl:with-param name="prmMes">
                    <xsl:value-of select="ahf:replace($stMes009,('%objname','%file'),($prmObjName,$allStyleDefFile))"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:variable name="filteredObjects" as="element()+">
            <xsl:call-template name="filterElements">
                <xsl:with-param name="prmTargetElem" select="$objects"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:sequence select="$filteredObjects[last()]/*[1]"/>
    </xsl:template>

    <!-- 
         getInstreamObjectReplacing template
         function: Get instream object specified by $prmObjName as node()* 
                   replacing text node from $prmSrcString by $prmDstString.
         parameter: prmObjName: Object name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
                    prmSrcStr: Source string
                    prmDstStr: Destination string
         note: 
      -->
    <xsl:function name="ahf:getInstreamObjectReplacing" as="node()*">
        <xsl:param name="prmObjName" as="xs:string"/>
        <xsl:param name="prmSrcStr" as="xs:string+"/>
        <xsl:param name="prmDstStr" as="xs:string+"/>
        
        <xsl:call-template name="getInstreamObjectReplacing">
            <xsl:with-param name="prmObjName" as="xs:string" select="$prmObjName"/>
            <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
            <xsl:with-param name="prmDstStr" select="$prmDstStr"/>
        </xsl:call-template> 
    </xsl:function>

    <xsl:template name="getInstreamObjectReplacing" as="node()*">
        <xsl:param name="prmObjName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstStr" as="xs:string+" required="yes"/>

        <xsl:variable name="instreamObject" as="node()*">
            <xsl:call-template name="getInstreamObject">
                <xsl:with-param name="prmObjName" select="$prmObjName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="replacedInstreamObject" as="node()*">
            <xsl:apply-templates select="$instreamObject" mode="GET_INSTREAM_OBJECTS_REPLACING">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstStr" select="$prmDstStr"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:sequence select="$replacedInstreamObject"/>
    </xsl:template>
    
    <xsl:template match="svg:*|mml:*" mode="GET_INSTREAM_OBJECTS_REPLACING">
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstStr" as="xs:string+" required="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstStr" select="$prmDstStr"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="#current">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstStr" select="$prmDstStr"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*" mode="GET_INSTREAM_OBJECTS_REPLACING">
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstStr" as="xs:string+" required="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstStr" select="$prmDstStr"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="#current">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstStr" select="$prmDstStr"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" mode="GET_INSTREAM_OBJECTS_REPLACING">
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstStr" as="xs:string+" required="yes"/>
        <xsl:variable name="text" as="xs:string" select="."/>
        <xsl:choose>
            <xsl:when test="ahf:containsAnyOf($text,$prmSrcStr)">
                <!--xsl:message select="'[text()] ',$text,' contains ',$prmSrcStr"/>
                <xsl:message select="'$prmSrcStr= ',$prmSrcStr"/>
                <xsl:message select="'$prmDstStr= ',$prmDstStr"/>
                <xsl:message select="'ahf:replace($text,$prmSrcStr,$prmDstStr)= ',ahf:replace($text,$prmSrcStr,$prmDstStr)"/-->
                <xsl:value-of select="ahf:replace($text,$prmSrcStr,$prmDstStr)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@*" mode="GET_INSTREAM_OBJECTS_REPLACING">
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstStr" as="xs:string+" required="yes"/>
        <xsl:variable name="attr" as="xs:string" select="string(.)"/>
        <xsl:choose>
            <xsl:when test="ahf:containsAnyOf($attr,$prmSrcStr)">
                <xsl:copy>
                    <xsl:value-of select="ahf:replace($attr,$prmSrcStr,$prmDstStr)"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
         getXmlObject tempalte
         function: Get XML object specified by $prmObjName as node()*.
         parameter: prmObjName: Object name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
         note: 
      -->
    <xsl:function name="ahf:getXmlObject" as="node()*">
        <xsl:param name="prmObjName" as="xs:string"/>
        <xsl:call-template name="getXmlObject">
            <xsl:with-param name="prmObjName" select="$prmObjName"/>
        </xsl:call-template>        
    </xsl:function>
    
    <xsl:template name="getXmlObject" as="node()*">
        <xsl:param name="prmObjName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <xsl:variable name="objects" as="element()*" select="$glXmlObjects/*[string(@name) eq $prmObjName]"/>
        <xsl:if test="empty($objects)">
            <xsl:call-template name="errorExit">
                <xsl:with-param name="prmMes">
                    <xsl:value-of select="ahf:replace($stMes010,('%objname','%file'),($prmObjName,$allStyleDefFile))"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:variable name="filteredObjects" as="element()+">
            <xsl:call-template name="filterElements">
                <xsl:with-param name="prmTargetElem" select="$objects"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="resultSeq" as="node()*" select="$filteredObjects[last()]/node()"/>
        <xsl:apply-templates select="$resultSeq" mode="GET_RESULT"/>
    </xsl:template>

    <xsl:template match="*" mode="GET_RESULT">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="style:*" mode="GET_RESULT">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*" mode="GET_RESULT">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="text()" mode="GET_RESULT">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="processing-instruction()|comment()" mode="GET_RESULT">
        <xsl:copy/>
    </xsl:template>

    <!-- 
         getXmlObjectReplacing template
         function: Get XML object specified by $prmObjName as node()* 
                   replacing text node from $prmSrcString by $prmDstString.
         parameter: prmObjName: Object name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
                    prmSrcStr: Source string
                    prmDstStr: Destination string
         note: 
      -->
    <xsl:function name="ahf:getXmlObjectReplacing" as="node()*">
        <xsl:param name="prmObjName" as="xs:string"/>
        <xsl:param name="prmSrcStr" as="xs:string+"/>
        <xsl:param name="prmDstStr" as="xs:string+"/>
        
        <xsl:call-template name="getXmlObjectReplacing">
            <xsl:with-param name="prmObjName" as="xs:string" select="$prmObjName"/>
            <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
            <xsl:with-param name="prmDstStr" select="$prmDstStr"/>
        </xsl:call-template> 
    </xsl:function>
    
    <xsl:template name="getXmlObjectReplacing" as="node()*">
        <xsl:param name="prmObjName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstStr" as="xs:string+" required="yes"/>
        
        <xsl:variable name="xmlObject" as="node()*">
            <xsl:call-template name="getXmlObject">
                <xsl:with-param name="prmObjName" select="$prmObjName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="replacedXmlObject" as="node()*">
            <xsl:apply-templates select="$xmlObject" mode="GET_XML_OBJECTS_REPLACING">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstStr" select="$prmDstStr"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:sequence select="$replacedXmlObject"/>
    </xsl:template>
    
    <xsl:template match="*" mode="GET_XML_OBJECTS_REPLACING">
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstStr" as="xs:string+" required="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstStr" select="$prmDstStr"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="#current">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstStr" select="$prmDstStr"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" mode="GET_XML_OBJECTS_REPLACING">
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstStr" as="xs:string+" required="yes"/>
        <xsl:variable name="text" as="xs:string" select="."/>
        <xsl:choose>
            <xsl:when test="ahf:containsAnyOf($text,$prmSrcStr)">
                <xsl:value-of select="ahf:replace($text,$prmSrcStr,$prmDstStr)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@*" mode="GET_XML_OBJECTS_REPLACING">
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstStr" as="xs:string+" required="yes"/>
        <xsl:variable name="attr" as="xs:string" select="string(.)"/>
        <xsl:choose>
            <xsl:when test="ahf:containsAnyOf($attr,$prmSrcStr)">
                <xsl:attribute name="{name(.)}" select="ahf:replace($attr,$prmSrcStr,$prmDstStr)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{name(.)}" select="$attr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
         getXmlObjectReplacingNode template
         function: Get formatting object specified by $prmObjName as node()* 
                   replacing text node from $prmSrcString by $prmDstNode.
         parameter: prmObjName: Object name
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
                    prmSrcStr: Source string
                    prmDstNode: Destination node stored under the each element
         note: 
      -->
    <xsl:function name="ahf:getXmlObjectReplacingNode" as="node()*">
        <xsl:param name="prmObjName" as="xs:string"/>
        <xsl:param name="prmSrcStr" as="xs:string+"/>
        <xsl:param name="prmDstNode" as="element()+"/>
        
        <xsl:call-template name="getXmlObjectReplacingNode">
            <xsl:with-param name="prmObjName" as="xs:string" select="$prmObjName"/>
            <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
            <xsl:with-param name="prmDstNode" select="$prmDstNode"/>
        </xsl:call-template> 
    </xsl:function>
    
    <xsl:template name="getXmlObjectReplacingNode" as="node()*">
        <xsl:param name="prmObjName" as="xs:string" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstNode" as="element()+" required="yes"/>
        
        <xsl:variable name="xmlObject" as="node()*">
            <xsl:call-template name="getXmlObject">
                <xsl:with-param name="prmObjName" select="$prmObjName"/>
                <xsl:with-param name="prmXmlLang" select="$prmXmlLang"/>
                <xsl:with-param name="prmDocType" select="$prmDocType"/>
                <xsl:with-param name="prmPaperSize" select="$prmPaperSize"/>
                <xsl:with-param name="prmOutputType" select="$prmOutputType"/>
                <xsl:with-param name="prmBrandType" select="$prmBrandType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="replacedXmlObject" as="node()*">
            <xsl:apply-templates select="$xmlObject" mode="GET_XML_OBJECTS_REPLACING_NODE">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstNode" select="$prmDstNode"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:sequence select="$replacedXmlObject"/>
    </xsl:template>
    
    <xsl:template match="*" mode="GET_XML_OBJECTS_REPLACING_NODE">
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstNode" as="element()+" required="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstNode" select="$prmDstNode"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="#current">
                <xsl:with-param name="prmSrcStr" select="$prmSrcStr"/>
                <xsl:with-param name="prmDstNode" select="$prmDstNode"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" mode="GET_XML_OBJECTS_REPLACING_NODE">
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstNode" as="element()+" required="yes"/>
        <xsl:variable name="text" as="xs:string" select="."/>
        <xsl:variable name="index" as="xs:integer?" select="index-of($prmSrcStr,$text)[1]"/>
        <xsl:choose>
            <xsl:when test="exists($index)">
                <xsl:copy-of select="$prmDstNode[$index]/node()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*" mode="GET_XML_OBJECTS_REPLACING_NODE">
        <xsl:param name="prmSrcStr" as="xs:string+" required="yes"/>
        <xsl:param name="prmDstNode" as="element()+" required="yes"/>
        <xsl:variable name="attr" as="xs:string" select="string(.)"/>
        <xsl:variable name="index" as="xs:integer?" select="index-of($prmSrcStr,$attr)[1]"/>
        <xsl:choose>
            <xsl:when test="exists($index)">
                <xsl:attribute name="{name(.)}" select="string($prmDstNode[$index])"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{name(.)}" select="$attr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

    <!-- 
         filterElements template
         function： Apply filtering to the element specified by $prmTargetElem using parameter $prmXmlLang,$prmDocType,$prmPaperSize.
         parameter: prmTargetElems：Target element（attribute-set,variable,etc)
                    prmXmlLang: Target xml:lang
                    prmDocType: Document type
                    prmPaperSize: Paper size
                    prmOutputType: Output type
                    prmBrandType: Brand type
         note: 
      -->
    <xsl:template name="filterElements" as="element()*">
        <xsl:param name="prmTargetElem" as="element()*" required="yes"/>
        <xsl:param name="prmXmlLang" as="xs:string?" required="no" select="$defaultXmlLang"/>
        <xsl:param name="prmDocType" as="xs:string?" required="no" select="$defaultDocType"/>
        <xsl:param name="prmPaperSize" as="xs:string?" required="no" select="$defaultPaperSize"/>
        <xsl:param name="prmOutputType" as="xs:string?" required="no" select="$defaultOutputType"/>
        <xsl:param name="prmBrandType" as="xs:string?" required="no" select="$defaultBrandType"/>
        
        <!-- Get variable value from strict condition. 
             If there is N pieces conditions, there are 2**N pieces patterns are needed.
         -->
        <xsl:choose>
            <!-- Matches xml:lang, doc-type, paper-size ,output-type and brand-type (5) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✔), paper-size(✔), output-type(✔), brand-type(✘) (4-1) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✔), paper-size(✔), output-type(✘), brand-type(✔) (4-2) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [empty(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [empty(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✔), paper-size(✘), output-type(✔), brand-type(✔) (4-3) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [empty(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [empty(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✘), paper-size(✔), output-type(✔), brand-type(✔) (4-4) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [empty(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [empty(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✔), paper-size(✔), output-type(✔), brand-type(✔) (4-5) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✔), paper-size(✔), output-type(✘), brand-type(✘) (3-1) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [empty(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [empty(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✔), paper-size(✘), output-type(✔), brand-type(✘) (3-2) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [empty(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [empty(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✔), paper-size(✘), output-type(✘), brand-type(✔) (3-3) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [empty(@paper-size)]
                [empty(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [empty(@paper-size)]
                    [empty(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✘), paper-size(✔), output-type(✔), brand-type(✘) (3-4) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [empty(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [empty(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✘), paper-size(✔), output-type(✘), brand-type(✔) (3-5) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [empty(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [empty(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [empty(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [empty(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✘), paper-size(✘), output-type(✔), brand-type(✔) (3-6) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [empty(@doc-type)]
                [empty(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [empty(@doc-type)]
                    [empty(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✔), paper-size(✔), output-type(✔), brand-type(✘) (3-7) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✔), paper-size(✔), output-type(✘), brand-type(✔) (3-8) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [empty(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [empty(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✔), paper-size(✘), output-type(✔), brand-type(✔) (3-9) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [empty(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [empty(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✘), paper-size(✔), output-type(✔), brand-type(✔) (3-10) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [empty(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [empty(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✔), paper-size(✘), output-type(✘), brand-type(✘) (2-1) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [empty(@paper-size)]
                [empty(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [empty(@paper-size)]
                    [empty(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✘), paper-size(✔), output-type(✘), brand-type(✘) (2-2) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [empty(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [empty(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [empty(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [empty(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✘), paper-size(✘), output-type(✔), brand-type(✘) (2-3) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [empty(@doc-type)]
                [empty(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [empty(@doc-type)]
                    [empty(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✔), doc-type(✘), paper-size(✘), output-type(✘), brand-type(✔) (2-4) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [empty(@doc-type)]
                [empty(@paper-size)]
                [empty(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [empty(@doc-type)]
                    [empty(@paper-size)]
                    [empty(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✔), paper-size(✔), output-type(✘), brand-type(✘) (2-5) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [empty(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [empty(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✔), paper-size(✘), output-type(✔), brand-type(✘) (2-6) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [empty(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [empty(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✔), paper-size(✘), output-type(✘), brand-type(✔) (2-7) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [empty(@paper-size)]
                [empty(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [empty(@paper-size)]
                    [empty(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✘), paper-size(✔), output-type(✔), brand-type(✘) (2-8) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [empty(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [empty(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✘), paper-size(✔), output-type(✘), brand-type(✔) (2-9) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [empty(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [empty(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [empty(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [empty(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang(✘), doc-type(✘), paper-size(✘), output-type(✔), brand-type(✔) (2-10) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [empty(@doc-type)]
                [empty(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [empty(@doc-type)]
                    [empty(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches xml:lang (1-1) -->
            <xsl:when test="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                [exists(@xml:lang)]
                [empty(@doc-type)]
                [empty(@paper-size)]
                [empty(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[ahf:strEqualAsSeq(string(@xml:lang),string($prmXmlLang))]
                    [exists(@xml:lang)]
                    [empty(@doc-type)]
                    [empty(@paper-size)]
                    [empty(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches doc-type (1-2)-->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                [exists(@doc-type)]
                [empty(@paper-size)]
                [empty(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [ahf:strEqualAsSeq(string(@doc-type),string($prmDocType))]
                    [exists(@doc-type)]
                    [empty(@paper-size)]
                    [empty(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches paper-size (1-3)-->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [empty(@doc-type)]
                [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                [exists(@paper-size)]
                [empty(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [empty(@doc-type)]
                    [ahf:strEqualAsSeq(string(@paper-size),string($prmPaperSize))]
                    [exists(@paper-size)]
                    [empty(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches output-type (1-4) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [empty(@doc-type)]
                [empty(@paper-size)]
                [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                [exists(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [empty(@doc-type)]
                    [empty(@paper-size)]
                    [ahf:strEqualAsSeq(string(@output-type),string($prmOutputType))]
                    [exists(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- Matches brand-type (1-5) -->
            <xsl:when test="$prmTargetElem[empty(@xml:lang)]
                [empty(@doc-type)]
                [empty(@paper-size)]
                [empty(@output-type)]
                [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                [exists(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem[empty(@xml:lang)]
                    [empty(@doc-type)]
                    [empty(@paper-size)]
                    [empty(@output-type)]
                    [ahf:strEqualAsSeq(string(@brand-type),string($prmBrandType))]
                    [exists(@brand-type)]
                    "/>
            </xsl:when>
            <!-- reference to language neutral resource -->
            <xsl:when test="$prmTargetElem
                [empty(@xml:lang)]
                [empty(@doc-type)]
                [empty(@paper-size)]
                [empty(@output-type)]
                [empty(@brand-type)]
                ">
                <xsl:sequence select="$prmTargetElem
                    [empty(@xml:lang)]
                    [empty(@doc-type)]
                    [empty(@paper-size)]
                    [empty(@output-type)]
                    [empty(@brand-type)]
                    "/>
            </xsl:when>
            <!-- matches only variable name -->
            <xsl:otherwise>
                <xsl:sequence select="$prmTargetElem"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- end of stylesheet -->
</xsl:stylesheet>

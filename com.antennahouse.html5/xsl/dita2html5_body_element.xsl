<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Body Element Templates
    **************************************************************
    File Name : dita2html5_body_element.xsl
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
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="xs ahf style dita-ot"
    version="3.0">

    <!--
    function:   section template
    param:      none
    return:     section
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/section')]">
        <section>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates select="*[contains-token(@class,'topic/title')]"/>
            <xsl:apply-templates select="node() except *[contains-token(@class,'topic/title')]"/>
        </section>
    </xsl:template>
    
    <!--
    function:   section, example title template
    param:      none
    return:     h[N]
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/section')]/*[contains-token(@class,'topic/title')]|*[contains-token(@class, 'topic/example')]/*[contains-token(@class,'topic/title')]">
        <xsl:variable name="headingLevel" as="xs:integer">
            <xsl:variable name="level" as="xs:integer" select="count(ancestor::*[contains-token(@class, 'topic/topic')]) + 1"/>
            <xsl:sequence select="if ($level gt $cHeadingLevelMax) then $cHeadingLevelMax else $level"/>
        </xsl:variable>
        <xsl:element name="h{$headingLevel}">
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('Section_Title_Class')"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!--
    function:   example template
    param:      none
    return:     div
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/example')]">
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates select="*[contains-token(@class,'topic/title')]"/>
            <xsl:apply-templates select="node() except *[contains-token(@class,'topic/title')]"/>
        </div>
    </xsl:template>

    <!--
    function:   div template
    param:      none
    return:     div
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/div')]">
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!--
    function:   sectiondiv template
    param:      none
    return:     none
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/sectiondiv')]">
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--
    function:   p template
    param:      none
    return:     p or div
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/p')]">
        <xsl:choose>
            <xsl:when test="descendant::*[ahf:isBlockLevelElement(.)] => exists()">
                <div>
                    <xsl:call-template name="genCommonAtts"/>
                    <xsl:call-template name="genIdAtt"/>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:call-template name="genCommonAtts"/>
                    <xsl:call-template name="genIdAtt"/>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   fig template
    param:      none
    return:     figure
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/fig')]">
        <xsl:variable name="figBorder" as="xs:string" select="ahf:getFigBorder(.)"/>
        <figure>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$figBorder"/>
                <xsl:with-param name="prmApplyDefaultFrameAtt" select="false()"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:call-template name="genFigTitle"/>
            <xsl:apply-templates select="node() except (*[contains-token(@class, 'topic/title')]|*[contains-token(@class, 'topic/desc')])"/>
        </figure>
    </xsl:template>
    
    <xsl:variable name="figFrameAll" as="xs:string" select="ahf:getVarValue('Fig_Frame_All')"/>
    <xsl:variable name="figFrameSides" as="xs:string" select="ahf:getVarValue('Fig_Frame_Sides')"/>
    <xsl:variable name="figFrameTop" as="xs:string" select="ahf:getVarValue('Fig_Frame_Top')"/>
    <xsl:variable name="figFrameBottom" as="xs:string" select="ahf:getVarValue('Fig_Frame_Bottom')"/>
    <xsl:variable name="figFrameTopbot" as="xs:string" select="ahf:getVarValue('Fig_Frame_Topbot')"/>
    <xsl:variable name="figFrameNone" as="xs:string" select="ahf:getVarValue('Fig_Frame_None')"/>
    
    <xsl:function name="ahf:getFigBorder" as="xs:string">
        <xsl:param name="prmFig" as="element()"/>
        <xsl:variable name="frame" as="xs:string" select="$prmFig/@frame => string()"/>
        <xsl:choose>
            <xsl:when test="$frame eq 'all'">
                <xsl:sequence select="$figFrameAll"/>
            </xsl:when>
            <xsl:when test="$frame eq 'sides'">
                <xsl:sequence select="$figFrameSides"/>
            </xsl:when>
            <xsl:when test="$frame eq 'top'">
                <xsl:sequence select="$figFrameTop"/>
            </xsl:when>
            <xsl:when test="$frame eq 'bottom'">
                <xsl:sequence select="$figFrameBottom"/>
            </xsl:when>
            <xsl:when test="$frame eq 'topbot'">
                <xsl:sequence select="$figFrameTopbot"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$figFrameNone"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--
    function:   fig title template
    param:      none
    return:     figcaption
    note:              
    -->
    <xsl:template name="genFigTitle">
        <xsl:param name="prmFig" as="element()" required="no" select="."/>
        <xsl:choose>
            <xsl:when test="ahf:hasFigTitle($prmFig)">
                <xsl:variable name="topic" as="element()" select="$prmFig/ancestor::*[contains-token(@class,'topic/topic')][last()]"/>
                <xsl:variable name="figCount" as="xs:integer" select="count($prmFig[ahf:hasFigTitle(.)] | $topic/descendant::*[contains-token(@class, 'topic/fig')][ahf:hasFigTitle(.)][. &lt;&lt; $prmFig])"/>
                <figcaption>
                    <xsl:if test="$prmFig/*[contains-token(@class,'topic/title')]">
                        <xsl:call-template name="genCommonAtts">
                            <xsl:with-param name="prmElement" select="$prmFig/*[contains-token(@class,'topic/title')]"/>
                        </xsl:call-template>
                    </xsl:if>
                    <span>
                        <xsl:call-template name="genCommonAtts">
                            <xsl:with-param name="prmElement" select="$prmFig/*[contains-token(@class,'topic/title')]"/>
                        </xsl:call-template>
                        <xsl:call-template name="getVarValueAsText">
                            <xsl:with-param name="prmVarName" select="'Figure_Title'"/>
                        </xsl:call-template>
                        <xsl:value-of select="$figCount"/>
                        <xsl:text> </xsl:text>
                    </span>
                    <xsl:choose>
                        <xsl:when test="*[contains-token(@class,'topic/title')]">
                            <span>
                                <xsl:apply-templates select="$prmFig/*[contains-token(@class,'topic/title')]/node()"/>
                            </span>
                            <xsl:if test="$prmFig/*[contains-token(@class,'topic/desc')]">
                                <xsl:text>.</xsl:text>
                                <br/>
                                <span>
                                    <xsl:call-template name="genCommonAtts">
                                        <xsl:with-param name="prmElement" select="$prmFig/*[contains-token(@class,'topic/desc')]"/>
                                    </xsl:call-template>
                                    <xsl:apply-templates select="$prmFig/*[contains-token(@class,'topic/desc')]/node()"/>
                                </span>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="*[contains-token(@class,'topic/desc')]">
                            <br/>
                            <span>
                                <xsl:call-template name="genCommonAtts">
                                    <xsl:with-param name="prmElement" select="$prmFig/*[contains-token(@class,'topic/desc')]"/>
                                    <xsl:with-param name="prmDefaultOutputClass" select="'figdesc'"/>
                                </xsl:call-template>
                                <xsl:apply-templates select="$prmFig/*[contains-token(@class,'topic/desc')]/node()"/>
                            </span>
                        </xsl:when>
                    </xsl:choose>
                </figcaption>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
    function:   Return fig has title or desc
    param:      prmFig
    return:     xs:boolean
    note:              
    -->
    <xsl:function name="ahf:hasFigTitle" as="xs:boolean">
        <xsl:param name="prmFig" as="element()"/>
        <xsl:sequence select="$prmFig/*[ahf:seqContainsToken(@class, ('topic/title','topic/desc'))] => exists()"/>
    </xsl:function>
    
    <!--
    function:   image template
    param:      none
    return:     div, etc
    note:              
    -->
    <xsl:variable name="imageWrapper" as="xs:string" select="ahf:getVarValue('Image_Wrapper')"/>
    <xsl:variable name="imageLeft" as="xs:string" select="ahf:getVarValue('Image_Left')"/>
    <xsl:variable name="imageRight" as="xs:string" select="ahf:getVarValue('Image_Right')"/>
    <xsl:variable name="imageCenter" as="xs:string" select="ahf:getVarValue('Image_Center')"/>
    
    <xsl:template match="*[contains-token(@class, 'topic/image')]">
        <xsl:variable name="placement" as="xs:string" select="@placement => string()"/>    
        <xsl:variable name="align" as="xs:string" select="@align => string()"/>
        <xsl:choose>
            <xsl:when test="$placement eq 'break'">
                <xsl:choose>
                    <xsl:when test="$align eq 'left'">
                        <div class="{($imageWrapper,$imageLeft) => string-join(' ')}">
                            <xsl:call-template name="processImage"/>
                        </div>
                    </xsl:when>
                    <xsl:when test="$align eq 'center'">
                        <div class="{($imageWrapper,$imageCenter) => string-join(' ')}">
                            <xsl:call-template name="processImage"/>
                        </div>
                    </xsl:when>
                    <xsl:when test="$align eq 'right'">
                        <div class="{($imageWrapper,$imageRight) => string-join(' ')}">
                            <xsl:call-template name="processImage"/>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="{$imageWrapper}">
                            <xsl:call-template name="processImage"/>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processImage"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
    function:   image processing template
    param:      none
    return:     image
    note:              
    -->
    <xsl:template name="processImage">
        <xsl:param name="prmImage" as="element()" required="no" select="."/>
        <xsl:choose>
            <xsl:when test="$prmImage/*[contains-token(@class,'topic/longdescref')]/@href => exists()">
                <xsl:variable name="longDescRef" as="element()" select="$prmImage/*[contains-token(@class,'topic/longdescref')]"/>
                <xsl:variable name="href" as="xs:string" select="$longDescRef/@href => string()"/>
                <xsl:variable name="format" as="xs:string" select="$longDescRef/@format => string()"/>
                <xsl:variable name="extensionOrAfter" as="xs:string" select="ahf:substringAfterLast($href,'.')"/>
                <xsl:variable name="destination" as="xs:string">
                    <xsl:choose>
                        <xsl:when test="not(string($format)) or $format eq 'dita'">
                            <xsl:sequence select="ahf:replaceExtensionWithFragment($href,$gpOutputExtension)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="$href"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <a>
                    <xsl:call-template name="genCommonAtts">
                        <xsl:with-param name="prmElement" select="$longDescRef"/>
                    </xsl:call-template>
                    <xsl:attribute name="href" select="$destination"/>
                    <img>
                        <xsl:call-template name="genCommonAtts">
                            <xsl:with-param name="prmElement" select="$prmImage"/>
                        </xsl:call-template>
                        <xsl:call-template name="genImageAtts">
                            <xsl:with-param name="prmImage" select="$prmImage"/>
                        </xsl:call-template>    
                    </img>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <img>
                    <xsl:call-template name="genCommonAtts">
                        <xsl:with-param name="prmElement" select="$prmImage"/>
                    </xsl:call-template>
                    <xsl:call-template name="genImageAtts">
                        <xsl:with-param name="prmImage" select="$prmImage"/>
                    </xsl:call-template>    
                </img>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="genImageAtts">
        <xsl:param name="prmImage" as="element()" required="no" select="."/>
        
        <!-- href -->
        <xsl:if test="$prmImage/@href => exists()">
            <xsl:attribute name="src" select="$prmImage/@href  => string()"/>
        </xsl:if>

        <!-- image size -->
        <xsl:variable name="height" as="xs:string" select="ahf:getLength(string($prmImage/@height))"/>
        <xsl:variable name="width"   as="xs:string" select="ahf:getLength(string($prmImage/@width))"/>
        <xsl:variable name="scale"   as="xs:string" select="normalize-space($prmImage/@scale)"/>
        <xsl:variable name="placement"  as="xs:string" select="string($prmImage/@placement)"/>
        <xsl:choose>
            <xsl:when test="string($width) or string($height)">
                <xsl:if test="string($width)">
                    <xsl:choose>
                        <xsl:when test="ahf:getPropertyUnit($width) eq $cUnitPx">
                            <xsl:attribute name="width" select="ahf:getPropertyNu($width)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="width" select="ahf:toPx($width,$cPxDpi) => round() => xs:integer()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="string($height)">
                    <xsl:choose>
                        <xsl:when test="ahf:getPropertyUnit($height) eq $cUnitPx">
                            <xsl:attribute name="height" select="ahf:getPropertyNu($height)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="height" select="ahf:toPx($height,$cPxDpi) => round() => xs:integer()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:when test="string($scale)">
                <xsl:variable name="imageSizeInfo" as="array(item())" select="ahf:getImageSizeInfo($prmImage)"/>
                <xsl:choose>
                    <xsl:when test="$imageSizeInfo(1) => xs:integer() gt 0 and $imageSizeInfo(2) => xs:integer() gt 0">
                        <xsl:variable name="pxWidth" as="xs:integer" select="$imageSizeInfo(1) treat as xs:integer"/>
                        <xsl:variable name="pxHeight" as="xs:integer" select="$imageSizeInfo(2) treat as xs:integer"/>
                        <xsl:variable name="horDpi" as="xs:integer" select="$imageSizeInfo(3) treat as xs:integer"/>
                        <xsl:variable name="verDpi" as="xs:integer" select="$imageSizeInfo(4) treat as xs:integer"/>
                        <xsl:variable name="scale" as="xs:double" select="$imageSizeInfo(5) treat as xs:double"/>
                        <xsl:attribute name="width" select="(ahf:toPx(concat($pxWidth,$cUnitPx),$horDpi) * $scale) => round() => xs:integer()"/>
                        <xsl:attribute name="height" select="(ahf:toPx(concat($pxHeight,$cUnitPx),$verDpi) * $scale) => round() => xs:integer()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:assert test="false()" select="'[genImageAtts] Failed to process scalling. Width=',$imageSizeInfo(1),' Height=',$imageSizeInfo(2),' horizontal-dpi=',$imageSizeInfo(3),' vertical-dpi=',$imageSizeInfo(4),' scale=',$imageSizeInfo(5)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>

        <!-- alt -->
        <xsl:choose>
            <xsl:when test="$prmImage/*[contains-token(@class, 'topic/alt')]">
                <xsl:variable name="altText" as="xs:string">
                    <xsl:variable name="tempAltText" as="xs:string*">
                        <xsl:apply-templates select="$prmImage/*[contains-token(@class, 'topic/alt')]" mode="TEXT_ONLY"/>
                    </xsl:variable>
                    <xsl:sequence select="string-join($tempAltText,'')"/>
                </xsl:variable>
                <xsl:attribute name="alt" select="$altText"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="alt" select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:  return normalized length
     param:     prmLen
     return:	if $prmLen has no unit of measure, assume it as pixel.
     note:      
     -->
    <xsl:function name="ahf:getLength" as="xs:string">
        <xsl:param name="prmLen" as="xs:string"/>
        
        <xsl:variable name="lengthStr" select="normalize-space($prmLen)"/>
        <xsl:variable name="unit" select="ahf:getPropertyUnit($lengthStr)"/>
        <xsl:choose>
            <xsl:when test="not(string($prmLen))">
                <xsl:sequence select="''"/>
            </xsl:when>
            <xsl:when test="not(string($unit))">
                <!-- If no unit is specified, adopt "px" -->
                <xsl:sequence select="concat($lengthStr,$cUnitPx)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$lengthStr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:  return image size information:
                Width and height in pixel, both dimension resolution, scale
     param:     prmImage image element
                prmMapDirUrl base map directory
     return:	image size information (width, height in pixel, resolution of both axes, scale)
     note:      
     -->
    <xsl:function name="ahf:getImageSizeInfo" as="array(item())">
        <xsl:param name="prmImage" as="element()"/>
        <xsl:variable name="defaultDpi" as="xs:integer" select="$cPxDpi"/>
        <xsl:variable name="horizontalDpi" as="xs:integer" select="if (string($prmImage/@dita-ot:horizontal-dpi) castable as xs:integer) then xs:integer($prmImage/@dita-ot:horizontal-dpi) else $defaultDpi"/>
        <xsl:variable name="verticalDpi" as="xs:integer" select="if (string($prmImage/@dita-ot:vertical-dpi) castable as xs:integer) then xs:integer($prmImage/@dita-ot:vertical-dpi) else $defaultDpi"/>
        <xsl:variable name="orgImageWidth" as="xs:integer">
            <xsl:variable name="imageWidth" as="xs:string" select="string($prmImage/@dita-ot:image-width)"/>
            <xsl:choose>
                <xsl:when test="$imageWidth castable as xs:integer">
                    <xsl:sequence select="$imageWidth => xs:integer()"/>
                </xsl:when>
                <xsl:when test="$imageWidth castable as xs:double">
                    <xsl:sequence select="$imageWidth => xs:double() => round() => xs:integer()"/>
                </xsl:when>
                <xsl:when test="ahf:isUnitValue($imageWidth)">
                    <xsl:sequence select="(ahf:toIn($imageWidth) * $horizontalDpi) => xs:double() => round() => xs:integer()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="0"/>
                </xsl:otherwise>
            </xsl:choose>            
        </xsl:variable>
        <xsl:variable name="orgImageHeight" as="xs:integer">
            <xsl:variable name="imageHeight" as="xs:string" select="string($prmImage/@dita-ot:image-height)"/>
            <xsl:choose>
                <xsl:when test="$imageHeight castable as xs:integer">
                    <xsl:sequence select="$imageHeight => xs:integer()"/>
                </xsl:when>
                <xsl:when test="$imageHeight castable as xs:double">
                    <xsl:sequence select="$imageHeight => xs:double() => round() => xs:integer()"/>
                </xsl:when>
                <xsl:when test="ahf:isUnitValue($imageHeight)">
                    <xsl:sequence select="(ahf:toIn($imageHeight) * $verticalDpi) => xs:double() => round() => xs:integer()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="0"/>
                </xsl:otherwise>
            </xsl:choose>            
        </xsl:variable>
        <xsl:variable name="scale" as="xs:double" select="if (string($prmImage/@scale)) then (xs:integer($prmImage/@scale) div 100) else 1"/>
        
        <xsl:choose>
            <xsl:when test="($orgImageWidth gt 0) and ($orgImageHeight gt 0)">
                <xsl:sequence select="[$orgImageWidth,$orgImageHeight,$horizontalDpi,$verticalDpi,$scale]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="[0,0,$horizontalDpi,$verticalDpi,$scale]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--
    function:   fn template
    param:      none
    return:     a
    note:       Ignore fn when mode="MODE_GET_CONTENTS"
    -->
    <xsl:variable name="fnRefPrefix" as="xs:string" select="ahf:getVarValue('Footnote_Ref_Prefix')"/>
    <xsl:variable name="fnRefSuffix" as="xs:string" select="ahf:getVarValue('Footnote_Ref_Suffix')"/>
    
    <xsl:template match="*[contains-token(@class, 'topic/fn')]">
        <xsl:param name="prmWithNoFn" tunnel="yes" required="no" as="xs:boolean" select="false()"/>
        <xsl:variable name="fn" as="element()" select="."/>
        <xsl:choose>
            <xsl:when test="$prmWithNoFn"/>
            <xsl:otherwise>
                <xsl:if test="@id => empty()">
                    <xsl:variable name="fnRefStr" as="xs:string" select="ahf:getFnRefStr($fn)"/>
                    <xsl:if test="string($fnRefStr)">
                        <a>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('Fn_Ref')"/>
                            </xsl:call-template>
                            <xsl:attribute name="href" select="'#' || string(ahf:genIdAtt($fn,true()))"/>
                            <span>
                                <xsl:call-template name="genCommonAtts">
                                    <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('Fn_Ref')"/>
                                </xsl:call-template>
                                <xsl:value-of select="$fnRefStr"/>
                            </span>
                        </a>
                    </xsl:if>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   generate fn reference string
    param:      fn
    return:     xs:string
    note:              
    -->
    <xsl:function name="ahf:getFnRefStr" as="xs:string">
        <xsl:param name="prmFn" as="element()"/>
        <xsl:choose>
            <xsl:when test="$prmFn/@callout">
                <xsl:sequence select="$prmFn/@callout => string()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="topic" as="element()" select="$prmFn/ancestor::*[contains-token(@class,'topic/topic')][1]"/>
                <xsl:variable name="fnCount" as="xs:integer?">
                    <xsl:choose>
                        <xsl:when test="$gpOutputFnAtEndOfTopic">
                            <xsl:sequence select="($topic/descendant::*[contains-token(@class,'topic/fn')][@callout => empty()][. &lt;&lt; $prmFn]|$prmFn) => count()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="topElement" as="element()?">
                                <xsl:choose>
                                    <xsl:when test="$prmFn/ancestor::*[ahf:seqContainsToken(@class,('topic/table','topic/simpletable'))]">
                                        <xsl:sequence select="$prmFn/ancestor::*[ahf:seqContainsToken(@class,('topic/table','topic/simpletable'))][last()]"/>
                                    </xsl:when>
                                    <xsl:when test="$prmFn/ancestor::*[ahf:seqContainsToken(@class,('topic/ul','topic/ol','topic/dl','topic/sl'))]">
                                        <xsl:sequence select="$prmFn/ancestor::*[ahf:seqContainsToken(@class,('topic/ul','topic/ol','topic/dl','topic/sl'))][last()]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="warningContinue">
                                            <xsl:with-param name="prmMes" select="ahf:replace($stMes040,('%file','%xpath'),($gpProcessingFileName,ahf:getHistoryXpathStr($prmFn)))"/>
                                        </xsl:call-template>
                                        <xsl:sequence select="()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$topElement => exists()">
                                    <xsl:sequence select="($topElement/descendant::*[contains-token(@class,'topic/fn')][@callout => empty()][. &lt;&lt; $prmFn]|$prmFn) => count()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$fnCount => exists()">
                        <xsl:variable name="fnRefStr" as="xs:string" select="concat($fnRefPrefix,string($fnCount),$fnRefSuffix)"/>
                        <xsl:sequence select="$fnRefStr"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--
    function:   output footnotes
    param:      prmElement
    return:     
    note:       $prmElement is supposed as single element.
                for about table the footnote list is generated per <table>. (not <tgroup>)
    -->
    <xsl:template name="genFootNoteList">
        <xsl:param name="prmElement" as="element()" required="yes"/>
        <xsl:variable name="upperElement" as="element()*" select="$prmElement/ancestor::*[ahf:seqContainsToken(@class,('topic/table','topic/simpletable','topic/ul','topic/ol','topic/dl','topic/sl'))]"/>
        <xsl:call-template name="genFootNoteSub">
            <xsl:with-param name="prmFn" as="element()*">
                <xsl:choose>
                    <xsl:when test="$prmElement[contains-token(@class,'topic/topic')]">
                        <xsl:sequence select="$prmElement/*[ahf:seqContainsToken(@class,('topic/title','topic/shortdesc','topic/abstract','topic/body'))]/descendant::*[contains-token(@class,'topic/fn')][not(contains-token(@class,'pr-d/synnote'))]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="$prmElement/descendant::*[contains-token(@class,'topic/fn')][not(contains-token(@class,'pr-d/synnote'))]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!--
    function:   output footnote list
    param:      prmFn
    return:     ul
    note:       
    -->
    <xsl:template name="genFootNoteSub">
        <xsl:param name="prmFn" as="element()*" required="yes"/>
        <xsl:if test="$prmFn => exists()">
            <ul>
                <xsl:call-template name="genCommonAtts">
                    <xsl:with-param name="prmElement" select="()"/>
                    <xsl:with-param name="prmDefaultOutputClass" select="(ahf:getVarValue('Fn_List'),ahf:getVarValue('List_Style_None')) => string-join(' ')"/>
                </xsl:call-template>
                <xsl:for-each select="$prmFn">
                    <xsl:variable name="fn" as="element()" select="."/>
                    <xsl:variable name="fnRefStr" as="xs:string" select="ahf:getFnRefStr($fn)"/>
                    <li>
                        <xsl:call-template name="genCommonAtts">
                            <xsl:with-param name="prmElement" select="$fn"/>
                            <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('Fn_Body')"/>
                        </xsl:call-template>
                        <xsl:copy-of select="ahf:genIdAtt($fn,true())"/>
                        <xsl:value-of select="$fnRefStr"/>
                        <xsl:call-template name="getVarValueAsText">
                            <xsl:with-param name="prmVarName" select="'Footnote_List_Sep'"/>
                        </xsl:call-template>
                        <xsl:apply-templates select="$fn/node()"/>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>

    <!--
    function:   cite template
    param:      none
    return:     cite
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/cite')]">
        <cite>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </cite>
    </xsl:template>

    <!--
    function:   lines template
    param:      none
    return:     p
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/lines')]">
        <p>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- preserve line-feed -->
    <xsl:template match="*[contains-token(@class, 'topic/lines')]/descendant::text()">
        <xsl:analyze-string select="string(.)" regex="&#x0A;">
            <xsl:matching-substring>
                <br/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <!--
    function:   ph template
    param:      none
    return:     span
    note:       no special formattings
    -->
    <xsl:template match="*[contains-token(@class, 'topic/ph')]">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!--
    function:   pre template
    param:      none
    return:     pre
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/pre')]">
        <pre>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </pre>
    </xsl:template>

    <!--
    function:   q template
    param:      none
    return:     q
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/q')]">
        <q>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </q>
    </xsl:template>

    <!--
    function:   term template
    param:      none
    return:     a/dfn or dfn
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/term')]">
        <xsl:variable name="term" as="element()" select="."/>
        <xsl:choose>
            <xsl:when test="$term/@href => exists()">
                <xsl:variable name="destAttr" as="attribute()?">
                    <xsl:call-template name="getDestinationAttr">
                        <xsl:with-param name="prmElem" select="$term"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="exists($destAttr)">
                        <a>
                            <xsl:call-template name="genCommonAtts"/>
                            <xsl:copy-of select="$destAttr"/>
                            <dfn>
                                <xsl:call-template name="genCommonAtts"/>
                                <xsl:call-template name="genIdAtt"/>
                                <xsl:apply-templates/>
                            </dfn>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <dfn>
                            <xsl:call-template name="genCommonAtts"/>
                            <xsl:call-template name="genIdAtt"/>
                            <xsl:apply-templates/>
                        </dfn>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <dfn>
                    <xsl:call-template name="genCommonAtts"/>
                    <xsl:call-template name="genIdAtt"/>
                    <xsl:apply-templates/>
                </dfn>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
    function:   text template
    param:      none
    return:     span
    note:       no special formattings
    -->
    <xsl:template match="*[contains-token(@class, 'topic/text')]">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!--
    function:   tm template
    param:      none
    return:     span
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/tm')]">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
            <span>
                <xsl:choose>
                    <xsl:when test="string(@tmtype) eq 'tm'">
                        <xsl:call-template name="getVarValueWithLangAsText">
                            <xsl:with-param name="prmVarName" select="'Tm_Symbol_Tm'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="string(@tmtype) eq 'reg'">
                        <xsl:call-template name="getVarValueWithLangAsText">
                            <xsl:with-param name="prmVarName" select="'Tm_Symbol_Reg'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="string(@tmtype) eq 'service'">
                        <xsl:call-template name="getVarValueWithLangAsText">
                            <xsl:with-param name="prmVarName" select="'Tm_Symbol_Service'"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </span>
        </span>
    </xsl:template>
    
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    DITA Utility Templates
    **************************************************************
    File Name : dita2html5_dita_util.xsl
    **************************************************************
    Copyright © 2009-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.co.jp/
    **************************************************************
-->

<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs ahf" >
    
    <!-- 
     function:  Judge LTR/RTL from language tag
     param:     prmXmlLang: language tag
     return:    xs:boolean
     note:      none
    -->
    <xsl:function name="ahf:isRtl" as="xs:boolean">
    	<xsl:param name="prmXmlLang" as="xs:string"/>
        <xsl:variable name="lang" as="xs:string" select="tokenize($prmXmlLang, '-')[1]"/>
        <xsl:sequence select="$lang = ('ar','he')"/>
    </xsl:function>
    
    <!-- 
     function:  Judge URL
     param:     prmUrl: check string
     return:    xs:boolean
     note:      none
    -->
    <xsl:function name="ahf:isUrl" as="xs:boolean">
        <xsl:param name="prmUrl" as="xs:string"/>
        <xsl:sequence select="starts-with($prmUrl,'http:/') or starts-with($prmUrl,'https:/')"/>
    </xsl:function>
    
    <!--
     function:   isToc Utility
     param:      prmTopicRef
     note: Return boolena that parameter should add toc or not.
    -->
    <xsl:function name="ahf:isToc" as="xs:boolean">
        <xsl:param name="prmTopicRef" as ="element()"/>
        <xsl:sequence select="not(ahf:isTocNo($prmTopicRef))"/>
    </xsl:function>
    
    <!-- 
     function:  Check @toc="no" 
     param:     prmTopicRef
     return:    xs:boolean
     note:		
     -->
    <xsl:function name="ahf:isTocNo" as="xs:boolean">
        <xsl:param name="prmTopicRef" as="element()"/>
        <xsl:choose>
            <xsl:when test="string($prmTopicRef/@toc) eq 'no'">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--
     function:  isTopicRef Utility
     param:     prmMapElem
     note:      Return boolean if parameter is topiref element.
    -->
    <xsl:function name="ahf:isTopicRef" as="xs:boolean">
        <xsl:param name="prmMapElem" as ="element()"/>
        <xsl:sequence select="$prmMapElem/@class => contains-token('map/topicref')"/>
    </xsl:function>

    <!--
     function:  isNotInRelTable Utility
     param:     prmMapElem
     note:      Return boolean if parameter is not in reltable element.
    -->
    <xsl:function name="ahf:isNotInRelTable" as="xs:boolean">
        <xsl:param name="prmMapElem" as ="element()"/>
        <xsl:sequence select="$prmMapElem/ancestor::*[@class => contains-token('map/reltable')] => empty()"/>
    </xsl:function>
    
    <!--
     function:  isResouceOnly Utility
     param:     prmTopicRef
     note:      Return boolean if parameter topiref is 'resource-only'.
    -->
    <xsl:function name="ahf:isResourceOnly" as="xs:boolean">
        <xsl:param name="prmTopicRef" as ="element()"/>
        <xsl:sequence select="string($prmTopicRef/@processing-role) eq 'resource-only'"/>
    </xsl:function>

    <!--
     function:  Replace file extension in a URI
     param:     prmFileName, prmExtension
     note:      xs:string
    -->
    <xsl:function name="ahf:replaceExtension" as="xs:string">
        <xsl:param name="prmPath" as ="xs:string"/>
        <xsl:param name="prmExtension" as="xs:string"/>
        <xsl:variable name="beforeFragment" as="xs:string">
            <xsl:sequence select="ahf:substringBeforeLast(if (contains($prmPath,'#')) then substring-before($prmPath,'#') else $prmPath,'.')"/>
        </xsl:variable>
        <xsl:sequence select="concat($beforeFragment,$prmExtension)"/>
    </xsl:function>

    <xsl:function name="ahf:replaceExtensionWithFragment" as="xs:string">
        <xsl:param name="prmPath" as ="xs:string"/>
        <xsl:param name="prmExtension" as="xs:string"/>
        <xsl:variable name="beforeFragment" as="xs:string">
            <xsl:sequence select="ahf:substringBeforeLast(if (contains($prmPath,'#')) then substring-before($prmPath,'#') else $prmPath,'.')"/>
        </xsl:variable>
        <xsl:variable name="fragment" as="xs:string" select="substring-after($prmPath,'#')"/>
        <xsl:sequence select="if ($fragment => string()) then concat($beforeFragment,$prmExtension,'#',$fragment) else concat($beforeFragment,$prmExtension)"/>
    </xsl:function>
    

    <!--
     function:  Judge Block Level Element Or Not
     param:     prmElem
     return;    xs:boolean
     note:      
    -->
    <xsl:variable name="blockElementClasses" as="xs:string+">
        <xsl:sequence select="'topic/body'"/>
        <xsl:sequence select="'topic/shortdesc'"/>
        <xsl:sequence select="'topic/abstract'"/>
        <xsl:sequence select="'topic/title'"/>
        <xsl:sequence select="'topic/section'"/>
        <xsl:sequence select="'task/info'"/>
        <xsl:sequence select="'topic/p'"/>
        <xsl:sequence select="'topic/pre'"/>
        <xsl:sequence select="'topic/note'"/>
        <xsl:sequence select="'topic/fig'"/>
        <xsl:sequence select="'topic/dl'"/>
        <xsl:sequence select="'topic/sl'"/>
        <xsl:sequence select="'topic/ol'"/>
        <xsl:sequence select="'topic/ul'"/>
        <xsl:sequence select="'topic/li'"/>
        <xsl:sequence select="'topic/sli'"/>
        <xsl:sequence select="'topic/itemgroup'"/>
        <xsl:sequence select="'topic/section'"/>
        <xsl:sequence select="'topic/table'"/>
        <xsl:sequence select="'topic/entry'"/>
        <xsl:sequence select="'topic/simpletable'"/>
        <xsl:sequence select="'topic/stentry'"/>
        <xsl:sequence select="'topic/example'"/>
    </xsl:variable>

    <xsl:function name="ahf:isBlockLevelElement" as="xs:boolean">
        <xsl:param name="prmElem" as="element()?"/>
        <xsl:variable name="class" as="xs:string*" select="($prmElem/@class =>string() => tokenize())[. ne '-']"/>
        <xsl:sequence select="($class = $blockElementClasses) or (contains-token($class,'topic/image') and string($prmElem/@placement) eq 'break')" />
    </xsl:function>
    
    <!-- 
      ============================================
         ID Related Functions
      ============================================
    -->
    <!--
     function:  Get Topic ID From Topic Element
     param:     prmElem
     return:    xs:ID
     note:      
    -->
    <xsl:function name="ahf:getClosestTopicId" as="xs:ID">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:sequence select="$prmElem/ancestor-or-self::*[contains-token(@class,'topic/topic')][1]/@id/string()"/>
    </xsl:function>
    
    <!--
     function:  Get Topic ID From Href Attribute
     param:     prmElem
     return:    xs:ID
     note:      
    -->
    <xsl:function name="ahf:getTopicIdFromHref" as="xs:ID?">
        <xsl:param name="prmHref" as="xs:string"/>
        <xsl:assert test="contains($prmHref,'#')" select="'[ahf:getTopicIdFromHref] Invalid $prmHref=',$prmHref"/>
        <xsl:variable name="fragment"  as="xs:string" select="substring-after($prmHref, '#')"/>
        <xsl:choose>
            <xsl:when test="string-length($fragment) gt 0">
                <xsl:choose>
                    <xsl:when test="contains($fragment, '/')">
                        <xsl:sequence select="substring-before($fragment, '/') => xs:ID()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="$fragment => xs:ID()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!--
     function:  Get Element ID From Href Attribute
     param:     prmElem
     return:    xs:string
     note:      
    -->
    <xsl:function name="ahf:getElementIdFromHref" as="xs:string">
        <xsl:param name="prmHref" as="xs:string"/>
        <xsl:variable name="topicAndElementId" as="xs:string" select="$prmHref => substring-after('#')"/>
        <xsl:choose>
            <xsl:when test="$topicAndElementId => contains('/')">
                <xsl:sequence select="$topicAndElementId => substring-after('/')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--
     function:  Get ID from topic ID and element ID
     param:     prmTopicId, prmElementId
     return:    xs:ID
     note:      Avoid possible DITA-OT bug:
                Using @keyref for topic's @id generates href="[target file]#[topic id]/[topic id]"  
    -->
    <xsl:function name="ahf:getIdFromTopicAndElementId" as="xs:ID">
        <xsl:param name="prmTopicId" as="xs:ID"/>
        <xsl:param name="prmElementId" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="string($prmElementId)">
                <xsl:choose>
                    <xsl:when test="$prmTopicId => string() ne $prmElementId">
                        <xsl:sequence select="concat($prmTopicId,$cIdSep,$prmElementId) => xs:ID()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="$prmTopicId"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$prmTopicId"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- end of stylesheet -->
</xsl:stylesheet>

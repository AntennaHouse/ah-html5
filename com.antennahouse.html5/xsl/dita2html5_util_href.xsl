<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    @href Attribute Utility Templates
    **************************************************************
    File Name : dita2html5_util_href.xsl
    **************************************************************
    Copyright © 2009-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.co.jp/
    **************************************************************
-->

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="xs ahf saxon" >

    <!--
    function:   Link href attribute processing 
    param:      prmLinkElem (link or xref)
    return:     attribute()?
    note:       format @href attribute based on target feature
    -->
    <xsl:template name="ahf:genHrefAtt" as="attribute()?">
        <xsl:param name="prmLinkElem" as="element()" required="yes"/>
        <xsl:variable name="href" as="xs:string" select="$prmLinkElem/@href => string()"/>
        <xsl:choose>
            <xsl:when test="string($href)">
                <xsl:choose>
                    <!-- non DITA target -->
                    <xsl:when test="ahf:isNonDitaTarget($prmLinkElem)">
                        <xsl:attribute name="href" select="$href"/>
                    </xsl:when>
                    <!-- DITA target (in same file) - process the internal href -->
                    <xsl:when test="ahf:isInnerLink($prmLinkElem)">
                        <xsl:attribute name="href" select="concat('#',ahf:getIdFromTopicAndElementId(xs:ID(ahf:getTopicIdFromHref($href)),ahf:getElementIdFromHref($href)))"/>
                    </xsl:when>
                    <!-- It's the link to a DITA file - process the file name (adding the html extension) and process the rest of the href -->
                    <xsl:when test="ahf:isDitaTarget($prmLinkElem)">
                        <xsl:attribute name="href">
                            <xsl:variable name="targetFilePath" select="ahf:replaceExtension($href,$gpOutputExtension)"/>
                            <xsl:variable name="fragment" as="xs:string">
                                <xsl:choose>
                                    <xsl:when test="contains($href, '#')">
                                        <xsl:sequence select="'#' || substring-after($href,'#')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:sequence select="''"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:value-of select="concat($targetFilePath,$fragment)"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:assert test="false()" select="'[ahf:genHrefAtt] Invalid href information. $prmLinkElem/@href=',$href"/>
                        <xsl:attribute name="href" select="$href"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
     function:  Determine whether the target is DITA or non-DITA
     param:     prmLinkElem: xref or link element
     return:	xs:boolaen
     note:
    -->
    <xsl:function name="ahf:isNonDitaTarget" as="xs:boolean">
        <xsl:param name="prmLinkElem" as="element()"/>
        <xsl:variable name="isNonDita" as="xs:boolean" select="($prmLinkElem/@format => empty() and $prmLinkElem/@scope => string() eq 'external') or ($prmLinkElem/@format => exists() and ($prmLinkElem/@format => string() ne 'dita'))"/>
        <xsl:sequence select="$isNonDita"/>
    </xsl:function>
    
    <xsl:function name="ahf:isDitaTarget" as="xs:boolean">
        <xsl:param name="prmLinkElem" as="element()"/>
        <xsl:variable name="isDita" as="xs:boolean" select="($prmLinkElem/@scope => string() = ('','local', 'peer')) and ($prmLinkElem/@format =>string() = ('','dita'))"/>
        <xsl:sequence select="$isDita"/>
    </xsl:function>
    
    <!-- 
     function:  Determine whether the target is in processing file itself or not
     param:     prmLinkElem: xref or link element
     return:	xs:boolaen
     note:      If $prmLinkElem/@href starts with "#", it is the topic/@id of processing file.
                However DITA allows the notation @href="target-file.xml#[topic-id]/[element-id]" and sometimes "target-file.xml" is processing file itself.
                This function determines the identitiy by comparing target file name with $gpProcessingFileName.
                $prmLinkElem/@href must be DITA target.
    -->
    <xsl:function name="ahf:isInnerLink" as="xs:boolean">
        <xsl:param name="prmLinkElem" as="element()"/>
        <xsl:variable name="href" as="xs:string" select="$prmLinkElem/@href => string()"/>
        <xsl:choose>
            <xsl:when test="$href => starts-with('#')">
                <!-- Obvious inner link -->
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="$href => contains('#')">
                <!-- The spcified file is equal to the processing file -->
                <xsl:variable name="fileName" as="xs:string" select="substring-before($href,'#')"/>
                <xsl:sequence select="$fileName eq $gpProcessingFileName"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:function>

    <!-- 
     function:  Get a/@href attribute
     param:     prmElem: Relevant element 
     return:	attribute()?
     note:		
    -->
    <xsl:template name="getDestinationAttr" as="attribute()?">
        <xsl:param name="prmElem" as="element()" required="yes"/>
        <xsl:call-template name="ahf:genHrefAtt">
            <xsl:with-param name="prmLinkElem" select="$prmElem"/>
        </xsl:call-template>
    </xsl:template>

    <!-- 
     function:  Get destination element from @href
     param:     prmLinkElem: xref or link 
     return:    element()?
     note:
    -->
    <xsl:template name="getLinkDestinationElement" as="element()?">
        <xsl:param name="prmLinkElem" as="element()" required="yes"/>

        <xsl:variable name="href" as="xs:string" select="$prmLinkElem/@href => string()"/>
        <xsl:choose>
            <xsl:when test="ahf:isNonDitaTarget($prmLinkElem)">
                <xsl:sequence select="()"/>
            </xsl:when>
            <!-- DITA target (in same file) - process the internal href -->
            <xsl:when test="ahf:isInnerLink($prmLinkElem)">
                <xsl:variable name="topicId" as="xs:string" select="ahf:getTopicIdFromHref($href)"/>
                <xsl:variable name="elemId" as="xs:string" select="ahf:getElementIdFromHref($href)"/>
                <xsl:choose>
                    <xsl:when test="string($elemId)">
                        <xsl:sequence select="$prmLinkElem/root()/descendant::*[contains-token(@class,'topic/topic')][@id => string() eq $topicId]/descendant::*[@id => string() eq $elemId]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="$prmLinkElem/root()/descendant::*[contains-token(@class,'topic/topic')][@id => string() eq $topicId]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- It's the link to a DITA file - get element from external file -->
            <xsl:when test="ahf:isDitaTarget($prmLinkElem)">
                <xsl:variable name="ditaFilePath" as="xs:string" select="if (contains($href,'#')) then substring-before($href,'#') else $href"/>
                <xsl:variable name="ditaFileDoc" as="document-node()" select="saxon:discard-document(document($ditaFilePath,root($prmLinkElem)))"/>
                <xsl:variable name="topicId" as="xs:string">
                    <xsl:choose>
                        <xsl:when test="contains($href,'#')">
                            <xsl:variable name="fragment" as="xs:string" select="substring-after($href,'#')"/>
                            <xsl:sequence select="if (contains($fragment,'/')) then substring-before($fragment,'/') else $fragment"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="($ditaFileDoc/descendant::*[contains-token(@class,'topic/topic')])[1]/@id => string()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="elemId" as="xs:string" select="if (contains($href,'#') and contains($href,'/')) then $href => substring-after('#') => substring-after('/') else ''"/>
                <xsl:variable name="targetElem" as="element()?">
                    <xsl:choose>
                        <xsl:when test="string($elemId)">
                            <xsl:sequence select="$ditaFileDoc/descendant::*[contains-token(@class,'topic/topic')][@id => string() eq $topicId]/descendant::*[@id => string() eq $elemId][1]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="$ditaFileDoc/descendant::*[contains-token(@class,'topic/topic')][@id => string() eq $topicId]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:sequence select="$targetElem"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="warningContinue">
                    <xsl:with-param name="prmMes"
                        select="ahf:replace($stMes030,('%href','%ohref','%file'),(string($prmLinkElem/@href),string($prmLinkElem/@ohref),string($prmLinkElem/@xtrf)))"/>
                </xsl:call-template>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Related-links Templates
    **************************************************************
    File Name : dita2html5_related-links.xsl
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
    
    <!-- Implementation notes
         The specifcation of DITA related-links is very flexible, it allows users to include author-arranged group of links using linklist.
         On other hand, links authored in reltable are integrated into related-links by DITA-OT preprocessing automatically.
         The rendition of the link that is direct child of related-links or child of linkpool are treated as implemetation dependent.
         However if a link is child of linklist, the order of the rendition should be preserved.
         
         This stylesheet implements the processing of related-links as follows;

         - Output child links (link/@role="child") using ol if they are child of topcref/@collection-type="sequence".
         - Output child links using ul if the are not child of topcref/@collection-type="sequence".
         - Output parent/next/previous links (link/@role="previos/next/parent") with label.
         - Output link/@role="friend" (authored in reltable) as "Related topic" preserving the order. 
         - Other links that have another @role values are ignored.
         - This stylesheet does not check the duplicate links.
         
         There are more implementations such as DITA-OT HTML5 plug-in.
         It checks duplicate links and honors whole @role values. Also it implements more complex linklist patterns.
         However it is too complex to maintain or customize and there should be no further needs for author-arranged linklist.
         This stylesheet adopts more simplified implementation than HTML5 plug-in.
      -->
    
    <!-- Output control parameter -->
    <xsl:param name="PRM_OUTPUT_CHILD_LINKS" as="xs:string" required="no" select="$cYes"/>
    <xsl:variable name="gpOutputChildLinks" as="xs:boolean" select="$PRM_OUTPUT_CHILD_LINKS eq $cYes"/>
    <xsl:param name="PRM_OUTPUT_PARENT_LINK" as="xs:string" required="no" select="$cYes"/>
    <xsl:variable name="gpOutputParentLink" as="xs:boolean" select="$PRM_OUTPUT_PARENT_LINK eq $cYes"/>
    <xsl:param name="PRM_OUTPUT_NEXT_PREVIOUS_LINKS" as="xs:string" required="no" select="$cYes"/>
    <xsl:variable name="gpOutputNextPreviousLinks" as="xs:boolean" select="$PRM_OUTPUT_NEXT_PREVIOUS_LINKS eq $cYes"/>
    
    <!--
    function:   Related-links Template
    param:      none
    return:     nav element, etc
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/related-links')]">
        <xsl:variable name="relatedLink" as="element()" select="."/>
        <nav>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsRelatedLinks'"/>
            </xsl:call-template>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:if test="$gpOutputChildLinks">
                <!--Output child links (outside of linklists) in @collection-type="unordered" or "choice"
                 -->
                <xsl:call-template name="genUlChildLinks"/>
                <!--Output child links (outside of linklists) in @collection-type="ordered" or "sequence"
                 -->
                <xsl:call-template name="genOlChildLinks"/>
            </xsl:if>
            <xsl:if test="$gpOutputParentLink or $gpOutputNextPreviousLinks">
                <!--Output next, previous and parent links
                 -->
                <xsl:call-template name="genNextPrevParentLinks"/>
            </xsl:if>
            <!-- Output link/@role="friend" as "Related topics"
             -->
            <xsl:call-template name="genFriendLinks"/>
        </nav>
    </xsl:template>
    
    <!--
    function:   Generate child links outside of linklists in in @collection-type = "unordered/choice"
    param:      none
    return:     ul, etc
    note:       current context is related-links 
    -->
    <xsl:template name="genUlChildLinks">
        <xsl:variable name="children" as="element()*"
            select="descendant::*[contains-token(@class, 'topic/link')]
                                 [@role => string() eq 'child']
                                 [parent::*[@collection-type => string() eq 'sequence'] => empty()]
                                 [ancestor::*[contains-token(@class, 'topic/linklist')] => empty()]"/>
        <xsl:if test="$children => exists()">
            <ul>
                <xsl:call-template name="getAttributeSet">
                    <xsl:with-param name="prmAttrSetName" select="'atsUlChildLinks'"/>
                </xsl:call-template>
                <xsl:apply-templates select="$children" mode="MODE_PROCESS_CHILDREN"/>
            </ul>
        </xsl:if>
    </xsl:template>
    
    <!--
    function:   Generate child links outside of linklists in in @collection-type = "ordered/sequence"
    param:      none
    return:     ol, etc
    note:       current context is related-links 
    -->
    <xsl:template name="genOlChildLinks">
        <xsl:variable name="children" as="element()*"
            select="descendant::*[contains-token(@class, 'topic/link')]
                                 [@role => string() eq 'child']
                                 [parent::*[@collection-type => string() eq 'sequence'] => exists()]
                                 [ancestor::*[contains-token(@class, 'topic/linklist')] => empty()]"/>
        <xsl:if test="$children => exists()">
            <ol>
                <xsl:call-template name="getAttributeSet">
                    <xsl:with-param name="prmAttrSetName" select="'atsOlChildLinks'"/>
                </xsl:call-template>
                <xsl:apply-templates select="$children" mode="MODE_PROCESS_CHILDREN"/>
            </ol>
        </xsl:if>
    </xsl:template>

    <!--
    function:   Child link processing 
    param:      none
    return:     li
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/link')]" mode="MODE_PROCESS_CHILDREN">
        <li>
            <xsl:call-template name="genCommonAtts"/>
            <a>
                <xsl:call-template name="genLinkAtt"/>
                <!--use linktext as linktext if it exists, otherwise use href as linktext-->
                <xsl:choose>
                    <xsl:when test="*[contains-token(@class, 'topic/linktext')]">
                        <xsl:apply-templates select="*[contains-token(@class, 'topic/linktext')]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@href"/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </li>
    </xsl:template>
    
    <!--
    function:   Generate links for next/previous/parent
    param:      none
    return:     
    note:       current context is related-links
    -->
    <xsl:template name="genNextPrevParentLinks">
        <xsl:variable name="nextPrevParentLinks" as="element()*">
            <xsl:sequence select="descendant::*[contains-token(@class, 'topic/link')]
                [@role => string() eq 'parent']
                [$gpOutputParentLink]"/>
            <xsl:sequence select="descendant::*[contains-token(@class, 'topic/link')]
                [@role => string() eq 'next']
                [$gpOutputNextPreviousLinks]"/>
            <xsl:sequence select="descendant::*[contains-token(@class, 'topic/link')]
                [@role => string() eq 'previous']
                [$gpOutputNextPreviousLinks]"/>
        </xsl:variable>
        <xsl:if test="$nextPrevParentLinks => exists()">
            <div>
                <xsl:call-template name="getAttributeSet">
                    <xsl:with-param name="prmAttrSetName" select="'atsFamilyLinks'"/>
                </xsl:call-template>
                <xsl:apply-templates select="$nextPrevParentLinks[@role => string() eq 'parent']"/>
                <xsl:apply-templates select="$nextPrevParentLinks[@role => string() eq 'previous']"/>
                <xsl:apply-templates select="$nextPrevParentLinks[@role => string() eq 'next']"/>
            </div>
        </xsl:if>
    </xsl:template>
    
    <!--
    function:   Creating actual link 
    param:      none
    return:     a
    note:       current context is link
    -->
    <xsl:template name="makeLink">
        <a>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genLinkAtt"/>
            <xsl:choose>
                <xsl:when test="*[contains-token(@class, 'topic/linktext')]">
                    <xsl:apply-templates select="*[contains-token(@class, 'topic/linktext')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </a>
    </xsl:template>

    <!--
    function:   Creating parent link 
    param:      none
    return:     div
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/link')][@role/string() eq 'parent']">
        <div>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsParentLink'"/>
            </xsl:call-template>
            <span>
                <xsl:call-template name="getAttributeSet">
                    <xsl:with-param name="prmAttrSetName" select="'atsLinkLabel'"/>
                </xsl:call-template>
                <xsl:call-template name="getVarValueAsText">
                    <xsl:with-param name="prmVarName" select="'Parent_Topic'"/>
                </xsl:call-template>
            </span>
            <xsl:call-template name="makeLink"/>
        </div>
    </xsl:template>

    <!--
    function:   Creating next link 
    param:      none
    return:     div
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/link')][@role => string() eq 'next']" priority="5">
        <div>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsNextLink'"/>
            </xsl:call-template>
            <span>
                <xsl:call-template name="getAttributeSet">
                    <xsl:with-param name="prmAttrSetName" select="'atsLinkLabel'"/>
                </xsl:call-template>
                <xsl:call-template name="getVarValueAsText">
                    <xsl:with-param name="prmVarName" select="'Next_Topic'"/>
                </xsl:call-template>
            </span>
            <xsl:call-template name="makeLink"/>
        </div>
    </xsl:template>

    <!--
    function:   Creating previous link 
    param:      none
    return:     div
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/link')][@role => string() eq 'previous']">
        <div>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsPreviousLink'"/>
            </xsl:call-template>
            <span>
                <xsl:call-template name="getAttributeSet">
                    <xsl:with-param name="prmAttrSetName" select="'atsLinkLabel'"/>
                </xsl:call-template>
                <xsl:call-template name="getVarValueAsText">
                    <xsl:with-param name="prmVarName" select="'Previous_Topic'"/>
                </xsl:call-template>
            </span>
            <xsl:call-template name="makeLink"/>
        </div>
    </xsl:template>

    <!--
    function:   Creating friend links 
    param:      none
    return:     div
    note:       current context is related-links
    -->
    <xsl:template name="genFriendLinks">
        <xsl:variable name="friendLinks" as="element()*">
            <xsl:sequence select="descendant::*[contains-token(@class, 'topic/link')]
                                               [@role => string() = ('','friend')]"/>
        </xsl:variable>
        <xsl:if test="exists($friendLinks)">
            <div>
                <xsl:call-template name="getAttributeSet">
                    <xsl:with-param name="prmAttrSetName" select="'atsFriendLinks'"/>
                </xsl:call-template>
                <span>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsFriendLinksLabel'"/>
                    </xsl:call-template>
                    <xsl:call-template name="getVarValueAsText">
                        <xsl:with-param name="prmVarName" select="'Related_Topic'"/>
                    </xsl:call-template>
                </span>
                <ul>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsFriendLinksUl'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="$friendLinks"/>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    
    <!--
    function:   Friend link processing 
    param:      none
    return:     li
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/link')][@role => string() = ('','friend')]">
        <li>
            <xsl:call-template name="genCommonAtts"/>
            <a>
                <xsl:call-template name="genLinkAtt"/>
                <!--use linktext as linktext if it exists, otherwise use href as linktext-->
                <xsl:choose>
                    <xsl:when test="*[contains-token(@class, 'topic/linktext')]">
                        <xsl:apply-templates select="*[contains-token(@class, 'topic/linktext')]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@href"/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </li>
    </xsl:template>

    <!--
    function:   Linktext and desc processing 
    param:      none
    return:     node
    note:       
    -->
    <xsl:template match="*[contains-token(@class, 'topic/linktext')]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*[contains-token(@class, 'topic/link')]/*[contains-token(@class, 'topic/desc')]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--
    function:   Link attribute processing 
    param:      none
    return:     li
    note:       current context is link
    -->
    <xsl:template name="genLinkAtt">
        <xsl:param name="prmLinkElem" as="element()" required="no" select="."/>
        <xsl:call-template name="ahf:genHrefAtt">
            <xsl:with-param name="prmLinkElem" select="$prmLinkElem"/>
        </xsl:call-template>
        <xsl:copy-of select="ahf:genLinkTargetAtt($prmLinkElem)"/>
    </xsl:template>

    <!--
    function:   Link target attribute processing 
    param:      prmLinkElem
    return:     attribute()?
    note:       determine how target page open
                @target="_blank" forces browsers to open another window
    -->
    <xsl:function name="ahf:genLinkTargetAtt" as="attribute()?">
        <xsl:param name="prmLinkElem" as="element()"/>
        <xsl:if test="$prmLinkElem/@scope => string() eq 'external' or $prmLinkElem/@type =>string() eq 'external' or ((lower-case($prmLinkElem/@format) eq 'pdf') and not($prmLinkElem/@scope/string() eq 'local'))">
            <xsl:attribute name="target">_blank</xsl:attribute>
        </xsl:if>
    </xsl:function>
    
</xsl:stylesheet>

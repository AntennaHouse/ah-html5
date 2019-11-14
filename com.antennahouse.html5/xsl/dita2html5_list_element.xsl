<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    List Element Templates
    **************************************************************
    File Name : dita2html5_list_element.xsl
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
    function:   ul template
    param:      none
    return:     ul
    note:              
    -->
    <xsl:template match="*[@class => contains-token('topic/ul')]">
        <xsl:variable name="ul" as="element()" select="."/>
        <xsl:variable name="compactOutputClass" as="xs:string" select="ahf:getCompactOutputClass(.)"/>
        <xsl:variable name="ulStyleClass" as="xs:string+">
            <xsl:call-template name="getVarValueAsStringSequence">
                <xsl:with-param name="prmVarName" select="'Ul_Style_Class_Html'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ulStyleClass" as="xs:string" select="ahf:getUlStyleClass($ul, $ulStyleClass)"/>
        <ul>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$compactOutputClass || ' ' || $ulStyleClass"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates select="*[@class => contains-token('topic/li')]">
                <xsl:with-param name="prmCompactOutputClass" select="$compactOutputClass"/>
            </xsl:apply-templates>
        </ul>
        <xsl:if test="not($gpOutputFnAtEndOfTopic)">
            <xsl:call-template name="genFootNoteList">
                <xsl:with-param name="prmElement" select="."/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- 
     function:  Get ul bullet format
     param:     prmUl, prmUlStyleStype
     return:    @class attribute string
     note:      
     -->
    <xsl:function name="ahf:getUlStyleClass" as="xs:string">
        <xsl:param name="prmUl" as="element()"/>
        <xsl:param name="prmUlStyleClass" as="xs:string+"/>
        
        <xsl:variable name="ulStyleClassCount" as="xs:integer" select="count($prmUlStyleClass)"/>
        <xsl:variable name="ulNestLevel" select="ahf:countUl($prmUl,0)" as="xs:integer"/>
        <xsl:variable name="styleOrder" as="xs:integer">
            <xsl:variable name="tempStyleOrder" as="xs:integer" select="$ulNestLevel mod $ulStyleClassCount"/>
            <xsl:sequence select="if ($tempStyleOrder eq 0) then $ulStyleClassCount else $tempStyleOrder"/>
        </xsl:variable>
        <xsl:sequence select="$prmUlStyleClass[$styleOrder]"/>
    </xsl:function>

    <!--
    function:   count ul
    param:      prmElement, prmCount
    return:     xs:integer
    note:              
    -->
    <xsl:function name="ahf:countUl" as="xs:integer">
        <xsl:param name="prmElement" as="element()"/>
        <xsl:param name="prmCount" as="xs:integer"/>
        
        <xsl:variable name="count" select="if ($prmElement[@class => contains-token('topic/ul')]) then ($prmCount + 1) else $prmCount"/>
        <xsl:choose>
            <xsl:when test="$prmElement[@class => ahf:seqContainsToken(('topic/entry','topic/stentry'))]">
                <xsl:sequence select="$count"/>
            </xsl:when>
            <xsl:when test="$prmElement[@class => contains-token('topic/note')]">
                <xsl:sequence select="$count"/>
            </xsl:when>
            <xsl:when test="$prmElement[@class => contains-token('topic/topic')]">
                <xsl:sequence select="$count"/>
            </xsl:when>
            <xsl:when test="$prmElement/parent::*">
                <xsl:sequence select="ahf:countUl($prmElement/parent::*, $count)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$count"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!--
    function:   ol template
    param:      none
    return:     ol
    note:              
    -->
    <xsl:template match="*[@class => contains-token('topic/ol')]">
        <xsl:variable name="ol" as="element()" select="."/>
        <xsl:variable name="compactOutputClass" as="xs:string" select="ahf:getCompactOutputClass(.)"/>
        <xsl:variable name="olStyleClass" as="xs:string+">
            <xsl:call-template name="getVarValueAsStringSequence">
                <xsl:with-param name="prmVarName" select="'Ol_Style_Class_Html'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="olStyleClass" as="xs:string" select="ahf:getOlStyleClass($ol, $olStyleClass)"/>
        <ol>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$compactOutputClass || ' ' || $olStyleClass"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates select="*[@class => contains-token('topic/li')]">
                <xsl:with-param name="prmCompactOutputClass" select="$compactOutputClass"/>
            </xsl:apply-templates>
        </ol>
        <xsl:if test="not($gpOutputFnAtEndOfTopic)">
            <xsl:call-template name="genFootNoteList">
                <xsl:with-param name="prmElement" select="."/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!--
    function:   get ol style class
    param:      prmOl
    return:     xs:string
    note:              
    -->
    <xsl:template name="getOlStyleClass" as="xs:string">
        <xsl:param name="prmOl" as="element()" required="no" select="."/>
        <xsl:variable name="olStyleClass" as="xs:string+">
            <xsl:call-template name="getVarValueWithLangAsStringSequence">
                <xsl:with-param name="prmVarName" select="'Ol_Style_Class_Html'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="olStyleClass" as="xs:string" select="ahf:getOlStyleClass($prmOl,$olStyleClass)"/>
        <xsl:sequence select="$olStyleClass"/>
    </xsl:template>
    
    <!-- 
     function:  Get ol number format
     param:     prmOl, prmOlNumberFormat
     return:    Number format string
     note:      
     -->
    <xsl:function name="ahf:getOlNumberFormat" as="xs:string">
        <xsl:param name="prmOl" as="element()"/>
        <xsl:param name="prmOlNumberFormat" as="xs:string+"/>
        
        <xsl:variable name="olNumberFormatCount" as="xs:integer" select="count($prmOlNumberFormat)"/>
        <xsl:variable name="olNestLevel" select="ahf:countOl($prmOl,0)" as="xs:integer"/>
        <xsl:variable name="numberOrder" as="xs:integer">
            <xsl:variable name="tempNumberOrder" as="xs:integer" select="$olNestLevel mod $olNumberFormatCount"/>
            <xsl:sequence select="if ($tempNumberOrder eq 0) then $olNumberFormatCount else $tempNumberOrder"/>
        </xsl:variable>
        <xsl:sequence select="$prmOlNumberFormat[$numberOrder]"/>
    </xsl:function>
    
    <xsl:function name="ahf:getOlStyleClass" as="xs:string">
        <xsl:param name="prmOl" as="element()"/>
        <xsl:param name="prmOlStyleClass" as="xs:string+"/>
        
        <xsl:variable name="olStyleClassCount" as="xs:integer" select="count($prmOlStyleClass)"/>
        <xsl:variable name="olNestLevel" select="ahf:countOl($prmOl,0)" as="xs:integer"/>
        <xsl:variable name="styleOrder" as="xs:integer">
            <xsl:variable name="tempStyleOrder" as="xs:integer" select="$olNestLevel mod $olStyleClassCount"/>
            <xsl:sequence select="if ($tempStyleOrder eq 0) then $olStyleClassCount else $tempStyleOrder"/>
        </xsl:variable>
        <xsl:sequence select="$prmOlStyleClass[$styleOrder]"/>
    </xsl:function>

    <!--
    function:   count ol
    param:      prmElement, prmCount
    return:     xs:integer
    note:              
    -->
    <xsl:function name="ahf:countOl" as="xs:integer">
        <xsl:param name="prmElement" as="element()"/>
        <xsl:param name="prmCount" as="xs:integer"/>
        
        <xsl:variable name="count" select="if ($prmElement[contains-token(@class, 'topic/ol')]) then ($prmCount + 1) else $prmCount"/>
        <xsl:choose>
            <xsl:when test="$prmElement[ahf:seqContainsToken(@class, ('topic/entry','topic/stentry'))]">
                <xsl:sequence select="$count"/>
            </xsl:when>
            <xsl:when test="$prmElement[contains-token(@class, 'topic/note')]">
                <xsl:sequence select="$count"/>
            </xsl:when>
            <xsl:when test="$prmElement[contains-token(@class, 'topic/topic')]">
                <xsl:sequence select="$count"/>
            </xsl:when>
            <xsl:when test="$prmElement/parent::*">
                <xsl:sequence select="ahf:countOl($prmElement/parent::*, $count)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$count"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--
    function:   li template
    param:      none
    return:     li
    note:       $prmCompactOutputClass isn't mandatory because there is specializtion of li that is not the child of ol/ul.
    -->
    <xsl:template match="*[contains-token(@class, 'topic/li')]">
        <xsl:param name="prmCompactOutputClass" as="xs:string" required="no" select="''"/>
        <li>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$prmCompactOutputClass"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <!--
    function:   dl template
    param:      none
    return:     dl
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/dl')]">
        <xsl:variable name="compactOutputClass" as="xs:string" select=". => ahf:getCompactOutputClass()"/>
        <dl>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$compactOutputClass"/>
            </xsl:call-template>
            <xsl:apply-templates select="*[contains-token(@class,'topic/dlentry')]">
                <xsl:with-param name="prmCompactOutputClass" tunnel="yes" select="$compactOutputClass"/>
            </xsl:apply-templates>
        </dl>
        <xsl:if test="not($gpOutputFnAtEndOfTopic)">
            <xsl:call-template name="genFootNoteList">
                <xsl:with-param name="prmElement" select="."/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!--
    function:   dlentry template
    param:      none
    return:     none
    note:       In HTML no corresponding elements exists for dlentry.
                The child of dl is dt or dd.
    -->
    <xsl:template match="*[contains-token(@class, 'topic/dlentry')]">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
    function:   dt template
    param:      none
    return:     dt
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/dt')]">
        <xsl:param name="prmCompactOutputClass" as="xs:string" tunnel="yes" required="yes"/>
        <dt>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$prmCompactOutputClass"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </dt>
    </xsl:template>

    <!--
    function:   dd template
    param:      none
    return:     dd
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/dd')]">
        <xsl:param name="prmCompactOutputClass" as="xs:string" tunnel="yes" required="yes"/>
        <xsl:variable name="isFirstDd" as="xs:boolean" select="preceding-sibling::*[contains-token(@class,'topic/dd')] => exists()"/>
        <dd>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$prmCompactOutputClass"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </dd>
    </xsl:template>
    
    <!--
    function:   dl (with dlhead) template
    param:      none
    return:     table
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/dl')][*[contains-token(@class,'topic/dlhead')] => exists()]" priority="5">
        <table>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('DL_Table')"/>
            </xsl:call-template>
            <thead>
                <xsl:call-template name="genClassAtt">
                    <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('DL_Dlhead_Thead')"/>
                </xsl:call-template>
                <tr>
                    <xsl:call-template name="genClassAtt">
                        <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('DL_Dlhead_Tr')"/>
                    </xsl:call-template>
                    <th>
                        <xsl:call-template name="genClassAtt">
                            <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('DL_Dlhead_Th')"/>
                        </xsl:call-template>
                        <xsl:apply-templates select="*[contains-token(@class,'topic/dlhead')]/*[contains-token(@class,'topic/dthd')]"/>
                    </th>
                    <th>
                        <xsl:call-template name="genClassAtt">
                            <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('DL_Dlhead_Th')"/>
                        </xsl:call-template>
                        <xsl:apply-templates select="*[contains-token(@class,'topic/dlhead')]/*[contains-token(@class,'topic/ddhd')]"/>
                    </th>
                </tr>
            </thead>
            <tbody>
                <xsl:call-template name="genClassAtt">
                    <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('DL_Tbody')"/>
                </xsl:call-template>
                <xsl:apply-templates select="*[contains-token(@class,'topic/dlentry')]" mode="MODE_DL_AS_TABLE">
                    <xsl:with-param name="prmIsCompact" tunnel="yes" select="ahf:isCompact(.)"/>
                </xsl:apply-templates>
            </tbody>
        </table>
        <xsl:if test="not($gpOutputFnAtEndOfTopic)">
            <xsl:call-template name="genFootNoteList">
                <xsl:with-param name="prmElement" select="."/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!--
    function:   dthead template
    param:      none
    return:     span
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/dthd')]">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--
    function:   ddhead template
    param:      none
    return:     span
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/ddhd')]">
        <span>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!--
    function:   dlentry template (table mode)
    param:      none
    return:     tr
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/dlentry')]" mode="MODE_DL_AS_TABLE">
        <tr>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('DL_Dlentry_Tr')"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <td>
                <xsl:call-template name="genCommonAtts">
                    <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('DL_Dt_Td')"/>
                </xsl:call-template>
                <xsl:apply-templates select="*[contains-token(@class,'topic/dt')]" mode="#current"/>
            </td>
            <td>
                <xsl:call-template name="genCommonAtts">
                    <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('DL_Dd_Td')"/>
                </xsl:call-template>
                <xsl:apply-templates select="*[contains-token(@class,'topic/dd')]" mode="#current"/>
            </td>
        </tr>
    </xsl:template>

    <!--
    function:   dt template (dl with dlhead)
    param:      none
    return:     span, etc
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/dt')]" mode="MODE_DL_AS_TABLE">
        <xsl:variable name="dt" as="element()" select="."/>
        <xsl:if test="$dt/preceding-sibling::*[contains-token(@class,'topic/dt')] => exists()">
            <br/>
        </xsl:if>
        <span>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="ahf:getVarValue('DL_Dt_Span')"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!--
    function:   dd template
    param:      none
    return:     dd
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/dd')]" mode="MODE_DL_AS_TABLE">
        <xsl:variable name="dd" as="element()" select="."/>
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--
    function:   sl template
    param:      none
    return:     ul
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/sl')]">
        <xsl:variable name="compactOutputClass" as="xs:string" select="ahf:getCompactOutputClass(.)"/>
        <ul>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$compactOutputClass"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates>
                <xsl:with-param name="prmCompactOutputClass" select="$compactOutputClass"/>
            </xsl:apply-templates>
        </ul>
    </xsl:template>
    
    <!--
    function:   sli template
    param:      none
    return:     li
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/sli')]">
        <xsl:param name="prmCompactOutputClass" as="xs:string" required="yes"/>
        <li>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$prmCompactOutputClass"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <!--
    function:   get @compact outputclass
    param:      ol,ul,sl,dl
    return:     xs:string
    note:              
    -->
    <xsl:variable name="compactClassToken" as="xs:string">
        <xsl:call-template name="getVarValue">
            <xsl:with-param name="prmVarName" select="'Compact_Class_Token'"/>
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:function name="ahf:getCompactOutputClass" as="xs:string">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:sequence select="if ($prmElem/@compact => string() eq $cYes) then $compactClassToken else ''"/>
    </xsl:function>

    <!--
    function:   Return @compact="yes" or not
    param:      ol,ul,sl,dl
    return:     xs:string
    note:              
    -->
    <xsl:function name="ahf:isCompact" as="xs:boolean">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:sequence select="$prmElem/@compact => string() eq 'yes'"/>
    </xsl:function>

</xsl:stylesheet>

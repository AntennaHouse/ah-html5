<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Table Element Templates
    **************************************************************
    File Name : dita2html5_table_element.xsl
    **************************************************************
    Copyright © 2008-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:style="http://www.antennahouse.com/names/XSLT/Document/Layout"
    exclude-result-prefixes="xs ahf style dita-ot"
    version="3.0">

    <!--
    function:   table template
    param:      none
    return:     div
    note:              
    -->
    <xsl:template match="*[contains-token(@class, 'topic/table')]">
        <xsl:variable name="tableAttr" select="ahf:getTableAttr(.)" as="element()"/>
        <div>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmApplyDefaultFrameAtt" select="false()"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates select="*[contains-token(@class, 'topic/tgroup')]">
                <xsl:with-param name="prmTable" tunnel="yes" select="."/>
                <xsl:with-param name="prmTableAttr" tunnel="yes" select="$tableAttr"/>
            </xsl:apply-templates>
            <xsl:if test="not($gpOutputFnAtEndOfTopic)">
                <xsl:call-template name="genFootNoteList">
                    <xsl:with-param name="prmElement" select="."/>
                </xsl:call-template>
            </xsl:if>
        </div>
    </xsl:template>

    <!-- 
     function:  build table attributes
     param:     prmTable
     return:    element()
     note:		
     -->
    <xsl:function name="ahf:getTableAttr" as="element()">
        <xsl:param name="prmTable" as="element()"/>
        <dummy>
            <xsl:attribute name="frame"  select="if (exists($prmTable/@frame))  then string($prmTable/@frame) else 'all'"/>
            <xsl:attribute name="colsep" select="if (exists($prmTable/@colsep)) then string($prmTable/@colsep) else '1'"/>
            <xsl:attribute name="rowsep" select="if (exists($prmTable/@rowsep)) then string($prmTable/@rowsep) else '1'"/>
            <xsl:attribute name="pgwide" select="if (exists($prmTable/@pgwide)) then string($prmTable/@pgwide) else '0'"/>
            <xsl:attribute name="rowheader" select="if (exists($prmTable/@rowheader)) then string($prmTable/@rowheader) else 'norowheader'"/>
            <xsl:if test="$prmTable/@scale => exists()">
                <xsl:attribute name="scale"  select="$prmTable/@scale => string()"/>
            </xsl:if>
            <xsl:copy-of select="$prmTable/@class"/>
        </dummy>
    </xsl:function>
    
    <!-- 
     function:  tgroup template
     param:     prmTableAttr and etc
     return:    table
     note:      
     -->
    <xsl:template match="*[contains-token(@class, 'topic/tgroup')]">
        <xsl:param name="prmTable" required="yes" tunnel="yes" as="element()"/>
        <xsl:param name="prmTableAttr" required="yes" tunnel="yes" as="element()"/>
        
        <xsl:variable name="tgroup" as="element()" select="."/>
        <xsl:variable name="tgroupAttr" select="ahf:addTgroupAttr(.,$prmTableAttr)" as="element()"/>
        <xsl:variable name="normalizedColSpec" as="element()+">
            <xsl:call-template name="genNormalizeColSpec"/>
        </xsl:variable>
        <table>
            <!-- @frame is processed here! -->
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmElement" select="$prmTableAttr"/>
                <xsl:with-param name="prmDefaultOutputClass" select="if ($prmTableAttr/@pgwide => string() eq '1') then 'table-pgwide-1' else ''"/>
            </xsl:call-template>
            <xsl:call-template name="genTableCaption">
                <xsl:with-param name="prmTable" select="$prmTable"/>
                <xsl:with-param name="prmTgroup" select="$tgroup"/>
            </xsl:call-template>
            <xsl:call-template name="genTableColGroup">
                <xsl:with-param name="prmNormalizedColSpec" select="$normalizedColSpec"/>
            </xsl:call-template>
            <xsl:if test="*[contains-token(@class,'topic/thead')]">
                <xsl:apply-templates select="*[contains-token(@class, 'topic/thead')]">
                    <xsl:with-param name="prmTgroup"     tunnel="yes" select="$tgroup"/>
                    <xsl:with-param name="prmTgroupAttr" tunnel="yes" select="$tgroupAttr"/>
                    <xsl:with-param name="prmColSpec"    tunnel="yes" select="$normalizedColSpec"/>
                </xsl:apply-templates>
            </xsl:if>
            <xsl:apply-templates select="*[contains-token(@class, 'topic/tbody')]">
                <xsl:with-param name="prmTgroup"     tunnel="yes" select="$tgroup"/>
                <xsl:with-param name="prmTgroupAttr" tunnel="yes" select="$tgroupAttr"/>
                <xsl:with-param name="prmColSpec"    tunnel="yes" select="$normalizedColSpec"/>
            </xsl:apply-templates>
        </table>
    </xsl:template>
    
    <!-- 
     function:  build tgroup attributes
     param:     prmTgroup, prmTableAttr
     return:    element()
     note:
     -->
    <xsl:function name="ahf:addTgroupAttr" as="element()">
        <xsl:param name="prmTgroup"    as="element()"/>
        <xsl:param name="prmTableAttr" as="element()"/>
        <dummy>
            <xsl:copy-of select="$prmTableAttr/@*"/>
            <xsl:copy-of select="$prmTgroup/@cols"/>
            <xsl:copy-of select="$prmTgroup/@colsep"/>
            <xsl:copy-of select="$prmTgroup/@rowsep"/>
            <xsl:copy-of select="$prmTgroup/@align"/>
            <xsl:attribute name="cols" select="$prmTgroup/@cols"/>
        </dummy>
    </xsl:function>

    <!-- 
     function:  build table caption
     param:     prmTgroup, prmTableTitle, $prmTableDesc
     return:    element()
     note:
     -->
    <xsl:template name="genTableCaption" as="element()?">
        <xsl:param name="prmTable"  as="element()" required="yes"/>
        <xsl:param name="prmTgroup" as="element()" required="yes"/>

        <xsl:variable name="tableTitle" as="element()?" select="$prmTable/*[contains-token(@class,'topic/title')]"/>
        <xsl:variable name="tableDesc" as="element()?" select="$prmTable/*[contains-token(@class,'topic/desc')]"/>
        <xsl:variable name="isFirstTgroup" as="xs:boolean" select="$prmTgroup/preceding-sibling::*[contains-token(@class, 'topic/tgroup')] => empty()"/>
        <xsl:variable name="outputTableCaption" as="xs:boolean" select="$isFirstTgroup and ($tableTitle => exists() or $tableDesc=> exists())"/>
        
        <xsl:if test="$outputTableCaption">
            <xsl:variable name="tableCount" as="xs:integer" select="count($prmTable/preceding::*[contains-token(@class, 'topic/table')]/*[contains-token(@class, 'topic/title')]) + 1"/>
            <caption>
                <span class="table-title-label">
                    <xsl:call-template name="genCommonAtts">
                        <xsl:with-param name="prmElement" select="$tableTitle"/>
                    </xsl:call-template>
                    <xsl:call-template name="getVarValueAsText">
                        <xsl:with-param name="prmVarName" select="'Table_Title'"/>
                    </xsl:call-template>
                    <xsl:value-of select="$tableCount"/>
                    <xsl:text> </xsl:text>
                </span>
                <xsl:choose>
                    <xsl:when test="$tableTitle => exists()">
                        <xsl:apply-templates select="$tableTitle/node()"/>
                        <xsl:if test="$tableDesc => exists()">
                            <xsl:text>.</xsl:text>
                            <br/>
                            <span>
                                <xsl:call-template name="genCommonAtts">
                                    <xsl:with-param name="prmElement" select="$tableDesc"/>
                                    <xsl:with-param name="prmDefaultOutputClass" select="'desc'"/>
                                </xsl:call-template>
                                <xsl:apply-templates select="$tableDesc/node()"/>
                            </span>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$tableDesc => exists()">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$tableDesc"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="'desc'"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$tableDesc/node()"/>
                        </span>
                    </xsl:when>
                </xsl:choose>
            </caption>
        </xsl:if>
    </xsl:template>

    <!-- 
     function:  build normalized colspec
     param:     prmTgroup
     return:    element()+
     note:
     -->
    <xsl:template name="genNormalizeColSpec" as="element()+">
        <xsl:param name="prmTgroup" as="element()" required="no" select="."/>
        
        <xsl:variable name="colspec" as="element()*" select="$prmTgroup/*[contains-token(@class,'topic/colspec')]"/>
        <xsl:variable name="cols" as="xs:integer" select="$prmTgroup/@cols => xs:integer()"/>
        <xsl:variable name="normalizedColSpec" as="element()+">
            <xsl:for-each select="1 to $cols">
                <xsl:variable name="colCount" as="xs:integer" select="."/>
                <xsl:choose>
                    <xsl:when test="$colspec[@colnum => xs:integer() eq $colCount] => exists()">
                        <xsl:variable name="currentColspec" as="element()" select="$colspec[$colCount]"/>
                        <xsl:copy select="$currentColspec">
                            <xsl:copy-of select="$currentColspec/@*"/>
                            <xsl:attribute name="colwidth" select="if ($currentColspec/@colwidth => contains('*')) then substring-before($currentColspec/@colwidth,'*') else '1'"/>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:otherwise>
                        <colspec class="- topic/colspec" colnum="{$colCount}" colname="{concat('col',$colCount)}" colwidth="1"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:sequence select="$normalizedColSpec"/>
    </xsl:template>

    <!-- 
     function:  build colgroup
     param:     prmTgroup
     return:    element()
     note:
     -->
    <xsl:template name="genTableColGroup" as="element()">
        <xsl:param name="prmNormalizedColSpec" as="element()+" required="yes"/>
        <xsl:variable name="cols" select="count($prmNormalizedColSpec)"/>
        <xsl:variable name="colWidthSum" as="xs:double" select="sum($prmNormalizedColSpec/@colwidth/string() ! xs:double(.))"/>
        <colgroup>
            <xsl:for-each select="1 to $cols">
                <xsl:variable name="colWidth" as="xs:double" select="$prmNormalizedColSpec[current()]/@colwidth => xs:double() div $colWidthSum * 100"/>
                <col>
                    <xsl:attribute name="style" select="concat('width:',$colWidth,'%')"></xsl:attribute>
                </col>
            </xsl:for-each>
        </colgroup>
    </xsl:template>

    <!-- 
     function:   thead template
     param:      prmTgroup, prmTgroupAttr, prmColSpec, etc
     return:     thead
     note:       
     -->
    <xsl:template match="*[contains-token(@class, 'topic/thead')]">
        <xsl:param name="prmTgroup"     as="element()" tunnel="yes" required="yes"/>
        <xsl:param name="prmTgroupAttr" as="element()" tunnel="yes" required="yes"/>
        <xsl:param name="prmColSpec"    as="element()+" tunnel="yes" required="yes"/>
        
        <xsl:variable name="thead" as="element()" select="."/>
        <xsl:variable name="theadInfo" as="element()">
            <xsl:call-template name="expandTheadOrTbodyWithSpanInfo">
                <xsl:with-param name="prmColNumber" select="$prmTgroup/@cols => xs:integer()"/>
                <xsl:with-param name="prmColSpec" select="$prmColSpec"/>
                <xsl:with-param name="prmTableHeadOrBodyPart" select="$thead"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:if test="$gpDebug">
            <xsl:result-document href="{$gpOutputDirUrl || ahf:getHistoryStr(.) || '.xml'}" method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes">
                <xsl:copy-of select="$theadInfo"/>
            </xsl:result-document>
        </xsl:if>
        
        <xsl:variable name="theadAttr" as="element()" select="ahf:addTheadAttr($thead,$prmTgroupAttr)"/>
        <thead>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:apply-templates select="*[contains-token(@class, 'topic/row')]">
                <xsl:with-param name="prmThead"        tunnel="yes" select="$thead"/>
                <xsl:with-param name="prmRowUpperAttr" tunnel="yes" select="$theadAttr"/>
                <xsl:with-param name="prmColSpec"      tunnel="yes" select="$prmColSpec"/>
                <xsl:with-param name="prmIsInThead"    tunnel="yes" select="true()"/>
                <xsl:with-param name="prmTheadOrTbodyInfo" tunnel="yes" as="element()" select="$theadInfo"/>
            </xsl:apply-templates>
        </thead>
    </xsl:template>
    
    <!-- 
     function:  build thead attributes
     param:     prmThead, prmTgroupAttr
     return:    element()
     note:		
     -->
    <xsl:function name="ahf:addTheadAttr" as="element()">
        <xsl:param name="prmThead"      as="element()"/>
        <xsl:param name="prmTgroupAttr" as="element()"/>
        <dummy>
            <xsl:copy-of select="$prmTgroupAttr/@*"/>
            <xsl:copy-of select="$prmThead/@valign"/>
        </dummy>
    </xsl:function>
    
    <!-- 
     function:  tbody template
     param:     prmTgroupAttr, prmColSpec
     return:    fo:table-body
     note:		
     -->
    <xsl:template match="*[contains-token(@class, 'topic/tbody')]">
        <xsl:param name="prmTgroup"     as="element()" tunnel="yes" required="yes"/>
        <xsl:param name="prmTgroupAttr" as="element()" tunnel="yes" required="yes"/>
        <xsl:param name="prmColSpec"    as="element()+" tunnel="yes" required="yes"/>

        <xsl:variable name="tbody" as="element()" select="."/>
        <xsl:variable name="tbodyInfo" as="element()">
            <xsl:call-template name="expandTheadOrTbodyWithSpanInfo">
                <xsl:with-param name="prmColNumber" select="$prmTgroup/@cols => xs:integer()"/>
                <xsl:with-param name="prmColSpec" select="$prmColSpec"/>
                <xsl:with-param name="prmTableHeadOrBodyPart" select="$tbody"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:if test="$gpDebug">
            <xsl:result-document href="{$gpOutputDirUrl || ahf:getHistoryStr($tbody) || '.xml'}" method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes">
                <xsl:copy-of select="$tbodyInfo"/>
            </xsl:result-document>
        </xsl:if>

        <xsl:variable name="tbodyAttr"  as="element()" select="ahf:addTbodyAttr($tbody,$prmTgroupAttr)"/>
        <tbody>
            <xsl:apply-templates select="*[contains-token(@class, 'topic/row')]">
                <xsl:with-param name="prmTbody"        tunnel="yes" select="$tbody"/>
                <xsl:with-param name="prmRowUpperAttr" tunnel="yes" select="$tbodyAttr"/>
                <xsl:with-param name="prmTheadOrTbodyInfo" tunnel="yes" as="element()" select="$tbodyInfo"/>
            </xsl:apply-templates>
        </tbody>
    </xsl:template>

    <!-- 
     function:  build tbody attributes
     param:     prmTbody, prmTgroupAttr
     return:    element()
     note:		
     -->
    <xsl:function name="ahf:addTbodyAttr" as="element()">
        <xsl:param name="prmTbody"      as="element()"/>
        <xsl:param name="prmTgroupAttr" as="element()"/>
        <dummy>
            <xsl:copy-of select="$prmTgroupAttr/@*"/>
            <xsl:copy-of select="$prmTbody/@valign"/>
        </dummy>
    </xsl:function>
    
    <!-- 
     function:  row template
     param:     prmRowUpperAttr, prmColSpec
     return:	row
     note:
     -->
    <xsl:template match="*[contains-token(@class, 'topic/row')]">
        <xsl:param name="prmRowUpperAttr" required="yes" tunnel="yes" as="element()"/>
        
        <xsl:variable name="row"  as="element()" select="."/>
        <xsl:variable name="rowAttr"  as="element()" select="ahf:addRowAttr($row,$prmRowUpperAttr)"/>
        <tr>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:apply-templates select="*[contains-token(@class, 'topic/entry')]">
                <xsl:with-param name="prmRow"        tunnel="yes" select="$row"/>
                <xsl:with-param name="prmRowAttr"    tunnel="yes" select="$rowAttr"/>
            </xsl:apply-templates>
        </tr>
    </xsl:template>
    
    <!-- 
     function:	build row attributes
     param:		prmRow, prmRowUpperAttr
     return:	element()
     note:		
     -->
    <xsl:function name="ahf:addRowAttr" as="element()">
        <xsl:param name="prmRow"    as="element()"/>
        <xsl:param name="prmRowUpperAttr" as="element()"/>
        <dummy>
            <xsl:copy-of select="$prmRowUpperAttr/@*"/>
            <xsl:copy-of select="$prmRow/@rowsep"/>
            <xsl:copy-of select="$prmRow/@valign"/>
        </dummy>
    </xsl:function>

    <!-- 
     function:  table header/body entry template
     param:     prmRowAttr, prmColSpec
     return:    th
     note:      refer to DITA specification about @headers
                http://docs.oasis-open.org/dita/dita/v1.3/errata02/os/complete/part3-all-inclusive/langRef/base/table.html#table
     -->
    <xsl:template match="*[contains-token(@class,'topic/thead')]/*[contains-token(@class,'topic/row')]/*[contains-token(@class,'topic/entry')]">
        <xsl:param name="prmRowAttr" required="yes" tunnel="yes" as="element()"/>
        <xsl:param name="prmColSpec" required="yes" tunnel="yes" as="element()*"/>
        
        <xsl:variable name="entry" as="element()" select="."/>
        <th>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass">
                    <xsl:variable name="entryClassAtts">
                        <xsl:call-template name="ahf:getEntryClassAttr">
                            <xsl:with-param name="prmEntry" select="."/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:sequence select="string-join($entryClassAtts,' ')"/>                    
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            
            <!-- colspan -->
            <xsl:if test="$entry/@dita-ot:morecols => exists()">
                <xsl:attribute name="colspan" select="$entry/@dita-ot:morecols => string() => xs:integer() + 1"/>
            </xsl:if>
            
            <!-- rowspan -->
            <xsl:if test="exists($entry/@morerows)">
                <xsl:attribute name="rowspan" select="$entry/@morerows => string() => xs:integer() + 1"/>
            </xsl:if>
            
            <!-- headers -->
            <xsl:call-template name="ahf:getHeadersAttr"/>
            
            <xsl:apply-templates/>
        </th>
    </xsl:template>

    <xsl:template match="*[contains-token(@class,'topic/tbody')]/*[contains-token(@class,'topic/row')]/*[contains-token(@class,'topic/entry')]">
        <xsl:param name="prmRowAttr" required="yes" tunnel="yes" as="element()"/>
        <xsl:param name="prmColSpec" required="yes" tunnel="yes" as="element()+"/>
        
        <xsl:variable name="entry" as="element()" select="."/>
        <xsl:variable name="colPos" as="xs:integer" select="$entry/@dita-ot:x => xs:integer()"/>
        <xsl:variable name="colSpec" as="element()" select="$prmColSpec[$colPos]"/>
        <xsl:variable name="applyTh" as="xs:boolean">
            <xsl:variable name="isTableRowHeader" as="xs:boolean" select="($prmRowAttr/@rowheader => string()) eq 'firstcol'"/>
            <xsl:variable name="isFirstCol" as="xs:boolean" select="$colPos = 1"/>
            <xsl:variable name="isColSpecRowHeader" as="xs:boolean" select="($colSpec/@rowheader => string()) eq 'headers'"/>
            <xsl:sequence select="($isTableRowHeader and $isFirstCol) or $isColSpecRowHeader"/>
        </xsl:variable>
        <xsl:element name="{if ($applyTh) then 'th' else 'td'}">
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass">
                    <xsl:variable name="entryClassAtts">
                        <xsl:call-template name="ahf:getEntryClassAttr">
                            <xsl:with-param name="prmEntry" select="."/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:sequence select="string-join($entryClassAtts,' ')"/>                    
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            
            <!-- colspan -->
            <xsl:if test="$entry/@dita-ot:morecols => exists()">
                <xsl:attribute name="colspan" select="$entry/@dita-ot:morecols => string() => xs:integer() + 1"/>
            </xsl:if>
            
            <!-- rowspan -->
            <xsl:if test="exists($entry/@morerows)">
                <xsl:attribute name="rowspan" select="$entry/@morerows => string() => xs:integer() + 1"/>
            </xsl:if>
            
            <!-- headers -->
            <xsl:call-template name="ahf:getHeadersAttr"/>
            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- 
     function:  get class atttribute value from entry attributes
     param:     prmEntry, prmRowAttr, prmColSpec
     return:	xs:string*
     note:      generates class attribute candidate as xs:string*
                Fix inheritance from colspec/@align DITA-OT bug:
                https://github.com/dita-ot/dita-ot/pull/3538
     -->
    <xsl:template name="ahf:getEntryClassAttr" as="xs:string*">
        <xsl:param name="prmEntry"        as="element()"/>
        <xsl:param name="prmRowAttr"      as="element()"  tunnel="yes" required="yes"/>
        <xsl:param name="prmRow"          as="element()"  tunnel="yes" required="yes"/>
        <xsl:param name="prmColSpec"      as="element()+" tunnel="yes" required="yes"/>
        <xsl:param name="prmTgroup"       as="element()"  tunnel="yes" required="yes"/>
        <xsl:param name="prmTheadOrTbodyInfo" as="element()" tunnel="yes" />
        
        <xsl:variable name="entrySigniture" as="xs:string" select="ahf:getHistoryStr($prmEntry)"/>
        <xsl:variable name="entryInfo" as="element()?" select="$prmTheadOrTbodyInfo/descendant::entry[@ahf:signiture => string() eq $entrySigniture]"/>
        <xsl:assert test="$entryInfo => exists()" select="ahf:genErrMsg($stMes2007,('%file','%path'),($prmEntry/@xtrf => string(), $entrySigniture))"/>
        <xsl:variable name="colnum" as="xs:integer" select="$entryInfo/@ahf:colnum => ahf:nz()"/>
        <xsl:assert test="$colnum gt 0" select="ahf:genErrMsg($stMes2009,('%file','%path'),($prmEntry/@xtrf => string(), $entrySigniture))"/>
        <xsl:variable name="colSpec" as="element()" select="$prmColSpec[$colnum]"/>
        
        <!-- colsep -->
        <xsl:choose>
            <xsl:when test="string($prmRowAttr/@colsep) eq '0'">
                <xsl:sequence select="'colsep-0'"/>
            </xsl:when>
            <xsl:when test="string($prmRowAttr/@colsep) eq '1'">
                <xsl:variable name="cols" as="xs:integer" select="$prmRowAttr/@cols => xs:integer()"/>
                <xsl:variable name="colPos" as="xs:integer" select="$colnum"/>
                <xsl:variable name="colSpan" as="xs:integer" select="$prmEntry/@dita-ot:morecols => ahf:nz()"/>
                <xsl:choose>
                    <xsl:when test="$colPos + $colSpan eq $cols">
                        <xsl:sequence select="'colsep-0'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="'colsep-1'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>

        <!-- rowsep -->
        <xsl:choose>
            <xsl:when test="string($prmRowAttr/@rowsep) eq '0'">
                <xsl:sequence select="'rowsep-0'"/>
            </xsl:when>
            <xsl:when test="string($prmRowAttr/@rowsep) eq '1'">
                <xsl:variable name="rows" as="xs:integer" select="$prmTgroup/*/*[contains-token(@class,'topic/row')] => count()"/>
                <xsl:variable name="rowPos" as="xs:integer" select="$prmEntry/@dita-ot:y => ahf:nz()"/>
                <xsl:variable name="rowSpan" as="xs:integer" select="$prmEntry/@morerows => ahf:nz()"/>
                <xsl:choose>
                    <xsl:when test="$rowPos + $rowSpan eq $rows">
                        <xsl:sequence select="'rowsep-0'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="'rowsep-1'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        
        <!-- align -->
        <xsl:choose>
            <xsl:when test="$prmEntry/@align => exists()">
                <xsl:variable name="align" as="xs:string" select="$prmEntry/@align => string()"/>
                <xsl:choose>
                    <xsl:when test="$align eq 'char'">
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes" select="ahf:replace($stMes250,('entry-pos'),(ahf:getHistoryXpathStr($prmEntry)))"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="concat('align-',$align)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$colSpec/@align => exists()">
                <xsl:variable name="align" as="xs:string" select="$colSpec/@align => string()"/>
                <xsl:choose>
                    <xsl:when test="$align eq 'char'">
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes" select="ahf:replace($stMes250,('%entry-pos'),(ahf:getHistoryXpathStr($prmEntry)))"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="concat('align-',$align)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        
        <!-- valign -->
        <xsl:choose>
            <xsl:when test="$prmEntry/@valign => exists()">
                <xsl:variable name="valign" as="xs:string" select="$prmEntry/@valign => string()"/>
                <xsl:sequence select="'valign-' => concat($valign)"/>
            </xsl:when>
            <xsl:when test="$prmRowAttr/@valign => exists()">
                <xsl:variable name="valign" as="xs:string" select="$prmRowAttr/@valign => string()"/>
                <xsl:sequence select="'valign-' => concat($valign)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- 
     function:  get @headers atttribute for th and td
     param:     prmEntry
     return:	xs:string
     note:      generates @headers attribute of HTML5 from DITA @headers attribute
     -->
    <xsl:template name="ahf:getHeadersAttr" as="attribute()?">
        <xsl:param name="prmEntry" as="element()" required="no" select="."/>
        
        <xsl:variable name="headersAtt" as="xs:string*" select="tokenize($prmEntry/@headers => string(),'\s')"/>
        <xsl:choose>
            <xsl:when test="$headersAtt => exists()">
                <xsl:variable name="idPrefixPart" as="xs:string" select="$prmEntry/ancestor::*[contains-token(@class,'topic/topic')][1]/@id => string() || $cIdSep"/>
                <xsl:variable name="headers" as="xs:string" select="$headersAtt ! concat($idPrefixPart,.) => string-join(' ')"/>
                <xsl:attribute name="headers" select="$headers"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
     function:  simpletable template
     param:	    
     return:    table
     note:		
     -->
    <xsl:template match="*[contains-token(@class, 'topic/simpletable')]">
        <xsl:variable name="keyCol" select="ahf:getKeyCol(.)" as="xs:integer"/>
        <xsl:variable name="simpleTableClassOpt" as="xs:string">
            <xsl:call-template name="getVarValue">
                <xsl:with-param name="prmVarName" select="'SimpleTable_Class_Opt'"/>
            </xsl:call-template>
        </xsl:variable>
        <table>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="$simpleTableClassOpt"/>
            </xsl:call-template>
            <xsl:if test="exists(@relcolwidth)">
                <xsl:call-template name="processRelColWidth">
                    <xsl:with-param name="prmRelColWidth" select="string(@relcolwidth)"/>
                    <xsl:with-param name="prmTable" select="."/>
                </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates select="*[contains-token(@class,'topic/sthead')]">
                <xsl:with-param name="prmKeyCol" tunnel="yes" select="$keyCol"/>
            </xsl:apply-templates>
            <tbody>
                <xsl:apply-templates select="*[contains-token(@class,'topic/strow')]">
                    <xsl:with-param name="prmKeyCol" tunnel="yes" select="$keyCol"/>
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
     function:  sthead template
     param:     prmKeyCol
     return:	thead
     note:      sthead is optional.
                This stylesheet apply bold for sthead if simpletable/@keycol is not defined.
     -->
    <xsl:template match="*[contains-token(@class, 'topic/sthead')]">
        <thead>
            <xsl:call-template name="genCommonAtts"/>
            <tr>
                <xsl:apply-templates/>
            </tr>
        </thead>
    </xsl:template>
    
    <!-- 
     function:  stentry template
     param:     prmKeyCol
     return:    stentry contents (fo:table-cell)
     note:      none
     -->
    <xsl:template match="*[contains-token(@class, 'topic/sthead')]/*[contains-token(@class, 'topic/stentry')]">
        <xsl:param name="prmKeyCol"   required="yes" tunnel="yes" as="xs:integer"/>
        <th>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass">
                    <xsl:call-template name="getVarValue">
                        <xsl:with-param name="prmVarName" select="'SimpleTable_Header_Cell_Class'"/>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </th>
    </xsl:template>
    
    <xsl:template match="*[contains-token(@class, 'topic/strow')]/*[contains-token(@class, 'topic/stentry')]">
        <xsl:param name="prmKeyCol"   required="yes" tunnel="yes" as="xs:integer"/>
        <xsl:variable name="applyTh" as="xs:boolean" select="$prmKeyCol = count(.|preceding-sibling::*[contains-token(@class, 'topic/stentry')])"/>
        <xsl:element name="{if ($applyTh) then 'th' else 'td'}">
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass">
                    <xsl:call-template name="getVarValue">
                        <xsl:with-param name="prmVarName" select="'SimpleTable_Body_Cell_Class'"/>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- 
     function:  strow template
     param:     prmKeyCol
     return:	row
     note:      none
     -->
    <xsl:template match="*[contains-token(@class, 'topic/strow')]">
        <tr>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <!-- 
     function:  get @keycol value and return it.
     param:     prmTable
     return:	integer
     note:		
     -->
    <xsl:function name="ahf:getKeyCol" as="xs:integer">
        <xsl:param name="prmTable" as="element()"/>
        
        <xsl:variable name="keyCol" as="xs:string" select="if ($prmTable/@keycol) then string($prmTable/@keycol) else '0'"/>
        <xsl:choose>
            <xsl:when test="$keyCol castable as xs:integer">
                <xsl:choose>
                    <xsl:when test="xs:integer($keyCol) ge 0">
                        <xsl:sequence select="xs:integer($keyCol)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes" 
                                select="ahf:replace($stMes050,('%file','%elem','%keycol'),(string($prmTable/@xtrf),name($prmTable),string($prmTable/@keycol)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="warningContinue">
                    <xsl:with-param name="prmMes" 
                        select="ahf:replace($stMes050,('%file','%elem','%keycol'),(string($prmTable/@xtrf),name($prmTable),string($prmTable/@keycol)))"/>
                </xsl:call-template>
                <xsl:sequence select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:  @relcolwidth processing
     param:     prmRelColWidth, prmTable
     return:    fo:table-column
     note:		
     -->
    <xsl:template name="processRelColWidth">
        <xsl:param name="prmRelColWidth" required="yes" as="xs:string"/>
        <xsl:param name="prmTable"  required="yes" as="element()"/>
        
        <xsl:variable name="relColWidthSeq" as="xs:string*" select="tokenize(string($prmRelColWidth), '[\s]+')"/>
        <xsl:variable name="relColWidthAsNumericSeq" as="xs:double*">
            <xsl:try>
                <xsl:for-each select="$relColWidthSeq">
                    <xsl:sequence select="if (contains(.,'*')) then xs:double(substring-before(.,'*')) else 0.0"/>
                </xsl:for-each>
                <xsl:catch errors="*">
                    <xsl:assert test="false()" select="'[processRelColWidth] Invalid simpletable/@relcolwidth=',$prmRelColWidth"/>
                    <xsl:sequence select="0.0"/>
                </xsl:catch>                
            </xsl:try>
        </xsl:variable>
        <xsl:variable name="relColWidthSum" as="xs:double" select="sum($relColWidthAsNumericSeq)"/>
        <xsl:choose>
            <xsl:when test="$relColWidthSum ne 0">
                <xsl:for-each select="$relColWidthAsNumericSeq">
                    <xsl:variable name="relWidth" as="xs:double" select="."/>
                    <xsl:variable name="relWidthPct" as="xs:double" select="$relWidth div $relColWidthSum * 100"/>
                    <col style="{concat('width:',$relWidthPct,'%')}"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- END OF STYLESHEET -->
</xsl:stylesheet>

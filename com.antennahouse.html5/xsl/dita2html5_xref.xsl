<?xml version='1.0' encoding="UTF-8" ?>
<!--
    ****************************************************************
    DITA to HTML5 Stylesheet 
    Module: xref element stylesheet
    Copyright © 2009-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL    : http://www.antennahouse.com/
    E-mail : info@antennahouse.com
    ****************************************************************
-->
<xsl:stylesheet version="3.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 exclude-result-prefixes="xs ahf"
>

    <!-- 
     function:  xref template
     param:     none
     return:	a element
     note:      
     -->
    <xsl:template match="*[contains-token(@class, 'topic/xref')]">
        <xsl:variable name="xref" as="element()" select="."/>
        <xsl:variable name="destAttr" as="attribute()?">
            <xsl:call-template name="getDestinationAttr">
                <xsl:with-param name="prmElem" select="$xref"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists($destAttr)">
                <a>
                    <xsl:copy-of select="$destAttr"/>
                    <xsl:call-template name="genXrefContentNodes">
                        <xsl:with-param name="prmXref"     select="$xref"/>
                        <xsl:with-param name="prmDstAttr"  select="$destAttr"/>
                    </xsl:call-template>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:apply-templates select="$xref/child::node() except $xref/child::*[contains-token(@class,'topic/desc')]"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:  Genrate xref contents
     param:     prmXref, prmDstAttr
     return:	node()*
     note:      none
     -->
    <xsl:template name="genXrefContentNodes" as="node()*">
        <xsl:param name="prmXref"     required="yes"  as="element()"/>
        <xsl:param name="prmDstAttr"  required="yes"  as="attribute()+"/>

        <xsl:variable name="destElement" as="element()?">
            <xsl:call-template name="getLinkDestinationElement">
                <xsl:with-param name="prmLinkElem" select="$prmXref"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="xrefTitle" as="node()*">
            <xsl:call-template name="getXrefTitle">
                <xsl:with-param name="prmXref"     select="$prmXref"/>
                <xsl:with-param name="prmDestElement" select="$destElement"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:sequence select="$xrefTitle"/>
    </xsl:template>

    <!-- 
     function:	Get title of xref
     param:       prmXref: xref element itself
                  prmDestElement: target of the xref
     return:      span (title string)
     note:		THIS TEMPLATE DOES NOT GENERATE @id ATTRIBUTE
     -->
    <xsl:template name="getXrefTitle" as="node()*">
        <xsl:param name="prmXref"          required="yes" as="element()"/>
        <xsl:param name="prmDestElement"   required="yes" as="element()?"/>
        
        <xsl:variable name="hasUserText" as="xs:boolean" select="$prmXref/node()[1][self::processing-instruction(ditaot)][string(.) eq 'usertext'] => exists()"/>
        
        <xsl:choose>
            <!-- external link or no destination element
                 Enable user text handling.
              -->
            <xsl:when test="empty($prmDestElement)">
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node()" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                            </xsl:call-template>
                            <xsl:value-of select="$prmXref/@href"/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- topic
              -->
            <xsl:when test="$prmDestElement[contains-token(@class, 'topic/topic')]">
                <xsl:variable name="topicTitleBody" as="node()*">
                    <xsl:apply-templates select="$prmDestElement/*[contains-token(@class, 'topic/title')]" mode="MODE_GET_CONTENTS"/>
                </xsl:variable>
                <xsl:variable name="outputClass" as="xs:string" select="'xref-topic'"/>
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:copy-of select="$topicTitleBody"/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- section -->
            <xsl:when test="$prmDestElement[contains-token(@class, 'topic/section')]">
                <xsl:variable name="outputClass" as="xs:string" select="'xref-section'"/>
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:when test="$prmDestElement/*[contains-token(@class, 'topic/title')]">
                        <xsl:variable name="sectionTitle" as="node()*">
                            <xsl:apply-templates select="$prmDestElement/*[contains-token(@class, 'topic/title')]" mode="MODE_GET_CONTENTS"/>
                        </xsl:variable>
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:copy-of select="$sectionTitle"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes" 
                                select="ahf:replace($stMes031,('%id','%file'),(string($prmDestElement/@id),string($prmDestElement/@xtrf)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- example -->
            <xsl:when test="$prmDestElement[contains-token(@class, 'topic/example')]">
                <xsl:variable name="outputClass" as="xs:string" select="'xref-example'"/>
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:when test="$prmDestElement/*[contains-token(@class, 'topic/title')]">
                        <xsl:variable name="exampleTitle" as="node()*">
                            <xsl:apply-templates select="$prmDestElement/*[contains-token(@class, 'topic/title')]" mode="MODE_GET_CONTENTS"/>
                        </xsl:variable>
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:copy-of select="$exampleTitle"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes" 
                                select="ahf:replace($stMes032,('%id','%file'),(string($prmDestElement/@id),string($prmDestElement/@xtrf)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- step/substep -->
            <xsl:when test="$prmDestElement[contains-token(@class, 'task/step')][ancestor::*[contains-token(@class,'task/steps')]]">
                <xsl:variable name="outputClass" as="xs:string" select="'xref-step'"/>
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Prefix of step: "step" -->
                        <xsl:variable name="stepHeading" as="xs:string">
                            <xsl:call-template name="getVarValueWithLang">
                                <xsl:with-param name="prmVarName" select="'Xref_Step_Prefix'"/>
                                <xsl:with-param name="prmElem" select="$prmDestElement"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="stepsNumberFormat" as="xs:string+">
                            <xsl:call-template name="getVarValueWithLangAsStringSequence">
                                <xsl:with-param name="prmVarName" select="'Step_Number_Formats'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="numberFormat" select="ahf:getOlNumberFormat($prmDestElement/parent::*,$stepsNumberFormat)" as="xs:string"/>
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:copy-of select="$stepHeading"/>
                            <xsl:number format="{$numberFormat}" value="ahf:getStepNumber($prmDestElement)"/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <xsl:when test="$prmDestElement[contains-token(@class, 'task/substep')][ancestor::*[contains-token(@class,'task/steps')]]">
                <xsl:variable name="outputClass" as="xs:string" select="'xref-substep'"/>
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Prefix of step: "step" -->
                        <xsl:variable name="stepHeading" as="xs:string">
                            <xsl:call-template name="getVarValueWithLang">
                                <xsl:with-param name="prmVarName" select="'Xref_Step_Prefix'"/>
                                <xsl:with-param name="prmElem" select="$prmDestElement"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="stepsNumberFormat" as="xs:string+">
                            <xsl:call-template name="getVarValueWithLangAsStringSequence">
                                <xsl:with-param name="prmVarName" select="'Step_Number_Formats'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="thisStepsNumberFormat" select="ahf:getOlNumberFormat($prmDestElement/parent::*/parent::*/parent::*,$stepsNumberFormat)" as="xs:string"/>
                        <xsl:variable name="thisSubStepsNumberFormat" select="ahf:getOlNumberFormat($prmDestElement/parent::*,$stepsNumberFormat)" as="xs:string"/>
                        <xsl:variable name="stepSubstepSeparator" as="text()?">
                            <xsl:call-template name="getVarValueWithLangAsText">
                                <xsl:with-param name="prmVarName" select="'Xref_Step_Substep_Separator'"/>
                                <xsl:with-param name="prmElem" select="$prmDestElement"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:copy-of select="$stepHeading"/>
                            <xsl:number format="{$thisStepsNumberFormat}" value="ahf:getStepNumber($prmDestElement/parent::*/parent::*)"/>
                            <xsl:copy-of select="$stepSubstepSeparator"/>
                            <xsl:number format="{$thisSubStepsNumberFormat}" value="ahf:getStepNumber($prmDestElement)"/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- ol/li -->
            <xsl:when test="$prmDestElement[contains-token(@class, 'topic/li')][parent::*[contains-token(@class,'topic/ol')]]">
                <xsl:variable name="outputClass" as="xs:string" select="'xref-ol-li'"/>
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Prefix of ol -->
                        <xsl:variable name="olNumberFormat" as="xs:string+">
                            <xsl:call-template name="getVarValueWithLangAsStringSequence">
                                <xsl:with-param name="prmVarName" select="'Ol_Number_Formats'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="olFormat" as="xs:string" select="ahf:getOlNumberFormat($prmDestElement,$olNumberFormat)"/>
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:number format="{$olFormat}"
                                value="count($prmDestElement | $prmDestElement/preceding-sibling::*[contains-token(@class, 'topic/li')])"/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- table -->
            <xsl:when test="$prmDestElement[contains-token(@class, 'topic/table')]">
                <xsl:variable name="outputClass" as="xs:string" select="'xref-table'"/>
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:when test="$prmDestElement/*[contains-token(@class, 'topic/title')]">
                        <xsl:variable name="tableTitle" as="node()*">
                            <xsl:apply-templates select="$prmDestElement/*[contains-token(@class, 'topic/title')]" mode="MODE_GET_CONTENTS"/>
                        </xsl:variable>
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:copy-of select="$tableTitle"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes"
                                select="ahf:replace($stMes033,('%id','%file'),(string($prmDestElement/@id),string($prmDestElement/@xtrf)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- fig -->
            <xsl:when test="$prmDestElement[contains-token(@class, 'topic/fig')]">
                <xsl:variable name="outputClass" as="xs:string" select="'xref-fig'"/>
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:when test="$prmDestElement/*[contains-token(@class, 'topic/title')]">
                        <xsl:variable name="figTitle" as="node()*">
                            <xsl:apply-templates select="$prmDestElement/*[contains-token(@class, 'topic/title')]" mode="MODE_GET_CONTENTS"/>
                        </xsl:variable>
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:copy-of select="$figTitle"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes"
                                select="ahf:replace($stMes034,('%id','%file'),(string($prmDestElement/@id),string($prmDestElement/@xtrf)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <!-- equation-block -->
            <xsl:when test="$prmDestElement[contains-token(@class, 'equation-d/equation-block')]">
                <xsl:variable name="outputClass" as="xs:string" select="'xref-equation-block'"/>
                <xsl:variable name="equationNumber" as="element()?" select="($prmDestElement/*[contains-token(@class, 'equation-d/equation-number')])[1]"/>
                <xsl:variable name="equtionNumberResult" as="node()*">
                    <xsl:choose>
                        <xsl:when test="$hasUserText">
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </xsl:when>
                        <xsl:when test="$equationNumber => exists()">
                            <xsl:call-template name="getVarValueWithLangAsText">
                                <xsl:with-param name="prmVarName" select="'Equation_Number_Ref_Prefix'"/>
                                <xsl:with-param name="prmElem" select="$equationNumber"/>
                            </xsl:call-template>
                            <xsl:call-template name="getVarValueWithLangAsText">
                                <xsl:with-param name="prmVarName" select="'Equation_Number_Prefix'"/>
                                <xsl:with-param name="prmElem" select="$equationNumber"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$equationNumber" mode="MODE_GET_CONTENTS"/>
                            <xsl:call-template name="getVarValueWithLangAsText">
                                <xsl:with-param name="prmVarName" select="'Equation_Number_Suffix'"/>
                                <xsl:with-param name="prmElem" select="$equationNumber"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- equation-block without equation-number -->
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </xsl:otherwise>
                    </xsl:choose>    
                </xsl:variable>
                <span>
                    <xsl:call-template name="genCommonAtts">
                        <xsl:with-param name="prmElement" select="$prmXref"/>
                        <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                    </xsl:call-template>
                    <xsl:copy-of select="$equtionNumberResult"/>
                </span>
            </xsl:when>
            
            <!-- fn -->
            <xsl:when test="$prmDestElement[contains-token(@class, 'topic/fn')]">
                <xsl:variable name="outputClass" as="xs:string" select="'fn-ref'"/>
                <xsl:variable name="fnRefStr" as="xs:string" select="ahf:getFnRefStr($prmDestElement)"/>
                <sapn>
                    <xsl:call-template name="genCommonAtts">
                        <xsl:with-param name="prmElement" select="$prmXref"/>
                        <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                    </xsl:call-template>
                    <xsl:value-of select="$fnRefStr"/>
                </sapn>
            </xsl:when>
            
            <!-- Other elements that have title -->
            <xsl:when test="$prmDestElement[child::*[contains-token(@class, 'topic/title')]]">
                <xsl:variable name="outputClass" as="xs:string" select="'xref-other-title'"/>
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="title" as="node()*">
                            <xsl:apply-templates select="$prmDestElement/*[contains-token(@class, 'topic/title')]" mode="MODE_GET_CONTENTS"/>
                        </xsl:variable>
                         <span>
                             <xsl:call-template name="genCommonAtts">
                                 <xsl:with-param name="prmElement" select="$prmXref"/>
                                 <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                             </xsl:call-template>
                             <xsl:copy-of select="$title"/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- Others: Adopt the content of xref itself if user supplied text exists.
             -->
            <xsl:otherwise>
                <xsl:variable name="outputClass" as="xs:string" select="'xref-other-no-title'"/>
                <xsl:choose>
                    <xsl:when test="$hasUserText">
                        <span>
                            <xsl:call-template name="genCommonAtts">
                                <xsl:with-param name="prmElement" select="$prmXref"/>
                                <xsl:with-param name="prmDefaultOutputClass" select="$outputClass"/>
                            </xsl:call-template>
                            <xsl:apply-templates select="$prmXref/node() except *[contains-token(@class,'topic/desc')]" mode="MODE_GET_CONTENTS"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes"
                                select="ahf:replace($stMes035,('%id','%elem','%file'),(string($prmDestElement/@id),name($prmDestElement),string($prmDestElement/@xtrf)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
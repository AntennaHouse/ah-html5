<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Task Element Templates
    **************************************************************
    File Name : dita2html5_task_element.xsl
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

    <!-- stepxmp, stepresult, info, tutorialinfo
         are treated as topic/itemgroup and implemented in dita2html5_specialization_elements.xsl
         steps-informal is implemented as section in dita2html5_topic_body_elements.xsl
     -->

    <!--
    function:   stpes template
    param:      none
    return:     section, ol other
    note:                     
    -->
    <xsl:template match="*[@class => contains-token('task/steps')]" priority="5">
        <xsl:variable name="steps" as="element()" select="."/>
        <xsl:variable name="stepExpand" as="xs:boolean" select="ahf:expandStep(.)"/>
        <xsl:choose>
            <xsl:when test="*[@class => contains-token('task/stepsection')] => empty()">
                <ol>
                    <xsl:call-template name="genCommonAtts"/>
                    <xsl:apply-templates select="*[@class => contains-token('task/step')]">
                        <xsl:with-param name="prmExpand" select="$stepExpand"/>
                    </xsl:apply-templates>                        
                </ol>
            </xsl:when>
            <xsl:otherwise>
                <section>
                    <xsl:call-template name="genCommonAtts"/>
                    <!-- group by step/stepsection -->
                    <xsl:for-each-group select="*[@class => contains-token('topic/li')]" group-adjacent="ahf:isStep(.)">
                        <xsl:choose>
                            <xsl:when test="current-grouping-key()">
                                <!-- group of step -->
                                <ol>
                                    <xsl:call-template name="genCommonAtts">
                                        <xsl:with-param name="prmElement" select="$steps"/>
                                    </xsl:call-template>
                                    <xsl:variable name="precedingStepCount" as="xs:integer" select="current-group()[1] => ahf:getStepNumber()"/>
                                    <xsl:attribute name="start" select="$precedingStepCount"/>
                                    <xsl:apply-templates select="current-group()">
                                        <xsl:with-param name="prmExpand" select="$stepExpand"/>
                                    </xsl:apply-templates>                        
                                </ol>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- stepsection -->
                                <xsl:apply-templates select="current-group()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each-group>
                </section>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
     function:    get step number
     param:       prmStep 
     return:      xs:integer
     note:        Skip stepsection		
     -->
    <xsl:function name="ahf:getStepNumber" as="xs:integer">
        <xsl:param name="prmStep" as="element()"/>
        <xsl:sequence select="count($prmStep| $prmStep/preceding-sibling::*[@class => contains-token('topic/li')][not(@class => contains-token('task/stepsection'))])"/>
    </xsl:function>
    
    <!--
    function:   stpes-unordered template
    param:      none
    return:     section, ul other
    note:              
    -->
    <xsl:template match="*[@class => contains-token('task/steps-unordered')]" priority="5">
        <xsl:variable name="stepExpand" as="xs:boolean" select="ahf:expandStep(.)"/>
        <xsl:choose>
            <xsl:when test="*[@class => contains-token('task/stepsection')] => empty()">
                <ul>
                    <xsl:call-template name="genCommonAtts"/>
                    <xsl:apply-templates select="*[@class => contains-token('task/step')]">
                        <xsl:with-param name="prmExpand" select="$stepExpand"/>
                    </xsl:apply-templates>                        
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <section>
                    <xsl:call-template name="genCommonAtts"/>
                    <!-- group by step/stepsection -->
                    <xsl:for-each-group select="*[@class => contains-token('topic/li')]" group-adjacent="ahf:isStep(.)">
                        <xsl:choose>
                            <xsl:when test="current-grouping-key()">
                                <!-- group of step -->
                                <ul>
                                    <xsl:call-template name="genCommonAtts">
                                        <xsl:with-param name="prmElement" select="current-group()[1]/parent::*"/>
                                    </xsl:call-template>
                                    <xsl:apply-templates select="current-group()">
                                        <xsl:with-param name="prmExpand" select="$stepExpand"/>
                                    </xsl:apply-templates>                        
                                </ul>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- stepsection -->
                                <xsl:apply-templates select="current-group()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each-group>
                </section>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
    function:   check expand/compact step
    param:      prmSteps
    return:     xs:boolean
    note:              
    -->
    <xsl:function name="ahf:expandStep" as="xs:boolean">
        <xsl:param name="prmSteps" as="element()"/>
        
        <xsl:choose>
            <xsl:when test="$prmSteps/*/*[@class => contains-token('task/info')] => exists()">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="$prmSteps/*/*[@class => contains-token('task/stepxmp')] => exists()">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="$prmSteps/*/*[@class => contains-token('task/tutorialinfo')] => exists()">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="$prmSteps/*/*[@class => contains-token('task/stepresult')] => exists()">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!--
    function:   group step/stepsection
    param:      prmStep
    return:     xs:boolean
    note:              
    -->
    <xsl:function name="ahf:isStep" as="xs:boolean">
        <xsl:param name="prmStep" as="element()"/>
        
        <xsl:choose>
            <xsl:when test="$prmStep[@class => contains-token('task/step')] => exists()">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!--
    function:   step processing
    param:      prmExpand
    return:     li, etc
    note:              
    -->
    <xsl:template match="*[@class => contains-token('task/step')]" priority="5">
        <xsl:param name="prmExpand" as="xs:boolean" tunnel="yes" required="no" select="false()"/>
        
        <li>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="if ($prmExpand) then 'stepexpand' else ''"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:call-template name="processImportance"/>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="*[@class => contains-token('task/step')]" priority="5" mode="MODE_ONE_STEP">
        <xsl:param name="prmExpand" as="xs:boolean" tunnel="yes" required="no" select="false()"/>
        
        <p>
            <xsl:call-template name="genCommonAtts">
                <xsl:with-param name="prmDefaultOutputClass" select="'p'"/>
            </xsl:call-template>
            <xsl:call-template name="genIdAtt"/>
            <xsl:call-template name="processImportance"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!--
    function:   step/@importance processing
    param:      prmStep
    return:     span
    note:              
    -->
    <xsl:template name="processImportance" as="element(span)?">
        <xsl:param name="prmStep" as="element()" required="no" select="."/>
        <xsl:variable name="importance" as="xs:string" select="$prmStep/@importance => string()"/>
        <xsl:choose>
            <xsl:when test="$importance eq 'optional'">
                <span class="step importance optiional">
                    <xsl:call-template name="getVarValueAsText">
                        <xsl:with-param name="prmVarName" select="'Step_Optional'"/>
                    </xsl:call-template>
                </span>
            </xsl:when>
            <xsl:when test="$importance eq 'required'">
                <span class="step importance required">
                    <xsl:call-template name="getVarValueAsText">
                        <xsl:with-param name="prmVarName" select="'Step_Required'"/>
                    </xsl:call-template>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    function:   task/stepsection processing
    param:      prmExpand
    return:     div
    note:              
    -->
    <xsl:template match="*[@class => contains-token('task/stepsection')]" priority="5">
        <xsl:param name="prmExpand" as="xs:boolean" tunnel="yes" required="no" select="false()"/>
        
        <div>
            <xsl:call-template name="genCommonAtts"/>
            <xsl:call-template name="genIdAtt"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
</xsl:stylesheet>

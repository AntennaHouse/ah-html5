<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Utility Templates
    **************************************************************
    File Name : dita2html5_util.xsl
    **************************************************************
    Copyright © 2009-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->

<xsl:stylesheet version="3.0" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs ahf" >

    <!-- 
      ============================================
         String utility
      ============================================
    -->
    <!--
    function: String Utility
    param: see below
    note: return the sub-string before or after of the LAST delimiter
    -->
    <xsl:function name="ahf:substringBeforeLast" as="xs:string">
        <xsl:param name="prmSrcString" as="xs:string"/>
        <xsl:param name="prmDlmString" as="xs:string"/>
        <xsl:call-template name="substringBeforeLast">
            <xsl:with-param name="prmSrcString" select="$prmSrcString"/>
            <xsl:with-param name="prmDlmString" select="$prmDlmString"/>
        </xsl:call-template>
    </xsl:function>

    <xsl:template name="substringBeforeLast">
    	<xsl:param name="prmSrcString" required="yes" as="xs:string"/>
    	<xsl:param name="prmDlmString" required="yes" as="xs:string"/>
    	
    	<xsl:variable name="substringBefore" select="substring-before($prmSrcString, $prmDlmString)"/>
    	<xsl:variable name="substringAfter" select="substring-after($prmSrcString, $prmDlmString)"/>
    	<xsl:choose>
    		<xsl:when test="contains($substringAfter, $prmDlmString)">
    			<xsl:variable name="restResult">
    				<xsl:call-template name="substringBeforeLast">
    					<xsl:with-param name="prmSrcString" select="$substringAfter"/>
    					<xsl:with-param name="prmDlmString" select="$prmDlmString"/>
    				</xsl:call-template>
    			</xsl:variable>
    			<xsl:value-of select="concat($substringBefore, $prmDlmString, $restResult)"/>
    		</xsl:when>
    		<xsl:otherwise>
    			<xsl:value-of select="$substringBefore"/>
    		</xsl:otherwise>
    	</xsl:choose>
    </xsl:template>
    
    <xsl:function name="ahf:substringAfterLast" as="xs:string">
    	<xsl:param name="prmSrcString" as="xs:string"/>
    	<xsl:param name="prmDlmString" as="xs:string"/>
    	
    	<xsl:variable name="substringBefore" select="substring-before($prmSrcString, $prmDlmString)"/>
    	<xsl:variable name="substringAfter" select="substring-after($prmSrcString, $prmDlmString)"/>
    	<xsl:choose>
    		<xsl:when test="not(contains($prmSrcString, $prmDlmString))">
    			<xsl:sequence select="$prmSrcString"/>
    		</xsl:when>
    		<xsl:when test="contains($substringAfter, $prmDlmString)">
    			<xsl:sequence select="ahf:substringAfterLast($substringAfter, $prmDlmString)"/>
    		</xsl:when>
    		<xsl:otherwise>
    			<xsl:sequence select="$substringAfter"/>
    		</xsl:otherwise>
    	</xsl:choose>
    </xsl:function>
    
    <!--
        function: Convert back-slash to slash
        param: prmString
        note: Result string
    -->
    <xsl:function name="ahf:bsToSlash" as="xs:string">
        <xsl:param name="prmStr" as="xs:string"/>
        <xsl:sequence select="translate($prmStr,'&#x005C;','/')"/>
    </xsl:function>

    <!--
     function: escapeForRegx
     param:    prmSrcString
     return:   Escaped xs:string
     note:     Original code by Priscilla Walmsley.
               http://www.xsltfunctions.com/xsl/functx_escape-for-regex.html
    -->
    <xsl:function name="ahf:escapeForRegxDst" as="xs:string">
        <xsl:param name="prmSrcString" as="xs:string"/>
        <xsl:sequence select="replace($prmSrcString,'(\\|\$)','\\$1')"/>
    </xsl:function>
    
    <xsl:function name="ahf:escapeForRegxSrc" as="xs:string">
        <xsl:param name="prmSrcString" as="xs:string"/>
        <xsl:sequence select="replace($prmSrcString,'(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')"/>
    </xsl:function>

    <!--
        function: Safe replace function
        param: prmStr,prmSrc,prmDst
        note: Result string
    -->
    <xsl:function name="ahf:safeReplace" as="xs:string">
        <xsl:param name="prmStr" as="xs:string"/>
        <xsl:param name="prmSrc" as="xs:string"/>
        <xsl:param name="prmDst" as="xs:string"/>
        <xsl:sequence select="replace($prmStr,ahf:escapeForRegxSrc($prmSrc),ahf:escapeForRegxDst($prmDst))"/>
    </xsl:function>
    
    <!--
        function: Multiple replace function
        param: prmStr,prmSrc,prmDst
        note: Result string
    -->
    <xsl:function name="ahf:replace" as="xs:string">
        <xsl:param name="prmStr" as="xs:string"/>
        <xsl:param name="prmSrc" as="xs:string+"/>
        <xsl:param name="prmDst" as="xs:string+"/>
    
        <xsl:variable name="firstResult" select="ahf:safeReplace($prmStr,$prmSrc[1],$prmDst[1])" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="exists($prmSrc[2]) and exists($prmDst[2])">
                <xsl:sequence select="ahf:replace($firstResult,subsequence($prmSrc,2),subsequence($prmDst,2))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$firstResult"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
      ============================================
         Node functions
      ============================================
    -->

    <!-- 
     function:  Select top level nodes from document-node
     param:     prmDocumentNode
     return:	result nodes
     note:		
     -->
    <xsl:function name="ahf:getTopLevelNodes" as="node()*">
        <xsl:param name="prmDocumentNode" as="document-node()"/>
        <xsl:sequence select="$prmDocumentNode/node()"/>
    </xsl:function>
    
    <!-- 
     function:  determine empty element
     param:     prmElem
     return:    xs:boolean
     note:		
     -->
    <xsl:function name="ahf:isNotEmptyElement" as="xs:boolean">
        <xsl:param name="prmElem" as="element()?"/>
        <xsl:sequence select="not(ahf:isEmptyElement($prmElem))"/>
    </xsl:function>        
    
    <xsl:function name="ahf:isEmptyElement" as="xs:boolean">
        <xsl:param name="prmElem" as="element()?"/>
        <xsl:choose>
            <xsl:when test="$prmElem => empty()">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="$prmElem/node() => empty()">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="every $node in $prmElem/node() satisfies ahf:isRedundantNode($node)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:  determine redundant node
     param:     prmNode
     return:    xs:boolean
     note:		
     -->
    <xsl:function name="ahf:isRedundantNode" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:choose>
            <xsl:when test="$prmNode/self::comment()">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="$prmNode/self::processing-instruction()">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="$prmNode/self::text()">
                <xsl:choose>
                    <xsl:when test="string(normalize-space($prmNode)) eq ''">
                        <xsl:sequence select="true()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="false()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$prmNode/self::element()">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="true()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
     function:  determine redundant nodes
     param:     prmNodes
     return:    xs:boolean
     note:		
     -->
    <xsl:function name="ahf:isRedundantNodes" as="xs:boolean">
        <xsl:param name="prmNodes" as="node()+"/>
        <xsl:sequence select="some $node in $prmNodes satisfies ahf:isRedundantNode($node)"/>
    </xsl:function>

    <!-- 
     function:  Get first preceding elememnt
     param:     prmElem
     return:    element()?
     note:		
     -->
    <xsl:function name="ahf:getFirstPrecedingSiblingElemWoWh" as="element()?">
        <xsl:param name="prmElem" as="element()?"/>
        <xsl:variable name="precedingFirstElem" as="element()?" select="$prmElem/preceding-sibling::*[1]"/>
        <xsl:choose>
            <xsl:when test="empty($precedingFirstElem)">
                <xsl:sequence select="()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="nodesBetween" as="node()*" select="$prmElem/preceding-sibling::node()[. &gt;&gt; $precedingFirstElem]"/>
                <xsl:choose>
                    <xsl:when test="empty($nodesBetween)">
                        <xsl:sequence select="$precedingFirstElem"/>
                    </xsl:when>
                    <xsl:when test="every $node in $nodesBetween satisfies ahf:isRedundantNode($node)">
                        <xsl:sequence select="$precedingFirstElem"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
     function:  Get first following elememnt
     param:     prmElem
     return:    element()?
     note:		
     -->
    <xsl:function name="ahf:getFirstFollowingSiblingElemWoWh" as="element()?">
        <xsl:param name="prmElem" as="element()?"/>
        <xsl:variable name="followingFirstElem" as="element()?" select="$prmElem/following-sibling::*[1]"/>
        <xsl:choose>
            <xsl:when test="empty($followingFirstElem)">
                <xsl:sequence select="()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="nodesBetween" as="node()*" select="$prmElem/following-sibling::node()[. &lt;&lt; $followingFirstElem]"/>
                <xsl:choose>
                    <xsl:when test="empty($nodesBetween)">
                        <xsl:sequence select="$followingFirstElem"/>
                    </xsl:when>
                    <xsl:when test="every $node in $nodesBetween satisfies ahf:isRedundantNode($node)">
                        <xsl:sequence select="$followingFirstElem"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
     function:  Determine the first child of parent
     param:     prmElem
     return:    xs:boolean
     note:		
     -->
    <xsl:function name="ahf:isFirstChildOfParent" as="xs:boolean">
        <xsl:param name="prmElem" as="element()?"/>
        <xsl:sequence select="$prmElem[parent::*/*[1] is $prmElem] => exists()"/>
    </xsl:function>
    

    <!-- 
      ============================================
         Tree Functions
      ============================================
    -->
    <!-- 
     function:    Generate element XPath string
     param:       prmElem
     return:      xs:string
     note:        
     -->
    <xsl:function name="ahf:getHistoryXpathStr" as="xs:string">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="ancestorElem" as="element()+" select="$prmElem/ancestor-or-self::*"/>
        <xsl:variable name="historyStr" as="xs:string*">
            <xsl:for-each select="$ancestorElem">
                <xsl:variable name="elem" select="."/>
                <xsl:variable name="name" as="xs:string" select="name()"/>
                <xsl:sequence select="'/'"/>
                <xsl:sequence select="local-name()"/>
                <xsl:sequence select="if (exists($elem/parent::*) or exists($elem/preceding-sibling::*|$elem/following-sibling::*)) then concat('[',string(count($elem/preceding-sibling::*[name() eq $name]) + 1),']') else ''"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:sequence select="string-join($historyStr,'')"/>
    </xsl:function>

    <!-- 
     function:    Generate element history string
     param:       prmElem
     return:      xs:string
     note:        Added topid/@id
     -->
    <xsl:function name="ahf:getHistoryStr" as="xs:string">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="ancestorElem" as="element()+" select="$prmElem/ancestor-or-self::*"/>
        <xsl:variable name="historyStr" as="xs:string*">
            <xsl:for-each select="$ancestorElem">
                <xsl:variable name="elem" select="."/>
                <xsl:variable name="name" as="xs:string" select="name()"/>
                <xsl:if test="position() gt 1">
                    <xsl:sequence select="'.'"/>
                </xsl:if>
                <xsl:sequence select="local-name()"/>
                <xsl:if test="position() eq 1">
                    <xsl:sequence select="'_'"/>
                    <xsl:sequence select="$elem/@id => string()"/>
                </xsl:if>
                <xsl:sequence select="if (exists($elem/parent::*) or exists($elem/preceding-sibling::*|$elem/following-sibling::*)) then string(count($elem|$elem/preceding-sibling::*[name() eq $name])) else ''"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:sequence select="string-join($historyStr,'')"/>
    </xsl:function>
    
    <!-- 
      ============================================
         Other functions
      ============================================
    -->
    <!-- 
     function:	Make hexadecimal string from positive integer
     param:		prmNumber
     return:	Hexadecimal string
     note:		
     -->
    <xsl:function name="ahf:intToHexString" as="xs:string">
        <xsl:param name="prmValue" as="xs:integer"/>
    
        <xsl:variable name="quotient"  select="$prmValue idiv 16" as="xs:integer"/>
        <xsl:variable name="remainder" select="$prmValue mod 16"  as="xs:integer"/>
        
        <xsl:variable name="quotientString" select="if ($quotient &gt; 0) then (ahf:intToHexString($quotient)) else ''" as="xs:string"/>
        <xsl:variable name="remainderString" as="xs:string">
            <xsl:choose>
                <xsl:when test="($remainder &gt;= 0) and ($remainder &lt;= 9)">
                    <xsl:value-of select="format-number($remainder, '0')"/>
                </xsl:when>
                <xsl:when test="$remainder = 10">
                    <xsl:value-of select="'A'"/>
                </xsl:when>
                <xsl:when test="$remainder = 11">
                    <xsl:value-of select="'B'"/>
                </xsl:when>
                <xsl:when test="$remainder = 12">
                    <xsl:value-of select="'C'"/>
                </xsl:when>
                <xsl:when test="$remainder = 13">
                    <xsl:value-of select="'D'"/>
                </xsl:when>
                <xsl:when test="$remainder = 14">
                    <xsl:value-of select="'E'"/>
                </xsl:when>
                <xsl:when test="$remainder = 15">
                    <xsl:value-of select="'F'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="concat($quotientString, $remainderString)"/>
    </xsl:function>
    
    <!-- 
     function:	Make hexadecimal string from codepoint sequence
     param:		prmCodePoint
     return:	Hexadecimal string
     note:		
     -->
    <xsl:function name="ahf:codepointToHexString" as="xs:string">
        <xsl:param name="prmCodePoint" as="xs:integer*"/>
    
        <xsl:choose>
            <xsl:when test="empty($prmCodePoint)">
                <xsl:sequence select="''"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="first" select="ahf:intToHexString($prmCodePoint[1])" as="xs:string"/>
                <xsl:variable name="paddingCount" select="string-length($first) mod 4"/>
                <xsl:variable name="paddingZero" select="if ($paddingCount gt 0) then string-join(for $i in 1 to $paddingCount return '0','') else ''"/>
                <xsl:variable name="rest"  select="ahf:codepointToHexString(subsequence($prmCodePoint,2))" as="xs:string"/>
                <xsl:sequence select="concat($paddingZero, $first, $rest)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:	Make hexadecimal string from string
     param:		prmString
     return:	Hexadecimal string
     note:		
     -->
    <xsl:function name="ahf:stringToHexString" as="xs:string">
        <xsl:param name="prmString" as="xs:string"/>
    
        <xsl:variable name="codePoints" select="string-to-codepoints($prmString)" as="xs:integer*"/>
        <xsl:sequence select="ahf:codepointToHexString($codePoints)"/>
    </xsl:function>
    
    <!-- 
        function:   Return true() if $prmStr contains one of the given $prmDstStrSeq[N].
        param:      prmStr, prmDstStrSeq
        return:     xs:boolean
        note:		
    -->
    <xsl:function name="ahf:seqContains" as="xs:boolean">
        <xsl:param name="prmStr" as="xs:string?"/>
        <xsl:param name="prmDstStrSeq" as="xs:string*"/>
        <xsl:choose>
            <xsl:when test="empty($prmStr) or empty($prmDstStrSeq)">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="some $dstStr in $prmDstStrSeq satisfies contains($prmStr,$dstStr)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
        function:   Return true() if tokenized $prmDstStr contains one of the given token $prmTokens.
        param:      prmDstStr, prmTokens
        return:     xs:boolean
        note:	   Change $prmDstStr occurrence indicator from ? to *.
                    2019-10-26 t.makita
    -->
    <xsl:function name="ahf:seqContainsToken" as="xs:boolean">
        <xsl:param name="prmDstStr" as="xs:string*"/>
        <xsl:param name="prmTokens" as="xs:string*"/>
        <xsl:choose>
            <xsl:when test="empty($prmDstStr) or empty($prmTokens)">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="dstStrs" as="xs:string*" select="$prmDstStr ! tokenize(.,'\s')"/>
                <xsl:sequence select="$dstStrs = $prmTokens"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
        function:   Return true() if $prmStr starts with one of the given $prmDstStrSeq.
        param:      prmDstStr, prmStrSeq
        return:     xs:boolean
        note:
    -->
    <xsl:function name="ahf:seqStartsWith" as="xs:boolean">
        <xsl:param name="prmDstStr" as="xs:string?"/>
        <xsl:param name="prmStrSeq" as="xs:string*"/>
        <xsl:choose>
            <xsl:when test="empty($prmDstStr) or empty($prmStrSeq)">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="some $str in $prmStrSeq satisfies starts-with($prmDstStr,$str)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!--
     function: containsAnyOf
     param:    prmSrcString,prmSearchString
     return:   Return true() if $prmSrcString contains any of $prmSrcString
     note:     Original code by Priscilla Walmsley.
               http://www.xsltfunctions.com/xsl/functx_contains-any-of.html
    -->
    <xsl:function name="ahf:containsAnyOf">
        <xsl:param name="prmSrcString" as="xs:string?"/>
        <xsl:param name="prmSearchStrings" as="xs:string*"/>
        <xsl:sequence select="some $searchString in $prmSearchStrings satisfies contains($prmSrcString,$searchString)"/>
    </xsl:function>
    
    <!--
     function: nz
     param:    prmNode?
     return:   Return xs:integer of string value of $prmNode
     note:     empty sequence is assumed as 0
    -->
    <xsl:function name="ahf:nz">
        <xsl:param name="prmNode" as="node()?"/>
        <xsl:choose>
            <xsl:when test="$prmNode => empty()">
                <xsl:sequence select="0"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:try>
                    <xsl:sequence select="$prmNode => string() => xs:integer()"/>
                    <xsl:catch errors="*">
                        <xsl:assert test="false()" select="'[ahf:nz] $prmNode has illegal value = ', string($prmNode)"/>
                        <xsl:sequence select="0"/>
                    </xsl:catch>
                </xsl:try>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!--
    function:   Processing instruction output template
    param:      prmPiName, prmPiContent
    return:     text()+
    note:       Saxon does not outputs processing instruction correctly in HTML5 output.
                <?php ～ ?> is converted into <?php ～ >
                To avoid this error, use xsl:text instead.
    -->
    <xsl:template name="outputPI" as="text()+">
        <xsl:param name="prmPiName" as="xs:string"/>
        <xsl:param name="prmPiContent" as="xs:string"/>
        
        <xsl:text disable-output-escaping="yes">&lt;?</xsl:text>
        <xsl:value-of select="$prmPiName"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$prmPiContent" disable-output-escaping="yes"/>
        <xsl:text></xsl:text>
        <xsl:text disable-output-escaping="yes">?&gt;</xsl:text>
    </xsl:template>

    <xsl:function name="ahf:outputPI" as="text()+">
        <xsl:param name="prmPiName" as="xs:string"/>
        <xsl:param name="prmPiContent" as="xs:string"/>
        <xsl:call-template name="outputPI">
            <xsl:with-param name="prmPiName" select="$prmPiName"/>
            <xsl:with-param name="prmPiContent" select="$prmPiContent"/>
        </xsl:call-template>        
    </xsl:function>
    
    <!-- end of stylesheet -->
</xsl:stylesheet>

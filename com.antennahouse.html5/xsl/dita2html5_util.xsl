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
URL : http://www.antennahouse.co.jp/
**************************************************************
-->

<xsl:stylesheet version="3.0" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
 	xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
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
     function:	Get leading white-space only text node of the given node()*
     param:		prmNode
     return:	leading white-space nodes
     note:		
     -->
    <xsl:function name="ahf:getLeadingUnusedNodes" as="node()*">
        <xsl:param name="prmNode" as="node()*"/>
        
        <xsl:variable name="firstNode" as="node()?" select="$prmNode[1]"/>
        <xsl:variable name="isLeadingUnusedNode" as="xs:boolean" select="exists($firstNode[self::text()][not(string(normalize-space(string(.))))]) or 
                                                                         exists($firstNode[self::processing-instruction()]) or
                                                                         exists($firstNode[self::comment()])"/>
        <xsl:choose>
            <xsl:when test="$isLeadingUnusedNode">
                <xsl:sequence select="$prmNode[1] | ahf:getLeadingUnusedNodes($prmNode[position() gt 1])"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
     function:	Get trailing white-space only text node or processing instruction or comment of the given node()*
     param:		prmNode
     return:	trailing white-space nodes
     note:		
     -->
    <xsl:function name="ahf:getTrailingUnusedNodes" as="node()*">
        <xsl:param name="prmNode" as="node()*"/>
        
        <xsl:variable name="lastNode" as="node()?" select="$prmNode[position() eq last()]"/>
        <xsl:variable name="isTrailingUnusedNode" as="xs:boolean" select="exists($lastNode[self::text()][not(string(normalize-space(string(.))))]) or 
                                                                          exists($lastNode[self::processing-instruction()]) or
                                                                          exists($lastNode[self::comment()])"/>
        <xsl:choose>
            <xsl:when test="$isTrailingUnusedNode">
                <xsl:sequence select="$prmNode[position() eq last()] | ahf:getTrailingUnusedNodes($prmNode[position() lt last()])"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
     function:	Remove leading white-space only text node or processing-instruction or comment of the given node()*
     param:		prmNode
     return:	result nodes
     note:		
     -->
    <xsl:function name="ahf:removeLeadingUnusedNodes" as="node()*">
        <xsl:param name="prmNode" as="node()*"/>
        
        <xsl:variable name="leadingUnusedNodes" as="node()*" select="ahf:getLeadingUnusedNodes($prmNode)"/>
        <xsl:sequence select="$prmNode except $leadingUnusedNodes"/>
    </xsl:function>

    <!-- 
     function:	Remove trailing white-space only text node or processing-instruction or comment of the given node()*
     param:		prmNode
     return:	result nodes
     note:		
     -->
    <xsl:function name="ahf:removeTrailingUnusedNodes" as="node()*">
        <xsl:param name="prmNode" as="node()*"/>
        
        <xsl:variable name="trailingUnusedNodes" as="node()*" select="ahf:getTrailingUnusedNodes($prmNode)"/>
        <xsl:sequence select="$prmNode except $trailingUnusedNodes"/>
    </xsl:function>
    
    <!-- 
     function:	Remove leading & trailing white-space only text node or processing-instruction or comment of the given node()*
     param:		prmNode
     return:	result nodes
     note:		
     -->
    <xsl:function name="ahf:removeLtUnusedNodes" as="node()*">
        <xsl:param name="prmNode" as="node()*"/>
        
        <xsl:variable name="unusedNodes" as="node()*" select="ahf:getLeadingUnusedNodes($prmNode) | ahf:getTrailingUnusedNodes($prmNode)"/>
        <xsl:sequence select="$prmNode except $unusedNodes"/>
    </xsl:function>

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
     note:        
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
        function:   Return true() if torkinized $prmDstStr contains one of the given token $prmTokens.
        param:      prmDstStr, prmTokens
        return:     xs:boolean
        note:	
    -->
    <xsl:function name="ahf:seqContainsToken" as="xs:boolean">
        <xsl:param name="prmDstStr" as="xs:string?"/>
        <xsl:param name="prmTokens" as="xs:string*"/>
        <xsl:choose>
            <xsl:when test="empty($prmDstStr) or empty($prmTokens)">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="dstStrs" as="xs:string*" select="tokenize($prmDstStr,'\s')"/>
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
    
    <!-- end of stylesheet -->
</xsl:stylesheet>

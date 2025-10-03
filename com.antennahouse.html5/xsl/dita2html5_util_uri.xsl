<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    URI Utility Templates
    **************************************************************
    File Name : dita2html5_util_uri.xsl
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
    exclude-result-prefixes="xs ahf" >

    <!--
    function:   Get relative path from $prmTopicUri to $prmMapUri 
    param:      prmTopicUri, prmMapUri
    return:     xs:string?
    note:       
    -->
    <xsl:function name="ahf:getPathToMapDirFromTopic" as="xs:string?">
        <xsl:param name="prmMapUri" as="xs:string"/>
        <xsl:param name="prmTopicUri" as="xs:string"/>
        <xsl:sequence select="ahf:getRelativePath(resolve-uri('.',$prmTopicUri),resolve-uri('.',$prmMapUri),'')"/>
    </xsl:function>
    
    <!--
    function:   Get relative path from $prmTopicUri and $prmFileName to $prmMapUri 
    param:      prmTopicUri, prmMapUri, prmFileName
    return:     xs:string?
    note:       
    -->
    <xsl:function name="ahf:getPathToFile" as="xs:string?">
        <xsl:param name="prmMapUri" as="xs:string"/>
        <xsl:param name="prmTopicUri" as="xs:string"/>
        <xsl:param name="prmFileName" as="xs:string"/>
        <xsl:sequence select="ahf:getRelativePath(resolve-uri('.',$prmTopicUri),resolve-uri('.',$prmMapUri), $prmFileName)"/>
    </xsl:function>

    <!--
    function:   Get relative path to $prmFile from $prmBaseDir using $prmTargetDir 
    param:      prmBaseDir, prmTargetDir, prmTargetFile
    return:     xs:string
    note:              
    -->
    <xsl:function name="ahf:getRelativePath" as="xs:string?">
        <xsl:param name="prmBaseDir" as="xs:string"/>
        <xsl:param name="prmTargetDir" as="xs:string"/>
        <xsl:param name="prmTargetFile" as="xs:string"/>
        
        <xsl:variable name="baseDirPathTokens" as="xs:string+" select="tokenize(replace($prmBaseDir, '/$', ''), '/')" />
        <xsl:variable name="targetDirPathTokens" as="xs:string+" select="tokenize(replace($prmTargetDir, '/$', ''), '/')" />
        <xsl:variable name="pathFromBase" as="xs:string*"
            select="for $i in 1 to count($baseDirPathTokens)
                        return if ($i > count($targetDirPathTokens) or $targetDirPathTokens[$i] != $baseDirPathTokens[$i])
                           then '..'
                           else ()"/>
        <xsl:variable name="pathToTarget" as="xs:string*"
            select="for $i in 1 to count($targetDirPathTokens)
                        return if ($i > count($baseDirPathTokens) or $targetDirPathTokens[$i] != $baseDirPathTokens[$i])
                            then $targetDirPathTokens[$i]
                            else ()"/>
        <xsl:sequence select="string-join(($pathFromBase, $pathToTarget, $prmTargetFile), '/')" />
    </xsl:function>

    <!--
    function:   Normalize href 
    param:      prmHref
    return:     xs:string
    note:              
    -->
    <xsl:function name="ahf:normalizeHref" as="xs:string">
        <xsl:param name="prmHref" as="xs:string"/>
        <xsl:sequence select="replace(translate($prmHref, '\', '/'), ' ', '%20')"/>
    </xsl:function>

</xsl:stylesheet>
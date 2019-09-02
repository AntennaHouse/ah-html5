<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Metadata Generation Templates
    **************************************************************
    File Name : dita2html5_gen_metadata.xsl
    **************************************************************
    Copyright © 2008-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs ahf"
    version="3.0">
    
    <!--
    function:   Generate Map Metadata For HTML Header
    param:      none
    return:     meta, etc
    note:       
    -->
    <xsl:template name="genMapMetadata">
        <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaType','%type',name($map))"/>
        <xsl:variable name="topicMeta" as="element()?" select="$map/*[contains-token(@class,'map/topicmeta')]"/>

        <!-- author
             <author> *
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/author')]">
            <xsl:variable name="author" as="element()*" select="$topicMeta/*[contains-token(@class,'topic/author')]"/>
            <xsl:variable name="authorMeta" as="node()*">
                <xsl:for-each  select="$topicMeta/*[contains-token(@class,'topic/author')]">
                    <xsl:variable name="author" as="element()" select="."/>
                    <xsl:variable name="authorValue" as="xs:string?" select="ahf:getNormalizedText($author)"/>
                    <xsl:if test="exists($authorValue)">
                        <xsl:choose>
                            <xsl:when test="$author/@type/string() => normalize-space() eq 'contributor'">
                                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaContributor','%contributor',$authorValue)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCreator','%creator',$authorValue)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$author => count() gt 1">
                    <!-- Get unique autor entry -->
                    <xsl:variable name="authorMetaSerialized" as="xs:string+" select="$authorMeta ! serialize(.)"/>
                    <xsl:variable name="authorMetaUnique" as="xs:string+" select="$authorMetaSerialized => distinct-values()"/>
                    <xsl:sequence select="$authorMetaUnique ! parse-xml-fragment(.) ! ahf:getTopLevelNodes(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$authorMeta"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <!-- source
             <source> ?
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/source')]/@href">
            <xsl:variable name="source" as="xs:string?" select="$topicMeta/*[contains-token(@class,'topic/source')]/@href/ahf:getNormalizedText(.)"/>
            <xsl:if test="exists($source)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaSource','%src',$source)"/>    
            </xsl:if>
        </xsl:if>

        <!-- publisher
             <publisher> ?
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/publisher')]">
            <xsl:variable name="publisher" as="xs:string?" select="$topicMeta/*[contains-token(@class,'topic/publisher')]/ahf:getNormalizedText(.)"/>
            <xsl:if test="exists($publisher)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaPublisher','%publisher',$publisher)"/>    
            </xsl:if>
        </xsl:if>

        <!-- copyright
            <copyright> * / <copyryear> +, <copyrholder>
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/copyright')]">
            <xsl:for-each select="$topicMeta/*[contains-token(@class,'topic/copyright')]">
                <xsl:variable name="copyright" as="element()" select="."/>
                <xsl:variable name="copyrYear" as="xs:string">
                    <xsl:variable name="tempCopyrYear" as="xs:string+">
                        <xsl:for-each select="$copyright/*[contains-token(@class,'topic/copyryear')]/@year/ahf:getNormalizedText(.)">
                            <xsl:sequence select="."/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:sequence select="string-join($tempCopyrYear,', ')"/>
                </xsl:variable>
                <xsl:variable name="copyrHolder" as="xs:string" select="string(ahf:getNormalizedText($copyright/*[contains-token(@class,'topic/copyrholder')]))"/>
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaRights',('%copy-year','%copy-holder'),($copyrYear,$copyrHolder))"/>    
            </xsl:for-each>
        </xsl:if>

        <!--created, modified, golive, expiry
            <critdates> ? / <created> ? , <revised> *
            <created> / @date
            <revised> / @modified, @golive?, @expiry
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/critdates')]">
            <xsl:variable name="critdates" as="element()" select="$topicMeta/*[contains-token(@class,'topic/critdates')]"/>
            <xsl:if test="exists($critdates/*[contains-token(@class,'topic/created')]/@date)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaDateCreated',('%date'),($critdates/*[contains-token(@class,'topic/created')]/@date/ahf:getNormalizedText(.)))"/>
            </xsl:if>
            <xsl:for-each select="$critdates/*[contains-token(@class,'topic/revised')]">
                <xsl:variable name="revised" as="element()" select="."/>
                <xsl:variable name="modified" as="xs:string" select="$revised/@modified/ahf:getNormalizedText(.)"/>
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaDateModified',('%date'),($modified))"/>    
                <xsl:variable name="golive" as="xs:string?" select="$revised/@golive/ahf:getNormalizedText(.)"/>
                <xsl:if test="exists($golive)">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaDateIssued',('%date'),($golive))"/>    
                </xsl:if>   
                <xsl:variable name="expiry" as="xs:string?" select="$revised/@expiry/ahf:getNormalizedText(.)"/>
                <xsl:if test="exists($expiry)">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaDateExpiry',('%date'),($expiry))"/>    
                </xsl:if>
            </xsl:for-each>
        </xsl:if>

        <!-- permissions
            <permissions> ?
            <permisiions> / @view
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/permissions')]">
            <xsl:variable name="permissions" as="element()" select="$topicMeta/*[contains-token(@class,'topic/permissions')]"/>
            <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaRightUsage',('%usage'),($permissions/@view/ahf:getNormalizedText(.)))"/>
        </xsl:if>

        <!-- audience
            <audience> * 
         -->
        <xsl:for-each select="$topicMeta/*[contains-token(@class,'topic/audience')]">
            <xsl:variable name="audience" as="element()" select="."/>
            <xsl:if test="$audience/@experiencelevel">
                <xsl:variable name="experienceLevel" as="xs:string?" select="$audience/@experiencelevel/ahf:getNormalizedText(.)"/>
                <xsl:if test="$experienceLevel =>exists()">
                    <xsl:copy-of select="$experienceLevel ! ahf:getXmlObjectReplacing('xmlMetaAudienceExperiencelevel','%experiencelevel',.)"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$audience/@importance">
                <xsl:variable name="importance" as="xs:string?" select="$audience/@importance/ahf:getNormalizedText(.)"/>
                <xsl:if test="$importance => exists()">
                    <xsl:copy-of select="$importance ! ahf:getXmlObjectReplacing('xmlMetaAudienceImportance','%importance',.)"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$audience/@name">
                <xsl:variable name="name" as="xs:string?" select="$audience/@name/ahf:getNormalizedText(.)"/>
                <xsl:if test="$name => exists()">
                    <xsl:copy-of select="$name ! ahf:getXmlObjectReplacing('xmlMetaAudienceName','%name',.)"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$audience/@job">
                <xsl:variable name="job" as="xs:string?" select="$audience/@job/ahf:getNormalizedText(.)"/>
                <xsl:if test="$job => exists()">
                    <xsl:choose>
                        <xsl:when test="$job eq 'other'">
                            <xsl:variable name="otherJob" as="xs:string?" select="$audience/@otherjob/ahf:getNormalizedText(.)"/>
                            <xsl:if test="exists($otherJob)">
                                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaAudienceJob','%job',$otherJob)"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaAudienceJob','%job',$job)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$audience/@type">
                <xsl:variable name="type" as="xs:string?" select="$audience/@type/ahf:getNormalizedText(.)"/>
                <xsl:if test="$type => exists()">
                    <xsl:choose>
                        <xsl:when test="$type eq 'other'">
                            <xsl:variable name="otherType" as="xs:string?" select="$audience/@othertype/ahf:getNormalizedText(.)"/>
                            <xsl:if test="exists($otherType)">
                                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaAudienceType','%type',$otherType)"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaAudienceType','%type',$type)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>

        <!-- category
            <category> *
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/category')]">
            <xsl:variable name="category" as="xs:string*" select="$topicMeta/*[contains-token(@class,'topic/category')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$category ! ahf:getXmlObjectReplacing('xmlMetaCoverage','%coverage',.)"/>
        </xsl:if>

        <!-- keywords
            <keywords> *
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/keywords')]">
            <xsl:variable name="keywords" as="xs:string*" select="ahf:genKeywords($topicMeta/*[contains-token(@class,'topic/keywords')])"/>
            <xsl:if test="exists($keywords)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaSubject','%subject',$keywords)"/>
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaKeywords','%keywords',$keywords)"/>
            </xsl:if>
        </xsl:if>

        <!-- prodname
            <prodinfo> * / <prodname>
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/prodname')]">
            <xsl:variable name="prodName" as="xs:string*" select="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/prodname')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$prodName ! ahf:getXmlObjectReplacing('xmlMetaProdName','%prod-name',.)"/>
        </xsl:if>

        <!-- version, release, modification 
            <prodinfo> * / <brand> / <vrmlist> ? / <vrm> + / @version, @release, @modification 
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/vrmlist')]/*[contains-token(@class,'topic/vrm')]">
            <xsl:variable name="vrms" as="element()*" select="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/vrmlist')]/*[contains-token(@class,'topic/vrm')]"/>
            <xsl:for-each select="$vrms">
                <xsl:variable name="vrm" as="element()" select="."/>
                <xsl:variable name="version" as="xs:string?" select="$vrm/@version/ahf:getNormalizedText(.)"/>
                <xsl:if test="exists($version)">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaVersion','%version',$version)"/>
                </xsl:if>
                <xsl:variable name="release" as="xs:string?" select="$vrm/@release/ahf:getNormalizedText(.)"/>
                <xsl:if test="exists($release)">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaRelease','%release',$release)"/>
                </xsl:if>
                <xsl:variable name="modification" as="xs:string?" select="$vrm/@modification/ahf:getNormalizedText(.)"/>
                <xsl:if test="exists($modification)">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaModification','%modification',$modification)"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>

        <!-- brand 
            <prodinfo> * / <brand> 
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/brand')]">
            <xsl:variable name="brand" as="xs:string*" select="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/brand')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$brand ! ahf:getXmlObjectReplacing('xmlMetaBrand','%brand',.)"/>
        </xsl:if>

        <!-- component
            <prodinfo> * / <component> 
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/component')]">
            <xsl:variable name="component" as="xs:string*" select="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/component')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$component ! ahf:getXmlObjectReplacing('xmlMetaComponent','%component',.)"/>
        </xsl:if>
        
        <!-- featnum
            <prodinfo> * / <featnum> 
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/featnum')]">
            <xsl:variable name="featnum" as="xs:string*" select="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/featnum')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$featnum ! ahf:getXmlObjectReplacing('xmlMetaFeatnum','%featnum',.)"/>
        </xsl:if>

        <!-- platform
            <prodinfo> * / <platform>
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/platform')]">
            <xsl:variable name="platform" as="xs:string*" select="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/platform')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$platform ! ahf:getXmlObjectReplacing('xmlMetaPlatform','%platform',.)"/>
        </xsl:if>

        <!-- prognum
            <prodinfo> * / <prognum> 
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/prognum')]">
            <xsl:variable name="prognum" as="xs:string*" select="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/prognum')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$prognum ! ahf:getXmlObjectReplacing('xmlMetaPrognum','%prognum',.)"/>
        </xsl:if>
        
        <!-- series
            <prodinfo> * / <series>
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/series')]">
            <xsl:variable name="series" as="xs:string*" select="$topicMeta/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/series')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$series ! ahf:getXmlObjectReplacing('xmlMetaSeries','%series',.)"/>
        </xsl:if>
        
        <!--othermeta
           <othermeta> *
         -->
        <xsl:if test="$topicMeta/*[contains-token(@class,'topic/othermeta')]">
            <xsl:variable name="othermetas" as="element()*" select="$topicMeta/*[contains-token(@class,'topic/othermeta')]"/>
            <xsl:copy-of select="$othermetas ! ahf:getXmlObjectReplacing('xmlMetaOther',('%name','%content'),(@name =>ahf:getNormalizedText() => string(),@content => ahf:getNormalizedText() => string()))"/>
        </xsl:if>

        <!--id
            map/@id
         -->
        <xsl:if test="$map/@id">
            <xsl:variable name="id" as="xs:string" select="$map/@id/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaIdentifier',('%id'),($id))"/>
        </xsl:if>
        
        <!--xml:lang
            $map/@id
         -->
        <xsl:if test="$map/@xml:lang">
            <xsl:variable name="xmlLang" as="xs:string?" select="$map/@xml:lang/ahf:getNormalizedText(.)"/>
            <xsl:if test="exists($xmlLang)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaLanguage',('%lang'),(ahf:nomalizeXmlLang($xmlLang)))"/>
            </xsl:if>
        </xsl:if>
        
    </xsl:template>

    <!--
    function:   Generate Topic Metadata For HTML Header
    param:      none
    return:     meta, etc
    note:       map/topicmeta will be merged into topic/prolog
    -->
    <xsl:template name="genTopicMetadata">
        <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaType','%type',name($topic))"/>
        <xsl:variable name="prolog" as="element()?" select="$topic/*[contains-token(@class,'topic/prolog')]"/>

        <!-- author
             <author> *
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/author')]">
            <xsl:variable name="author" as="element()*" select="$prolog/*[contains-token(@class,'topic/author')]"/>
            <xsl:variable name="authorMeta" as="node()*">
                <xsl:for-each  select="$prolog/*[contains-token(@class,'topic/author')]">
                    <xsl:variable name="author" as="element()" select="."/>
                    <xsl:variable name="authorValue" as="xs:string?" select="ahf:getNormalizedText($author)"/>
                    <xsl:if test="exists($authorValue)">
                        <xsl:choose>
                            <xsl:when test="$author/@type/string() => normalize-space() eq 'contributor'">
                                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaContributor','%contributor',$authorValue)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaCreator','%creator',$authorValue)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$author => count() gt 1">
                    <!-- Get unique autor entry -->
                    <xsl:variable name="authorMetaSerialized" as="xs:string+" select="$authorMeta ! serialize(.)"/>
                    <xsl:variable name="authorMetaUnique" as="xs:string+" select="$authorMetaSerialized => distinct-values()"/>
                    <xsl:sequence select="$authorMetaUnique ! parse-xml-fragment(.) ! ahf:getTopLevelNodes(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$authorMeta"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <!-- source
             <source> ?
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/source')]/@href">
            <xsl:variable name="source" as="xs:string?" select="$prolog/*[contains-token(@class,'topic/source')]/@href/ahf:getNormalizedText(.)"/>
            <xsl:if test="exists($source)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaSource','%src',$source)"/>    
            </xsl:if>
        </xsl:if>

        <!-- publisher
             <publisher> ?
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/publisher')]">
            <xsl:variable name="publisher" as="xs:string?" select="$prolog/*[contains-token(@class,'topic/publisher')]/ahf:getNormalizedText(.)"/>
            <xsl:if test="exists($publisher)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaPublisher','%publisher',$publisher)"/>    
            </xsl:if>
        </xsl:if>

        <!-- copyright
            <copyright> * / <copyryear> +, <copyrholder>
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/copyright')]">
            <xsl:for-each select="$prolog/*[contains-token(@class,'topic/copyright')]">
                <xsl:variable name="copyright" as="element()" select="."/>
                <xsl:variable name="copyrYear" as="xs:string">
                    <xsl:variable name="tempCopyrYear" as="xs:string+">
                        <xsl:for-each select="$copyright/*[contains-token(@class,'topic/copyryear')]/@year/ahf:getNormalizedText(.)">
                            <xsl:sequence select="."/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:sequence select="string-join($tempCopyrYear,', ')"/>
                </xsl:variable>
                <xsl:variable name="copyrHolder" as="xs:string" select="string(ahf:getNormalizedText($copyright/*[contains-token(@class,'topic/copyrholder')]))"/>
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaRights',('%copy-year','%copy-holder'),($copyrYear,$copyrHolder))"/>    
            </xsl:for-each>
        </xsl:if>

        <!--created, modified, golive, expiry
            <critdates> ? / <created> ? , <revised> *
            <created> / @date
            <revised> / @modified, @golive?, @expiry
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/critdates')]">
            <xsl:variable name="critdates" as="element()" select="$prolog/*[contains-token(@class,'topic/critdates')]"/>
            <xsl:if test="exists($critdates/*[contains-token(@class,'topic/created')]/@date)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaDateCreated',('%date'),($critdates/*[contains-token(@class,'topic/created')]/@date/ahf:getNormalizedText(.)))"/>
            </xsl:if>
            <xsl:for-each select="$critdates/*[contains-token(@class,'topic/revised')]">
                <xsl:variable name="revised" as="element()" select="."/>
                <xsl:variable name="modified" as="xs:string" select="$revised/@modified/ahf:getNormalizedText(.)"/>
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaDateModified',('%date'),($modified))"/>    
                <xsl:variable name="golive" as="xs:string?" select="$revised/@golive/ahf:getNormalizedText(.)"/>
                <xsl:if test="exists($golive)">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaDateIssued',('%date'),($golive))"/>    
                </xsl:if>   
                <xsl:variable name="expiry" as="xs:string?" select="$revised/@expiry/ahf:getNormalizedText(.)"/>
                <xsl:if test="exists($expiry)">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaDateExpiry',('%date'),($expiry))"/>    
                </xsl:if>
            </xsl:for-each>
        </xsl:if>

        <!-- permissions
            <permissions> ?
            <permisiions> / @view
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/permissions')]">
            <xsl:variable name="permissions" as="element()" select="$prolog/*[contains-token(@class,'topic/permissions')]"/>
            <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaRightUsage',('%usage'),($permissions/@view/ahf:getNormalizedText(.)))"/>
        </xsl:if>

        <!-- audience
            <audience> * 
         -->
        <xsl:for-each select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/audience')]">
            <xsl:variable name="audience" as="element()" select="."/>
            <xsl:if test="$audience/@experiencelevel">
                <xsl:variable name="experienceLevel" as="xs:string?" select="$audience/@experiencelevel/ahf:getNormalizedText(.)"/>
                <xsl:if test="$experienceLevel =>exists()">
                    <xsl:copy-of select="$experienceLevel ! ahf:getXmlObjectReplacing('xmlMetaAudienceExperiencelevel','%experiencelevel',.)"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$audience/@importance">
                <xsl:variable name="importance" as="xs:string?" select="$audience/@importance/ahf:getNormalizedText(.)"/>
                <xsl:if test="$importance => exists()">
                    <xsl:copy-of select="$importance ! ahf:getXmlObjectReplacing('xmlMetaAudienceImportance','%importance',.)"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$audience/@name">
                <xsl:variable name="name" as="xs:string?" select="$audience/@name/ahf:getNormalizedText(.)"/>
                <xsl:if test="$name => exists()">
                    <xsl:copy-of select="$name ! ahf:getXmlObjectReplacing('xmlMetaAudienceName','%name',.)"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$audience/@job">
                <xsl:variable name="job" as="xs:string?" select="$audience/@job/ahf:getNormalizedText(.)"/>
                <xsl:if test="$job => exists()">
                    <xsl:choose>
                        <xsl:when test="$job eq 'other'">
                            <xsl:variable name="otherJob" as="xs:string?" select="$audience/@otherjob/ahf:getNormalizedText(.)"/>
                            <xsl:if test="exists($otherJob)">
                                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaAudienceJob','%job',$otherJob)"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaAudienceJob','%job',$job)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$audience/@type">
                <xsl:variable name="type" as="xs:string?" select="$audience/@type/ahf:getNormalizedText(.)"/>
                <xsl:if test="$type => exists()">
                    <xsl:choose>
                        <xsl:when test="$type eq 'other'">
                            <xsl:variable name="otherType" as="xs:string?" select="$audience/@othertype/ahf:getNormalizedText(.)"/>
                            <xsl:if test="exists($otherType)">
                                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaAudienceType','%type',$otherType)"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaAudienceType','%type',$type)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        
        <!-- category
            <category> *
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/category')]">
            <xsl:variable name="category" as="xs:string*" select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/category')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$category ! ahf:getXmlObjectReplacing('xmlMetaCoverage','%coverage',.)"/>
        </xsl:if>

        <!-- keywords
            <keywords> )*
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/keywords')]">
            <xsl:variable name="keywords" as="xs:string*" select="ahf:genKeywords($prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/keywords')])"/>
            <xsl:if test="exists($keywords)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaSubject','%subject',$keywords)"/>
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaKeywords','%keywords',$keywords)"/>
            </xsl:if>
        </xsl:if>

        <!-- prodname
            <prodinfo> * / <prodname>
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/prodname')]">
            <xsl:variable name="prodName" as="xs:string*" select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/prodname')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$prodName ! ahf:getXmlObjectReplacing('xmlMetaProdName','%prod-name',.)"/>
        </xsl:if>

        <!-- version, release, modification 
            <prodinfo> * / <brand> / <vrmlist> ? / <vrm> + / @version, @release, @modification 
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/vrmlist')]/*[contains-token(@class,'topic/vrm')]">
            <xsl:variable name="vrms" as="element()*" select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/vrmlist')]/*[contains-token(@class,'topic/vrm')]"/>
            <xsl:for-each select="$vrms">
                <xsl:variable name="vrm" as="element()" select="."/>
                <xsl:variable name="version" as="xs:string?" select="$vrm/@version/ahf:getNormalizedText(.)"/>
                <xsl:if test="exists($version)">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaVersion','%version',$version)"/>
                </xsl:if>
                <xsl:variable name="release" as="xs:string?" select="$vrm/@release/ahf:getNormalizedText(.)"/>
                <xsl:if test="exists($release)">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaRelease','%release',$release)"/>
                </xsl:if>
                <xsl:variable name="modification" as="xs:string?" select="$vrm/@modification/ahf:getNormalizedText(.)"/>
                <xsl:if test="exists($modification)">
                    <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaModification','%modification',$modification)"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>

        <!-- brand 
            <prodinfo> * / <brand> 
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/brand')]">
            <xsl:variable name="brand" as="xs:string*" select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/brand')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$brand ! ahf:getXmlObjectReplacing('xmlMetaBrand','%brand',.)"/>
        </xsl:if>

        <!-- component
            <prodinfo> * / <component> 
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/component')]">
            <xsl:variable name="component" as="xs:string*" select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/component')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$component ! ahf:getXmlObjectReplacing('xmlMetaComponent','%component',.)"/>
        </xsl:if>
        
        <!-- featnum
            <prodinfo> * / <featnum> 
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/featnum')]">
            <xsl:variable name="featnum" as="xs:string*" select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/featnum')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$featnum ! ahf:getXmlObjectReplacing('xmlMetaFeatnum','%featnum',.)"/>
        </xsl:if>

        <!-- platform
            <prodinfo> * / <platform>
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/platform')]">
            <xsl:variable name="platform" as="xs:string*" select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/platform')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$platform ! ahf:getXmlObjectReplacing('xmlMetaPlatform','%platform',.)"/>
        </xsl:if>

        <!-- prognum
            <prodinfo> * / <prognum> 
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/prognum')]">
            <xsl:variable name="prognum" as="xs:string*" select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/prognum')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$prognum ! ahf:getXmlObjectReplacing('xmlMetaPrognum','%prognum',.)"/>
        </xsl:if>
        
        <!-- series
            <prodinfo> * / <series>
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/series')]">
            <xsl:variable name="series" as="xs:string*" select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/prodinfo')]/*[contains-token(@class,'topic/series')]/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="$series ! ahf:getXmlObjectReplacing('xmlMetaSeries','%series',.)"/>
        </xsl:if>
        
        <!--othermeta
           <othermeta> *
         -->
        <xsl:if test="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/othermeta')]">
            <xsl:variable name="othermetas" as="element()*" select="$prolog/*[contains-token(@class,'topic/metadata')]/*[contains-token(@class,'topic/othermeta')]"/>
            <xsl:copy-of select="$othermetas ! ahf:getXmlObjectReplacing('xmlMetaOther',('%name','%content'),(@name => ahf:getNormalizedText() => string(),@content => ahf:getNormalizedText() => string()))"/>
        </xsl:if>

        <!--id
            map/@id
         -->
        <xsl:if test="$topic/@id">
            <xsl:variable name="id" as="xs:string" select="$topic/@id/ahf:getNormalizedText(.)"/>
            <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaIdentifier',('%id'),($id))"/>
        </xsl:if>
        
        <!--xml:lang
            $map/@id
         -->
        <xsl:if test="$topic/@xml:lang">
            <xsl:variable name="xmlLang" as="xs:string?" select="$topic/@xml:lang/ahf:getNormalizedText(.)"/>
            <xsl:if test="exists($xmlLang)">
                <xsl:copy-of select="ahf:getXmlObjectReplacing('xmlMetaLanguage',('%lang'),(ahf:nomalizeXmlLang($xmlLang)))"/>
            </xsl:if>
        </xsl:if>
        
    </xsl:template>

    <!-- 
     function:  Generate Keyword From <keywords>
     param:     prmKeywords: keywords element
     return:    xs:string
     note:      <keywords> = (<apiname> | <cmdname> | <indexterm> | <keyword> | <markupname> | <msgnum> | <numcharref> | 
                              <option> | <parameterentity> | <parmname> | <textentity> | <varname> | <wintitle> | 
                              <xmlatt> | <xmlelement> | <xmlnsname> | <xmlpi> )*
    -->
    <xsl:function name="ahf:genKeywords" as="xs:string?">
        <xsl:param name="prmKeywords" as="element()*"/>
        <xsl:variable name="tempKeywords" as="xs:string*">
            <xsl:for-each select="$prmKeywords">
                <xsl:apply-templates select="*" mode="MODE_GET_KEYWORD"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="combinedKeyWord" select="string-join(distinct-values($tempKeywords),', ')"/>
        <xsl:sequence select="if (string($combinedKeyWord)) then $combinedKeyWord else ()"/>
    </xsl:function>
    
    <xsl:template match="*[contains-token(@class,'topic/keyword')]" mode="MODE_GET_KEYWORD" as="xs:string?">
        <xsl:variable name="tempKeyWord" as="xs:string*">
            <xsl:apply-templates mode="TEXT_ONLY"/>
        </xsl:variable>
        <xsl:variable name="combinedKeyWord" as="xs:string" select="normalize-space(string-join($tempKeyWord,''))"/>
        <xsl:sequence select="if (string($combinedKeyWord)) then $combinedKeyWord else ()"/>
    </xsl:template>
    
    <xsl:template match="*[contains-token(@class,'topic/indexterm')]|*[contains-token(@class,'topic/index-base')]" mode="MODE_GET_KEYWORD" as="xs:string*">
        <xsl:variable name="tempIndexterm" as="xs:string*">
            <xsl:apply-templates select="node() except (*[contains-token(@class,'topic/indexterm')]|*[contains-token(@class,'topic/index-base')])" mode="TEXT_ONLY"/>
        </xsl:variable>
        <xsl:variable name="combinedKeyWord" as="xs:string" select="normalize-space(string-join($tempIndexterm,''))"/>
        <xsl:sequence select="if (string($combinedKeyWord)) then $combinedKeyWord else ()"/>
        <xsl:apply-templates select="*[contains-token(@class,'topic/indexterm')]|*[contains-token(@class,'topic/index-base')]" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="*" mode="MODE_GET_KEYWORD" as="xs:string?">
        <xsl:variable name="tempElemValue" as="xs:string*">
            <xsl:apply-templates mode="TEXT_ONLY"/>
        </xsl:variable>
        <xsl:variable name="combinedElemValue" as="xs:string" select="normalize-space(string-join($tempElemValue,''))"/>
        <xsl:sequence select="if (string($combinedElemValue)) then $combinedElemValue else ()"/>
    </xsl:template>

</xsl:stylesheet>

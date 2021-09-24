<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Message definition
    **************************************************************
    File Name : dita2html5_message.xsl
    **************************************************************
    Copyright © 2009-2019 Antenna House, Inc.All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.co.jp/
    **************************************************************
-->

<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs">
    <!--
    ===============================================
    Message Definition
    ===============================================
    -->
    <xsl:variable name="stMes001">
        <xsl:text>[General 001W] No template is defined for this element. element=%elem file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes005">
        <xsl:text>[getAttributeSet 005F] Attribute-set name not found attribute-set=%attrsetname file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes006">
        <xsl:text>[getAttributeValue 006F] Attribute-set name not found. attribute-set=%attrsetname file=%file</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes007">
        <xsl:text>[getAttributeValue 007F] Attribute name not found. attribute-name=%attrname attribute-set-name=%attrsetname file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes008">
        <xsl:text>[getVarValue 008F] Variable %var is not found in %file.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes009">
        <xsl:text>[getInstreamObject 009F] Instream object name not found. obj-name=%objname file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes010">
        <xsl:text>[getFormattingObject 010F] Formatting object name not found. obj-name=%objname file=%file</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes012">
        <xsl:text>[getVarValueAsInteger 012F] Variable value is not castable as xs:integer. variable=%var value=%value file=%file</xsl:text>
    </xsl:variable>
    
    
    <!--xsl:variable name="stMes020">
        <xsl:text>[getVarValue 020F] Variable %var defined more than once in %file.</xsl:text>
    </xsl:variable-->
    
    <!--xsl:variable name="stMes021">
        <xsl:text>[getVarValue 021F] Variable %var defined more than once in %file.</xsl:text>
    </xsl:variable-->
    
    <xsl:variable name="stMes023">
        <xsl:text>[getVarRecursive 023F] Referenced variable %varname</xsl:text>
        <xsl:text> is not exist in %stylefile</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes025">
        <xsl:text>[getCssStyle 025F] Style %style does not defined in %file.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes028">
        <xsl:text>[percentToNumber 028W] Invalid @scale value. Assumed 100. scale=%scale element=%elem file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes030">
        <xsl:text>[processLocalXref 030F] Xref/@href destination topic does not found. Probably href format is illegal. href=%href  ohref=%ohref file=%file.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes031">
        <xsl:text>[getXrefTitle 031W] Xref/@href destination section has no title element. Section id=%id file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes032">
        <xsl:text>[getXrefTitle 032W] Xref/@href destination example has no title element. Example id=%id file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes033">
        <xsl:text>[getXrefTitle 033W] Xref/@href destination table has no title element. Table id=%id file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes034">
        <xsl:text>[getXrefTitle 034W] Xref/@href destination fig has no title element. Fig id=%id file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes035">
        <xsl:text>[getXrefTitle 035W] Xref/@href destination %elem has no title content. %elem id=%id file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes037">
        <xsl:text>[getFootnotePrefix 037W] The fn element does not have table,simpletable,ul,ol,dl,glossdef as ancestor. This fn will be ignored. Content='%cont' file=%file</xsl:text>
    </xsl:variable>
    
    <!--xsl:variable name="stMes040">
        <xsl:text>[bodyelements 040W] Element object that has unknown element is not supported. file=%file trace=%trace</xsl:text>
    </xsl:variable-->
    
    <xsl:variable name="stMes040">
        <xsl:text>[bodyelements 040W] Ignored fn element in invalid position file="%file" xpath="%xpath"</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes050">
        <xsl:text>[getKeyCol 050W] The keycol attribute is not positive integer. Assumed as not specified. file=%file element=%elem keycol=%keycol</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes055">
        <xsl:text>[dlhead 055W] As PRM_FORMAT_DL_AS_BLOCK='yes', the dl/dlhead element is ignored. file=%file </xsl:text>
    </xsl:variable>
    
    
    <xsl:variable name="stMes060">
        <xsl:text>[synnoteref 060W] The href attribute of synnoteref cannot be resolved. file=%file trace=%trace @href=%href</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes062">
        <xsl:text>[processLink 062W] Ignored invalid link in related-links or reltable. file=%file href=%href</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes063">
        <xsl:text>[processLink 063W] Ignored invalid link in related-links or reltable. file=%file href=%href</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes070">
        <xsl:text>[processLink 070W] topicref/@href target does not found. href='%href' file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes072">
        <xsl:text>[processLocalXref 072F] Xref target is not contained in map. href='%href' ohref='%ohref' file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes074">
        <xsl:text>[makeBasicLinkDestination 074F] Topic in href target does not found. href='%href' file=%file element=%element</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes076">
        <xsl:text>[processTopicref 076F] topicref/@href target does not found. href='%href' file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes078">
        <xsl:text>[genGlossaryListMain 078F] Referenced topicref does not found. id of topic='%id' file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes079">
        <xsl:text>[genGlossaryListBookMark 079F] Referenced topicref does not found. id of topic='%id' file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes080">
        <xsl:text>[Frontmatter 080W] Element:%elem without @href attribute is ignored. file=%file</xsl:text>
    </xsl:variable>
        
    <xsl:variable name="stMes082">
        <xsl:text>[Frontmatter 082W] Element:%elem without @href attribute is not supported. file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes084">
        <xsl:text>[Backmatter 084W] Element:%elem without @href attribute is ignored. file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes086">
        <xsl:text>[Backmatter 086W] Element:%elem without @href attribute is not supported. file=%file</xsl:text>
    </xsl:variable>
        
    <xsl:variable name="stMes087">
        <xsl:text>[Figurelist 087W] Element:%elem is ignored. There is no figure with title. file=%file</xsl:text>
    </xsl:variable>
        
    <xsl:variable name="stMes088">
        <xsl:text>[Tablelist 088W] Element:%elem is ignored. There is no table with title. file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes089">
        <xsl:text>[Glossarylist 089W] Element:%elem is ignored. There is no glossentry as the child of %elem. file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes090">
        <xsl:text>[Glossarylist 090W] Element:%elem should be written in backmatter otherwise all of indexterm after the %elem will be automatically ignored. file=%file</xsl:text>
    </xsl:variable>
        
    <xsl:variable name="stMes092">
        <xsl:text>[abbreviated-form 092W] Referenced glossentry not found. @keyref=%keyref @href=%href file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes100">
        <xsl:text>[ditamapClass 100F] Undefined ditamap class. class=%class file=%file</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes101">
        <xsl:text>[documentLang 101W] xml:lang is not specified in map or topic. Adopt '%lang' as default language.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes102">
        <xsl:text>[altstyledef 102W] Alternate style definition file %file does not found. Stylesheet use %default as style definition file.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes103">
        <xsl:text>[altstyledef 103W] Alternate style definition file %file does not found. Stylesheet use %default as alternate style definition file.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes104">
        <xsl:text>[styledef 104F] Style definition file %file does not found.</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes105">
        <xsl:text>[styledef 105F] Language specific style definition file is not found. file="%file"</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes200">
        <xsl:text>[map 200W] Failed to generate navigation title for topicref="%xpath" @href="%href"</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes204">
        <xsl:text>[related-links 204W] The link to '%href' may appear more than once in '%file'.</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes250">
        <xsl:text>[getEntryClassAttr 250W] align='char' is not supported in HTML output. entry='%entry-pos'.</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes400">
        <xsl:text>[getPropertyNu 400W] Invalid non-numeric property value='%val'. Treated as 1.0.</xsl:text>
    </xsl:variable>
    
    
    
    
    
    
    
    
    <xsl:variable name="stMes601">
        <xsl:text>[genIndex 601I] Index debug start.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes602">
        <xsl:text>[genIndex 602I] Index debug end.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes610">
        <xsl:text>[indexterm 610W] Authoring error! Indexterm has sibling index-see element.</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore this index-see element.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes611">
        <xsl:text>[indexterm 611W] Authoring error! Indexterm has sibling index-see-also element.</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore this index-see-also element.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes612">
        <xsl:text>[indexterm 612W] Authoring error! Indexterm has both index-see and index-see-also child element.</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore this index-see element.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes620">
        <xsl:text>[indexterm 620W] Authoring error! Text of indexterm is empty.</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore this indexterm element.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes621">
        <xsl:text>[indexterm 621W] Authoring error! Text of indexterm is too long.</xsl:text>
        <xsl:text> It must be less than %max  characters for sorting.</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will trim this indexterm text for index sorting.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes630">
        <xsl:text>[indexterm 630W] Authoring error! Start attribute is specified in nesting indexterm more than once.</xsl:text>
        <xsl:text> previous='%prev'</xsl:text>
        <xsl:text> current='%curr'</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore this start attribute.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes640">
        <xsl:text>[indexterm 640W] End attribute authoring error! Corresponding indexterm that has same start attribute value does not found.</xsl:text>
        <xsl:text> end='%end'</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore this end attribute.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes641">
        <xsl:text>[indexterm 641W] End attribute authoring error! Corresponding indexterm that has same start attribute value exist plurally.</xsl:text>
        <xsl:text> end='%end'</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore this end attribute.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes642">
        <xsl:text>[indexterm 642W] Authoring warning! Indexterm element that has end attribute should not have ancestor indexterm element.</xsl:text>
        <xsl:text> end='%end'</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore ancestor indexterm.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes643">
        <xsl:text>[indexterm 643W] Authoring warning! Indexterm element that has end attribute should not have child indexterm element.</xsl:text>
        <xsl:text> end='%end'</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore child indexterm.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes650">
        <xsl:text>[indexterm 650W] Authoring error! Attribute start and end cannot be specified together in one indexterm.</xsl:text>
        <xsl:text> start='%start'</xsl:text>
        <xsl:text> end='%end'</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore this indexterm.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes651">
        <xsl:text>[indexterm 651W] Authoring error! End attribute cannot be specified to the descendant of indexterm that has start attribute.</xsl:text>
        <xsl:text> start='%start'</xsl:text>
        <xsl:text> end='%end'</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore this indexterm.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes652">
        <xsl:text>[indexterm 652W] Authoring error! Start attribute cannot be specified to the descendant of indexterm that has end attribute.</xsl:text>
        <xsl:text> start='%start'</xsl:text>
        <xsl:text> end='%end'</xsl:text>
        <xsl:text> index-key='%key'</xsl:text>
        <xsl:text> file=%file</xsl:text>
        <xsl:text> Stylesheet will ignore this indexterm.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes900">
        <xsl:text>[attribute-set 900F] Illegal attribute found in attribute-set element in style definition. attribute-set-name='%attribute-set-name' attribute='%attribute'.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes902">
        <xsl:text>[attribute-set 902F] Attribute-sets references itself by @use-attribute-sets attribute. attribute-set-name='%attribute-set-name'.</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes904">
        <xsl:text>[processUseAttributeSet 904F] There is no attribute-set referenced by @use-attribute-sets. use-attribute-set='%attribute-set-name'.</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes906">
        <xsl:text>[variable 906F] Illegal attribute found in variable element in style definition. variable name='%variable-name' attribute='%attribute'.</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes1022" as="xs:string">
        <xsl:text>[getColNumFromColName 1022F] colname='%colname' does not exists in table/tgroup/colspec. Probably table/tgroup/@cols='%cols' is not match actual column count. file=%file</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes1600">
        <xsl:text>[makeTableCount 1600F] topicref/@href target does not found. href='%href' file=%file</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes1602">
        <xsl:text>[makeFigureCount 1602F] topicref/@href target does not found. href='%href' file=%file</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes1604">
        <xsl:text>[getTablePreviousAmount 1604F] topic target does not found in $tableNumberingMap. id='%id'</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes1606">
        <xsl:text>[getFigPreviousAmount 1606F] topic target does not found in $figureNumberingMap. id='%id'</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes2000">
        <xsl:text>[toTwip 2000F] Invalid input unit value = '%value'.</xsl:text>
    </xsl:variable>
    <xsl:variable name="stMes2001">
        <xsl:text>[toTwip 2001F] Failed to convert to twip. Input value = '%value'.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes2002">
        <xsl:text>[toEmu 2002F] Invalid input unit value = '%value'.</xsl:text>
    </xsl:variable>
    <xsl:variable name="stMes2003">
        <xsl:text>[toEmu 2002F] Failed to convert to EMU. Input value = '%value'.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes2004">
        <xsl:text>[toMm 2004F] Invalid input unit value = '%value'.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes2005">
        <xsl:text>[toMm 2005F] Failed to convert to mm. Input value = '%value'.</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="stMes2007">
        <xsl:text>[getEntryClassAttr 2007F] Failed to get entry information file='%file' entry='%path'.</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes2009">
        <xsl:text>[getEntryClassAttr 2009F] $entryInfo/@ahf:colnum is empty. file='%file' entry='%path'.</xsl:text>
    </xsl:variable>

    <xsl:variable name="stMes2011">
        <xsl:text>[expandTheadOrTbodyWithSpanInfo 2011W] Fixed DITA-OT entry/@colnum bug. file='%file' entry='%path' dita-ot:x='%dita-ot:x' ahf:colnum='%ahf:colnum'</xsl:text>
    </xsl:variable>
    
</xsl:stylesheet>

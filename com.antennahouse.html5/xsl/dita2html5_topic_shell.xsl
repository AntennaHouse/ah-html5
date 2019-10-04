<?xml version="1.0" encoding="UTF-8"?>
<!--
    **************************************************************
    DITA to HTML5 Stylesheet
    Topic Shell Templates
    **************************************************************
    File Name : dita2html5_topic_shell.xsl
    **************************************************************
    Copyright © 2008-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:include href="dita2html5_param.xsl"/>
    <xsl:include href="dita2html5_constant.xsl"/>
    <xsl:include href="dita2html5_global.xsl"/>
    <xsl:include href="dita2html5_message.xsl"/>
    <xsl:include href="dita2html5_dita_util.xsl"/>
    <xsl:include href="dita2html5_dita_util_html_only.xsl"/>
    <xsl:include href="dita2html5_error_util.xsl"/>
    <xsl:include href="dita2html5_util.xsl"/>
    <xsl:include href="dita2html5_util_unit.xsl"/>
    <xsl:include href="dita2html5_util_href.xsl"/>
    <xsl:include href="dita2html5_gen_header.xsl"/>
    <xsl:include href="dita2html5_gen_metadata.xsl"/>
    <xsl:include href="dita2html5_text_mode.xsl"/>
    <xsl:include href="dita2html5_dita_class.xsl"/>
    <xsl:include href="dita2html5_common.xsl"/>
    <xsl:include href="dita2html5_html_common.xsl"/>
    <xsl:include href="dita2html5_style_set.xsl"/>
    <xsl:include href="dita2html5_style_get.xsl"/>
    <xsl:include href="dita2html5_topic_main.xsl"/>
    <xsl:include href="dita2html5_topic_element.xsl"/>
    <xsl:include href="dita2html5_body_element.xsl"/>
    <xsl:include href="dita2html5_list_element.xsl"/>
    <xsl:include href="dita2html5_task_element.xsl"/>
    <xsl:include href="dita2html5_specialization_element.xsl"/>
    <xsl:include href="dita2html5_table_element.xsl"/>
    <xsl:include href="dita2html5_xref.xsl"/>
    <xsl:include href="dita2html5_related-links.xsl"/>
    <xsl:include href="dita2html5_svg_domain.xsl"/>
    <xsl:include href="dita2html5_highlight_domain.xsl"/>
    <xsl:include href="dita2html5_software_domain.xsl"/>
    <xsl:include href="dita2html5_user_interface_domain.xsl"/>
    <xsl:include href="dita2html5_note_element.xsl"/>
    
</xsl:stylesheet>

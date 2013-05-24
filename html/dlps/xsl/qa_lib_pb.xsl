<?xml version='1.0'?>

<!--

  qa_lib_pb.xsl - XSLT stylesheet for markup QA of TEI pb and fw
    elements.

  Intended to be imported into another, primary stylesheet (namely
  qa_tei_html.xsl for HTML output or qa_tei_commandline.xsl for text
  output).

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2003-09-29
  Last modified: 2005-09-21

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="teiHeader" mode="pb"/>

<xsl:template match="text" mode="pb">
    <xsl:apply-templates select="descendant::pb" mode="pb"/>
</xsl:template>

<xsl:template match="pb" mode="pb">
    <!-- normally a pb with attribute 'n' should contain an <fw type="pageno"> -->

    <!-- There is no need to issue a warning for this; <fw
         type="pageno"> can/should be used only when needed (that is,
         when the <pb n="..."> value and the <fw type="pageno"> value
         are different for some reason) -->
<!--
    <xsl:if test="@n and not(fw[@type='pageno'])">
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="type">W</xsl:with-param>
	    <xsl:with-param name="msg">&lt;pb&gt; element has 'n' attribute but not &lt;fw type='pageno'&gt;.</xsl:with-param>
	</xsl:call-template>
    </xsl:if>
-->

    <!-- shouldn't have more than one <fw type="pageno"> (error) or type="header" (warning) in a single <pb> -->
    <xsl:choose>
	<xsl:when test="count(fw[@type='pageno']) > 1">
	    <xsl:call-template name="outputMsg">
		<xsl:with-param name="type">E</xsl:with-param>
		<xsl:with-param name="msg">&lt;pb&gt; element has more than one &lt;fw type="pageno"&gt;.</xsl:with-param>
	    </xsl:call-template>
	</xsl:when>

	<xsl:when test="count(fw[@type='header']) > 1">
	    <xsl:call-template name="outputMsg">
		<xsl:with-param name="type">W</xsl:with-param>
		<xsl:with-param name="msg">&lt;pb&gt; element has more than one &lt;fw type="header"&gt;.</xsl:with-param>
	    </xsl:call-template>
	</xsl:when>
    </xsl:choose>

    <xsl:if test="local-name(..)='figure'">
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="type">W</xsl:with-param>
	    <xsl:with-param name="msg">&lt;pb&gt; found within &lt;figure&gt;: A legitimate need for &lt;pb&gt; within &lt;figure&gt; is extremely rare. Check page images to make sure this markup is legitimate.</xsl:with-param>
	</xsl:call-template>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>

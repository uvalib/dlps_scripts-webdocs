<?xml version='1.0'?>

<!--

  qa_lib_foreign.xsl - XSLT stylesheet for markup QA of TEI <foreign>
    elements and use of the global 'lang' attribute.

  Intended to be imported into another, primary stylesheet (namely
  qa_tei_html.xsl for HTML output or qa_tei_commandline.xsl for text
  output).

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2003-05-23
  Last modified: 2005-12-19

  2005-12-19: gpm2a: Commented out test for <hi> within <foreign>. The
  experience of the hands-on text production folks in DLPS is that
  this test is not needed; it is just a hindrance.

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="teiHeader" mode="foreign"/>

<xsl:template match="text" mode="foreign">
<!--
    <xsl:apply-templates select="descendant::foreign" mode="foreign"/>
-->
    <xsl:apply-templates select="descendant::*[@lang]" mode="global_lang"/>
</xsl:template>

<xsl:template match="foreign" mode="foreign">
    <!-- use of foreign still requires marking the change in typeface; <foreign> should include <hi> -->
    <xsl:if test="not(hi)">
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="type">W</xsl:with-param>
	    <xsl:with-param name="msg">&lt;foreign&gt; element does not contain &lt;hi&gt;, but marking change in typeface is still required when using &lt;foreign&gt;.</xsl:with-param>
	</xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template match="*" mode="global_lang">
    <xsl:variable name="lang" select="@lang"/>

    <!-- value of 'lang' must correspond to a language declared within teiHeader -->
    <xsl:if test="not(/TEI.2/teiHeader/profileDesc/langUsage/language[@id=$lang])">
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="msg">Value of attribute 'lang' (<xsl:value-of select="$lang"/>) has no corresponding declaration in teiHeader/profileDesc/langUsage.</xsl:with-param>
	</xsl:call-template>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>

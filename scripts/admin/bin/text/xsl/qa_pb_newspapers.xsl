<?xml version="1.0"?>

<!--

  qa_pb_newspapers.xsl - XSLT stylesheet for QA of page break tags in
    newspaper markup.

  Intended to be run from the command line; output is text, not XML or HTML.

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2004-05-24
  Last modified: 2006-01-12

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- INCLUDES -->
<xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_globals.xsl"/>


<!-- PARAMETERS -->
<xsl:param name="filename"/>
<xsl:param name="errorsOnly"/>


<!-- OUTPUT -->
<xsl:output method="text"/>


<!-- TOP-LEVEL TEMPLATE -->
<xsl:template match="/">
    <xsl:apply-templates select="TEI.2/text//pb"/>
</xsl:template>

<xsl:template match="pb">
    <!-- In newspaper markup, <pb/> must be a child of <body>, not of a div -->
    <xsl:if test="not(local-name(..)='body')">
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="msg">Element &lt;pb/&gt; must be a child of &lt;body&gt;</xsl:with-param>
	</xsl:call-template>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>

<?xml version="1.0"?>

<!--
     util_lib.xsl - library of utility "functions" (named templates)
     Greg Murray <gpm2a@virginia.edu>
     2003-05-01
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- uc - returns input string converted to upper-case -->
    <xsl:template name="uc">
	<xsl:param name="string"/>

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:value-of select="translate($string, $lower, $upper)"/>
    </xsl:template>

    <!-- lc - returns input string converted to lower-case -->
    <xsl:template name="lc">
	<xsl:param name="string"/>

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:value-of select="translate($string, $upper, $lower)"/>
    </xsl:template>

    <!-- ucfirst - returns input string with first character converted to upper-case -->
    <xsl:template name="ucfirst">
	<xsl:param name="string"/>

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="first" select="substring($string, 1, 1)"/>
	<xsl:variable name="remainder" select="substring($string, 2)"/>

	<xsl:value-of select="translate($first, $lower, $upper)"/><xsl:value-of select="$remainder"/>
    </xsl:template>

    <!-- lcfirst - returns input string with first character converted to lower-case -->
    <xsl:template name="lcfirst">
	<xsl:param name="string"/>

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="first" select="substring($string, 1, 1)"/>
	<xsl:variable name="remainder" select="substring($string, 2)"/>

	<xsl:value-of select="translate($first, $upper, $lower)"/><xsl:value-of select="$remainder"/>
    </xsl:template>

</xsl:stylesheet>

<?xml version='1.0'?>

<!--

  qa_tei_html.xsl - XSLT stylesheet for markup QA of TEI texts. Output
    is HTML (can be invoked from SaxonServlet, or from the commandline
    to produce an HTML report).

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2003-05-22
  Last modified: 2005-07-26

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon">

<!-- INCLUDES -->
<xsl:import href="qa_lib_globals.xsl"/>
<xsl:import href="qa_lib_corr.xsl"/>
<xsl:import href="qa_lib_empty.xsl"/>
<xsl:import href="qa_lib_foreign.xsl"/>
<xsl:import href="qa_lib_misc.xsl"/>
<xsl:import href="qa_lib_notes.xsl"/>
<xsl:import href="qa_lib_pb.xsl"/>
<xsl:import href="qa_lib_structure.xsl"/>
<xsl:import href="qa_lib_tables.xsl"/>


<!-- PARAMETERS -->
<xsl:param name="filename"/>
<xsl:param name="errorsOnly"/>
<xsl:param name="finalization"/>
<xsl:param name="all"/>

<xsl:param name="corr"/>
<xsl:param name="empty"/>
<xsl:param name="foreign"/>
<xsl:param name="misc"/>
<xsl:param name="notes"/>
<xsl:param name="pb"/>
<xsl:param name="structure"/>
<xsl:param name="tables"/>


<!-- OUTPUT -->
<xsl:output method="html"/>


<!-- NAMED TEMPLATES -->
<!-- override the template "outputMsg" contained in qa_lib_globals.xsl (which is for text/command-line output) -->
<xsl:template name="outputMsg">
    <xsl:param name="type"/>
    <xsl:param name="msg"/>

    <tr>
	<xsl:choose>
	    <xsl:when test="$type='I'"><td valign="top" class="listing"><span class="info">Info</span></td></xsl:when>
	    <xsl:when test="$type='W'"><td valign="top" class="listing"><span class="warning">WARNING</span></td></xsl:when>
	    <xsl:otherwise><td valign="top" class="listing"><span class="error">ERROR</span></td></xsl:otherwise>
	</xsl:choose>
	<td class="listing"><xsl:value-of select="saxon:line-number()"/></td>
	<td class="listing"><xsl:value-of select="$msg"/></td>
    </tr>
</xsl:template>

<xsl:template name="outputMsg_OLD">
    <xsl:param name="type"/>
    <xsl:param name="msg"/>

    <tr>
	<xsl:choose>
	    <xsl:when test="$type='I'"><td valign="top" class="listing"><span class="info">Info</span></td></xsl:when>
	    <xsl:when test="$type='W'"><td valign="top" class="listing"><span class="warning">WARNING</span></td></xsl:when>
	    <xsl:otherwise><td valign="top" class="listing"><span class="error">ERROR</span></td></xsl:otherwise>
	</xsl:choose>
	<td class="listing">
	    <xsl:value-of select="$msg"/>
	    <br/>Path:
	    <span class="path"><xsl:text>/</xsl:text>
	    <xsl:for-each select="ancestor-or-self::*">
		<xsl:variable name="me" select="local-name()"/>
		<xsl:value-of select="$me"/>

		<!-- add a number indicating which element this is if
		there are sibling elements of the same type -
		e.g. table[7] indicates the 7th table -->
		<xsl:if test="$me='table'">
		<xsl:choose>
		    <xsl:when test="preceding-sibling::table">
			<xsl:text>[</xsl:text>
			<xsl:value-of select="count(preceding-sibling::table)+1"/>
			<xsl:text>]</xsl:text>
		    </xsl:when>
		</xsl:choose>
		</xsl:if>

		<xsl:choose>
		    <xsl:when test="@id">
			<xsl:if test="not(local-name()='text') and not(local-name()='body') and not(local-name()='front') and not(local-name()='back')">
			    <xsl:text> id="</xsl:text><xsl:value-of select="@id"/><xsl:text>"</xsl:text>
			</xsl:if>
		    </xsl:when>
		    <xsl:when test="@n">
			<xsl:text> n="</xsl:text><xsl:value-of select="@n"/><xsl:text>"</xsl:text>
		    </xsl:when>
		    <xsl:when test="@type">
			<xsl:text> type="</xsl:text><xsl:value-of select="@type"/><xsl:text>"</xsl:text>
		    </xsl:when>
		</xsl:choose>
		<xsl:text>/</xsl:text>
	    </xsl:for-each>
	    </span>
	</td>
    </tr>
</xsl:template>


<!-- TOP-LEVEL TEMPLATE -->
<xsl:template match="/">
    <html>
	<head>
	    <title><xsl:value-of select="$filename"/> - DLPS Markup QA Programs</title>
	    <link rel="stylesheet" type="text/css" href="/dlps/css/markupQA.css"/>
	</head>
	<body>
	    <h1>DLPS Markup QA Programs</h1>
	    <h2><xsl:value-of select="$filename"/></h2>

	    <!-- table of contents -->
	    <ul>
		<xsl:if test="$structure or $all">
		    <li><a href="#structure">Structure</a></li>
		</xsl:if>
		<xsl:if test="$notes or $all">
		    <li><a href="#notes">Notes</a></li>
		</xsl:if>
		<xsl:if test="$tables or $all">
		    <li><a href="#tables">Tables, lists and block quotations</a></li>
		</xsl:if>
		<xsl:if test="$foreign or $all">
		    <li><a href="#foreign">Foreign phrases</a></li>
		</xsl:if>
		<xsl:if test="$corr or $all">
		    <li><a href="#corr">Corrections</a></li>
		</xsl:if>
		<xsl:if test="$empty or $all">
		    <li><a href="#empty">Empty elements/attributes</a></li>
		</xsl:if>
		<xsl:if test="$pb or $all">
		    <li><a href="#pb">Page breaks</a></li>
		</xsl:if>
		<xsl:if test="$misc or $all">
		    <li><a href="#misc">Miscellaneous</a></li>
		</xsl:if>
	    </ul>

	    <xsl:if test="$structure or $all">
		<a name="structure"><h4>Structure</h4></a>
		<table cellpadding="6" cellspacing="0" width="100%" class="listing">
		    <tr class="head"><td width="10%">Type</td><td>Line</td><td>Description</td></tr>
		    <xsl:apply-templates mode="structure"/>
		</table>
	    </xsl:if>

	    <xsl:if test="$notes or $all">
		<a name="notes"><h4>Notes</h4></a>
		<table cellpadding="6" cellspacing="0" width="100%" class="listing">
		    <tr class="head"><td width="10%">Type</td><td>Line</td><td>Description</td></tr>
		    <xsl:apply-templates mode="notes"/>
		</table>
	    </xsl:if>

	    <xsl:if test="$tables or $all">
		<a name="tables"><h4>Tables, lists and block quotations</h4></a>
		<table cellpadding="6" cellspacing="0" width="100%" class="listing">
		    <tr class="head"><td width="10%">Type</td><td>Line</td><td>Description</td></tr>
		    <xsl:apply-templates mode="tables"/>
		</table>
	    </xsl:if>

	    <xsl:if test="$foreign or $all">
		<a name="foreign"><h4>Foreign phrases</h4></a>
		<table cellpadding="6" cellspacing="0" width="100%" class="listing">
		    <tr class="head"><td width="10%">Type</td><td>Line</td><td>Description</td></tr>
		    <xsl:apply-templates mode="foreign"/>
		</table>
	    </xsl:if>

	    <xsl:if test="$corr or $all">
		<a name="corr"><h4>Corrections</h4></a>
		<table cellpadding="6" cellspacing="0" width="100%" class="listing">
		    <tr class="head"><td width="10%">Type</td><td>Line</td><td>Description</td></tr>
		    <xsl:apply-templates mode="corr"/>
		</table>
	    </xsl:if>

	    <xsl:if test="$empty or $all">
		<a name="empty"><h4>Empty elements/attributes</h4></a>
		<table cellpadding="6" cellspacing="0" width="100%" class="listing">
		    <tr class="head"><td width="10%">Type</td><td>Line</td><td>Description</td></tr>
		    <xsl:apply-templates mode="empty"/>
		</table>
	    </xsl:if>

	    <xsl:if test="$pb or $all">
		<a name="pb"><h4>Page breaks</h4></a>
		<table cellpadding="6" cellspacing="0" width="100%" class="listing">
		    <tr class="head"><td width="10%">Type</td><td>Line</td><td>Description</td></tr>
		    <xsl:apply-templates mode="pb"/>
		</table>
	    </xsl:if>

	    <xsl:if test="$misc or $all">
		<a name="misc"><h4>Miscellaneous</h4></a>
		<table cellpadding="6" cellspacing="0" width="100%" class="listing">
		    <tr class="head"><td width="10%">Type</td><td>Line</td><td>Description</td></tr>
		    <xsl:apply-templates mode="misc"/>
		</table>
	    </xsl:if>

	</body>
    </html>
</xsl:template>

</xsl:stylesheet>

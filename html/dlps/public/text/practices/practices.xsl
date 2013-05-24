<?xml version="1.0"?>

<!--

  practices.xsl - Transforms a document conforming to practices.dtd
    (for documentation of local markup practices) to XHTML 1.1 for
    web display

  Greg Murray <gpm2a@virginia.edu>
  Written: 2005-08-09
  Last modified: 2005-08-30

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<!-- ============================== -->
<!-- OUTPUT                         -->
<!-- ============================== -->

<!--<xsl:output method="xml" indent="yes" doctype-system="xhtml11target.dtd"/>-->
<xsl:output method="html" indent="yes"/>


<!-- ============================== -->
<!-- INPUT PARAMETERS               -->
<!-- ============================== -->

<xsl:param name="applies">all</xsl:param> <!-- 'POSTKB' or 'VENDOR' or 'all' -->
<xsl:param name="source"/> <!-- name of (or path to) source XML file -->


<!-- ============================== -->
<!-- DEBUGGING AIDS                 -->
<!-- ============================== -->

<xsl:template match="*">
	<xsl:message>Warning: Unhandled element <xsl:value-of select="local-name()"/></xsl:message>
	<xsl:apply-templates/>
</xsl:template>


<!-- ============================== -->
<!-- TOP-LEVEL TEMPLATE             -->
<!-- ============================== -->

<xsl:template match="/">
	<!-- output a warning not to edit the HTML file -->
	<xsl:text disable-output-escaping="yes">

&lt;!--
*******************************************************************************
DO NOT EDIT THIS FILE. This file was dynamically generated. Instead, edit the
XML file (conforming to practices.dtd) from which this HTML file was derived</xsl:text>
	<xsl:choose>
		<!-- output path to XML source file, if available -->
		<xsl:when test="$source">
			<xsl:text>: 
</xsl:text>
			<xsl:value-of select="$source"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>.</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text disable-output-escaping="yes">
*******************************************************************************
--&gt;
</xsl:text>
	<html xml:lang="en">
		<head>
			<title><xsl:value-of select="practices/practicesHeader/docDesc/title[@type='main']"/></title>
			<!--<link rel="stylesheet" type="text/css" href="http://text.lib.virginia.edu/bin/cgi-dl/dlps/css/practices.css"/>-->
			<link rel="stylesheet" type="text/css" href="practices.css"/>
		</head>
		<body>
			<h1><xsl:apply-templates select="practices/practicesHeader/docDesc/title[@type='main']"/></h1>

			<xsl:if test="practices/practicesHeader/docDesc/title[@type='sub']">
				<p><b><xsl:apply-templates select="practices/practicesHeader/docDesc/title[@type='sub']"/></b></p>
			</xsl:if>

			<h2>Overview</h2>
			<!-- process <argument> for entire document -->
			<xsl:apply-templates select="practices/practicesDoc/argument" mode="prelim"/>
			<hr/>

			<h2>Contents</h2>
			<ul>
				<!-- generate table of contents -->
				<xsl:apply-templates select="practices/practicesDoc/practiceGroup" mode="toc"/>

				<li>Appendixes
					<ul>
						<li><a href="#indexPractices">Complete List of Practices</a></li>
						<li><a href="#indexTags">Index of Elements, Attributes, and Terms</a>
							<ul>
								<li><a href="#indexElements">Elements</a></li>
								<li><a href="#indexAttributes">Attributes</a></li>
								<li><a href="#indexTerms">Terms</a></li>
							</ul>
						</li>
						<li><a href="#enforcement">Enforcement Programs</a>
							<ul>
								<li><a href="#dtd">DTD</a></li>
								<li><a href="#programs">Programs</a></li>
							</ul>
						</li>
						<li><a href="#about">About This Documentation</a></li>
					</ul>
				</li>
			</ul>
			<hr/>

			<!-- process main document content -->
			<xsl:apply-templates select="practices/practicesDoc"/>
			<hr/>

			<h2><a id="indexPractices">Complete List of Practices</a></h2>
			<ul>
				<xsl:apply-templates select="practices/practicesDoc/practiceGroup" mode="index"/>
			</ul>
			<hr/>

			<h2><a id="indexTags">Index of Elements, Attributes, and Terms</a></h2>
			<ul>
				<li><a href="#indexElements">Elements</a></li>
				<li><a href="#indexAttributes">Attributes</a></li>
				<li><a href="#indexTerms">Terms</a></li>
			</ul>
			<xsl:call-template name="indexTags"/>
			<hr/>

			<h2><a id="enforcement">Enforcement Programs</a></h2>
			<ul>
				<li><a href="#dtd">DTD</a></li>
				<li><a href="#programs">Programs</a></li>
			</ul>
			<!-- process header - program descriptions -->
			<xsl:apply-templates select="practices/practicesHeader/enforcementDesc"/>
			<hr/>

			<h2><a id="about">About This Documentation</a></h2>
			<!-- process header - document description -->
			<xsl:apply-templates select="practices/practicesHeader/docDesc"/>
		</body>
	</html>
	<xsl:text>
</xsl:text>
</xsl:template>


<!-- ============================== -->
<!-- TABLE OF CONTENTS              -->
<!-- ============================== -->

<xsl:template match="practiceGroup" mode="toc">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<li>
			<a>
				<xsl:attribute name="href"><xsl:value-of select="concat('#', @id)"/></xsl:attribute>
				<xsl:apply-templates select="head" mode="asIs"/>
			</a>
			<xsl:if test="practiceGroup">
				<ul>
					<xsl:apply-templates select="practiceGroup" mode="toc"/>
				</ul>
			</xsl:if>
		</li>
	</xsl:if>
</xsl:template>


<!-- ============================== -->
<!-- LIST OF PRACTICES              -->
<!-- ============================== -->

<xsl:template match="practiceGroup" mode="index">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<li>
			<a>
				<xsl:attribute name="href"><xsl:value-of select="concat('#', @id)"/></xsl:attribute>
				<xsl:apply-templates select="head" mode="asIs"/>
			</a>
			<ul>
				<xsl:apply-templates select="practiceGroup|practice" mode="index"/>
			</ul>
		</li>
	</xsl:if>
</xsl:template>

<xsl:template match="practice" mode="index">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<li>
			<a>
				<xsl:attribute name="href"><xsl:value-of select="concat('#', @id)"/></xsl:attribute>
				<xsl:apply-templates select="head" mode="asIs"/>
			</a>
		</li>
	</xsl:if>
</xsl:template>


<!-- ============================== -->
<!-- HEADER ELEMENTS                -->
<!-- ============================== -->

<xsl:template match="docDesc">
	<table cellpadding="4">
		<xsl:for-each select="respStmt">
			<tr>
				<th><xsl:apply-templates select="resp"/>:</th>
				<td><xsl:apply-templates select="name"/></td>
			</tr>
		</xsl:for-each>

		<xsl:if test="summary">
			<tr>
				<th>Overview:</th>
				<td><xsl:apply-templates select="summary"/></td>
			</tr>
		</xsl:if>

		<tr>
			<th>Last modified:</th>
			<td><xsl:text disable-output-escaping="yes">&lt;!--#echo var="LAST_MODIFIED"--&gt;</xsl:text></td>
		</tr>

		<xsl:if test="revisionDesc">
			<tr>
				<th>
					<xsl:text disable-output-escaping="yes">Revision&amp;nbsp;history:</xsl:text>
				</th>
				<td>
					<xsl:for-each select="revisionDesc/change">
						<table border="1" cellpadding="4" class="normal">
							<tr>
								<td class="label">Date:</td>
								<td><xsl:value-of select="date"/></td>
							</tr>
							<xsl:for-each select="respStmt">
								<tr>
									<td class="label">Role:</td>
									<td><xsl:value-of select="resp"/></td>
								</tr>
								<tr>
									<td class="label">Name:</td>
									<td><xsl:value-of select="name"/></td>
								</tr>
							</xsl:for-each>
							<tr>
								<td class="label">Change:</td>
								<td><xsl:apply-templates select="changeEntry"/></td>
							</tr>
						</table>
						<br/>
					</xsl:for-each>
				</td>
			</tr>
		</xsl:if>
	</table>
</xsl:template>

<xsl:template match="changeEntry|description|name|resp|summary|title">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="enforcementDesc">
	<h3 id="dtd">DTD</h3>
	<xsl:apply-templates select="dtd"/>

	<h3 id="programs">Programs</h3>
	<xsl:apply-templates select="programs"/>
</xsl:template>

<xsl:template match="dtd">
	<table cellpadding="4" class="normal">
		<tr>
			<th>DTD name:</th>
			<td><xsl:apply-templates select="name"/></td>
		</tr>
		<tr>
			<th>DTD files:</th>
			<td>
				<xsl:for-each select="dtdFiles/dtdFile">
					<table border="1" cellpadding="4" class="normal">
						<tr>
							<td class="label">Filename:</td>
							<td><xsl:apply-templates select="filename"/></td>
						</tr>
						<tr>
							<td class="label">Description:</td>
							<td><xsl:apply-templates select="description"/></td>
						</tr>
						<tr>
							<td class="label">Disk path:</td>
							<td><xsl:value-of select="@diskPath"/></td>
						</tr>
						<tr>
							<td class="label">URL:</td>
							<td><xsl:value-of select="@url"/></td>
						</tr>
					</table>
					<br/>
				</xsl:for-each>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="programs">
	<table cellpadding="4" class="normal">
		<xsl:apply-templates select="program"/>
	</table>
</xsl:template>

<xsl:template match="program">
	<tr>
		<th>
			<a>
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				<xsl:value-of select="@id"/>
				<xsl:text>:</xsl:text>
			</a>
		</th>
		<td>
			<table border="1" cellpadding="4" class="normal">
				<tr>
					<td class="label">Filename:</td>
					<td><xsl:apply-templates select="filename"/></td>
				</tr>
				<tr>
					<td class="label">Type:</td>
					<td><xsl:value-of select="@type"/></td>
				</tr>
				<tr>
					<td class="label">Language:</td>
					<td><xsl:value-of select="@language"/></td>
				</tr>
				<tr>
					<td class="label">Description:</td>
					<td><xsl:apply-templates select="description"/></td>
				</tr>
				<tr>
					<td class="label">Disk path:</td>
					<td><xsl:value-of select="@diskPath"/></td>
				</tr>
				<xsl:if test="@url">
					<tr>
						<td class="label">URL:</td>
						<td><xsl:value-of select="@url"/></td>
					</tr>
				</xsl:if>
			</table>
		</td>
	</tr>
</xsl:template>


<!-- ============================== -->
<!-- BODY ELEMENTS                  -->
<!-- ============================== -->

<xsl:template match="practicesDoc">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="practiceGroup">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<xsl:apply-templates select="head"/>
		<xsl:apply-templates select="argument"/>

		<!-- list the practices in this group -->
		<xsl:if test="practice">
			<ul class="synopsis">
				<xsl:for-each select="practice">
					<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
						<li>
							<a>
								<xsl:attribute name="href"><xsl:value-of select="concat('#', @id)"/></xsl:attribute>
								<xsl:apply-templates select="head" mode="asIs"/>
							</a>
						</li>
					</xsl:if>
				</xsl:for-each>
			</ul>
		</xsl:if>

		<xsl:apply-templates select="practiceGroup|practice"/>
	</xsl:if>
</xsl:template>

<xsl:template match="practice">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<table border="1" cellpadding="8" class="practice">
			<xsl:if test="@id">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</table>
	</xsl:if>
</xsl:template>

<xsl:template match="argument" mode="prelim">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<xsl:apply-templates/>
	</xsl:if>
</xsl:template>

<xsl:template match="argument">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<xsl:choose>
			<xsl:when test="parent::practicesDoc"/>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template match="desc">
		<tr>
			<th>Description</th>
			<td><xsl:apply-templates/></td>
		</tr>
</xsl:template>

<xsl:template match="eg">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<pre><xsl:apply-templates/></pre>
	</xsl:if>
</xsl:template>

<xsl:template match="enforcement">
	<!-- Suppress enforcement info for VENDOR output -->
	<xsl:if test="$applies='POSTKB' or $applies='all'">
		<tr>
			<th>Enforcement</th>
			<td>
				<table>
					<tr>
						<td class="label">Machine-enforceable:</td>
						<td><xsl:value-of select="@machine-enforceable"/></td>
					</tr>
					<xsl:if test="@enforced = 'no' and @machine-enforceable != 'no'">
						<tr>
							<td class="label">Enforced:</td>
							<td><span class="attn"><xsl:value-of select="@enforced"/></span></td>
						</tr>
					</xsl:if>
					<xsl:if test="@method">
						<tr>
							<td class="label">Method:</td>
							<td>
								<xsl:choose>
									<xsl:when test="@method='dtd'">
										<a href="#dtd">DTD</a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@method"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<xsl:if test="@method-name">
							<tr>
								<td class="label">Name:</td>
								<td><xsl:value-of select="@method-name"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="@message-type">
							<tr>
								<td class="label">Message type:</td>
								<td><xsl:value-of select="@message-type"/></td>
							</tr>
						</xsl:if>
					</xsl:if>
					<xsl:if test="remarks">
						<tr>
							<td class="label">Comments:</td>
							<td><xsl:apply-templates/></td>
						</tr>
					</xsl:if>
				</table>
			</td>
		</tr>
	</xsl:if>
</xsl:template>

<xsl:template match="exceptions">
	<tr>
		<th>Exceptions</th>
		<td><xsl:apply-templates/></td>
	</tr>
</xsl:template>

<xsl:template match="exemplum">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<xsl:choose>
			<xsl:when test="parent::practice">
				<tr>
					<th>Example</th>
					<td><xsl:apply-templates/></td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template match="reason">
	<!-- Suppress reason info for VENDOR output -->
	<xsl:if test="$applies='POSTKB' or $applies='all'">
		<tr>
			<th>Reason</th>
			<td><xsl:apply-templates/></td>
		</tr>
	</xsl:if>
</xsl:template>

<xsl:template match="remarks">
	<xsl:choose>
		<xsl:when test="parent::practice">
			<tr>
				<th>Remarks</th>
				<td><xsl:apply-templates/></td>
			</tr>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="seeAlso">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<tr>
			<th>See also</th>
			<td><xsl:apply-templates/></td>
		</tr>
	</xsl:if>
</xsl:template>


<!-- ============================== -->
<!-- BLOCK-LEVEL ELEMENTS           -->
<!-- ============================== -->

<xsl:template match="admon">
	<div>
		<xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
		<span>
			<xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="@type='note'">NOTE</xsl:when>
				<xsl:when test="@type='tip'">TIP</xsl:when>
				<xsl:when test="@type='important'">IMPORTANT</xsl:when>
				<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
			</xsl:choose>
		</span>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="head" mode="asIs">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="head">
	<xsl:choose>
		<xsl:when test="parent::practiceGroup">
			<xsl:variable name="c" select="count(ancestor::practiceGroup)"/>
			<xsl:choose>
				<xsl:when test="$c = 1">
					<xsl:if test="parent::practiceGroup[preceding-sibling::practiceGroup]">
						<hr/>
					</xsl:if>
					<h2>
						<xsl:if test="../@id">
							<xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
						</xsl:if>
						<xsl:apply-templates/>
					</h2>
				</xsl:when>
				<xsl:when test="$c = 2">
					<h3>
						<xsl:if test="../@id">
							<xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
						</xsl:if>
						<xsl:apply-templates/>
					</h3>
				</xsl:when>
				<xsl:otherwise>
					<p>
						<xsl:if test="../@id">
							<xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
						</xsl:if>
						<b>
							<xsl:apply-templates/>
						</b>
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<xsl:when test="parent::practice">
			<tr>
				<td colspan="2" class="headrow">
					<table class="headrow">
						<tr>
							<!-- get heading for this practice -->
							<td class="headrow">
								<xsl:apply-templates/>
	
								<xsl:if test="$applies='all'">
									<xsl:if test="parent::practice[@applies] and parent::practice[@applies != 'global']">
										<!-- indicate the mode/audience this practice applies to -->
										<xsl:text> (</xsl:text>
										<xsl:value-of select="parent::practice/@applies"/>
										<xsl:text>)</xsl:text>
									</xsl:if>
								</xsl:if>
							</td>
							<td class="headrowGroupHeadings">
								<xsl:call-template name="formatGroupHeadings">
									<xsl:with-param name="practice" select="parent::practice"/>
								</xsl:call-template>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</xsl:when>

		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="item">
	<xsl:choose>
		<xsl:when test="preceding-sibling::label[1]">
			<xsl:apply-templates/>
		</xsl:when>
		<xsl:otherwise>
			<li>
				<xsl:apply-templates/>
			</li>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="label">
	<li>
		<b><xsl:apply-templates/></b>
		<xsl:if test="following-sibling::item[1]//text()">
			<!-- include em dash between label and item -->
			<xsl:text disable-output-escaping="yes"> &amp;mdash; </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="following-sibling::item[1]"/>
	</li>
</xsl:template>

<xsl:template match="list">
	<xsl:if test="head">
		<p><b><xsl:apply-templates select="head"/></b></p>
	</xsl:if>
	<ul>
		<xsl:choose>
			<xsl:when test="label">
				<!-- let label template handle items -->
				<xsl:apply-templates select="*[not(self::head)][not(self::item)]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*[not(self::head)]"/>
			</xsl:otherwise>
		</xsl:choose>
	</ul>
</xsl:template>

<xsl:template match="p">
	<xsl:choose>
		<xsl:when test="(parent::changeEntry or parent::exceptions or parent::exemplum or parent::item or parent::reason or parent::remarks or parent::summary) and ( not(preceding-sibling::p) )">
			<xsl:apply-templates/>
		</xsl:when>
		<xsl:otherwise>
			<p>
				<xsl:apply-templates/>
			</p>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- ============================== -->
<!-- PHRASE-LEVEL ELEMENTS          -->
<!-- ============================== -->

<xsl:template match="att">
	<xsl:choose>
		<xsl:when test="@tei='no'">
			<span class="mono"><i><xsl:value-of select="."/></i></span>
		</xsl:when>
		<xsl:otherwise>
			<span class="mono"><xsl:value-of select="."/></span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="char">
	<xsl:text disable-output-escaping="yes">&amp;</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="datatype|filename|kw|xpath">
	<span class="mono"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="emph|term">
	<i><b><xsl:apply-templates/></b></i>
</xsl:template>

<xsl:template match="gi|tag">
	<span class="mono">&lt;<xsl:value-of select="."/>&gt;</span>
	<!--
	<xsl:choose>
		<xsl:when test="@tei='no'">
			<span class="mono"><i>&lt;<xsl:value-of select="."/>&gt;</i></span>
		</xsl:when>
		<xsl:otherwise>
			<span class="mono">&lt;<xsl:value-of select="."/>&gt;</span>
		</xsl:otherwise>
	</xsl:choose>
	-->
</xsl:template>

<xsl:template match="hi">
	<xsl:choose>
		<xsl:when test="@rend='italic'">
			<i><xsl:apply-templates/></i>
		</xsl:when>
		<xsl:when test="@rend='bold'">
			<b><xsl:apply-templates/></b>
		</xsl:when>
		<xsl:when test="@rend='attn'">
			<span class="attn"><xsl:apply-templates/></span>
		</xsl:when>
		<xsl:when test="@rend='revised'">
			<span class="revised"><xsl:apply-templates/></span>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="lb">
	<br/>
</xsl:template>

<xsl:template match="ptr">
	<xsl:variable name="target"><xsl:value-of select="@target"/></xsl:variable>

	<xsl:if test="parent::seeAlso and preceding-sibling::ptr">
		<!-- not first <ptr/> within <seeAlso>; precede hyperlink with line break -->
		<br/>
	</xsl:if>

	<a>
		<xsl:attribute name="href">#<xsl:value-of select="$target"/></xsl:attribute>

		<xsl:variable name="targetHeading" select="//*[@id=$target]/head"/>
		<xsl:choose>
			<xsl:when test="$targetHeading">
				<xsl:apply-templates select="$targetHeading" mode="asIs"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$target"/>
			</xsl:otherwise>
		</xsl:choose>
	</a>
</xsl:template>

<xsl:template match="ref">
	<a>
		<xsl:attribute name="href">#<xsl:value-of select="@target"/></xsl:attribute>
		<xsl:apply-templates/>
	</a>
</xsl:template>

<xsl:template match="usage">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<span class="mono"><xsl:apply-templates/></span>
	</xsl:if>
</xsl:template>

<xsl:template match="val">
	<span class="mono">
		<xsl:choose>
			<xsl:when test="parent::label or @quoted='no'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</span>
</xsl:template>

<xsl:template match="xref">
	<xsl:if test="@applies='global' or @applies=$applies or $applies='all'">
		<xsl:choose>
			<xsl:when test="@type='external'">
				<!-- link should open a new window; use '_blank' -->
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<!-- assume this is a page-image example; use 'examples' window -->
				<a target="examples">
					<xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
					<xsl:apply-templates/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>


<!-- ============================== -->
<!-- NAMED TEMPLATES                -->
<!-- ============================== -->

<!-- Outputs the group and sub-group of a practice, formatted as "Main: Sub" -->
<xsl:template name="formatGroupHeadings">
	<xsl:param name="practice"/> <!-- The <practice> element for which to print group/sub-group -->

	<xsl:if test="$practice/parent::practiceGroup">
		<xsl:variable name="parentGroup" select="$practice/parent::practiceGroup"/>
		<!-- get heading of 'grandparent' grouping, if any -->
		<xsl:if test="$parentGroup/parent::practiceGroup">
			<xsl:apply-templates select="$parentGroup/parent::practiceGroup/head" mode="asIs"/>
			<xsl:text>: </xsl:text>
 		</xsl:if>
		<!-- get heading of parent grouping -->
		<xsl:apply-templates select="$parentGroup/head" mode="asIs"/>
	</xsl:if>
</xsl:template>

<!-- Index of practices -->
<!--
<xsl:template name="indexPractices">
	<ul>
		<xsl:for-each select="//practice">
			<xsl:sort select="head"/>
			<li>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat('#', @id)"/></xsl:attribute>
					<xsl:apply-templates select="head" mode="asIs"/>
				</a>
			</li>
		</xsl:for-each>
	</ul>
</xsl:template>
-->

<!-- Index of elements, attributes, and terms -->
<xsl:template name="indexTags">
	<h3 id="indexElements">Elements</h3>
	<ul>
		<xsl:for-each select="(//gi | //tag)[@key]">
			<xsl:sort/>
			<xsl:sort select="ancestor::practice/head"/>
			<xsl:variable name="practice" select="ancestor::practice"/>
			<xsl:if test="$practice/@applies='global' or $practice/@applies=$applies or $applies='all'">
				<xsl:choose>
					<xsl:when test="self::gi">
						<li>
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="concat('#', $practice/@id)"/>
								</xsl:attribute>
								<span class="mono"><xsl:value-of select="@key"/></span>
								<xsl:choose>
									<xsl:when test="@key = 'div1 - div7'">
										<xsl:text> elements</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text> element</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text disable-output-escaping="yes"> &amp;mdash; </xsl:text>
								<xsl:apply-templates select="$practice/head" mode="asIs"/>
								<xsl:text> (</xsl:text>
								<xsl:call-template name="formatGroupHeadings">
									<xsl:with-param name="practice" select="$practice"/>
								</xsl:call-template>
								<xsl:text>)</xsl:text>
							</a>
						</li>
					</xsl:when>
					<xsl:when test="self::tag">
						<li>
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="concat('#', $practice/@id)"/>
								</xsl:attribute>
								<span class="mono"><xsl:value-of select="@key"/></span>
								<xsl:text disable-output-escaping="yes"> &amp;mdash; </xsl:text>
								<xsl:apply-templates select="$practice/head" mode="asIs"/>
								<xsl:text> (</xsl:text>
								<xsl:call-template name="formatGroupHeadings">
									<xsl:with-param name="practice" select="$practice"/>
								</xsl:call-template>
								<xsl:text>)</xsl:text>
							</a>
						</li>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</ul>
	
	<h3 id="indexAttributes">Attributes</h3>
	<ul>
		<xsl:for-each select="//att[@key]">
			<xsl:sort/>
			<xsl:sort select="ancestor::practice/head"/>
			<xsl:variable name="practice" select="ancestor::practice"/>
			<xsl:if test="$practice/@applies='global' or $practice/@applies=$applies or $applies='all'">
				<li>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="concat('#', $practice/@id)"/>
						</xsl:attribute>
						<span class="mono"><xsl:value-of select="@key"/></span>
						<xsl:text> attribute</xsl:text>
						<xsl:if test="@element">
							<xsl:text> on </xsl:text>
							<span class="mono">
								<xsl:text disable-output-escaping="yes">&amp;lt;</xsl:text>
								<xsl:value-of select="@element"/>
								<xsl:text disable-output-escaping="yes">&amp;gt;</xsl:text>
							</span>
						</xsl:if>
						<xsl:text disable-output-escaping="yes"> &amp;mdash; </xsl:text>
						<xsl:apply-templates select="$practice/head" mode="asIs"/>
						<xsl:text> (</xsl:text>
						<xsl:call-template name="formatGroupHeadings">
							<xsl:with-param name="practice" select="$practice"/>
						</xsl:call-template>
						<xsl:text>)</xsl:text>
					</a>
				</li>
			</xsl:if>
		</xsl:for-each>
	</ul>

	<h3 id="indexTerms">Terms</h3>
	<ul>
		<xsl:for-each select="//term[@key]">
			<xsl:sort/>
			<xsl:sort select="ancestor::practice/head"/>
			<xsl:variable name="practice" select="ancestor::practice"/>
			<xsl:if test="$practice/@applies='global' or $practice/@applies=$applies or $applies='all'">
				<li>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="concat('#', $practice/@id)"/>
						</xsl:attribute>
						<em><xsl:value-of select="@key"/></em>
						<xsl:text disable-output-escaping="yes"> &amp;mdash; </xsl:text>
						<xsl:apply-templates select="$practice/head" mode="asIs"/>
						<xsl:text> (</xsl:text>
						<xsl:call-template name="formatGroupHeadings">
							<xsl:with-param name="practice" select="$practice"/>
						</xsl:call-template>
						<xsl:text>)</xsl:text>
					</a>
				</li>
			</xsl:if>
		</xsl:for-each>
	</ul>
</xsl:template>

</xsl:stylesheet>

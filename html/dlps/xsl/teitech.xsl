<?xml version="1.0"?>

<!--

  teitech.xsl - transforms teitech TEI XML to HTML for web display

  Intended for use with texts validated against the teitech DTD. May
  not work with other flavors of TEI.

  Greg Murray <gpm2a@virginia.edu>
  Written: 2004-02-17
  Last modified: 2006-05-26

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- INCLUDES -->
<xsl:import href="util_lib.xsl"/>
<xsl:import href="tei_lib.xsl"/>


<!-- OUTPUT -->
<xsl:output method="html"/>


<!-- PARAMETERS -->
<xsl:param name="dir">text</xsl:param>  <!-- directory containing XML source file; used to make self-referencing URLs -->
<xsl:param name="filename"/>            <!-- filename of XML source file; used to make self-referencing URLs -->
<xsl:param name="divid"/>               <!-- specific div to display; if not specified, entire document will be displayed -->


<!-- GLOBAL VARIABLES -->
<xsl:variable name="servletPath">http://pogo.lib.virginia.edu/cgi-dlps/saxon/SaxonCGI.pl</xsl:variable>

<xsl:variable name="sourceFile"><xsl:value-of select="concat('http://pogo.lib.virginia.edu/dlps/dlpsdoc_xml/', $dir, '/', $filename)"/></xsl:variable>

<xsl:variable name="stylesheet">http://pogo.lib.virginia.edu/dlps/xsl/teitech.xsl</xsl:variable>


<!-- NAMED TEMPLATES -->

<xsl:template name="getURL">
    <!-- constructs a URL for the Saxon servlet -->
    <xsl:param name="id"/>

    <xsl:value-of select="$servletPath"/>
    <xsl:text>?source=</xsl:text><xsl:value-of select="$sourceFile"/>
    <xsl:text>&amp;style=</xsl:text><xsl:value-of select="$stylesheet"/>
    <xsl:text>&amp;dir=</xsl:text><xsl:value-of select="$dir"/>
    <xsl:if test="$filename">
	<xsl:text>&amp;filename=</xsl:text><xsl:value-of select="$filename"/>
    </xsl:if>
    <xsl:if test="$id">
	<xsl:text>&amp;divid=</xsl:text><xsl:value-of select="$id"/>
    </xsl:if>
</xsl:template>


<!-- TOP-LEVEL TEMPLATE -->
<xsl:template match="/">
    <html>
	<head>
	    <title><xsl:value-of select="TEI.2/teiHeader/fileDesc/titleStmt/title"/></title>
	    <link rel="stylesheet" type="text/css" href="/dlps/css/teitech.css"/>
	</head>
	<body>
	    <!-- document title -->
	    <h1><xsl:value-of select="TEI.2/teiHeader/fileDesc/titleStmt/title"/></h1>

	    <!-- document argument -->
	    <xsl:apply-templates select="TEI.2/text/body/argument">
		<xsl:with-param name="go">1</xsl:with-param>
	    </xsl:apply-templates>

	    <!-- table of contents -->
	    <xsl:if test="count(TEI.2/text/body/div1) > 1">
		<hr/>
		<xsl:call-template name="toc"/>
	    </xsl:if>

	    <!-- process specific element, if ID specified; otherwise process entire document -->
	    <xsl:choose>
		<xsl:when test="$divid">
		    <xsl:apply-templates select="//*[@id=$divid]"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:apply-templates select="TEI.2/text"/>
		</xsl:otherwise>
	    </xsl:choose>
	</body>
    </html>
</xsl:template>


<!-- TABLE OF CONTENTS TEMPLATES -->

<xsl:template name="toc">
    <!-- generate table of contents from div1 elements -->
    <h2>Contents</h2>
<!--
    <p><a>
	<xsl:attribute name="href">
	    <xsl:call-template name="getURL"/>
	</xsl:attribute>
	<xsl:text>Entire document</xsl:text>
    </a></p>
-->
    <ul>
	<xsl:apply-templates select="TEI.2/text//div1" mode="toc"/>
    </ul>
</xsl:template>

<xsl:template match="div1" mode="toc">
    <li>
	<a>
	    <xsl:attribute name="href">
<!--
		<xsl:call-template name="getURL">
		    <xsl:with-param name="id"><xsl:value-of select="@id"/></xsl:with-param>
		</xsl:call-template>
-->
		<xsl:value-of select="concat('#', @id)"/>
	    </xsl:attribute>
	    <xsl:apply-templates select="head" mode="toc"/>
	</a>
    </li>
</xsl:template>

<xsl:template match="head" mode="toc">
    <xsl:apply-templates>
	<xsl:with-param name="toc">1</xsl:with-param>
    </xsl:apply-templates>
    <xsl:if test="following-sibling::head">
	<xsl:text>: </xsl:text>
    </xsl:if>
</xsl:template>


<!-- DIVISIONS -->

<xsl:template match="div1">
    <hr/>
    <xsl:apply-templates/>
</xsl:template>


<!-- HEADINGS -->

<xsl:template match="head">
    <a>
	<xsl:attribute name="name">
	    <xsl:value-of select="../@id"/>
	</xsl:attribute>

	<xsl:choose>
	    <xsl:when test="local-name(..)='div1'">
		<h2><xsl:apply-templates/></h2>
	    </xsl:when>
	    <xsl:when test="local-name(..)='div2'">
		<h3><xsl:apply-templates/></h3>
	    </xsl:when>
	    <xsl:when test="local-name(..)='div3'">
		<h4><xsl:apply-templates/></h4>
	    </xsl:when>
	    <xsl:when test="local-name(..)='div4'">
		<h5><xsl:apply-templates/></h5>
	    </xsl:when>
	    <xsl:otherwise>
		<h6><xsl:apply-templates/></h6>
	    </xsl:otherwise>
	</xsl:choose>
    </a>
</xsl:template>


<!-- BLOCK-LEVEL ELEMENTS -->

<xsl:template match="argument">
    <!-- process arguments explicitly/on demand (not implicitly/when they occur in the XML) -->
    <xsl:param name="go"/>
    <xsl:if test="$go"><xsl:apply-templates/></xsl:if>
</xsl:template>


<!-- ELEMENTS FOR TECHNICAL DOCUMENTATION -->

<xsl:template match="eg">
    <pre><xsl:apply-templates/></pre>
</xsl:template>

<xsl:template match="code | command | path | kw | att | val">
    <code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="gi | tag">
    <code>&lt;<xsl:apply-templates/>&gt;</code>
</xsl:template>

<xsl:template match="admon">
    <div>
	<xsl:choose>
	    <xsl:when test="@type='special' and @applies">
		<xsl:attribute name="class"><xsl:value-of select="@applies"/></xsl:attribute>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
	    </xsl:otherwise>
	</xsl:choose>
	<span>
	    <xsl:choose>
		<xsl:when test="@type='special' and @applies">
		    <xsl:attribute name="class"><xsl:value-of select="@applies"/></xsl:attribute>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
		</xsl:otherwise>
	    </xsl:choose>

	    <xsl:choose>
		<xsl:when test="@type='special'">
		    <xsl:text>SPECIAL INSTRUCTIONS</xsl:text>
		    <xsl:if test="@applies">
			<xsl:text>: </xsl:text>
			<xsl:choose>
			    <xsl:when test="@applies='text-only'">
				<xsl:text>Text-only (no page images)</xsl:text>
			    </xsl:when>
			    <xsl:otherwise>
				<xsl:value-of select="@applies"/>
			    </xsl:otherwise>
			</xsl:choose>
		    </xsl:if>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:call-template name="uc">
			<xsl:with-param name="string"><xsl:value-of select="@type"/></xsl:with-param>
		    </xsl:call-template>
		</xsl:otherwise>
	    </xsl:choose>
	</span>
	<xsl:apply-templates/>
    </div>
</xsl:template>


<!-- PHRASE-LEVEL ELEMENTS -->

<xsl:template match="gizmo">
    <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="replace">
    <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="seg">
    <span>
	<xsl:if test="@type">
	    <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
	</xsl:if>
	<xsl:apply-templates/>
    </span>
</xsl:template>

<!-- override the template for <xref> from tei_lib.xsl -->
<xsl:template match="xref">
    <a>
	<xsl:choose>
	    <xsl:when test="@url">
		<xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
	    </xsl:when>
	    <xsl:when test="@type='scripts'">
		<!-- supply URL for scripts documentation -->
		<xsl:attribute name="href"><xsl:value-of select="concat('http://pogo.lib.virginia.edu/dlps/dlps-only/dlpsdoc/text/scripts/dlpsTextScripts.html#', text())"/></xsl:attribute>
	    </xsl:when>
	</xsl:choose>

        <xsl:if test="@type">
            <xsl:choose>
                <xsl:when test="@type='external'">
                    <!-- link should open a new window; use '_blank' -->
                    <xsl:attribute name="target">_blank</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="target"><xsl:value-of select="@type"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:apply-templates/>
    </a>
</xsl:template>


<!-- BREAKS -->

<xsl:template match="lb">
    <br/>
</xsl:template>

</xsl:stylesheet>

<?xml version="1.0"?>

<!--

  tei_preview.xsl - provides essential transformation from TEI XML to
  HTML for basic web display

  Intended for use with texts validated against the uva-dl-tei DTD in
  post-keyboarding mode. May not work with other flavors of TEI.

  Greg Murray <gpm2a@virginia.edu>
  Written: 2003-05-19
  Last modified: 2008-09-17

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- INCLUDES -->
<xsl:import href="util_lib.xsl"/>
<xsl:import href="tei_lib.xsl"/>


<!-- OUTPUT -->
<xsl:output method="html"/>


<!-- PARAMETERS -->
<xsl:param name="docid"/>
<xsl:param name="filename"><xsl:value-of select="concat($docid, '.xml')"/></xsl:param>
<xsl:param name="divid"/>
<xsl:param name="mode"/>
<xsl:param name="imageExt"><xsl:text>.gif</xsl:text></xsl:param>
<xsl:param name="dtd"/>


<!-- GLOBAL VARIABLES -->
<xsl:variable name="servletPath">http://pogo.lib.virginia.edu/cgi-dlps/saxon/SaxonCGI.pl</xsl:variable>

<xsl:variable name="sourceFile"><xsl:value-of select="concat('http://pogo.lib.virginia.edu/dlps/xml/', $filename)"/></xsl:variable>

<xsl:variable name="stylesheet">http://pogo.lib.virginia.edu/dlps/xsl/tei_preview.xsl</xsl:variable>

<xsl:variable name="imagePath">http://pogo.lib.virginia.edu/dlps/uva-only/proofreader/images/<xsl:value-of select="$docid"/>/</xsl:variable>


<!-- NAMED TEMPLATES -->

<xsl:template name="getURL">
    <!-- constructs a URL for the Saxon servlet -->
    <xsl:param name="id"/>
    <xsl:param name="type"/>

    <xsl:value-of select="$servletPath"/>
    <xsl:text>?source=</xsl:text><xsl:value-of select="$sourceFile"/>
    <xsl:text>&amp;style=</xsl:text><xsl:value-of select="$stylesheet"/>

    <xsl:if test="boolean($docid)">
	<xsl:text>&amp;docid=</xsl:text><xsl:value-of select="$docid"/>
    </xsl:if>

    <xsl:if test="boolean($filename)">
	<xsl:text>&amp;filename=</xsl:text><xsl:value-of select="$filename"/>
    </xsl:if>

    <xsl:if test="boolean($id)">
	<xsl:text>&amp;divid=</xsl:text><xsl:value-of select="$id"/>
    </xsl:if>

    <xsl:if test="boolean($imageExt)">
	<xsl:text>&amp;imageExt=</xsl:text><xsl:value-of select="$imageExt"/>
    </xsl:if>

    <xsl:if test="boolean($dtd)">
	<xsl:text>&amp;dtd=</xsl:text><xsl:value-of select="$dtd"/>
    </xsl:if>

    <xsl:choose>
	<xsl:when test="$type='note'">
	    <xsl:text>&amp;mode=note</xsl:text>
	</xsl:when>
    </xsl:choose>
</xsl:template>

<xsl:template name="getLabel">
    <xsl:choose>
	<xsl:when test="local-name()='group'">Group of texts</xsl:when>
	<xsl:when test="local-name()='text'">Text</xsl:when>
	<xsl:when test="local-name()='front'">Front matter</xsl:when>
	<xsl:when test="local-name()='body'">Body of text</xsl:when>
	<xsl:when test="local-name()='back'">Back matter</xsl:when>
	<xsl:when test="local-name()='titlePage'">Title page: </xsl:when>
    </xsl:choose>
</xsl:template>


<!-- TABLE OF CONTENTS TEMPLATES -->

<xsl:template name="toc">
    <p><a>
	<xsl:attribute name="href">
	    <xsl:call-template name="getURL">
		<xsl:with-param name="id">0</xsl:with-param>
	    </xsl:call-template>
	</xsl:attribute>
	<xsl:text>Entire document</xsl:text>
    </a></p>
    <ul>
	<xsl:apply-templates select="TEI.2/text/*" mode="toc"/>
    </ul>
</xsl:template>

<xsl:template match="group|text|front|body|back|titlePage" mode="toc">
    <li>
	<xsl:choose>
	    <xsl:when test="@id">
		<a>
		    <xsl:attribute name="href">
			<xsl:call-template name="getURL">
			    <xsl:with-param name="id"><xsl:value-of select="@id"/></xsl:with-param>
			</xsl:call-template>
		    </xsl:attribute>
		    <xsl:call-template name="getLabel"/>
		    <xsl:if test="local-name()='titlePage'">
			<xsl:apply-templates select="docTitle/titlePart" mode="toc"/>
		    </xsl:if>
		</a>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:call-template name="getLabel"/>
		<xsl:if test="local-name()='titlePage'">
		    <xsl:apply-templates select="docTitle/titlePart" mode="toc"/>
		</xsl:if>
	    </xsl:otherwise>
	</xsl:choose>

	<xsl:choose>
	    <xsl:when test="local-name()='titlePage'"/>
	    <xsl:otherwise>
		<ul>
		    <xsl:apply-templates select="group|text|front|body|back|div1|titlePage" mode="toc"/>
		</ul>
	    </xsl:otherwise>
	</xsl:choose>
    </li>
</xsl:template>

<xsl:template match="div1|div2|div3|div4|div5|div6|div7" mode="toc">
    <li>
	<a>
	    <xsl:attribute name="href">
		<xsl:call-template name="getURL">
		    <xsl:with-param name="id"><xsl:value-of select="@id"/></xsl:with-param>
		</xsl:call-template>
	    </xsl:attribute>
	    <xsl:if test="@type">
		<xsl:call-template name="ucfirst">
		    <xsl:with-param name="string"><xsl:value-of select="@type"/></xsl:with-param>
		</xsl:call-template>
	    </xsl:if>
	    <xsl:if test="@type and (head//text() or @n)">
		<xsl:text>: </xsl:text>
	    </xsl:if>
	    <xsl:choose>
		<xsl:when test="head">
		    <xsl:apply-templates select="head" mode="toc"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:value-of select="@n"/>
		</xsl:otherwise>
	    </xsl:choose>
	</a>

	<xsl:if test="div2">
	    <ul><xsl:apply-templates select="div2" mode="toc"/></ul>
	</xsl:if>
	<xsl:if test="div3">
	    <ul><xsl:apply-templates select="div3" mode="toc"/></ul>
	</xsl:if>
	<xsl:if test="div4">
	    <ul><xsl:apply-templates select="div4" mode="toc"/></ul>
	</xsl:if>
	<xsl:if test="div5">
	    <ul><xsl:apply-templates select="div5" mode="toc"/></ul>
	</xsl:if>
	<xsl:if test="div6">
	    <ul><xsl:apply-templates select="div6" mode="toc"/></ul>
	</xsl:if>
	<xsl:if test="div7">
	    <ul><xsl:apply-templates select="div7" mode="toc"/></ul>
	</xsl:if>
    </li>
</xsl:template>

<xsl:template match="titlePart" mode="toc">
    <xsl:choose>
	<xsl:when test="@type='alt'"/>
	<xsl:when test="@type='desc'"/>
	<xsl:otherwise>
	    <xsl:apply-templates>
		<xsl:with-param name="toc">1</xsl:with-param>
	    </xsl:apply-templates>
	    <xsl:if test="following-sibling::titlePart[@type!='alt'][@type!='desc']">
		<xsl:text>: </xsl:text>
	    </xsl:if>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="head" mode="toc">
    <xsl:choose>
	<xsl:when test="@type='alt'"/>
	<xsl:when test="@type='desc'"/>
	<xsl:when test="@type='divisional'"/>
	<xsl:otherwise>
	    <xsl:apply-templates>
		<xsl:with-param name="toc">1</xsl:with-param>
	    </xsl:apply-templates>
	    <xsl:if test="following-sibling::head[@type!='alt'][@type!='desc'][@type!='divisional']">
		<xsl:text>: </xsl:text>
	    </xsl:if>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- TOP-LEVEL TEMPLATE -->
<xsl:template match="/">
    <html>
	<head>
	    <xsl:choose>
		<xsl:when test="$mode='note'">
		    <title>Notes</title>
		</xsl:when>
		<xsl:otherwise>
		    <title><xsl:value-of select="TEI.2/teiHeader/fileDesc/titleStmt/title"/></title>
		</xsl:otherwise>
	    </xsl:choose>

	    <xsl:choose>
		<xsl:when test="$dtd='teitech'">
		    <link rel="stylesheet" type="text/css"
                          href="/dlps/css/teitech.css"/>
		</xsl:when>
		<xsl:otherwise>
		    <link rel="stylesheet" type="text/css"
                          href="/dlps/css/tei.css"/>
		</xsl:otherwise>
	    </xsl:choose>
	</head>
	<body onLoad="window.focus()">
	    <xsl:choose>
		<xsl:when test="$mode='note'"/>
		<xsl:otherwise>
		    <xsl:apply-templates select="TEI.2/teiHeader/fileDesc"/>
		</xsl:otherwise>
	    </xsl:choose>

	    <xsl:choose>
		<xsl:when test="$divid">
		    <xsl:choose>
			<xsl:when test="$divid='0'">
			    <!-- process entire document -->
			    <xsl:apply-templates select="TEI.2/text"/>
			</xsl:when>
			<xsl:otherwise>
			    <!-- process element matching ID passed -->
			    <xsl:apply-templates select="//*[@id=$divid]"/>
			</xsl:otherwise>
		    </xsl:choose>
		</xsl:when>
		<xsl:otherwise>
		    <!-- no div ID passed; display table of contents -->
		    <xsl:call-template name="toc"/>
		</xsl:otherwise>
	    </xsl:choose>
	</body>
    </html>
</xsl:template>


<!-- TEI HEADER TEMPLATES -->

<xsl:template match="fileDesc">
    <table width="80%" class="metadata">
	<xsl:if test="titleStmt/title">
	    <tr><th width="10%" align="right" valign="top">Title:</th><td>
		<xsl:apply-templates select="titleStmt/title[1]"/>
		<xsl:if test="titleStmt/title[@type='volume']">
		    <xsl:text> / </xsl:text>
		    <xsl:apply-templates select="titleStmt/title[@type='volume']"/>
		</xsl:if>
	    </td></tr>
	</xsl:if>
	<xsl:if test="titleStmt/author">
	    <tr><th align="right">Author:</th><td><xsl:apply-templates select="titleStmt/author"/></td></tr>
	</xsl:if>
<!--
	<xsl:if test="titleStmt/respStmt">
	    <xsl:for-each select="titleStmt/respStmt">
		<tr><th align="right"><xsl:value-of select="resp"/></th><td><xsl:value-of select="name"/></td></tr>
	    </xsl:for-each>
	</xsl:if>
-->
	<tr><th align="right">File:</th><td><xsl:value-of select="$filename"/></td></tr>

	<xsl:if test="boolean($dtd)">
	    <tr><th align="right">DTD:</th><td><xsl:value-of select="$dtd"/></td></tr>
	</xsl:if>
    </table>
    <p> </p>
</xsl:template>


<!-- NOTES -->

<xsl:template match="note">
    <xsl:choose>
	<xsl:when test="$mode='note'">
	    <p>
		<xsl:if test="@n"><sup>[<xsl:value-of select="@n"/>]</sup><xsl:text> </xsl:text></xsl:if>
		<xsl:apply-templates select="*[not(self::note)]"/>
	    </p>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:if test="@place='end' or @place='inline' or @place='left' or @place='right'">
		<p>
		    <xsl:if test="@n"><sup>[<xsl:value-of select="@n"/>]</sup><xsl:text> </xsl:text></xsl:if>
		    <xsl:apply-templates select="*[not(self::note)]"/>
		</p>
	    </xsl:if>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- FIGURES AND ORNAMENTS -->

<xsl:template match="figure|frontispiece">
    <xsl:variable name="entity"><xsl:value-of select="@entity"/></xsl:variable>
    <xsl:variable name="pb_entity"><xsl:value-of select="preceding::pb[1]/@entity"/></xsl:variable>

    <xsl:choose>
	<!-- for now, always display hyperlink to page image rather
             than <img> tag, since 'figure scans' are usually not available -->
	<!--<xsl:when test="$entity='none'">-->
	<xsl:when test="true()">
	    <!-- supply hyperlink to page image -->
	    <xsl:choose>
		<xsl:when test="@rend='inline'">
		    <a target="images" href="{$imagePath}{$pb_entity}{$imageExt}">[figure]</a>
		    <xsl:apply-templates/>
		</xsl:when>
		<xsl:otherwise>
		    <p align="center">
			<a target="images" href="{$imagePath}{$pb_entity}{$imageExt}">[figure]</a>
			<xsl:apply-templates/>
		    </p>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
	<xsl:otherwise>
	    <!-- display image -->
	    <xsl:choose>
		<xsl:when test="@rend='inline'">
		    <img src="{$imagePath}{$entity}{$imageExt}"/>
		    <xsl:apply-templates/>
		</xsl:when>
		<xsl:otherwise>
		    <p align="center">
			<img src="{$imagePath}{$entity}{$imageExt}"/>
			<xsl:apply-templates/>
		    </p>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="figDesc"/>

<xsl:template match="ornament">
    <xsl:choose>
	<xsl:when test="@type='line'">
	    <hr align="center" width="20%" size="1" noshade="noshade"/>
	</xsl:when>
	<xsl:when test="@type='characters'">
	    <xsl:choose>
		<xsl:when test="@rend='inline'">
		    <xsl:apply-templates/>
		</xsl:when>
		<xsl:otherwise>
		    <p align="center"><xsl:apply-templates/></p>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
    </xsl:choose>
</xsl:template>


<!-- ARBITRARY PHRASE-LEVEL SECTIONS -->

<xsl:template match="seg">
    <xsl:choose>
	<xsl:when test="@type='note-symbol'">
	    <xsl:choose>
		<xsl:when test="../@n"/>
		<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
	<xsl:when test="@type='postscript'">
	    <!-- treat as block-level element -->
	    <p><xsl:apply-templates/></p>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:apply-templates/>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- HIGHLIGHTING -->

<xsl:template match="hi">
    <xsl:param name="toc"/>
    <xsl:choose>
	<xsl:when test="@rend='italic'"><i><xsl:apply-templates/></i></xsl:when>

	<xsl:when test="@rend='bold'">
	    <xsl:choose>
		<xsl:when test="$toc">
		    <b><xsl:apply-templates>
			<xsl:with-param name="toc">1</xsl:with-param>
		    </xsl:apply-templates></b>
		</xsl:when>
		<xsl:otherwise>
		    <b><xsl:apply-templates/></b>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>

	<xsl:when test="@rend='underline'"><u><xsl:apply-templates/></u></xsl:when>
	<xsl:when test="@rend='sub'"><sub><xsl:apply-templates/></sub></xsl:when>
	<xsl:when test="@rend='super' or @rend='sup'"><sup><xsl:apply-templates/></sup></xsl:when>
	<xsl:when test="@rend='small-caps' or @rend='smcap'"><span class="smcap"><xsl:apply-templates/></span></xsl:when>
	<xsl:when test="@rend='gothic'"><span class="gothic" title="gothic"><xsl:apply-templates/></span></xsl:when>

	<xsl:when test="@rend='center'"><span class="center"><xsl:apply-templates/></span></xsl:when>
	<xsl:when test="@rend='right'"><span class="right"><xsl:apply-templates/></span></xsl:when>
	<xsl:when test="@rend='left'"><span class="left"><xsl:apply-templates/></span></xsl:when>

	<!-- 'indent' etc. and 'hang' are handled at the block level; no styles applied here -->
	<xsl:when test="@rend='indent'">
	    <xsl:apply-templates/>
	</xsl:when>
	<xsl:when test="@rend='indent2'">
	    <xsl:apply-templates/>
	</xsl:when>
	<xsl:when test="@rend='indent3'">
	    <xsl:apply-templates/>
	</xsl:when>
	<xsl:when test="@rend='indent4'">
	    <xsl:apply-templates/>
	</xsl:when>
	<xsl:when test="@rend='indent5'">
	    <xsl:apply-templates/>
	</xsl:when>
	<xsl:when test="@rend='hang'">
	    <xsl:apply-templates/>
	</xsl:when>

	<xsl:otherwise><span class="unknown"><xsl:apply-templates/></span></xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- POINTERS -->

<xsl:template match="ref|ptr">
    <xsl:param name="toc"/>
    <xsl:variable name="target" select="@target"/>

    <xsl:if test="not($toc)">
    <a>
	<xsl:if test="//note[@id=$target]">
	    <!-- this ref/ptr points to a <note> element; use 'notes' window for display of note -->
	    <xsl:attribute name="target">notes</xsl:attribute>
	</xsl:if>

	<xsl:attribute name="href">
	    <xsl:call-template name="getURL">
		<xsl:with-param name="id"><xsl:value-of select="@target"/></xsl:with-param>
		<xsl:with-param name="type">note</xsl:with-param>
	    </xsl:call-template>
	</xsl:attribute>

	<!-- for text of link, use n attribute if available; otherwise use content of element -->
	<xsl:choose>
	    <xsl:when test="@n">
		<sup>[<xsl:value-of select="@n"/>]</sup>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:choose>
		    <xsl:when test="local-name()='ref'"><xsl:apply-templates/></xsl:when>
		    <xsl:otherwise>[?]</xsl:otherwise>
		</xsl:choose>
	    </xsl:otherwise>
	</xsl:choose>
    </a>
    </xsl:if>
</xsl:template>


<!-- BREAKS -->

<xsl:template match="pb">
    <xsl:variable name="entity"><xsl:value-of select="@entity"/></xsl:variable>
    <xsl:variable name="content">
        <xsl:choose>
            <xsl:when test="@n">
                <xsl:value-of select="@n"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[page image]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:choose>
	<xsl:when test="name(..)='table'">
	  <tr><td>
	    <hr/>
            <xsl:choose>
                <xsl:when test="@entity">
                    <a target="images" href="{$imagePath}{$entity}{$imageExt}">
                        <xsl:value-of select="$content"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$content"/>
                </xsl:otherwise>
            </xsl:choose>
	    <br/><br/>
	  </td></tr>
	</xsl:when>
	<xsl:otherwise>
	    <hr/>
            <xsl:choose>
                <xsl:when test="@entity">
                    <a target="images" href="{$imagePath}{$entity}{$imageExt}">
                        <xsl:value-of select="$content"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$content"/>
                </xsl:otherwise>
            </xsl:choose>
	    <br/><br/>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>

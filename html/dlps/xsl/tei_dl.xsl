<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- tei2htmlTEST.xsl converts a chunk of TEI excerpted by the
		idTEXT.xsl stylesheet to generic HTML which is intended to be
		styled by a CSS stylesheet -->

	<xsl:strip-space elements="*"/>

	<!-- The output element makes no sense in cocoon and is ignored
	     since the serializer determines encoding/mimetype/indention/etc... -->
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>

	<xsl:template match="/">
		<html>
			<head>
				<link type="text/css" href="http://pogo.lib.virginia.edu/dlps/css/main.css" rel="stylesheet"/>
				<link type="text/css" href="http://pogo.lib.virginia.edu/dlps/css/default.css" rel="stylesheet"/>
			</head>
			<body>
				<xsl:apply-templates select="//text"/>
			</body>
		</html>
	</xsl:template>

	<!-- These elements are always blocks -->
	<xsl:template
		match="ab|argument|back|cit|closer|dateline|div1|div2|div3|div4|
   div5|div6|div7|docAuthor|docEdition|docImprint|docTitle|entry|
   epigraph|front|lg|opener|ornament|salute|signed|sp|
   speaker|titlePage|trailer"
		mode="tei">
		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="name()"/>
			</xsl:attribute>
			<xsl:comment>spacer</xsl:comment>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- These elements are always inline -->
	<xsl:template match="foreign|ref">
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="name()"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="ptr">
		<!-- ptr is an empty element; use 'n' attribute as content (with square brackets to indicate it's not in the print source) -->
		<span class="ptr">[<xsl:value-of select="@n"/>]</span>
	</xsl:template>

	<!-- These elements should be considered inline unless specified as block -->
	<xsl:template match="bibl|stage">
		<xsl:choose>
			<xsl:when test="@rend='block'">
				<div>
					<xsl:attribute name="class">
						<xsl:value-of select="local-name()"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:attribute name="class">
						<xsl:value-of select="local-name()"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- The <figure> element should be considered block unless specified as inline -->
	<xsl:template match="figure|frontispiece">
		<xsl:choose>
			<xsl:when test="@rend='inline'">
				<span class="figure">
					<!-- always use class="figure", never class="frontispiece" -->
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<div class="figure">
					<!-- always use class="figure", never class="frontispiece" -->
					<xsl:comment>spacer</xsl:comment>
					<xsl:apply-templates/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="figDesc"/>

	<!-- The <seg> element is inline unless 'type' attribute indicates block -->
	<xsl:template match="seg">
		<xsl:choose>
			<xsl:when test="@type='postscript' or @type='call-out' or @rend='block'">
				<div>
					<xsl:attribute name="class">
						<xsl:value-of select="@type"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:attribute name="class">
						<xsl:value-of select="@type"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</span>
				<xsl:if test="@type='note-symbol'">
					<!-- insert a space between note symbol and note content -->
					<xsl:text> </xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="q">
		<div>
			<xsl:if test="not(ancestor::epigraph)">
				<xsl:attribute name="class">
					<xsl:value-of select="local-name()"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="byline">
		<div>
			<xsl:choose>
				<xsl:when test="ancestor::titlePage">
					<xsl:attribute name="class">titlePageByline</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">
						<xsl:value-of select="name()"/>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="lb">
		<br/>
	</xsl:template>

	<xsl:template match="pb">
		<a name="{@pid}">
			<xsl:comment>spacer</xsl:comment>
		</a>
		<a name="{@n}">
			<xsl:comment>spacer</xsl:comment>
		</a>
		<div>
			<xsl:choose>
				<xsl:when test="not(preceding::pb)">
					<xsl:attribute name="class">pbfirst</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">pb</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<div class="pb-display">
				<xsl:if test="@n">
					<span class="page-number"> Page <xsl:value-of select="@n"/>
					</span>
					<br/>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="list">
		<xsl:apply-templates select="head"/>
		<ul>
			<xsl:for-each select="item">
				<li>
					<xsl:apply-templates select="preceding-sibling::label[1]"/>
					<xsl:text/>
					<xsl:apply-templates/>
				</li>
			</xsl:for-each>
		</ul>
		<!-- process descendant <note> elements here, after the close of the list -->
		<xsl:apply-templates select="descendant::note">
			<xsl:with-param name="force">true</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="label">
		<span class="label">
			<xsl:apply-templates/>
			<xsl:text> </xsl:text>
		</span>
	</xsl:template>

	<xsl:template match="p">
		<xsl:choose>
			<xsl:when test="figure and count(child::*)=1">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:if test="@rend">
						<xsl:attribute name="class">
							<xsl:value-of select="@rend"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="note/p[1]|figure/p[1]">
		<xsl:apply-templates/>
		<br/>
	</xsl:template>

	<xsl:template match="note">
		<xsl:param name="force"/>
		<xsl:choose>
			<xsl:when test="ancestor::head and not($force)"/>
			<!-- skip for now; this note will be processed at the end of the heading; see template for <head> -->
			<xsl:when test="ancestor::l and not($force)"/>
			<!-- skip for now; this note will be processed at the end of the line of verse; see template for <l> -->
			<xsl:when test="ancestor::list and not($force)"/>
			<!-- skip for now; this note will be processed at the end of the list; see template for <list> -->
			<xsl:when test="ancestor::table and not($force)"/>
			<!-- skip for now; this note will be processed at the end of the table; see template for <table> -->
			<xsl:otherwise>
				<div class="note">
					<!-- if no note symbol, or note is unanchored (i.e. pointed to by <ptr/>), use 'n' attribute (with square brackets to indicate it's not in the print source) -->
					<xsl:if test="not(seg[@type='note-symbol']) or @anchored='no'">
						<xsl:if test="@n">
							<span class="note-symbol">[<xsl:value-of select="@n"/>]</span>
							<!-- insert a space between note symbol and note content -->
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:apply-templates/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="table">
		<xsl:choose>
			<xsl:when test="descendant::pb">
				<!--We have to deal with page breaks in our tables like: 
					<table><row><coll/></row><pb/><row><coll/></row></table>
				-->
				<xsl:for-each select="pb">
					<xsl:variable name="pbnumbefore" select="position() - 1"/>
					<xsl:choose>
						<xsl:when test="position() = 1">
							<table cellspacing="0">
								<xsl:apply-templates select="preceding-sibling::*"/>
							</table>
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:otherwise>
							<!-- we need the intersect of nodes preceding the current
								and nodes following the pb before this one
							-->
							<xsl:variable name="preceding" select="preceding-sibling::*"/>
							<xsl:variable name="following"
								select="../pb[position() = $pbnumbefore]/following-sibling::*"/>
							<table cellspacing="0">
								<xsl:for-each
									select="$preceding[count(.|$following)=count($following)]">
									<xsl:apply-templates select="."/>
								</xsl:for-each>
							</table>
							<xsl:apply-templates select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:if test="pb[last()]/following-sibling::*">
					<table cellspacing="0">
						<xsl:apply-templates select="pb[last()]/following-sibling::*"/>
					</table>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test=".//row">
					<table cellspacing="0">
						<xsl:apply-templates/>
					</table>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<!-- process descendant <note> elements here, after the close of the table -->
		<xsl:apply-templates select="descendant::note">
			<xsl:with-param name="force">true</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="row">
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>

	<xsl:template match="cell">
		<td>
			<xsl:if test="@rend or @role='label'">
				<xsl:attribute name="class">
					<xsl:if test="@rend">
						<xsl:value-of select="@rend"/>
					</xsl:if>
					<xsl:if test="@rend and @role='label'">
						<xsl:text> </xsl:text>
						<!-- whitespace -->
					</xsl:if>
					<xsl:if test="@role='label'">
						<xsl:value-of select="@role"/>
					</xsl:if>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="number(@cols) > 1">
				<xsl:attribute name="colspan">
					<xsl:value-of select="@cols"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="number(@rows) > 1">
				<xsl:attribute name="rowspan">
					<xsl:value-of select="@rows"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</td>
	</xsl:template>

	<xsl:template match="hi">
		<xsl:choose>
			<!-- for note references and note symbols, avoid applying CSS superscript style twice (which elevates the content excessively) -->
			<xsl:when test="ancestor::ref and @rend='super'">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="ancestor::seg[@type='note-symbol'] and @rend='super'">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:attribute name="class">
						<xsl:value-of select="@rend"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="add">
		<xsl:call-template name="add_del_handler">
			<xsl:with-param name="label">added</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="del">
		<xsl:call-template name="add_del_handler">
			<xsl:with-param name="label">deleted</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="add_del_handler">
		<xsl:param name="label"/>
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="local-name()"/>
			</xsl:attribute>
			<xsl:text>[</xsl:text>
			<xsl:value-of select="$label"/>
			<xsl:text>: </xsl:text>
			<xsl:choose>
				<xsl:when test="@rend">
					<span>
						<xsl:attribute name="class">
							<xsl:value-of select="@rend"/>
						</xsl:attribute>
						<xsl:apply-templates/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>]</xsl:text>
		</span>
	</xsl:template>

	<xsl:template match="head">
		<div>
			<xsl:attribute name="class">
				<xsl:choose>
					<!-- headings on div1, div2, etc. need to indicate 'main' or 'sub' if applicable -->
					<xsl:when test="starts-with(local-name(..), 'div')">
						<xsl:choose>
							<xsl:when test="not(@type) or @type='main'">
								<xsl:text>head-main</xsl:text>
							</xsl:when>
							<xsl:when test="@type='sub'">
								<xsl:text>head-sub</xsl:text>
							</xsl:when>
							<xsl:when test="@type='divisional'">
								<xsl:text>head-divisional</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>head</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- all other headings -->
					<xsl:otherwise>
						<xsl:text>head</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
			<!--<br />-->
		</div>
		<xsl:choose>
			<xsl:when test="local-name(..)='list' or local-name(..)='table'">
				<!-- do not process descendant <note> elements; they will be handled by the <list> or <table> template -->
			</xsl:when>
			<xsl:otherwise>
				<!-- process descendant <note> elements here, after the close of the heading -->
				<xsl:apply-templates select="descendant::note">
					<xsl:with-param name="force">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="table/head">
		<caption>
			<xsl:apply-templates/>
		</caption>
	</xsl:template>

	<xsl:template match="titlePart">
		<div>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="not(@type) or @type='main'">
						<xsl:text>head-main</xsl:text>
					</xsl:when>
					<xsl:when test="@type='sub'">
						<xsl:text>head-sub</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>head</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="publisher|pubPlace|docDate">
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="local-name()"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
		<xsl:if test="local-name(following-sibling::*[1]) != 'lb'">
			<br/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="l">
		<!-- Include line number span whether @n is present or not; this
		     avoids alignment problems that occur when some lines in a
		     line grouping include @n, others don't. In block quotations,
		     exclude line numbers altogether. -->
		<xsl:if test="not(ancestor::q)">
			<span class="line-number">
				<xsl:choose>
					<xsl:when test="@n">
						<xsl:value-of select="@n"/>
					</xsl:when>
					<xsl:otherwise>
						&#160;<!--<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>-->
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:if>
		<span>
			<xsl:if test="@rend">
				<xsl:attribute name="class">
					<xsl:value-of select="@rend"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
		<br/>
		<!-- process descendant <note> elements here, after the close of the line of verse -->
		<xsl:apply-templates select="descendant::note">
			<xsl:with-param name="force">true</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="gap">
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="name()"/>
			</xsl:attribute>
			<xsl:text>[omission</xsl:text>
			<!-- include description of gap if available -->
			<xsl:if test="@desc">
				<xsl:text>: </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(@desc) = 3">
						<!-- typically a 3-character language code -->
						<xsl:choose>
							<xsl:when test="@desc='chi'">Chinese characters</xsl:when>
							<xsl:otherwise>foreign language</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@desc"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:text>]</xsl:text>
		</span>
	</xsl:template>

	<xsl:template match="unclear">
		<xsl:variable name="textcontent">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$textcontent != ''">
				<span>
					<xsl:attribute name="class">
						<xsl:value-of select="name()"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:attribute name="class">
						<xsl:value-of select="name()"/>
					</xsl:attribute>
					<xsl:text>[unclear]</xsl:text>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

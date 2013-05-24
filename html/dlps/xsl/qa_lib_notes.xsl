<?xml version='1.0'?>

<!--

  qa_lib_notes.xsl - XSLT stylesheet for markup QA of TEI note
    elements and the ref/ptr elements that point to them.

  Intended to be imported into another, primary stylesheet (namely
  qa_tei_html.xsl for HTML output or qa_tei_commandline.xsl for text
  output).

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2003-12-13
  Last modified: 2010-05-14

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- INDEX KEYS -->
<xsl:key name="ref-target" match="ref" use="@target"/>
<xsl:key name="ptr-target" match="ptr" use="@target"/>
<xsl:key name="pointer-target" match="ref|ptr" use="@target"/>


<!-- TEMPLATES -->
<xsl:template match="teiHeader" mode="notes"/>

<xsl:template match="text" mode="notes">
    <xsl:apply-templates select="descendant::note" mode="notes"/>
    <xsl:apply-templates select="descendant::ref" mode="notes"/>
</xsl:template>

<xsl:template match="note" mode="notes">
    <xsl:variable name="ref_node" select="key('ref-target', @id)"/>
    <xsl:variable name="ptr_node" select="key('ptr-target', @id)"/>
    <xsl:variable name="pointer_node" select="key('pointer-target', @id)"/>

    <!-- id, place, n attributes required (except in <teiHeader>, and this template only matches descendants of <text>) -->
    <xsl:choose>
	<xsl:when test="not(@id)">
	    <xsl:call-template name="outputMsg">
		<xsl:with-param name="msg">Missing id: id attribute required on &lt;note&gt; (except in &lt;teiHeader&gt;).</xsl:with-param>
	    </xsl:call-template>
	</xsl:when>

	<xsl:when test="not(@place)">
	    <!-- for production files, missing @place is an error condition; for migration texts, it is only a warning -->
	    <xsl:choose>
		<xsl:when test="/TEI.2/teiHeader[@type='migrated']">
		    <xsl:call-template name="outputMsg">
			<xsl:with-param name="type">W</xsl:with-param>
			<xsl:with-param name="msg">Missing place: no place attribute on &lt;note&gt;</xsl:with-param>
		    </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:call-template name="outputMsg">
			<xsl:with-param name="msg">Missing place: place attribute required on &lt;note&gt; (except in &lt;teiHeader&gt;).</xsl:with-param>
		    </xsl:call-template>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>

	<!-- n attribute is required if the <note> is pointed to by a <ref> or <ptr/> -->
	<xsl:when test="not(@n) and $pointer_node">
	    <xsl:call-template name="outputMsg">
		<xsl:with-param name="msg">Missing n: n attribute required on &lt;note&gt; (except in &lt;teiHeader&gt;).</xsl:with-param>
	    </xsl:call-template>
	</xsl:when>
    </xsl:choose>

    <!-- each <note> must be pointed to by a <ref> or <ptr/>, unless
         place="inline" or rend="inline"
         (an inline note just occurs where it occurs; it is not
          necessarily referred to by a pointer element) -->
    <xsl:if test="not($pointer_node)">
	<xsl:choose>
	    <xsl:when test="@place='inline' or @rend='inline'"/>
	    <xsl:otherwise>
		<!-- for production files, this is an error condition; for migration files, it is only a warning -->
		<xsl:choose>
		    <xsl:when test="/TEI.2/teiHeader[@type='migrated']">
			<xsl:call-template name="outputMsg">
			    <xsl:with-param name="type">W</xsl:with-param>
			    <xsl:with-param name="msg">Stray note: &lt;note id="<xsl:value-of select="@id"/>"&gt; has no corresponding &lt;ref&gt; or &lt;ptr/&gt;.</xsl:with-param>
			</xsl:call-template>
		    </xsl:when>
		    <xsl:otherwise>
			<xsl:call-template name="outputMsg">
			    <xsl:with-param name="msg">Stray note: &lt;note id="<xsl:value-of select="@id"/>"&gt; has no corresponding &lt;ref&gt; or &lt;ptr/&gt;.</xsl:with-param>
			</xsl:call-template>
		    </xsl:otherwise>
		</xsl:choose>
	    </xsl:otherwise>
	</xsl:choose>
    </xsl:if>

    <!-- value of n on note must match value of n on corresponding ref/ptr -->
    <xsl:if test="@n and $pointer_node">
	<xsl:choose>
	    <xsl:when test="not($pointer_node/@n)">
		<!-- 'n' attribute required on any ref/ptr that points to a note-->
		<xsl:call-template name="outputMsg">
		    <xsl:with-param name="msg">Missing n: n attribute required on any &lt;ref&gt; or &lt;ptr/&gt; that points to a &lt;note&gt;.</xsl:with-param>
		</xsl:call-template>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:if test="not(string(@n) = string($pointer_node/@n))">
		    <xsl:call-template name="outputMsg">
			<xsl:with-param name="msg">n mismatch: Attribute 'n' on &lt;note&gt; (<xsl:value-of select="@n"/>) not equal to attribute 'n' on &lt;ref&gt; or &lt;ptr/&gt; (<xsl:value-of select="$pointer_node/@n"/>).</xsl:with-param>
		    </xsl:call-template>
		</xsl:if>
	    </xsl:otherwise>
	</xsl:choose>
    </xsl:if>

    <!-- notes (except endnotes and inline notes) should immediately follow their corresponding ref/ptr -->
    <xsl:if test="$pointer_node and not(@place='end') and not(@place='inline')">
	<xsl:choose>
	    <!-- if the immediately preceding sibling is <ref> or <ptr/>, that's fine -->
	    <xsl:when test="local-name(preceding-sibling::*[1])='ref'"/>
	    <xsl:when test="local-name(preceding-sibling::*[1])='ptr'"/>

	    <!-- it's also ok if the immediately preceding sibling is a <corr> containg <ref> or <ptr/> -->
	    <xsl:when test="local-name(preceding-sibling::*[1])='corr' and (preceding-sibling::*[1]/ref or preceding-sibling::*[1]/ptr)"/>

	    <xsl:otherwise>
		<xsl:call-template name="outputMsg">
		    <xsl:with-param name="type">W</xsl:with-param>
		    <xsl:with-param name="msg">Misplaced note: &lt;note&gt; is not an endnote (not place="end") but does not immediately follow &lt;ref&gt; or &lt;ptr/&gt;.</xsl:with-param>
		</xsl:call-template>
	    </xsl:otherwise>
	</xsl:choose>
    </xsl:if>

    <!-- if <seg type="note-symbol"> is used, it must be the first node in the <note> -->
    <xsl:variable name="note_symbol" select="child::seg[@type='note-symbol']"/>
    <xsl:if test="$note_symbol">
	<xsl:if test="$note_symbol/preceding-sibling::* or $note_symbol/preceding-sibling::text()">
	    <xsl:call-template name="outputMsg">
		<xsl:with-param name="msg">If &lt;seg type="note-symbol"&gt; is used, it must be the first content within &lt;note&gt;</xsl:with-param>
	    </xsl:call-template>
	</xsl:if>
    </xsl:if>

    <!-- first child element of an anchored note should be <seg type="note-symbol"> -->
    <xsl:if test="not(@anchored='no') and not(@place='inline')">
	<xsl:choose>
	    <xsl:when test="local-name(child::*[1])='seg' and child::*[1][@type='note-symbol']"/>
	    <xsl:otherwise>
		<xsl:call-template name="outputMsg">
		    <xsl:with-param name="type">W</xsl:with-param>
		    <xsl:with-param name="msg">Missing note-symbol: Footnote or endnote without first child element &lt;seg type="note-symbol"&gt;.</xsl:with-param>
		</xsl:call-template>
	    </xsl:otherwise>
	</xsl:choose>
    </xsl:if>

    <!-- note symbol on note should match note symbol on corresponding ref -->
    <xsl:if test="seg[@type='note-symbol']">
	<xsl:variable name="ns" select="seg[@type='note-symbol']"/>
	<xsl:if test="$ref_node">
	    <xsl:if test="not($ns = $ref_node)">
		<!-- test whether only difference is a period at end of note symbol (common with endnotes) -->
		<xsl:choose>
		    <xsl:when test="substring($ns, string-length($ns)) = '.'">
			<xsl:if test="not(substring($ns, 1, string-length($ns) - 1) = $ref_node)">
			    <xsl:call-template name="outputMsg">
				<xsl:with-param name="type">W</xsl:with-param>
				<xsl:with-param name="msg">Note symbol on &lt;note&gt; (<xsl:value-of select="substring($ns, 1, string-length($ns) - 1)"/>) does not equal content of &lt;ref&gt; (<xsl:value-of select="$ref_node"/>).</xsl:with-param>
			    </xsl:call-template>
			</xsl:if>
		    </xsl:when>
		    <xsl:otherwise>
			<xsl:call-template name="outputMsg">
			    <xsl:with-param name="type">W</xsl:with-param>
			    <xsl:with-param name="msg">Note symbol on &lt;note&gt; (<xsl:value-of select="$ns"/>) does not equal content of &lt;ref&gt; (<xsl:value-of select="$ref_node"/>).</xsl:with-param>
			</xsl:call-template>
		    </xsl:otherwise>
		</xsl:choose>
	    </xsl:if>
	</xsl:if>
    </xsl:if>

    <!-- normally anchored="no" should be used if (and only if) note is pointed to by ptr (no note symbol, suggesting unanchored) -->
    <xsl:choose>
	<xsl:when test="@anchored='no'">
	    <xsl:if test="$ref_node">
		<!-- unanchored notes should be pointed to by <ptr/>,
                     not <ref>; a separate test (above) will catch
                     cases where note has neither ptr nor ref -->
		<xsl:call-template name="outputMsg">
		    <xsl:with-param name="msg">anchored mismatch: Element &lt;note&gt; has attribute anchored="no" but is anchored (is pointed to by &lt;ref&gt;).</xsl:with-param>
		</xsl:call-template>
	    </xsl:if>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:if test="$ptr_node">
		<xsl:call-template name="outputMsg">
		    <xsl:with-param name="type">W</xsl:with-param>
		    <xsl:with-param name="msg">anchored mismatch: Attribute anchored="no" is expected on &lt;note&gt; if note is unanchored (is pointed to by &lt;ptr/&gt;).</xsl:with-param>
		</xsl:call-template>
	    </xsl:if>
	</xsl:otherwise>
    </xsl:choose>

    <!-- a note should not contain a page break, with the exception of endnotes or inline notes -->
    <xsl:if test="not(@place='end') and not(@place='inline')">
	<xsl:if test="descendant::pb">
	    <xsl:call-template name="outputMsg">
		<xsl:with-param name="msg">Page break within note: &lt;note&gt; is not an endnote or inline note (not place="end" or place="inline") but contains &lt;pb/&gt;.</xsl:with-param>
	    </xsl:call-template>
	</xsl:if>
    </xsl:if>

</xsl:template>

<xsl:template match="ref" mode="notes">
    <!-- test for <hi rend="super"> immediately preceding <ref>; the <hi> should be inside the <ref> -->
    <xsl:if test="parent::hi[@rend='super']">
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="type">W</xsl:with-param>
	    <xsl:with-param name="msg">&lt;ref target="<xsl:value-of select='@target'/>"&gt; is immediately preceded by &lt;hi rend="super"&gt;. Normally the &lt;hi&gt; element should be inside the &lt;ref&gt;.</xsl:with-param>
	</xsl:call-template>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>

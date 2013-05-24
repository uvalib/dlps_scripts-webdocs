<?xml version='1.0'?>

<!--

  qa_lib_structure.xsl - XSLT stylesheet for markup QA of TEI major
    structure, divs, and heads.

  Intended to be imported into another, primary stylesheet (namely
  qa_tei_html.xsl for HTML output or qa_tei_commandline.xsl for text
  output).

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2003-05-22
  Last modified: 2008-11-04

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="testId">
    <!-- This template is used to enforce requiring attribute 'id' on
         major structural elements (except for quoted texts) when in
         finalization mode. -->
    <xsl:if test="not(@id) and not(ancestor::q)">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">In 'finalization' mode, attribute 'id'
is required on &lt;<xsl:value-of select="local-name(.)"/>&gt;.</xsl:with-param>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template match="teiHeader" mode="structure"/>

<xsl:template match="text" mode="structure">

    <!-- use of <group> -->
    <xsl:if test="group">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="type">W</xsl:with-param>
            <xsl:with-param name="msg">Element &lt;group&gt; found; &lt;group&gt;
should be used only when specifically requested by DLPS.</xsl:with-param>
        </xsl:call-template>
    </xsl:if>

    <!-- exactly one <titlePage> -->
    <xsl:if test="count(descendant::titlePage) > 1 and not(group)">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="type">W</xsl:with-param>
            <xsl:with-param name="msg">Text contains more than one &lt;titlePage&gt;
element but does not use &lt;group&gt;.</xsl:with-param>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="not(descendant::titlePage) and not(descendant::div1[@type='nameplate'])">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="type">W</xsl:with-param>
            <xsl:with-param name="msg">Text has neither a &lt;titlePage&gt;
(for books) nor a &lt;div1 type="nameplate"&gt; (for newspapers).</xsl:with-param>
        </xsl:call-template>
    </xsl:if>

    <!-- if in 'finalization' mode, 'id' attribute is required on major structural elements  -->
    <xsl:if test="$finalization">
	<xsl:call-template name="testId"/>

	<xsl:for-each select="descendant::group|descendant::text|descendant::front|descendant::body|descendant::back|descendant::titlePage|descendant::div1|descendant::div2|descendant::div3|descendant::div4|descendant::div5|descendant::div6|descendant::div7">
	    <xsl:call-template name="testId"/>
	</xsl:for-each>
    </xsl:if>

    <xsl:apply-templates select="front" mode="structure"/>

    <xsl:apply-templates select="descendant::head" mode="structure"/>

    <xsl:apply-templates select="descendant::titlePage" mode="structure"/>

    <xsl:apply-templates select="descendant::div1" mode="structure"/>
</xsl:template>


<!-- FRONT -->

<xsl:template match="front" mode="structure">
    <!-- DTD allows page breaks within <front> (for covers/edges/spine),
         but the DTD cannot (without creating an ambiguous content model)
         enforce allowing page breaks only at the very beginning of front,
         prior to any div1 or titlePage elements. Check for that here. -->
    <xsl:apply-templates select="pb" mode="structure"/>

    <!-- DTD allows <front> to contain only page breaks (for cases
         where front matter consists only of pb tags for
         covers/edges/spine), but it's a very unusual circumstance,
         so issue a warning if it occurs -->
    <xsl:if test="not(titlePage) and not(div1)">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="type">W</xsl:with-param>
            <xsl:with-param name="msg">&lt;front&gt; has no &lt;titlePage&gt; and no &lt;div1&gt; elements</xsl:with-param>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template match="pb" mode="structure">
    <xsl:if test="preceding-sibling::div1 or preceding-sibling::titlePage">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">&lt;pb&gt; is allowed within &lt;front&gt; only at the very beginning of &lt;front&gt;, not following a &lt;titlePage&gt; or &lt;div1&gt; element</xsl:with-param>
        </xsl:call-template>
    </xsl:if>
</xsl:template>


<!-- TITLE PAGES -->

<xsl:template match="titlePage" mode="structure">
    <!-- verso should be included; thus titlePage should contain exactly two page breaks -->
    <xsl:if test="count(descendant::pb) != 2">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="type">W</xsl:with-param>
            <xsl:with-param name="msg">&lt;titlePage&gt; should contain exactly two &lt;pb&gt; elements (for recto and verso of title page)</xsl:with-param>
        </xsl:call-template>
    </xsl:if>
</xsl:template>


<!-- DIVISIONS -->

<xsl:template name="sectionSubsection">
    <xsl:if test="@type='section'">
	<!-- if type="section", parent type should not be "section" or "subsection" -->
	<xsl:if test="parent::*[@type='section'] or parent::*[@type='subsection']">
	    <xsl:call-template name="outputMsg">
		<xsl:with-param name="msg">Div is type="section" but should be type="subsection", because parent div is type="<xsl:value-of select='../@type'/>".</xsl:with-param>
	    </xsl:call-template>
	</xsl:if>
    </xsl:if>

    <xsl:if test="@type='subsection'">
	<!-- if type="subsection", parent type should be "section" or "subsection" (not "chapter" etc.) -->
	<xsl:if test="not(parent::*[@type='section']) and not(parent::*[@type='subsection'])">
	    <xsl:call-template name="outputMsg">
		<xsl:with-param name="msg">Div is type="subsection" but should be type="section", because parent div is type="<xsl:value-of select='../@type'/>".</xsl:with-param>
	    </xsl:call-template>
	</xsl:if>
    </xsl:if>
</xsl:template>

<xsl:template name="quotedLetterWarning">
    <xsl:call-template name="outputMsg">
        <xsl:with-param name="type">W</xsl:with-param>
        <xsl:with-param name="msg">Div has type="letter", but no other divs at the same level have type="letter"; this div could actually be a quoted letter.</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<!-- if type="letter" but no sibling divs are type="letter", warn that this could actually be a quoted letter -->

<xsl:template match="div1" mode="structure">
    <xsl:if test="@type='letter'">
        <xsl:if test="preceding-sibling::div1 or following-sibling::div1">
            <xsl:if test="not(preceding-sibling::div1[@type='letter']) and not(following-sibling::div1[@type='letter'])">
                <xsl:call-template name="quotedLetterWarning"/>
            </xsl:if>
        </xsl:if>
    </xsl:if>

    <xsl:call-template name="sectionSubsection"/>
    <xsl:apply-templates select="div2" mode="structure"/>
</xsl:template>

<xsl:template match="div2" mode="structure">
    <xsl:if test="@type='letter'">
        <xsl:if test="preceding-sibling::div2 or following-sibling::div2">
            <xsl:if test="not(preceding-sibling::div2[@type='letter']) and not(following-sibling::div2[@type='letter'])">
                <xsl:call-template name="quotedLetterWarning"/>
            </xsl:if>
        </xsl:if>
    </xsl:if>

    <xsl:call-template name="sectionSubsection"/>
    <xsl:apply-templates select="div3" mode="structure"/>
</xsl:template>

<xsl:template match="div3" mode="structure">
    <xsl:if test="@type='letter'">
        <xsl:if test="preceding-sibling::div3 or following-sibling::div3">
            <xsl:if test="not(preceding-sibling::div3[@type='letter']) and not(following-sibling::div3[@type='letter'])">
                <xsl:call-template name="quotedLetterWarning"/>
            </xsl:if>
        </xsl:if>
    </xsl:if>

    <xsl:call-template name="sectionSubsection"/>
    <xsl:apply-templates select="div4" mode="structure"/>
</xsl:template>

<xsl:template match="div4" mode="structure">
    <xsl:if test="@type='letter'">
        <xsl:if test="preceding-sibling::div4 or following-sibling::div4">
            <xsl:if test="not(preceding-sibling::div4[@type='letter']) and not(following-sibling::div4[@type='letter'])">
                <xsl:call-template name="quotedLetterWarning"/>
            </xsl:if>
        </xsl:if>
    </xsl:if>

    <xsl:call-template name="sectionSubsection"/>
    <xsl:apply-templates select="div5" mode="structure"/>
</xsl:template>

<xsl:template match="div5" mode="structure">
    <xsl:if test="@type='letter'">
        <xsl:if test="preceding-sibling::div5 or following-sibling::div5">
            <xsl:if test="not(preceding-sibling::div5[@type='letter']) and not(following-sibling::div5[@type='letter'])">
                <xsl:call-template name="quotedLetterWarning"/>
            </xsl:if>
        </xsl:if>
    </xsl:if>

    <xsl:call-template name="sectionSubsection"/>
    <xsl:apply-templates select="div6" mode="structure"/>
</xsl:template>

<xsl:template match="div6" mode="structure">
    <xsl:if test="@type='letter'">
        <xsl:if test="preceding-sibling::div6 or following-sibling::div6">
            <xsl:if test="not(preceding-sibling::div6[@type='letter']) and not(following-sibling::div6[@type='letter'])">
                <xsl:call-template name="quotedLetterWarning"/>
            </xsl:if>
        </xsl:if>
    </xsl:if>

    <xsl:call-template name="sectionSubsection"/>
    <xsl:apply-templates select="div7" mode="structure"/>
</xsl:template>

<xsl:template match="div7" mode="structure">
    <xsl:if test="@type='letter'">
        <xsl:if test="preceding-sibling::div7 or following-sibling::div7">
            <xsl:if test="not(preceding-sibling::div7[@type='letter']) and not(following-sibling::div7[@type='letter'])">
                <xsl:call-template name="quotedLetterWarning"/>
            </xsl:if>
        </xsl:if>
    </xsl:if>

    <xsl:call-template name="sectionSubsection"/>
</xsl:template>


<!-- HEADINGS -->

<xsl:template match="head" mode="structure">

    <!-- 'type' required when multiple <head> elements -->
    <xsl:if test="starts-with(local-name(..), 'div')">
        <xsl:if test="preceding-sibling::head or following-sibling::head">
            <xsl:if test="not(@type)">
                <xsl:call-template name="outputMsg">
                    <xsl:with-param name="msg">Attribute type required on &lt;head&gt; when more than one &lt;head&gt;.</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>

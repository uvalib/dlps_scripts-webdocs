<?xml version='1.0'?>

<!--

  qa_lib_misc.xsl - XSLT stylesheet for markup QA of TEI documents;
    checks miscellaneous general requirements not handled by the
    other qa_lib_*.xsl stylesheets

  Intended to be imported into another, primary stylesheet (namely
  qa_tei_html.xsl for HTML output or qa_tei_commandline.xsl for text
  output).

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2005-07-26
  Last modified: 2007-04-18

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="teiHeader" mode="misc"/>

    <xsl:template match="text" mode="misc">
        <xsl:apply-templates select="descendant::caesura" mode="misc"/>
        <xsl:apply-templates select="descendant::gap" mode="misc"/>
        <xsl:apply-templates select="descendant::hi" mode="misc"/>
        <xsl:apply-templates select="descendant::ornament" mode="misc"/>
        <xsl:apply-templates select="descendant::stage" mode="misc"/>
    </xsl:template>

    <!-- CAESURA -->
    <xsl:template match="caesura" mode="misc">
        <!-- allow <caesura> only within <l> -->
        <xsl:choose>
            <xsl:when test="ancestor::l"/>
            <xsl:otherwise>
                <xsl:call-template name="outputMsg">
                    <xsl:with-param name="msg">Element &lt;caesura/&gt; is allowed only within &lt;l&gt;</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- GAP -->
    <xsl:template match="gap" mode="misc">
        <!-- allow 'other' attribute only when reason="other" -->
        <xsl:if test="@other and not(@reason='other')">
            <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">Use of 'other' attribute is allowed only when reason="other"</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <!-- require 'other' attribute when reason="other" -->
        <xsl:if test="@reason='other' and not(@other)">
            <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">Attribute 'other' is required when reason="other"</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <!-- use of altRend should be limited to editorial omissions -->
        <xsl:if test="@altRend and not(@reason='editorial')">
            <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">Use of 'altRend' attribute is allowed only when reason="editorial".</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- HI -->
    <xsl:template match="hi" mode="misc">
        <!-- allow 'other' attribute only when rend="other" -->
        <xsl:if test="@other and not(@rend='other')">
            <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">Use of 'other' attribute is allowed only when rend="other".</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <!-- require 'other' attribute when rend="other" -->
        <xsl:if test="@rend='other' and not(@other)">
            <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">Attribute 'other' is required when rend="other"</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:variable name="rend" select="@rend"/>
        <xsl:if test="hi[@rend = $rend]">
            <xsl:call-template name="outputMsg">
                <xsl:with-param name="type">W</xsl:with-param>
                <xsl:with-param name="msg">&lt;hi&gt; contains another &lt;hi&gt; element with the same 'rend' attribute value ("<xsl:value-of select="$rend"/>").</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ORNAMENT -->
    <xsl:template match="ornament" mode="misc">
	<xsl:choose>
	    <xsl:when test="@type='characters'">
		<!-- must have content -->
		<xsl:if test="not( text() )">
		    <xsl:call-template name="outputMsg">
			<xsl:with-param name="msg">When &lt;ornament type="characters"&gt;, the element must have content (must not be empty).</xsl:with-param>
		    </xsl:call-template>
		</xsl:if>
	    </xsl:when>

	    <xsl:when test="@type='line' or @type='ornament'">
		<!-- must be empty -->
		<xsl:if test="not(normalize-space(.)='')">
		    <xsl:call-template name="outputMsg">
			<xsl:with-param name="msg">When &lt;ornament type="<xsl:value-of select='@type'/>"&gt;, the element must be empty.</xsl:with-param>
		    </xsl:call-template>
		</xsl:if>
	    </xsl:when>
	</xsl:choose>
    </xsl:template>

    <!-- STAGE -->
    <xsl:template match="stage" mode="misc">
        <!-- the DTD allows <stage> in <lg>, but this should occur only in the context of a <sp> (for verse drama) -->
        <xsl:if test="parent::lg">
            <xsl:choose>
                <xsl:when test="ancestor::sp"/>
                <xsl:otherwise>
                    <xsl:call-template name="outputMsg">
                        <xsl:with-param name="type">W</xsl:with-param>
                        <xsl:with-param name="msg">Element &lt;stage&gt; occurs in &lt;lg&gt; but is not inside a &lt;sp&gt;</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>

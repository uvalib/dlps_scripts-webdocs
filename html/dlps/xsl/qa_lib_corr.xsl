<?xml version='1.0'?>

<!--

  qa_lib_corr.xsl - XSLT stylesheet for markup QA of TEI elements and
    attributes related to corrections, additions, and deletions.

  Intended to be imported into another, primary stylesheet (namely
  qa_tei_html.xsl for HTML output or qa_tei_commandline.xsl for text
  output).

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2003-05-26
  Last modified: 2003-08-15

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="teiHeader" mode="corr"/>

<xsl:template match="text" mode="corr">
    <xsl:apply-templates select="descendant::corr" mode="corr"/>
    <xsl:apply-templates select="descendant::add" mode="corr"/>
    <xsl:apply-templates select="descendant::del" mode="corr"/>
    <xsl:apply-templates select="descendant::*[@resp]" mode="global_resp"/>
</xsl:template>


<xsl:template match="corr" mode="corr">

    <!-- 'sic' is required on <corr> unless correcting an error of omission (for which there's nothing to put in 'sic') -->
    <xsl:if test="not(@sic)">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="type">W</xsl:with-param>
            <xsl:with-param name="msg">&lt;corr&gt; element with no 'sic' attribute, but 'sic' is required unless correcting an error of omission (for which there is nothing to record in 'sic').</xsl:with-param>
        </xsl:call-template>
    </xsl:if>

    <!-- 'resp' is required on <corr> unless the corrector is unknown because you're converting existing markup -->
    <xsl:if test="not(@resp)">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="type">W</xsl:with-param>
            <xsl:with-param name="msg">&lt;corr&gt; element with no 'resp' attribute, but 'resp' is required unless you are converting existing markup for which the corrector is unknown.</xsl:with-param>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="addDel">
    <xsl:variable name="hand" select="@hand"/>

    <!-- value of 'hand' attribute must refer to an 'id' value on <hand> in TEI header
         (which goes beyond the DTD requirement that 'hand' is required and must be an IDREF) -->
    <xsl:if test="not(/TEI.2/teiHeader/profileDesc/handList/hand[@id=$hand])">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="type">E</xsl:with-param>
            <xsl:with-param name="msg">Value of 'hand' attribute (<xsl:value-of select="$hand"/>) has no corresponding &lt;hand&gt; declaration in teiHeader/profileDesc/handList.</xsl:with-param>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template match="add" mode="corr">
    <xsl:call-template name="addDel"/>

    <!-- <add> should not contain only <del> -->
    <xsl:if test="del">
        <xsl:if test="not( text() ) and not(*[local-name()!='del'])">
            <xsl:call-template name="outputMsg">
                <xsl:with-param name="type">W</xsl:with-param>
                <xsl:with-param name="msg">&lt;add&gt; contains only &lt;del&gt; element(s).</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:if>
</xsl:template>

<xsl:template match="del" mode="corr">
    <xsl:call-template name="addDel"/>
</xsl:template>

<xsl:template match="*" mode="global_resp">
    <xsl:variable name="resp" select="@resp"/>

    <!-- value of 'resp' attribute must correspond to value of an 'id' on any element within
         <teiHeader> (which goes beyond the DTD requirement that resp must be an IDREF) -->
    <xsl:if test="not(/TEI.2/teiHeader//*[@id=$resp])">
        <xsl:call-template name="outputMsg">
            <xsl:with-param name="type">W</xsl:with-param>
            <xsl:with-param name="msg">Value of 'resp' attribute (<xsl:value-of select="$resp"/>) has no corresponding responsibility declaration in &lt;teiHeader&gt;.</xsl:with-param>
        </xsl:call-template>
    </xsl:if>

</xsl:template>

</xsl:stylesheet>

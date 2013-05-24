<?xml version='1.0'?>

<!--

  qa_lib_tables.xsl - XSLT stylesheet for markup QA of TEI tables,
    lists, and block quotations.

  Intended to be imported into another, primary stylesheet (namely
  qa_tei_html.xsl for HTML output or qa_tei_commandline.xsl for text
  output).

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2003-05-28
  Last modified: 2004-12-13

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="teiHeader" mode="tables"/>

<xsl:template match="text" mode="tables">
    <xsl:apply-templates select="descendant::list|descendant::table|descendant::q" mode="tables"/>
</xsl:template>


<!-- LISTS -->

<xsl:template match="list" mode="tables">
    <xsl:apply-templates select="item" mode="tables"/>
</xsl:template>

<xsl:template match="item" mode="tables">
    <!-- list item content model is %specialPara; so test whether item contains both <p> and PCDATA -->
    <xsl:if test="p">
	<xsl:if test="text()">
	    <xsl:if test="normalize-space(text())!=''">
		<xsl:call-template name="outputMsg">
		    <xsl:with-param name="type">W</xsl:with-param>
		    <xsl:with-param name="msg">Mixed content: List item contains both &lt;p&gt; and character data, but normally should contain one or the other of these, not both.</xsl:with-param>
		</xsl:call-template>
	    </xsl:if>
	</xsl:if>
    </xsl:if>
</xsl:template>


<!-- TABLES -->

<xsl:template match="table" mode="tables">
    <!-- normally a table should not contain a column break (cb) -->
    <xsl:if test="cb">
        <xsl:variable name="parentDivInfo">
            <xsl:call-template name="getParentDivName"/>
            <xsl:text>: "</xsl:text>
            <xsl:call-template name="getParentDivHeading"/>
            <xsl:text>"</xsl:text>
        </xsl:variable>
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="type">W</xsl:with-param>
	    <xsl:with-param name="msg">Column break within table: &lt;table&gt; contains &lt;cb/&gt;. (See <xsl:value-of select="$parentDivInfo"/>)</xsl:with-param>
	</xsl:call-template>
    </xsl:if>

    <!-- because this stylesheet does not attempt to ensure consistent number of cells across all
         rows when <cell rows="..."> is used, warn (once) if 'rows' attribute is used (other than
         with the default value of 1) -->
    <xsl:if test="descendant::cell[@rows!='1']">
	<xsl:variable name="parentDivInfo">
	    <xsl:call-template name="getParentDivName"/>
	    <xsl:text>: "</xsl:text>
	    <xsl:call-template name="getParentDivHeading"/>
	    <xsl:text>"</xsl:text>
	</xsl:variable>
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="type">W</xsl:with-param>
	    <xsl:with-param name="msg">Use of 'rows' attribute on table cell(s). Visually check appearance of table in web browser. (See <xsl:value-of select="$parentDivInfo"/>)</xsl:with-param>
	</xsl:call-template>
    </xsl:if>

    <xsl:apply-templates select="row" mode="tables"/>
</xsl:template>

<xsl:template match="row" mode="tables">
    <!-- test that all rows contain the same numer of cells, whether literally or by spanning -->
    <xsl:choose>
	<xsl:when test="following-sibling::row">
	    <xsl:variable name="total" select="sum(cell/@cols)"/>
	    <xsl:variable name="comp" select="sum(following-sibling::row[1]/cell/@cols)"/>
	    <xsl:if test="$total != $comp">
		<!-- If this table makes use of <cell rows="..."> to make a cell span multiple rows,
                     don't warn about column discrepancy (since there may not actually be one at all);
                     instead, template for <table> above issues warning about use of 'rows' attribute. -->
		<xsl:if test="not(../descendant::cell[@rows!='1'])">
		    <xsl:call-template name="outputMsg">
			<xsl:with-param name="type">W</xsl:with-param>
			<xsl:with-param name="msg">Table column discrepancy: Current table row contains <xsl:value-of select="$total"/> cells, but following row contains <xsl:value-of select="$comp"/> cells.</xsl:with-param>
		    </xsl:call-template>
		</xsl:if>
	    </xsl:if>
	</xsl:when>
    </xsl:choose>

    <!-- normally a table row should not contain a column break (cb) -->
    <!-- this is now controlled at the DTD level
    <xsl:if test="cb">
        <xsl:variable name="parentDivInfo">
            <xsl:call-template name="getParentDivName"/>
            <xsl:text>: "</xsl:text>
            <xsl:call-template name="getParentDivHeading"/>
            <xsl:text>"</xsl:text>
        </xsl:variable>
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="type">W</xsl:with-param>
	    <xsl:with-param name="msg">Column break within table: &lt;row&gt; contains &lt;cb/&gt;. (See <xsl:value-of select="$parentDivInfo"/>)</xsl:with-param>
	</xsl:call-template>
    </xsl:if>
    -->

    <!-- a table row should not contain a page break (pb) -->
    <!-- this is now controlled at the DTD level
    <xsl:if test="pb">
        <xsl:variable name="parentDivInfo">
            <xsl:call-template name="getParentDivName"/>
            <xsl:text>: "</xsl:text>
            <xsl:call-template name="getParentDivHeading"/>
            <xsl:text>"</xsl:text>
        </xsl:variable>
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="type">E</xsl:with-param>
	    <xsl:with-param name="msg">Page break within table: &lt;row&gt; contains &lt;pb/&gt;. (See <xsl:value-of select="$parentDivInfo"/>)</xsl:with-param>
	</xsl:call-template>
    </xsl:if>
    -->

    <xsl:apply-templates select="cell" mode="tables"/>
</xsl:template>

<xsl:template match="cell" mode="tables">
    <!-- a table cell should not contain a column break (cb) -->
    <!-- this is now controlled at the DTD level
    <xsl:if test="cb">
        <xsl:variable name="parentDivInfo">
            <xsl:call-template name="getParentDivName"/>
            <xsl:text>: "</xsl:text>
            <xsl:call-template name="getParentDivHeading"/>
            <xsl:text>"</xsl:text>
        </xsl:variable>
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="type">W</xsl:with-param>
	    <xsl:with-param name="msg">Column break within table: &lt;cell&gt; contains &lt;cb/&gt;. (See <xsl:value-of select="$parentDivInfo"/>)</xsl:with-param>
	</xsl:call-template>
    </xsl:if>
    -->

    <!-- a table cell should not contain a page break (pb) -->
    <!-- this is now controlled at the DTD level
    <xsl:if test="pb">
        <xsl:variable name="parentDivInfo">
            <xsl:call-template name="getParentDivName"/>
            <xsl:text>: "</xsl:text>
            <xsl:call-template name="getParentDivHeading"/>
            <xsl:text>"</xsl:text>
        </xsl:variable>
	<xsl:call-template name="outputMsg">
	    <xsl:with-param name="type">E</xsl:with-param>
	    <xsl:with-param name="msg">Page break within table: &lt;cell&gt; contains &lt;pb/&gt;. (See <xsl:value-of select="$parentDivInfo"/>)</xsl:with-param>
	</xsl:call-template>
    </xsl:if>
    -->
</xsl:template>


<!-- BLOCK QUOTATIONS -->

<xsl:template match="q" mode="tables">
    <!-- q content model is %specialPara; so test whether q contains both block-level elements (p or lg) and PCDATA -->
    <xsl:if test="p or lg">
	<xsl:if test="text()">
	    <xsl:if test="normalize-space(text())!=''">
		<xsl:call-template name="outputMsg">
		    <xsl:with-param name="type">W</xsl:with-param>
		    <xsl:with-param name="msg">Mixed content: Quotation (&lt;q&gt;) contains both block-level element (&lt;p&gt; or &lt;lg&gt;) and character data, but normally should contain one or the other of these, not both.</xsl:with-param>
		</xsl:call-template>
	    </xsl:if>
	</xsl:if>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>

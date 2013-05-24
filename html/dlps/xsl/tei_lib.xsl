<?xml version="1.0" encoding="US-ASCII"?>

<!--

  tei_lib.xsl - Library of templates for transforming TEI XML to
      HTML. Intended to be imported into another, primary stylesheet.

  Greg Murray <gpm2a@virginia.edu>
  Written: 2003-05-09
  Last modified: 2006-04-10

  2004-08-02: gpm2a: Changed named template 'setRend' to test for
  rend="right" and rend="left" (in addition to rend="center").

  2005-01-26: gpm2a: Changed named for <hi> to allow for a few color
  values.

  2006-04-10: gpm2a: Added template for <ptr/> elements.

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- NAMED TEMPLATES -->

<xsl:template name="setRend">
    <xsl:choose>
	<xsl:when test="@rend='indent' or hi[@rend='indent']">
	    <xsl:attribute name="class">indent</xsl:attribute>
	</xsl:when>
	<xsl:when test="@rend='indent2' or hi[@rend='indent2']">
	    <xsl:attribute name="class">indent2</xsl:attribute>
	</xsl:when>
	<xsl:when test="@rend='indent3' or hi[@rend='indent3']">
	    <xsl:attribute name="class">indent3</xsl:attribute>
	</xsl:when>
	<xsl:when test="@rend='indent4' or hi[@rend='indent4']">
	    <xsl:attribute name="class">indent4</xsl:attribute>
	</xsl:when>
	<xsl:when test="@rend='indent5' or hi[@rend='indent5']">
	    <xsl:attribute name="class">indent5</xsl:attribute>
	</xsl:when>
	<xsl:when test="@rend='hang' or hi[@rend='hang']">
	    <xsl:choose>
		<xsl:when test="local-name()='cell'"/><!-- my CSS approach to hanging indentation doesn't work in td/th -->
		<xsl:otherwise>
		    <xsl:attribute name="class">hang</xsl:attribute>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
	<xsl:when test="@rend='center' or hi[@rend='center'][1]">
	    <xsl:attribute name="align">center</xsl:attribute>
	</xsl:when>
	<xsl:when test="@rend='right'">
	    <xsl:attribute name="align">right</xsl:attribute>
	</xsl:when>
	<xsl:when test="@rend='left'">
	    <xsl:attribute name="align">left</xsl:attribute>
	</xsl:when>

	<!-- colors -->
	<xsl:when test="@rend='green'">
	    <xsl:attribute name="style">color: green</xsl:attribute>
	</xsl:when>
	<xsl:when test="@rend='gray'">
	    <xsl:attribute name="style">color: gray</xsl:attribute>
	</xsl:when>
    </xsl:choose>
</xsl:template>

<xsl:template name="setHeadAlign">
    <xsl:choose>
	<xsl:when test="@rend='left' or hi[1][@rend='left']">
	    <xsl:attribute name="style">text-align: left;</xsl:attribute>
	</xsl:when>
	<xsl:when test="@rend='right' or hi[1][@rend='right']">
	    <xsl:attribute name="style">text-align: right;</xsl:attribute>
	</xsl:when>
	<xsl:when test="@rend='center' or hi[1][@rend='center']">
	    <xsl:attribute name="style">text-align: center;</xsl:attribute>
	</xsl:when>
	<!-- otherwise, use default, as specified in CSS stylesheet -->
    </xsl:choose>
</xsl:template>


<!-- HEADINGS -->

<xsl:template match="head">
    <xsl:choose>
	<xsl:when test="local-name(..)='div1'">
	    <xsl:choose>
		<xsl:when test="@type='sub'">
		    <h2><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h2>
		</xsl:when>
		<xsl:when test="@type='desc'">
		    <h3><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h3>
		</xsl:when>
		<xsl:otherwise>
		    <h1><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h1>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>

	<xsl:when test="local-name(..)='div2'">
	    <xsl:choose>
		<xsl:when test="@type='sub'">
		    <h3><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h3>
		</xsl:when>
		<xsl:when test="@type='desc'">
		    <h4><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h4>
		</xsl:when>
		<xsl:otherwise>
		    <h2><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h2>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>

	<xsl:when test="local-name(..)='div3'">
	    <xsl:choose>
		<xsl:when test="@type and @type!='main'">
		    <h4><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h4>
		</xsl:when>
		<xsl:otherwise>
		    <h3><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h3>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>

	<xsl:when test="local-name(..)='div4'">
	    <h4><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h4>
	</xsl:when>
	<xsl:when test="local-name(..)='div5'">
	    <h5><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h5>
	</xsl:when>
	<xsl:when test="local-name(..)='div6'">
	    <h6><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h6>
	</xsl:when>
	<xsl:when test="local-name(..)='div7'">
	    <h7><xsl:call-template name="setHeadAlign"/><xsl:apply-templates/></h7>
	</xsl:when>

	<xsl:when test="local-name(..)='figure'">
	    <br/><b><xsl:apply-templates/></b><br/>
	</xsl:when>

	<xsl:otherwise>
	    <p><xsl:call-template name="setHeadAlign"/><b><xsl:apply-templates/></b></p>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- TITLE PAGE ELEMENT TEMPLATES -->

<xsl:template match="titlePage">
    <div align="center">
	<xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="titlePart">
    <xsl:choose>
	<xsl:when test="@type='main'"><h1><xsl:apply-templates/></h1></xsl:when>
	<xsl:when test="@type='sub'"><h2><xsl:apply-templates/></h2></xsl:when>
	<xsl:otherwise><p><xsl:apply-templates/></p></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="byline|docEdition|docImprint">
    <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="pubPlace|publisher|docDate">
    <xsl:choose>
	<xsl:when test="local-name(following-sibling::*[1])='lb'">
	    <xsl:apply-templates/>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:apply-templates/><br/>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- BLOCK-LEVEL ELEMENT TEMPLATES -->

<xsl:template match="p">
    <xsl:choose>
	<xsl:when test="@rend='none'"/>
	<xsl:when test="local-name(..)='item' and not(preceding-sibling::p)">
	    <xsl:apply-templates/>
	</xsl:when>
	<xsl:when test="local-name(..)='note' and not(preceding-sibling::p)">
	    <xsl:apply-templates/>
	</xsl:when>
	<xsl:when test="local-name(..)='sp' and not(preceding-sibling::p)">
	    <xsl:apply-templates/>
	</xsl:when>
	<xsl:when test="local-name(..)='figure'">
	    <p align="center"><xsl:apply-templates/></p>
	</xsl:when>
	<xsl:otherwise>
	    <p>
		<xsl:call-template name="setRend"/>
		<xsl:apply-templates/>
	    </p>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="ab">
    <p>
	<xsl:call-template name="setRend"/>
	<xsl:apply-templates/>
    </p>
</xsl:template>

<xsl:template match="argument">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="lg">
    <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="l">
    <xsl:choose>
	<xsl:when test="@rend='indent'">
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:apply-templates/><br/>
	</xsl:when>
	<xsl:when test="@rend='indent2'">
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:apply-templates/><br/>
	</xsl:when>
	<xsl:when test="@rend='indent3'">
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:apply-templates/><br/>
	</xsl:when>
	<xsl:when test="@rend='indent4'">
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:apply-templates/><br/>
	</xsl:when>
	<xsl:when test="@rend='indent5'">
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text>
	    <xsl:apply-templates/><br/>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:apply-templates/><br/>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="q">
    <blockquote><xsl:apply-templates/></blockquote>
</xsl:template>

<xsl:template match="table">
    <xsl:apply-templates select="head"/>
    <table border="1" cellpadding="6">
	<xsl:apply-templates select="*[not(self::head)]"/>
    </table>
</xsl:template>

<xsl:template match="row">
    <tr><xsl:apply-templates/></tr>
</xsl:template>

<xsl:template match="cell">
    <xsl:choose>
	<xsl:when test="@role='label'">
	    <th>
		<xsl:call-template name="setRend"/>
		<xsl:if test="number(@cols) > 1">
		    <xsl:attribute name="colspan"><xsl:value-of select="@cols"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="number(@rows) > 1">
		    <xsl:attribute name="rowspan"><xsl:value-of select="@rows"/></xsl:attribute>
		</xsl:if>
		<xsl:choose>
		    <xsl:when test="descendant::text()">
			<xsl:apply-templates/>
		    </xsl:when>
		    <xsl:otherwise>
			<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
		    </xsl:otherwise>
		</xsl:choose>
	    </th>
	</xsl:when>
	<xsl:otherwise>
	    <td>
		<xsl:call-template name="setRend"/>
		<xsl:if test="@rend='center' or @rend='right'">
		    <xsl:attribute name="align"><xsl:value-of select="@rend"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="number(@cols) > 1">
		    <xsl:attribute name="colspan"><xsl:value-of select="@cols"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="number(@rows) > 1">
		    <xsl:attribute name="rowspan"><xsl:value-of select="@rows"/></xsl:attribute>
		</xsl:if>
		<xsl:choose>
		    <xsl:when test="descendant::text()">
			<xsl:apply-templates/>
		    </xsl:when>
		    <xsl:otherwise>
			<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
		    </xsl:otherwise>
		</xsl:choose>
	    </td>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="list">
    <xsl:apply-templates select="head"/>
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

<xsl:template match="label">
    <xsl:choose>
	<xsl:when test="following-sibling::item[1]//text()">
	    <!-- include em dash between label and item -->
	    <li>
		<xsl:call-template name="setRend"/>
		<b><xsl:apply-templates/></b><xsl:text disable-output-escaping="yes"> &amp;mdash; </xsl:text>
		<xsl:apply-templates select="following-sibling::item[1]"/>
		<xsl:if test="../@type='prose' and following-sibling::label"><br/><br/></xsl:if>
	    </li>
	</xsl:when>
	<xsl:otherwise>
	    <li>
		<xsl:call-template name="setRend"/>
		<b><xsl:apply-templates/></b>
		<xsl:apply-templates select="following-sibling::item[1]"/>
		<xsl:if test="../@type='prose' and following-sibling::label"><br/><br/></xsl:if>
	    </li>
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
		<xsl:call-template name="setRend"/>
		<xsl:apply-templates/>
		<xsl:if test="../@type='prose' and following-sibling::item"><br/><br/></xsl:if>
	    </li>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="sp">
    <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="stage">
    <xsl:choose>
	<xsl:when test="local-name(..)='sp' and not(position()=1)">
	    <!-- direct child of <sp>, not of a container like <p> or <l> -->
	    <p><xsl:apply-templates/></p>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:apply-templates/>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="dateline">
    <xsl:choose>
	<xsl:when test="@rend='left' or hi[1][@rend='left']">
	    <p><xsl:apply-templates/></p>
	</xsl:when>
	<xsl:when test="@rend='center' or hi[1][@rend='center']">
	    <p align="center"><xsl:apply-templates/></p>
	</xsl:when>
	<xsl:otherwise>
	    <p align="right"><xsl:apply-templates/></p>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="closer">
    <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="salute">
    <xsl:choose>
	<xsl:when test="local-name(..)='closer'">
	    <div class="salute_closer">
		<xsl:apply-templates/><br/>
	    </div>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:apply-templates/><br/>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="signed">
    <div class="signed">
	<xsl:apply-templates/><br/>
    </div>
</xsl:template>

<xsl:template match="trailer">
    <p align="center"><xsl:apply-templates/></p>
</xsl:template>


<!-- PHRASE-LEVEL ELEMENT TEMPLATES -->

<xsl:template match="term|title">
    <xsl:choose>
	<xsl:when test="ancestor::teiHeader">
	    <xsl:apply-templates/>
	</xsl:when>
	<xsl:otherwise>
	    <i><xsl:apply-templates/></i>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="emph">
    <em><xsl:apply-templates/></em>
</xsl:template>


<!-- HIGHLIGHTING -->

<xsl:template match="hi">
    <xsl:choose>
	<!-- typographic changes -->
        <xsl:when test="@rend='italic'"><i><xsl:apply-templates/></i></xsl:when>
        <xsl:when test="@rend='bold'"><b><xsl:apply-templates/></b></xsl:when>
        <xsl:when test="@rend='underline'"><u><xsl:apply-templates/></u></xsl:when>
        <xsl:when test="@rend='sub'"><sub><xsl:apply-templates/></sub></xsl:when>
        <xsl:when test="@rend='super' or @rend='sup'"><sup><xsl:apply-templates/></sup></xsl:when>

	<!-- colors -->
        <xsl:when test="@rend='green'"><span style="color:green"><xsl:apply-templates/></span></xsl:when>
        <xsl:when test="@rend='gray'"><span style="color:gray"><xsl:apply-templates/></span></xsl:when>

        <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- POINTERS -->

<xsl:template match="ptr">
    <xsl:variable name="target"><xsl:value-of select="@target"/></xsl:variable>
    <a>
	<xsl:attribute name="href">
	    <xsl:value-of select="concat('#', @target)"/>
	</xsl:attribute>

	<xsl:choose>
	    <xsl:when test="//*[@id=$target]/head">
		<xsl:value-of select="//*[@id=$target]/head"/>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:text>[untitled]</xsl:text>
	    </xsl:otherwise>
	</xsl:choose>
    </a>
</xsl:template>

<xsl:template match="xref">
    <a>
	<xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
	<xsl:if test="@type='external'">
	    <!-- link should open a new window; use '_blank' -->
	    <xsl:attribute name="target">_blank</xsl:attribute>
	</xsl:if>
	<xsl:apply-templates/>
    </a>
</xsl:template>


<!-- GAPS AND UNCLEARS -->

<xsl:template match="gap">
    <span class="gap">
	<xsl:choose>
	    <xsl:when test="@desc">
		<xsl:if test="@reason">
		    <xsl:attribute name="title">Reason for omission: <xsl:value-of select="@reason"/></xsl:attribute>
		</xsl:if>
		<xsl:text>[Omitted: </xsl:text>
		<xsl:choose>
		    <xsl:when test="@desc='chi'">
			<xsl:text>Chinese</xsl:text>
		    </xsl:when>
		    <xsl:otherwise>
			<xsl:value-of select="@desc"/>
		    </xsl:otherwise>
		</xsl:choose>
		<xsl:text>]</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:if test="@reason">
		    <xsl:attribute name="title">Reason for omission: <xsl:value-of select="@reason"/></xsl:attribute>
		</xsl:if>
		<xsl:text>[content omitted]</xsl:text>
	    </xsl:otherwise>
	</xsl:choose>
    </span>
</xsl:template>

<xsl:template match="unclear">
    <span class="unclear">
	<xsl:choose>
	    <xsl:when test="descendant::text()">
		<xsl:apply-templates/>
	    </xsl:when>
	    <xsl:otherwise>[illegible]</xsl:otherwise>
	</xsl:choose>
    </span>
</xsl:template>


<!-- BREAKS -->

<xsl:template match="lb">
    <xsl:param name="toc"/>
    <xsl:if test="not($toc)">
	<xsl:choose>
	    <xsl:when test="name(..)='l'">
		<!-- lb occurs within a line of verse -->
		<!-- <br/><xsl:text disable-output-escaping='yes'>&amp;nbsp; &amp;nbsp; &amp;nbsp;</xsl:text> -->
	    </xsl:when>
	    <xsl:otherwise>
		<br/>
	    </xsl:otherwise>
	</xsl:choose>
    </xsl:if>
</xsl:template>


<!-- ELEMENTS FOR TECHNICAL DOCUMENTATION -->
<!-- TODO: remove; these are now in teitech.xsl -->

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
	<xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
	<span>
	    <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
	    <xsl:call-template name="uc">
		<xsl:with-param name="string"><xsl:value-of select="@type"/></xsl:with-param>
	    </xsl:call-template>
	</span>
	<xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="gizmo">
    <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="replace">
    <i><xsl:apply-templates/></i>
</xsl:template>

</xsl:stylesheet>

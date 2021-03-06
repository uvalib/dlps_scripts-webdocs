<?xml version="1.0"?>

<!--

  scripts.xsl - Transforms a document conforming to scripts.dtd (for
    documentation of local processing scripts) to XHTML for web display

  Greg Murray <gpm2a@virginia.edu>
  Written: 2005-12-06
  Last modified: 2010-05-19

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon">

<!-- ============================== -->
<!-- OUTPUT                         -->
<!-- ============================== -->

<xsl:output method="xml"
  encoding="US-ASCII"
  omit-xml-declaration="yes"
  indent="yes"
  saxon:indent-spaces="2"
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
/>


<!-- ============================== -->
<!-- INPUT PARAMETERS               -->
<!-- ============================== -->

<xsl:param name="source"/><!-- name of (or path to) source XML file -->


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
XML file (conforming to scripts.dtd) from which this HTML file was derived</xsl:text>
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
--&gt;</xsl:text>
  <html xml:lang="en" lang="en">
    <head>
      <title><xsl:value-of select="scripts/scriptsHeader/title[@type='main']"/></title>
      <!--
      <link rel="stylesheet" type="text/css" href="http://pogo.lib.virginia.edu/dlps/css/scripts.css"/>
      -->
      <link rel="stylesheet" type="text/css" href="scripts.css"/>
    </head>
    <body>
      <h1><xsl:apply-templates select="scripts/scriptsHeader/title[@type='main']"/></h1>

      <xsl:if test="scripts/scriptsHeader/title[@type='sub']">
        <p class="heading"><xsl:apply-templates select="scripts/scriptsHeader/title[@type='sub']"/></p>
      </xsl:if>

      <h2>Overview</h2>
      <xsl:apply-templates select="scripts/scriptsHeader/summary"/>
      <hr/>

      <h2>Contents</h2>
      <ul>
        <!-- generate table of contents -->
        <xsl:apply-templates select="scripts/scriptsDoc/scriptsGroup" mode="toc"/>

        <li>Appendixes
          <ul>
            <li><a href="#indexScripts">Alphabetic Index of Scripts</a></li>
            <li><a href="#about">About This Documentation</a></li>
          </ul>
        </li>
      </ul>
      <hr/>


      <!-- process main document content -->
      <xsl:apply-templates select="scripts/scriptsDoc"/>
      <hr/>


      <!-- generate alphabetic index -->
      <h2 id="indexScripts">Alphabetic Index of Scripts</h2>
      <table class="index">
        <xsl:apply-templates select="//script" mode="index">
          <xsl:sort select="head"/>
        </xsl:apply-templates>
      </table>
      <hr/>

      <h2 id="about">About This Documentation</h2>
      <!-- process header -->
      <xsl:apply-templates select="scripts/scriptsHeader"/>
    </body>
  </html>
  <xsl:text>
</xsl:text>
</xsl:template>



<!-- ============================== -->
<!-- HEADER ELEMENTS                -->
<!-- ============================== -->

<xsl:template match="scriptsHeader">
  <table cellpadding="4" class="header">
    <xsl:for-each select="respStmt">
      <tr>
        <th><xsl:apply-templates select="resp"/>:</th>
        <td><xsl:apply-templates select="name"/></td>
      </tr>
    </xsl:for-each>

    <xsl:if test="revisionDesc">
      <tr>
        <th>Last modified:</th>
        <td><xsl:apply-templates select="revisionDesc/change[last()]/date"/></td>
      </tr>
      <tr>
        <th class="nowrap">Revision history:</th>
        <td>
          <xsl:for-each select="revisionDesc/change">
            <table cellpadding="4" class="normal" width="100%">
              <tr>
                <td class="label" width="5%">Date:</td>
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

<xsl:template match="changeEntry|date|name|resp|summary|title">
  <xsl:apply-templates/>
</xsl:template>


<!-- ============================== -->
<!-- TABLE OF CONTENTS              -->
<!-- ============================== -->

<xsl:template match="scriptsGroup" mode="toc">
  <li>
    <a>
      <xsl:attribute name="href"><xsl:value-of select="concat('#', @id)"/></xsl:attribute>
      <xsl:apply-templates select="head" mode="asIs"/>
    </a>
    <xsl:if test="scriptsGroup">
      <ul>
        <xsl:apply-templates select="scriptsGroup" mode="toc"/>
      </ul>
    </xsl:if>
  </li>
</xsl:template>


<!-- ============================== -->
<!-- ALPHABETIC INDEX OF SCRIPTS    -->
<!-- ============================== -->

<xsl:template match="script" mode="index">
  <tr>
    <th>
      <a>
        <xsl:attribute name="href"><xsl:value-of select="concat('#', @id)"/></xsl:attribute>
        <xsl:apply-templates select="head" mode="asIs"/>
      </a>
    </th>
    <td>
      <xsl:apply-templates select="desc" mode="asIs"/>
    </td>
  </tr>
</xsl:template>


<!-- ============================== -->
<!-- BODY ELEMENTS                  -->
<!-- ============================== -->

<xsl:template match="scriptsDoc">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="scriptsGroup">
  <xsl:apply-templates select="head"/>
  <xsl:apply-templates select="argument"/>

  <!-- list the practices in this group -->
  <xsl:if test="script">
    <ul class="synopsis">
      <xsl:for-each select="script">
        <li>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="concat('#', @id)"/></xsl:attribute>
            <xsl:apply-templates select="head" mode="asIs"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:if>

  <xsl:apply-templates select="scriptsGroup|script"/>

</xsl:template>

<xsl:template match="script">
  <table class="script" cellspacing="0">
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>

    <xsl:apply-templates select="head"/>
    <xsl:apply-templates select="desc"/>

    <tr>
      <th>User interface</th>
      <td>
        <xsl:choose>
          <xsl:when test="@interface='command-line'">
            <xsl:text>Command line</xsl:text>
          </xsl:when>
          <xsl:when test="@interface='web'">
            <xsl:text>Web browser</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@interface"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>

    <!-- process all elements except <head>, <desc> and <seeAlso> -->
    <xsl:apply-templates select="*[not(self::head|self::desc|self::seeAlso)]"/>

    <tr>
      <th>Language</th>
      <td>
        <xsl:choose>
          <xsl:when test="@language='PerlWin32'">Perl for Win32</xsl:when>
          <xsl:otherwise><xsl:value-of select="@language"/></xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>

    <tr>
      <th>Location</th>
      <td>
        <xsl:choose>
          <xsl:when test="@url">
            <table>
              <tr>
                <td class="label">Path:</td>
                <td><xsl:value-of select="@diskPath"/></td>
              </tr>
              <tr>
                <td class="label">URL:</td>
                <td>
                  <a>
                    <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
                    <xsl:value-of select="@url"/>
                  </a>
                </td>
              </tr>
            </table>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@diskPath"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>

    <xsl:apply-templates select="seeAlso"/>
  </table>
</xsl:template>

<xsl:template match="after">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::after">
    <!-- there is a following before/after pair; include <hr/> as separator -->
    <hr/>
  </xsl:if>
</xsl:template>

<xsl:template match="arg">
  <tr>
    <td class="nowrap" valign="top">
      <xsl:apply-templates select="argName"/>
      <xsl:choose>
        <xsl:when test="@required='yes'">
          <xsl:text> (required)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> (optional)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:apply-templates select="desc"/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="argName">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="args">
  <tr>
    <th>Input</th>
    <td>
      <table class="args">
        <tr>
          <td class="label">argument</td>
          <td class="label">description</td>
        </tr>
        <xsl:apply-templates/>
      </table>
    </td>
  </tr>
</xsl:template>

<xsl:template match="argument">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="before">
  <xsl:apply-templates/>
  <xsl:if test="not(following-sibling::before) and not(preceding-sibling::before)">
    <!-- this is the only <before> element; include <hr/> to separate before from after -->
    <hr/>
  </xsl:if>
</xsl:template>

<xsl:template match="beforeAfter">
  <tr>
    <th>XML Before and After</th>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="context">
  <tr>
    <th>Workflow context</th>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="default">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="desc" mode="asIs">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="desc">
  <xsl:choose>
    <xsl:when test="parent::script">
      <tr>
        <th>Description</th>
        <td><xsl:apply-templates/></td>
      </tr>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="eg">
  <xsl:choose>
    <xsl:when test="parent::option or parent::example">
      <code><xsl:apply-templates/></code>
    </xsl:when>
    <xsl:otherwise>
      <pre><xsl:apply-templates/></pre>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="examples">
  <tr>
    <th>Examples</th>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="example">
  <xsl:apply-templates select="eg"/>
  <xsl:if test="desc">
    <!-- include em dash between example and its description -->
    <!--<xsl:text disable-output-escaping="yes"> &amp;mdash; </xsl:text>-->
    <br/>
    <xsl:apply-templates select="desc"/>
  </xsl:if>
  <xsl:if test="following-sibling::example">
    <br/><br/>
  </xsl:if>
</xsl:template>

<xsl:template match="head" mode="asIs">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="head">
  <xsl:choose>
    <xsl:when test="parent::scriptsGroup">
      <xsl:variable name="c" select="count(ancestor::scriptsGroup)"/>
      <xsl:choose>
        <xsl:when test="$c = 1">
          <xsl:if test="parent::scriptsGroup[preceding-sibling::scriptsGroup]">
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

    <xsl:when test="parent::script">
      <tr>
        <td colspan="2" class="headrow">
          <table class="headrow">
            <tr>
              <!-- get heading for this practice -->
              <td class="headrow">
                <xsl:apply-templates/>
              </td>
              <td class="headrowGroupHeadings">
                <xsl:call-template name="formatGroupHeadings">
                  <xsl:with-param name="script" select="parent::script"/>
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

<xsl:template match="interaction">
  <tr>
    <th>Interaction with user</th>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="options">
  <tr>
    <th>Options</th>
    <td>
      <table class="options">
        <tr>
          <xsl:if test="optionGroup">
            <td></td>
          </xsl:if>
          <td class="label">option</td>
          <td class="label">usage</td>
          <td class="label">description</td>
          <xsl:if test="descendant::default">
            <td class="label">default</td>
          </xsl:if>
        </tr>
        <xsl:apply-templates select="optionGroup|option"/>
      </table>
      <xsl:apply-templates select="remarks"/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="optionGroup">
  <tr>
    <th class="flat"><xsl:apply-templates select="head"/><xsl:text>:</xsl:text></th>
    <td colspan="3" class="flat"></td>
  </tr>
  <xsl:apply-templates select="option"/>
</xsl:template>

<xsl:template match="option">
  <tr>
    <xsl:if test="parent::optionGroup">
      <td></td>
    </xsl:if>
    <td valign="top" class="nowrap">
      <xsl:value-of select="optionName"/>
      <xsl:if test="optionName/@expan">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="optionName/@expan"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </td>
    <td valign="top"><xsl:apply-templates select="usage"/></td>
    <td valign="top"><xsl:apply-templates select="desc"/></td>
    <xsl:if test="default or preceding-sibling::option/default or following-sibling::default">
      <td valign="top"><xsl:apply-templates select="default"/></td>
    </xsl:if>
  </tr>
</xsl:template>

<xsl:template match="output">
  <tr>
    <th>Output</th>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="remarks">
  <xsl:choose>
    <xsl:when test="parent::script">
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
  <tr>
    <th>See also</th>
    <td><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="tracksys">
  <tr>
    <th>Updates tracking system?</th>
    <td><!--Yes: --><xsl:apply-templates/></td>
  </tr>
</xsl:template>

<xsl:template match="usage">
  <xsl:choose>
    <xsl:when test="parent::script">
      <tr>
        <th>Usage</th>
        <td>
          <code><xsl:apply-templates/></code>
        </td>
      </tr>
    </xsl:when>
    <xsl:when test="parent::option">
      <span class="nowrap"><code><xsl:apply-templates/></code></span>
    </xsl:when>
    <xsl:otherwise>
      <code><xsl:apply-templates/></code>
    </xsl:otherwise>
  </xsl:choose>
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
    <xsl:when test="parent::remarks and ancestor::options">
      <p><xsl:apply-templates/></p>
    </xsl:when>
    <xsl:when test="(parent::changeEntry or parent::item or parent::output or parent::remarks) and ( not(preceding-sibling::p) )">
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

<!--
<xsl:template match="char">
  <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>;</xsl:text>
</xsl:template>
-->

<xsl:template match="code">
  <code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="att|command|datatype|filename|kw|optionMention|path">
  <span class="kw"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="emph|term">
  <i><b><xsl:apply-templates/></b></i>
</xsl:template>

<xsl:template match="gi|tag">
  <span class="kw">
    <xsl:text>&lt;</xsl:text><xsl:value-of select="."/>
    <xsl:if test="@rend='empty'"><xsl:text>/</xsl:text></xsl:if>
    <xsl:text>&gt;</xsl:text>
  </span>
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

<xsl:template match="replace">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="val">
  <span class="kw">
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
  <xsl:if test="parent::seeAlso and preceding-sibling::ptr">
    <!-- not first link within <seeAlso>; precede hyperlink with line break -->
    <br/>
  </xsl:if>

  <a>
    <xsl:if test="@type='external'">
      <!-- link should open a new window; use '_blank' -->
      <xsl:attribute name="target">_blank</xsl:attribute>
    </xsl:if>
    <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
    <xsl:apply-templates/>
  </a>
</xsl:template>


<!-- ============================== -->
<!-- NAMED TEMPLATES                -->
<!-- ============================== -->

<!-- Outputs the group and sub-group, formatted as "Main: Sub" -->
<xsl:template name="formatGroupHeadings">
  <xsl:param name="script"/> <!-- The <script> element for which to print group/sub-group -->

  <xsl:if test="$script/parent::scriptsGroup">
    <xsl:variable name="parentGroup" select="$script/parent::scriptsGroup"/>
    <!-- get heading of 'grandparent' grouping, if any -->
    <xsl:if test="$parentGroup/parent::scriptsGroup">
      <xsl:apply-templates select="$parentGroup/parent::scriptsGroup/head" mode="asIs"/>
      <xsl:text>: </xsl:text>
     </xsl:if>
    <!-- get heading of parent grouping -->
    <xsl:apply-templates select="$parentGroup/head" mode="asIs"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

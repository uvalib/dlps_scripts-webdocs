<?xml version='1.0'?>

<!--

  qa_globals.xsl - global variables and named templates supporting the
    main DLPS QA stylesheets

  Intended to be imported into another, primary stylesheet (namely
  qa_tei_html.xsl for HTML output or qa_tei_commandline.xsl for text
  output).

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2004-12-08
  Last modified: 2005-01-11

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon">


<!-- GLOBAL VARIABLES -->
<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>


<!-- NAMED TEMPLATES -->
<xsl:template name="outputMsg">
    <xsl:param name="type"/>
    <xsl:param name="msg"/>

    <xsl:choose>
        <xsl:when test="$type='I'">
            <xsl:if test="not($errorsOnly)">
                <xsl:call-template name="printLeader">
                    <xsl:with-param name="type">Info</xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="concat(normalize-space($msg), $newline)"/>
            </xsl:if>
        </xsl:when>

        <xsl:when test="$type='W'">
            <xsl:if test="not($errorsOnly)">
                <xsl:call-template name="printLeader">
                    <xsl:with-param name="type">WARNING</xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="concat(normalize-space($msg), $newline)"/>
            </xsl:if>
        </xsl:when>

        <xsl:otherwise>
            <xsl:call-template name="printLeader">
                <xsl:with-param name="type">ERROR</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="concat(normalize-space($msg), $newline)"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="printLeader">
    <xsl:param name="type"/>

    <!-- filename -->
    <xsl:if test="$filename != ''">
	<xsl:value-of select="concat($filename, ': ')"/>
    </xsl:if>

    <!-- line number -->
    <xsl:value-of select="concat(saxon:line-number(), ': ')"/>

    <!-- message type -->
    <xsl:value-of select="concat($type, ': ')"/>
</xsl:template>

<xsl:template name="getParentDivName">
    <xsl:choose>
	<xsl:when test="ancestor::div7"><xsl:text>div7</xsl:text></xsl:when>
	<xsl:when test="ancestor::div6"><xsl:text>div6</xsl:text></xsl:when>
	<xsl:when test="ancestor::div5"><xsl:text>div5</xsl:text></xsl:when>
	<xsl:when test="ancestor::div4"><xsl:text>div4</xsl:text></xsl:when>
	<xsl:when test="ancestor::div3"><xsl:text>div3</xsl:text></xsl:when>
	<xsl:when test="ancestor::div2"><xsl:text>div2</xsl:text></xsl:when>
	<xsl:when test="ancestor::div1"><xsl:text>div1</xsl:text></xsl:when>
	<xsl:otherwise><xsl:value-of select="local-name(..)"/></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="getParentDivHeading">
    <xsl:choose>
	<xsl:when test="ancestor::div7">
	    <xsl:choose>
		<xsl:when test="ancestor::div7/head">
		    <xsl:value-of select="ancestor::div7/head/text()"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:text>[untitled]</xsl:text>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
	<xsl:when test="ancestor::div6">
	    <xsl:choose>
		<xsl:when test="ancestor::div6/head">
		    <xsl:value-of select="ancestor::div6/head/text()"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:text>[untitled]</xsl:text>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
	<xsl:when test="ancestor::div5">
	    <xsl:choose>
		<xsl:when test="ancestor::div5/head">
		    <xsl:value-of select="ancestor::div5/head/text()"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:text>[untitled]</xsl:text>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
	<xsl:when test="ancestor::div4">
	    <xsl:choose>
		<xsl:when test="ancestor::div4/head">
		    <xsl:value-of select="ancestor::div4/head/text()"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:text>[untitled]</xsl:text>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
	<xsl:when test="ancestor::div3">
	    <xsl:choose>
		<xsl:when test="ancestor::div3/head">
		    <xsl:value-of select="ancestor::div3/head/text()"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:text>[untitled]</xsl:text>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
	<xsl:when test="ancestor::div2">
	    <xsl:choose>
		<xsl:when test="ancestor::div2/head">
		    <xsl:value-of select="ancestor::div2/head/text()"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:text>[untitled]</xsl:text>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
	<xsl:when test="ancestor::div1">
	    <xsl:choose>
		<xsl:when test="ancestor::div1/head">
		    <xsl:value-of select="ancestor::div1/head/text()"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:text>[untitled]</xsl:text>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:choose>
		<xsl:when test="../head">
		    <xsl:value-of select="../head"/>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:text>[untitled]</xsl:text>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>

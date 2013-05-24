<?xml version='1.0'?>

<!--

  qa_lib_empty.xsl - XSLT stylesheet for markup QA of TEI documents;
    checks for empty elements and empty attributes, and for use of
    rend="none".

  Intended to be imported into another, primary stylesheet (namely
  qa_tei_html.xsl for HTML output or qa_tei_commandline.xsl for text
  output).

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2003-05-22
  Last modified: 2008-01-17

  2007-01-04: gpm2a: Check <teiHeader> also (in addition to <text>).

  2007-01-30: gpm2a: Added <caesura/> to list of allowed empty elements.

  2008-01-17: gpm2a: Selling my soul in the name of migration. Allow
  (warning only) empty <date value=""> inside a migrated header, for
  cases (such as revisionDesc/change) where a date is required (in
  every version of TEI since the dawn of time) but the
  inherited/migrated data simply does not include a date.

  2010-02-25: gpm2a: Added <hand/> to list of allowed empty elements.

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="teiHeader" mode="empty">
        <xsl:apply-templates select="*" mode="empty"/>
    </xsl:template>

    <xsl:template match="text" mode="empty">
        <xsl:apply-templates select="*" mode="empty"/>
    </xsl:template>

    <xsl:template match="*" mode="empty">
        <!-- test whether this element is empty (has no child elements or text nodes; if text nodes, cannot resolve to whitespace only) -->
        <xsl:choose>
            <!-- test for child element(s) -->
            <xsl:when test="*"/>
            <!-- no child elements found; test for empty text nodes (no text nodes, or text nodes containing whitespace only) -->
            <xsl:when test="normalize-space(.)=''">
                <xsl:choose>
                    <!-- the following elements are expected or allowed to be empty -->
                    <xsl:when test="local-name()='lb'"/>
                    <xsl:when test="local-name()='pb'"/>
                    <xsl:when test="local-name()='cb'"/>
                    <xsl:when test="local-name()='cols'"/>
                    <xsl:when test="local-name()='milestone'"/>
                    <xsl:when test="local-name()='gap'"/>
                    <xsl:when test="local-name()='unclear'"/>
                    <xsl:when test="local-name()='ptr'"/>
                    <xsl:when test="local-name()='figure'"/>
                    <xsl:when test="local-name()='frontispiece'"/>
                    <xsl:when test="local-name()='cell'"/>
                    <xsl:when test="local-name()='ornament' and @type='ornament'"/>
                    <xsl:when test="local-name()='ornament' and @type='line'"/>
                    <xsl:when test="local-name()='ab' and @type='empty'"/>
                    <xsl:when test="local-name()='handShift'"/>
                    <xsl:when test="local-name()='hand'"/>
                    <xsl:when test="local-name()='caesura'"/>

                    <!-- the following elements need to generate an error (not just a warning) if empty -->
                    <xsl:when test="local-name()='head' or local-name()='figDesc'">
                        <xsl:call-template name="outputMsg">
                            <xsl:with-param name="msg">Element '<xsl:value-of select="local-name()"/>' is empty.</xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>

                    <!-- other empty elements generate a warning (not an error) -->
                    <xsl:otherwise>
                        <xsl:call-template name="outputMsg">
                            <xsl:with-param name="type">W</xsl:with-param>
                            <xsl:with-param name="msg">Element '<xsl:value-of select="local-name()"/>' is empty.</xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>

        <!-- test for empty attributes on this element -->
        <xsl:for-each select="@*">
            <xsl:if test="normalize-space(.)=''">
		<xsl:choose>
		    <xsl:when test="local-name()='to' and parent::dateRange">
			<!-- empty 'to' attribute value on <dateRange> needs just a warning -->
			<xsl:call-template name="outputMsg">
			    <xsl:with-param name="type">W</xsl:with-param>
			    <xsl:with-param name="msg">Attribute 'to' is empty for &lt;dateRange&gt;. This is allowed only for date ranges where the end date is unknown.</xsl:with-param>
			</xsl:call-template>
		    </xsl:when>
		    <xsl:when test="local-name()='value' and parent::date and ancestor::teiHeader[@type='migrated']">
			<!-- allow (warning only) empty <date value=""> in a migrated header, for cases (such as revisionDesc/change) where a date is required but the inherited/migrated data simply does not include a date -->
			<xsl:call-template name="outputMsg">
			    <xsl:with-param name="type">W</xsl:with-param>
			    <xsl:with-param name="msg">Attribute 'value' is empty for &lt;date&gt;.</xsl:with-param>
			</xsl:call-template>
		    </xsl:when>
		    <xsl:otherwise>
			<!-- otherwise, an empty attribute value is an error. -->
			<xsl:call-template name="outputMsg">
			    <xsl:with-param name="type">E</xsl:with-param>
			    <xsl:with-param name="msg">Attribute '<xsl:value-of select="local-name()"/>' is empty.</xsl:with-param>
			</xsl:call-template>
		    </xsl:otherwise>
		</xsl:choose>
            </xsl:if>
        </xsl:for-each>

        <!-- test for use of rend="none" on this element -->
        <xsl:if test="@rend='none'">
            <xsl:choose>
                <!-- in the case of <ab type="empty">, rend="none" is ok; otherwise, warn -->
                <xsl:when test="local-name()='ab' and @type='empty'"/>
                <xsl:otherwise>
                    <xsl:call-template name="outputMsg">
                        <xsl:with-param name="type">W</xsl:with-param>
                        <xsl:with-param name="msg">Use of rend="none" on element other than &lt;ab type="empty"&gt;.</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:apply-templates select="*" mode="empty"/>
    </xsl:template>
</xsl:stylesheet>

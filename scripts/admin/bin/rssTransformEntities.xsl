<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- This stylesheet performs an identity transform, copying its input
to output.  However, the output encoding is set to 'us-ascii' so that all
named character references will be output as Unicode numeric character
entities.  For example, &copy; becomes &#169; -->

<xsl:strip-space elements="*" />
<xsl:output method="xml" encoding="us-ascii"
     indent="yes" />

<xsl:template match="/">
   <xsl:apply-templates mode="copy" />
</xsl:template>

<xsl:template match="@*|node()" mode="copy">
   <xsl:copy>
      <xsl:apply-templates select="@*" mode="copy" />
      <xsl:apply-templates mode="copy" />
   </xsl:copy>
</xsl:template>

</xsl:stylesheet>

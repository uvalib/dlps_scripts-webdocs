<?xml version="1.0"?>

<!--

  strings.xsl - utility functions and named templates for string manipulation,
    case conversion, etc.

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  2004-06-07

-->

<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dlps="http://dlps.lib.virginia.edu/"
	exclude-result-prefixes="dlps">

<!-- ======================================================================= -->
<!-- GLOBAL VARIABLES                                                        -->
<!-- ======================================================================= -->

<xsl:variable name="newline">
	<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>


<!-- ======================================================================= -->
<!-- FUNCTIONS                                                               -->
<!-- ======================================================================= -->

<xsl:function name="dlps:getNumbers">
	<!-- removes non-digit characters from a string -->
	<xsl:param name="in"/>
	<xsl:sequence select="replace($in, '[^\d]', '')"/>
</xsl:function>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:function name="dlps:stripNewlines">
	<!-- removes carriage returns and/or newlines from a string -->
	<xsl:param name="in"/>
	<xsl:sequence select="replace($in, '[\r\n]', '')"/>
</xsl:function>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:function name="dlps:trim">
	<!-- removes leading and trailing whitespace from a string -->
	<xsl:param name="in"/>
	<xsl:variable name="v1" select="replace($in, '^\s+', '')"/>
	<xsl:sequence select="replace($v1, '\s+$', '')"/>
</xsl:function>


<!-- ======================================================================= -->
<!-- NAMED TEMPLATES                                                         -->
<!-- ======================================================================= -->

<!-- convert case -->
<xsl:template name="convertCase">
	<xsl:param name="toConvert"/>
	<xsl:param name="conversion"/>
	
	<xsl:choose>
		<xsl:when test="$conversion='lower'">
			<xsl:value-of select="translate($toConvert,$ucletters,$lcletters)"/>
		</xsl:when>
		<xsl:when test="$conversion='upper'">
			<xsl:value-of select="translate($toConvert,$lcletters,$ucletters)"/>
		</xsl:when>
		<xsl:when test="$conversion='proper'">
			<xsl:call-template name="convertProperCase">
				<xsl:with-param name="toConvert">
					<xsl:value-of select="translate($toConvert,$ucletters,$lcletters)"/>
				</xsl:with-param>
				<xsl:with-param name="isFirstWord">true</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$toConvert"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- convert to proper case; this is called by convertCase above; should not be called directly -->
<xsl:template name="convertProperCase">
	<xsl:param name="toConvert"/>
	<xsl:param name="isFirstWord">false</xsl:param>

	<!-- test whether input string is empty (end condition for recursion) -->
	<xsl:if test="string-length($toConvert) > 0">
		<!-- break string into two parts: first letter, and everything else -->
		<xsl:variable name="f" select="substring($toConvert, 1, 1)"/>
		<xsl:variable name="s" select="substring($toConvert, 2)"/>

		<!-- always convert first and last words, but otherwise exclude insignificant words from conversion -->
		<xsl:choose>
			<xsl:when test="$isFirstWord='true'">
				<!-- always convert first letter of first word -->
				<xsl:call-template name="convertCase">
					<xsl:with-param name="toConvert" select="$f"/>
					<xsl:with-param name="conversion">upper</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- determine whether this word is significant -->
				<xsl:choose>
					<xsl:when test="contains($s, ' ')">
						<xsl:variable name="word" select="concat( $f, substring-before($s, ' ') )"/>
						<xsl:choose>
							<xsl:when test="$word='a' or $word='against' or $word='an' or $word='and'
								or $word='as' or $word='between' or $word='but' or $word='by'
								or $word='for' or $word='from' or $word='in' or $word='nor'
								or $word='of' or $word='on' or $word='or' or $word='so' or $word='the'
								or $word='to' or $word='with' or $word='yet'">
								<!-- insignificant word; output without converting -->
								<xsl:value-of select="$f"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- significant word; convert -->
								<xsl:call-template name="convertCase">
									<xsl:with-param name="toConvert" select="$f"/>
									<xsl:with-param name="conversion">upper</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!-- no more words; always convert first letter of last word -->
						<xsl:call-template name="convertCase">
							<xsl:with-param name="toConvert" select="$f"/>
							<xsl:with-param name="conversion">upper</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

		<!-- determine whether to continue processing recursively -->
		<xsl:choose>
			<!-- if input string contains a space (word separator), output remainder of current
			     word, then call this template recursively to convert remaining words -->
			<xsl:when test="contains($s, ' ')">
				<xsl:value-of select="substring-before($s, ' ')"/>
				<xsl:text> </xsl:text>
				<xsl:call-template name="convertProperCase">
					<xsl:with-param name="toConvert" select="substring-after($s, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<!-- if no spaces (no more words), just output remainder of current word -->
			<xsl:otherwise>
				<xsl:value-of select="$s"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>

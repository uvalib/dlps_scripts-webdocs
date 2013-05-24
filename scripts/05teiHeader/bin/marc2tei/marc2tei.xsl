<?xml version="1.0"?>

<!--

  marc2tei.xsl - XSLT (2.0) stylesheet for transformation of MARC XML to TEI
    header XML (TEI P4)

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2004-06-07
  Last modified: 2007-01-16

  For info on MARC XML, see http://www.loc.gov/marc/marcxml.html
  For into on the TEI header, see http://www.tei-c.org/P4X/HD.html

  The stylesheet expects three parameters: the title control number
  (bibliographic record ID) of the Virgo/MARC record for which to produce a
  corresponding TEI header, the Virgo ID of the physical item, and the DLPS ID
  of the item.

  The stylesheet uses some Saxon extensions, so it should be processed using the
  Saxon XSLT processor.

  For info on Saxon, see http://saxon.sourceforge.net/

-->

<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:dlps="http://dlps.lib.virginia.edu/"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="dlps">

<!-- INCLUDES -->
<xsl:include href="strings.xsl"/>

<!-- OUTPUT -->
<!-- When the output encoding is US-ASCII, Saxon outputs non-ASCII characters
     from the input document as numeric character entities. This allows the
     output document to be readable by any text editor and therefore completely
     portable. Also, by specifying hexadecimal representation of numeric
     character entities we ensure that those numeric entities can be converted
     programmatically to named/mnemonic character entities without difficulty. -->
<xsl:output
	method="xml"
	encoding="US-ASCII"
	indent="yes"
	saxon:indent-spaces="0"
	saxon:character-representation="hex"/>

<!-- PARAMETERS -->
<xsl:param name="titleControl"/>
<xsl:param name="virgoID"/>
<xsl:param name="dlpsID"/>
<xsl:param name="standaloneHeader">false</xsl:param> <!-- true | false -->
<xsl:param name="imagesResp">DLPS</xsl:param>        <!-- DLPS | SpecialCollections | Apex | Acme | Heckman -->
<xsl:param name="vendor">Apex</xsl:param>            <!-- Apex | TechBooks -->
<xsl:param name="year">2007</xsl:param>
<xsl:param name="quiet">false</xsl:param>            <!-- true | false (controls whether warning messages are sent to standard out; error messages are always sent to standard out) -->


<!-- ======================================================================= -->
<!-- NAMED TEMPLATES                                                         -->
<!-- ======================================================================= -->

<xsl:template name="formatPersonalName">
	<!-- outputs name-related markup for authors and contributors; should be
	     called when current node is a <datafield> for author or contributor -->
	<xsl:variable name="tag"><xsl:value-of select="@tag"/></xsl:variable>

	<!-- subfield a: personal name (non-repeatable) -->
	<!-- if in form "last, first" then split into first and last name fields -->
	<xsl:if test="subfield[@code='a']">
		<xsl:variable name="a" select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/>
		<xsl:analyze-string select="$a" regex="^([^,]+), (.+)$">
			<xsl:matching-substring>
				<name n="{$tag}|a" type="last"><xsl:value-of select="regex-group(1)"/></name>
				<name n="{$tag}|a" type="first"><xsl:value-of select="regex-group(2)"/></name>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<name n="{$tag}|a" type="full"><xsl:value-of select="."/></name>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:if>

	<!-- subfield q: "Fuller form of name" - "A more complete form of the name contained in subfield $a." (non-repeatable) -->
	<xsl:if test="subfield[@code='q']">
		<name n="{$tag}|q" type="fuller-form"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='q']) )"/></name>
	</xsl:if>

	<!-- subfield b: numeration (e.g. "Jr.") (non-repeatable) -->
	<xsl:if test="subfield[@code='b']">
		<name n="{$tag}|b" type="number"><xsl:value-of select="dlps:trim(subfield[@code='b'])"/></name>
	</xsl:if>

	<!-- subfield c: title (e.g. "Sir") (repeatable) -->
	<!-- subfield c is repeatable, so loop through all -->
	<xsl:for-each select="subfield[@code='c']">
		<name n="{$tag}|c" type="title"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(.) )"/></name>
	</xsl:for-each>

	<!-- subfield d: dates (birth, death, flourishing, etc.) (non-repeatable) -->
	<!-- if in form of a range of years, use <dateRange>; otherwise use <date> -->
	<xsl:if test="subfield[@code='d']">
		<xsl:variable name="d" select="dlps:trimPunctuation( dlps:trim(subfield[@code='d']) )"/>
		<xsl:analyze-string select="$d" regex="^(\d{{4}})-(\d{{4}})$">
			<xsl:matching-substring>
				<dateRange n="{$tag}|d">
					<xsl:attribute name="from"><xsl:value-of select="regex-group(1)"/></xsl:attribute>
					<xsl:attribute name="to"><xsl:value-of select="regex-group(2)"/></xsl:attribute>
					<xsl:value-of select="."/>
				</dateRange>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<date n="{$tag}|d">
					<xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
					<xsl:value-of select="."/>
				</date>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:if>
</xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:template name="langUsage">
	<!-- get main language code from field 008, which is a fixed-width string where main language is a 3-char code starting at char 36 -->
	<xsl:variable name="mainLangCode" select="substring(controlfield[@tag='008'], 36, 3)"/>

	<langUsage>
		<!-- main language (008) -->
		<xsl:variable name="mainLangDesc" select="dlps:getLangDesc($mainLangCode)"/>
		<xsl:choose>
			<xsl:when test="$mainLangDesc = $mainLangCode">
				<xsl:value-of select="$newline"/>
				<xsl:comment> ATTN Cataloging: Unexpected language code; please supply language name </xsl:comment>
				<xsl:value-of select="$newline"/>
				<language n="008" id="{$mainLangCode}" usage="main">[<xsl:value-of select="$mainLangCode"/>]</language>
			</xsl:when>
			<xsl:otherwise>
				<language n="008" id="{$mainLangCode}" usage="main"><xsl:value-of select="$mainLangDesc"/></language>
			</xsl:otherwise>
		</xsl:choose>

		<!-- other languages (041) -->
		<xsl:apply-templates select="datafield[@tag='041']">
			<xsl:with-param name="mainLangCode"><xsl:value-of select="$mainLangCode"/></xsl:with-param>
		</xsl:apply-templates>
	</langUsage>
</xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:template name="testUnauthorized">
	<!-- tests whether the current node contains a "?" subfield, indicating
	     an unauthorized entry; if so, prints a comment to that effect -->
	<xsl:if test="subfield[@code='?']">
		<xsl:if test="matches(subfield[@code='?'], 'unauthorized', 'i')">
			<xsl:comment> ATTN Cataloging: Unauthorized </xsl:comment>
			<xsl:value-of select="$newline"/>
		</xsl:if>
	</xsl:if>
</xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:template name="volumeNumber">
	<!-- prints volume number, if any -->
	<xsl:if test="datafield[@tag='949'][subfield[@code='i']=$virgoID]/subfield[@code='v']">
		<!-- there's a datafield 949 indicating the volume number for this Virgo ID -->
		<xsl:variable name="volno" select="datafield[@tag='949'][subfield[@code='i']=$virgoID]/subfield[@code='v']"/>
		<xsl:analyze-string select="$volno" regex="^[vV]\.(.+)$">
			<xsl:matching-substring>
				<biblScope n="949|v" type="volume">
					<num>
						<xsl:attribute name="value"><xsl:value-of select="regex-group(1)"/></xsl:attribute>
						<xsl:text>Vol. </xsl:text>
						<xsl:value-of select="regex-group(1)"/>
					</num>
				</biblScope>
			</xsl:matching-substring>
		</xsl:analyze-string>
	</xsl:if>
</xsl:template>


<!-- ======================================================================= -->
<!-- FUNCTIONS                                                               -->
<!-- ======================================================================= -->

<xsl:function name="dlps:formatTitle">
	<xsl:param name="in"/>

	<!-- strip newlines -->
	<xsl:variable name="v1"><xsl:value-of select="dlps:stripNewlines($in)"/></xsl:variable>

	<!-- trim leading and trailing whitespace -->
	<xsl:variable name="v2"><xsl:value-of select="dlps:trim($v1)"/></xsl:variable>

	<!-- remove final / that sometimes occurs at end of title -->
	<xsl:sequence select="replace($v2, '\s*/$', '')"/>
</xsl:function>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:function name="dlps:getAlternateTitleType">
	<!-- returns value for 'type' attribute on <title> for MARC 246 (alternate title) -->
	<!-- if title type is not specified in 2nd indicator, defaults to "alternate" -->
	<xsl:param name="ind2"/>
	<xsl:choose>
		<xsl:when test="$ind2 = '0'">
			<xsl:sequence select="'portion'"/>
		</xsl:when>
		<xsl:when test="$ind2 = '1'">
			<xsl:sequence select="'parallel'"/>
		</xsl:when>
		<xsl:when test="$ind2 = '2'">
			<xsl:sequence select="'distinctive'"/>
		</xsl:when>
		<!-- 2nd indicator of "3" indicates "Other title"; skip this case (let it fall through to <xsl:otherwise>) -->
		<xsl:when test="$ind2 = '4'">
			<xsl:sequence select="'cover'"/>
		</xsl:when>
		<xsl:when test="$ind2 = '5'">
			<xsl:sequence select="'added-title-page'"/>
		</xsl:when>
		<xsl:when test="$ind2 = '6'">
			<xsl:sequence select="'caption'"/>
		</xsl:when>
		<xsl:when test="$ind2 = '7'">
			<xsl:sequence select="'running'"/>
		</xsl:when>
		<xsl:when test="$ind2 = '8'">
			<xsl:sequence select="'spine'"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:sequence select="'alternate'"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:function name="dlps:getLangDesc">
	<!-- if the input string is a known language code, returns the language description; otherwise returns the input string -->
	<xsl:param name="in"/>
	<xsl:choose>
		<!-- these are language codes for some common languages where code is same for both MARC and ISO 639-2 -->
		<xsl:when test="$in = 'ang'">
			<xsl:sequence select="'English, Old (ca. 450-1100)'"/>
		</xsl:when>
		<xsl:when test="$in = 'ara'">
			<xsl:sequence select="'Arabic'"/>
		</xsl:when>
		<xsl:when test="$in = 'chi'">
			<xsl:sequence select="'Chinese'"/>
		</xsl:when>
		<xsl:when test="$in = 'dan'">
			<xsl:sequence select="'Danish'"/>
		</xsl:when>
		<xsl:when test="$in = 'eng'">
			<xsl:sequence select="'English'"/>
		</xsl:when>
		<xsl:when test="$in = 'enm'">
			<xsl:sequence select="'English, Middle (1100-1500)'"/>
		</xsl:when>
		<xsl:when test="$in = 'fre'">
			<xsl:sequence select="'French'"/>
		</xsl:when>
		<xsl:when test="$in = 'frm'">
			<xsl:sequence select="'French, Middle (ca. 1400-1800)'"/>
		</xsl:when>
		<xsl:when test="$in = 'ger'">
			<xsl:sequence select="'German'"/>
		</xsl:when>
		<xsl:when test="$in = 'grc'">
			<xsl:sequence select="'Greek, Ancient (to 1453)'"/>
		</xsl:when>
		<xsl:when test="$in = 'gre'">
			<xsl:sequence select="'Greek, Modern (1453- )'"/>
		</xsl:when>
		<xsl:when test="$in = 'heb'">
			<xsl:sequence select="'Hebrew'"/>
		</xsl:when>
		<xsl:when test="$in = 'ita'">
			<xsl:sequence select="'Italian'"/>
		</xsl:when>
		<xsl:when test="$in = 'lat'">
			<xsl:sequence select="'Latin'"/>
		</xsl:when>
		<xsl:when test="$in = 'spa'">
			<xsl:sequence select="'Spanish'"/>
		</xsl:when>

		<xsl:otherwise>
			<xsl:sequence select="$in"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:function name="dlps:getLangUsage">
	<!-- returns a value for <language usage="..."> attribute, based on 041 subfield code -->
	<xsl:param name="in"/>
	<xsl:choose>
		<xsl:when test="$in = 'a'">
			<xsl:sequence select="'main'"/>
		</xsl:when>
		<xsl:when test="$in = 'b'">
			<xsl:sequence select="'summary/abstract'"/>
		</xsl:when>
		<xsl:when test="$in = 'd'">
			<xsl:sequence select="'sung/spoken'"/>
		</xsl:when>
		<xsl:when test="$in = 'e'">
			<xsl:sequence select="'libretto'"/>
		</xsl:when>
		<xsl:when test="$in = 'f'">
			<xsl:sequence select="'table of contents'"/>
		</xsl:when>
		<xsl:when test="$in = 'g'">
			<xsl:sequence select="'accompanying material'"/>
		</xsl:when>
		<xsl:when test="$in = 'h'">
			<xsl:sequence select="'translation'"/>
		</xsl:when>

		<xsl:otherwise>
			<xsl:sequence select="'other'"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:function name="dlps:getRelatedTitleType">
	<!-- returns value for 'type' attribute on <title> for related and uniform titles -->
	<xsl:param name="tag"/>
	<xsl:choose>
		<xsl:when test="$tag = '740'">
			<xsl:sequence select="'related'"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:sequence select="'uniform'"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:function name="dlps:getSortTitle">
	<!-- returns "sort" title - a title suitable for sorting purposes; removes nonfiling characters
	     and normalizes resulting string according to the NACO normalization rules at
	     http://www.loc.gov/catdir/pcc/naco/normrule.html#a -->
	<xsl:param name="in"/>
	<xsl:param name="nonfiling"/> <!-- number of nonfiling characters -->

	<!-- remove nonfiling characters, if any -->
	<xsl:variable name="v" select="substring($in, number($nonfiling) + 1)"/>

	<!-- DIACRITICS -->
	<!-- replace characters having diacritic marks with their ASCII equivalents -->
	<!-- what follows accounts for all characters in Unicode blocks Latin-1 Supplement and Latin Extended-A -->
	<xsl:variable name="v" select="translate($v, '&#xC0;&#xC1;&#xC2;&#xC3;&#xC4;&#xC5;&#x100;&#x102;&#x104;', 'AAAAAAAAAA')"/>
	<xsl:variable name="v" select="translate($v, '&#xE0;&#xE1;&#xE2;&#xE3;&#xE4;&#xE5;&#x101;&#x103;&#x105;', 'aaaaaaaaaa')"/>

	<xsl:variable name="v" select="translate($v, '&#xC7;&#x106;&#x108;&#x10A;&#x10C;', 'CCCCC')"/>
	<xsl:variable name="v" select="translate($v, '&#xE7;&#x107;&#x109;&#x10B;&#x10D;', 'ccccc')"/>

	<xsl:variable name="v" select="translate($v, '&#xD0;&#x10E;&#x110;', 'DDD')"/>
	<xsl:variable name="v" select="translate($v, '&#xF0;&#x10F;&#x111;', 'ddd')"/>

	<xsl:variable name="v" select="translate($v, '&#xC8;&#xC9;&#xCA;&#xCB;&#x112;&#x114;&#x116;&#x118;&#x11A;', 'EEEEEEEEEE')"/>
	<xsl:variable name="v" select="translate($v, '&#xE8;&#xE9;&#xEA;&#xEB;&#x113;&#x115;&#x117;&#x119;&#x11B;', 'eeeeeeeeee')"/>

	<xsl:variable name="v" select="translate($v, '&#x11C;&#x11E;&#x120;&#x122;', 'GGGG')"/>
	<xsl:variable name="v" select="translate($v, '&#x11D;&#x11F;&#x121;&#x123;', 'gggg')"/>

	<xsl:variable name="v" select="translate($v, '&#x124;&#x126;', 'HH')"/>
	<xsl:variable name="v" select="translate($v, '&#x125;&#x127;', 'hh')"/>

	<xsl:variable name="v" select="translate($v, '&#xCC;&#xCD;&#xCE;&#xCF;&#x128;&#x12A;&#x12C;&#x12E;&#x130;', 'IIIIIIIIII')"/>
	<xsl:variable name="v" select="translate($v, '&#xEC;&#xED;&#xEE;&#xEF;&#x129;&#x12B;&#x12D;&#x12F;&#x131;', 'iiiiiiiiii')"/>

	<xsl:variable name="v" select="translate($v, '&#x134;', 'J')"/>
	<xsl:variable name="v" select="translate($v, '&#x135;', 'j')"/>

	<xsl:variable name="v" select="translate($v, '&#x136;', 'K')"/>
	<xsl:variable name="v" select="translate($v, '&#x137;', 'k')"/>

	<xsl:variable name="v" select="translate($v, '&#x139;&#x13B;&#x13D;&#x13F;&#x141;', 'LLLLL')"/>
	<xsl:variable name="v" select="translate($v, '&#x13A;&#x13C;&#x13E;&#x140;&#x142;', 'lllll')"/>

	<xsl:variable name="v" select="translate($v, '&#xD1;&#x143;&#x145;&#x147;', 'NNNN')"/>
	<xsl:variable name="v" select="translate($v, '&#xF1;&#x144;&#x146;&#x148;&#x149;', 'nnnnn')"/>

	<xsl:variable name="v" select="translate($v, '&#xD2;&#xD3;&#xD4;&#xD5;&#xD6;&#xD8;&#x14C;&#x14E;&#x150;', 'OOOOOOOOOO')"/>
	<xsl:variable name="v" select="translate($v, '&#xF2;&#xF3;&#xF4;&#xF5;&#xF6;&#xF8;&#x14D;&#x14F;&#x151;', 'oooooooooo')"/>

	<xsl:variable name="v" select="translate($v, '&#x154;&#x156;&#x158;', 'RRR')"/>
	<xsl:variable name="v" select="translate($v, '&#x155;&#x157;&#x159;', 'rrr')"/>

	<xsl:variable name="v" select="translate($v, '&#x15A;&#x15C;&#x15E;&#x160;', 'SSSS')"/>
	<xsl:variable name="v" select="translate($v, '&#x15B;&#x15D;&#x15F;&#x161;', 'ssss')"/>

	<xsl:variable name="v" select="translate($v, '&#x162;&#x164;&#x166;', 'TTT')"/>
	<xsl:variable name="v" select="translate($v, '&#x163;&#x165;&#x167;', 'ttt')"/>

	<xsl:variable name="v" select="translate($v, '&#xD9;&#xDA;&#xDB;&#xDC;&#x168;&#x16A;&#x16C;&#x16E;&#x170;&#x172;', 'UUUUUUUUUU')"/>
	<xsl:variable name="v" select="translate($v, '&#xF9;&#xFA;&#xFB;&#xFC;&#x169;&#x16B;&#x16D;&#x16F;&#x171;&#x173;', 'uuuuuuuuuu')"/>

	<xsl:variable name="v" select="translate($v, '&#x174;', 'W')"/>
	<xsl:variable name="v" select="translate($v, '&#x175;', 'w')"/>

	<xsl:variable name="v" select="translate($v, '&#xDD;&#x176;&#x178;', 'YYY')"/>
	<xsl:variable name="v" select="translate($v, '&#xFD;&#xFF;&#x177;', 'yyy')"/>

	<xsl:variable name="v" select="translate($v, '&#x179;&#x17B;&#x17D;', 'ZZZ')"/>
	<xsl:variable name="v" select="translate($v, '&#x17A;&#x17C;&#x17E;', 'zzz')"/>

	<!-- LIGATURES -->
	<xsl:variable name="v" select="replace($v, '&#xC6;', 'AE')"/>
	<xsl:variable name="v" select="replace($v, '&#xE6;', 'ae')"/>

	<xsl:variable name="v" select="replace($v, '&#x132;', 'IJ')"/>
	<xsl:variable name="v" select="replace($v, '&#x133;', 'ij')"/>

	<xsl:variable name="v" select="replace($v, '&#x152;', 'OE')"/>
	<xsl:variable name="v" select="replace($v, '&#x153;', 'oe')"/>

	<!-- OTHER SPECIAL CHARACTERS -->
	<!-- Icelandic thorn -->
	<xsl:variable name="v" select="replace($v, '&#xDE;', 'TH')"/>
	<xsl:variable name="v" select="replace($v, '&#xFE;', 'th')"/>

	<!-- the following characters are not specifically included in the NACO normalization rules;
	     I am applying the spirit, not the letter, of the rules -->
	<xsl:variable name="v" select="replace($v, '&#xDF;', 'ss')"/>   <!-- German eszett, or sharp s, or sz ligature -->
	<xsl:variable name="v" select="translate($v, '&#x138;', 'k')"/> <!-- Greenlandic kra -->
	<xsl:variable name="v" select="translate($v, '&#x14A;', 'N')"/> <!-- capital eng -->
	<xsl:variable name="v" select="translate($v, '&#x14B;', 'n')"/> <!-- small eng -->
	<xsl:variable name="v" select="translate($v, '&#x17F;', 's')"/> <!-- long s -->

	<!-- also handle Greek alpha, beta, and gamma, since these are specifically mentioned by the NACO rules -->
	<xsl:variable name="v" select="translate($v, '&#x391;', 'A')"/>
	<xsl:variable name="v" select="translate($v, '&#x392;', 'B')"/>
	<xsl:variable name="v" select="translate($v, '&#x393;', 'G')"/>
	<xsl:variable name="v" select="translate($v, '&#x3B1;', 'a')"/>
	<xsl:variable name="v" select="translate($v, '&#x3B2;', 'b')"/>
	<xsl:variable name="v" select="translate($v, '&#x3B3;', 'g')"/>

	<!-- PUNCTUATION -->
	<!-- NACO rules specify replacing some punctuation characters with a space -->
	<xsl:variable name="quot"><xsl:text>&quot;</xsl:text></xsl:variable>
	<xsl:variable name="v" select="translate($v, $quot, '_')"/>
	<xsl:variable name="v" select="translate($v, '!()-{}&lt;&gt;:;.?&#xBF;&#xA1;/\@*%=&#xB1;&#x2228;&#x2260;&#xAE;&#x2117;&#xA9;$&#xA3;&#xB0;^_`~', '                                        ')"/>

	<!-- NACO rules specify replacing a "terminal comma" with a space -->
	<xsl:variable name="v" select="replace($v, ',(\s*)$', ' $1')"/>
	<!-- NACO rules specify retaining the first comma (unless it is a terminal comma) but replacing
	     each subsequent comma with a space -->
	<xsl:variable name="v" select="dlps:normalizeSortTitleCommas($v)"/>

	<!-- NACO rules specify deleting some punctuation characters -->
	<xsl:variable name="apos"><xsl:text>&apos;</xsl:text></xsl:variable>
	<xsl:variable name="v" select="translate($v, $apos, '')"/>
	<xsl:variable name="v" select="translate($v, '[]|', '')"/>

	<!-- WHITESPACE -->
	<!-- trim leading and trailing whitespace, and replace multiple whitespace characters with a single space character -->
	<xsl:variable name="v" select="normalize-space($v)"/>

	<!-- CASE -->
	<!-- covert to lower case -->
	<xsl:variable name="v">
		<xsl:call-template name="convertCase">
			<xsl:with-param name="toConvert" select="$v"/>
			<xsl:with-param name="conversion">lower</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:sequence select="$v"/>

</xsl:function>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:function name="dlps:normalizeSortTitleCommas">
	<!-- any comma, except the first one, is replaced by a space - in accordance with the NACO
	     normalization rules used by function dlps:getSortTitle(); called by dlps:getSortTitle() only -->
	<xsl:param name="in"/>
	<xsl:choose>
		<xsl:when test="matches($in, '(,[^,]*),')">
			<!-- replace second comma with a space -->
			<xsl:variable name="out" select="replace($in, '(,[^,]*),', '$1 ')"/>
			<!-- call this function recursively to continue replacing subsequent commas -->
			<xsl:sequence select="dlps:normalizeSortTitleCommas($out)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:sequence select="$in"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:function name="dlps:trimPunctuation">
	<!-- removes final comma, period, or semicolon from a string (except for certain cases) -->
	<xsl:param name="in"/>
	<xsl:choose>
		<xsl:when test="matches($in, '\s[A-Z]\.$')">
			<!-- string ends with an initial, as in 'John Q.'; do not remove final '.' -->
			<xsl:sequence select="$in"/>
		</xsl:when>
		<xsl:when test="matches($in, '\s[A-Z]\.[A-Z]\.$')">
			<!-- string ends with two initials, as in 'J.Q.'; do not remove final '.' -->
			<xsl:sequence select="$in"/>
		</xsl:when>
		<xsl:when test="matches($in, '\s(ed|co|ltd|inc)\.$', 'i') or matches($in, '^ed\.$', 'i')">
			<!-- string ends with a known abbreviation; do not remove final '.' -->
			<xsl:sequence select="$in"/>
		</xsl:when>
		<xsl:when test="matches($in, '\.\.\.$')">
			<!-- string ends with '...'; do not remove final '.' -->
			<xsl:sequence select="$in"/>
		</xsl:when>
		<xsl:otherwise>
			<!-- remove final comma, period, semicolon, or colon -->
			<xsl:sequence select="replace($in, '\s*[,\.;:]$', '')"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>


<!-- ======================================================================= -->
<!-- TOP-LEVEL TEMPLATE                                                      -->
<!-- ======================================================================= -->

<xsl:template match="/">
	<xsl:choose>
		<xsl:when test="boolean($titleControl)">
			<!-- title control number was passed as a parameter, so select <record> for this particular title control number -->
			<xsl:variable name="record" select="//record[datafield[@tag='910']/subfield[@code='a']=$titleControl]"/>
			<xsl:choose>
				<xsl:when test="boolean($record)">
					<xsl:apply-templates select="$record"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message><xsl:value-of select="concat('marc2tei.xsl: ERROR: No record found for title control number ', $titleControl)"/></xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<!-- title control number not provided; select first <record> element -->
			<xsl:if test="not($quiet = 'true')">
				<xsl:message>marc2tei.xsl: Warning: No title control number provided. Processing first record...</xsl:message>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="//record">
					<xsl:apply-templates select="//record[1]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>marc2tei.xsl: ERROR: No records found.</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="record">
	<xsl:choose>
		<xsl:when test="$standaloneHeader = 'true'">
			<xsl:call-template name="standaloneHeader"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="TEI.2"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- ======================================================================= -->
<!-- OUTPUT TEMPLATE FOR <TEI.2> DOCUMENT                                    -->
<!-- ======================================================================= -->

<xsl:template name="TEI.2">
	<!-- creates a <TEI.2> output document (as opposed to a <standaloneHeader> document) -->

	<!-- DOCTYPE declaration and internal subset -->
	<xsl:text disable-output-escaping="yes"><![CDATA[
<!DOCTYPE TEI.2 SYSTEM "http://text.lib.virginia.edu/dtd/tei/tei-p4/tei2.dtd" [
<!ENTITY % POSTKB "INCLUDE">
<!ENTITY % TEI.extensions.ent SYSTEM "http://text.lib.virginia.edu/dtd/tei/uva-dl-tei/uva-dl-tei.ent">
<!ENTITY % TEI.extensions.dtd SYSTEM "http://text.lib.virginia.edu/dtd/tei/uva-dl-tei/uva-dl-tei.dtd">

<!ENTITY % dlps-teiHeader SYSTEM "http://text.lib.virginia.edu/ent/dlps-teiHeader.ent"> %dlps-teiHeader;
<!ENTITY % ISOlat1 SYSTEM "http://text.lib.virginia.edu/charent/iso-lat1.ent"> %ISOlat1;
<!ENTITY % ISOlat2 SYSTEM "http://text.lib.virginia.edu/charent/iso-lat2.ent"> %ISOlat2;
<!ENTITY % ISOnum  SYSTEM "http://text.lib.virginia.edu/charent/iso-num.ent">  %ISOnum;
<!ENTITY % ISOpub  SYSTEM "http://text.lib.virginia.edu/charent/iso-pub.ent">  %ISOpub;
<!ENTITY % ISOtech SYSTEM "http://text.lib.virginia.edu/charent/iso-tech.ent"> %ISOtech;
<!ENTITY % UVAsupp SYSTEM "http://text.lib.virginia.edu/charent/uva-supp.ent"> %UVAsupp;
]>
]]></xsl:text>

	<TEI.2>
		<!-- output TEI header -->
		<xsl:call-template name="teiHeader"/>

		<!-- output minimal body for parsing purposes -->
		<text>
		<body>
		<div1 type="section">
		<ab type="empty" rend="none"/>
		</div1>
		</body>
		</text>
	</TEI.2>
	<xsl:value-of select="$newline"/>
</xsl:template>


<!-- ======================================================================= -->
<!-- OUTPUT TEMPLATE FOR <standaloneHeader> DOCUMENT                         -->
<!-- ======================================================================= -->

<xsl:template name="standaloneHeader">
	<!-- creates a <standaloneHeader> output document (as opposed to a <TEI.2> document) -->

	<!-- DOCTYPE declaration and internal subset -->
	<xsl:text disable-output-escaping="yes"><![CDATA[
<!DOCTYPE standaloneHeader SYSTEM "http://text.lib.virginia.edu/dtd/tei/tei-p4/tei2.dtd" [
<!ENTITY % STANDALONE_HEADER "INCLUDE">
<!ENTITY % POSTKB "INCLUDE">
<!ENTITY % TEI.extensions.ent SYSTEM "http://text.lib.virginia.edu/dtd/tei/uva-dl-tei/uva-dl-tei.ent">
<!ENTITY % TEI.extensions.dtd SYSTEM "http://text.lib.virginia.edu/dtd/tei/uva-dl-tei/uva-dl-tei.dtd">

<!ENTITY % dlps-teiHeader SYSTEM "http://text.lib.virginia.edu/ent/dlps-teiHeader.ent"> %dlps-teiHeader;
<!ENTITY % ISOlat1 SYSTEM "http://text.lib.virginia.edu/charent/iso-lat1.ent"> %ISOlat1;
<!ENTITY % ISOlat2 SYSTEM "http://text.lib.virginia.edu/charent/iso-lat2.ent"> %ISOlat2;
<!ENTITY % ISOnum  SYSTEM "http://text.lib.virginia.edu/charent/iso-num.ent">  %ISOnum;
<!ENTITY % ISOpub  SYSTEM "http://text.lib.virginia.edu/charent/iso-pub.ent">  %ISOpub;
<!ENTITY % ISOtech SYSTEM "http://text.lib.virginia.edu/charent/iso-tech.ent"> %ISOtech;
<!ENTITY % UVAsupp SYSTEM "http://text.lib.virginia.edu/charent/uva-supp.ent"> %UVAsupp;
]>
]]></xsl:text>

	<standaloneHeader>
		<!-- output TEI header -->
		<xsl:call-template name="teiHeader"/>
	</standaloneHeader>
	<xsl:value-of select="$newline"/>
</xsl:template>


<!-- ======================================================================= -->
<!-- MAIN OUTPUT TEMPLATE                                                    -->
<!-- ======================================================================= -->

<xsl:template name="teiHeader">
	<!-- set up some global variables for this template -->
	<!-- for 6xx fields, a 2nd indicator of '0' (zero) indicates Library of Congress Subject Headings -->
	<xsl:variable name="LCSH" select="datafield[@ind2='0'][@tag='600' or @tag='610' or @tag='611' or @tag='630' or @tag='648' or @tag='650' or @tag='651' or @tag='653' or @tag='654' or @tag='655' or @tag='656' or @tag='657' or @tag='658']"/>

	<!-- for 6xx fields, a 2nd indicator of '2' indicates Medical Subject Headings (MESH) -->
	<xsl:variable name="MESH" select="datafield[@ind2='2'][@tag='600' or @tag='610' or @tag='611' or @tag='630' or @tag='648' or @tag='650' or @tag='651' or @tag='653' or @tag='654' or @tag='655' or @tag='656' or @tag='657' or @tag='658']"/>

	<!-- for 6xx fields, a 2nd indicator of '7' indicates that the source is specified in subfield 2;
	     here we're looking for 'gsafd' in 655 -->
	<xsl:variable name="gsafd" select="datafield[@ind2='7'][subfield[@code='2']='gsafd'][@tag='655']"/>

	<!-- we're mapping 75x fields as "other" keyword terms -->
	<xsl:variable name="other75x" select="datafield[@tag='752' or @tag='753' or @tag='754' or @tag='755']"/>

<teiHeader type="AACR2">
<fileDesc>
<titleStmt>
	<!-- title for electronic text (245) -->
	<xsl:apply-templates select="datafield[@tag='245']" mode="title245"/>

	<!-- statement of responsibility (245 c) -->
	<xsl:apply-templates select="datafield[@tag='245']" mode="resp245"/>

	<!-- author(s) (100) -->
	<xsl:apply-templates select="datafield[@tag='100' or @tag='110' or @tag='111']"/>

	<!-- responsibility for images -->
	<xsl:value-of select="$newline"/>
	<xsl:choose>
		<xsl:when test="matches($imagesResp, 'Special ?Collections', 'i')">
			<xsl:text disable-output-escaping="yes">&amp;resp_images_sc;</xsl:text>
		</xsl:when>
		<xsl:when test="matches($imagesResp, 'Apex', 'i')">
			<xsl:text disable-output-escaping="yes">&amp;resp_images_Apex;</xsl:text>
		</xsl:when>
		<xsl:when test="matches($imagesResp, 'Acme', 'i')">
			<xsl:text disable-output-escaping="yes">&amp;resp_images_acme;</xsl:text>
		</xsl:when>
		<xsl:when test="matches($imagesResp, 'Heckman', 'i')">
			<xsl:text disable-output-escaping="yes">&amp;resp_images_heckman;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text disable-output-escaping="yes">&amp;resp_images_dlps;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="$newline"/>

	<!-- responsibility for transcription -->
	<xsl:choose>
		<xsl:when test="matches($imagesResp, 'Special ?Collections', 'i')">
			<!-- assume this is a non-transcription item -->
		</xsl:when>
		<xsl:otherwise>
			<!-- &resp_transcription_Apex; -->
			<xsl:text disable-output-escaping="yes">&amp;resp_transcription_</xsl:text>
			<xsl:value-of select="$vendor"/>
			<xsl:text>;</xsl:text><xsl:value-of select="$newline"/>

			<!-- &resp_markup1_Apex; -->
			<xsl:text disable-output-escaping="yes">&amp;resp_markup1_</xsl:text>
			<xsl:value-of select="$vendor"/>
			<xsl:text>;</xsl:text><xsl:value-of select="$newline"/>

			<!-- &resp_markup2_Apex2DLPS; -->
			<xsl:text disable-output-escaping="yes">&amp;resp_markup2_</xsl:text>
			<xsl:value-of select="$vendor"/>
			<xsl:text>2DLPS;</xsl:text><xsl:value-of select="$newline"/>
		</xsl:otherwise>
	</xsl:choose>

	<xsl:if test="not($standaloneHeader = 'true')">
		<!-- indicate volume number, if any -->
		<xsl:call-template name="volumeNumber"/>
	</xsl:if>
</titleStmt>

<xsl:if test="not($standaloneHeader = 'true')">
	<!-- add extent placeholder -->
	<extent>? kilobytes</extent>
</xsl:if>

<publicationStmt>
	<!-- publisher of electronic text -->
	<publisher>University of Virginia Library</publisher>
	<pubPlace>Charlottesville, Virginia</pubPlace>
	<date value="{$year}"><xsl:value-of select="$year"/></date>

	<availability status="public">
		<p n="copyright">Copyright <xsl:text disable-output-escaping="yes">&amp;copy; </xsl:text>
		<xsl:value-of select="$year"/> by the Rector and Visitors of the University of Virginia</p>
		<p n="access">Publicly accessible</p>
	</availability>

	<!-- ID for electronic text (DLPS ID) -->
	<xsl:if test="not($standaloneHeader = 'true')">
		<idno type="DLPS ID">
			<xsl:choose>
				<xsl:when test="boolean($dlpsID)">
					<xsl:value-of select="$dlpsID"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not($quiet = 'true')">
						<xsl:message>marc2tei.xsl: Warning: No DLPS ID provided</xsl:message>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</idno>
	</xsl:if>
</publicationStmt>
<seriesStmt>
	<title>University of Virginia Library, Text collection</title>
	<idno type="uva-set">UVA-LIB-Text</idno>
</seriesStmt>
<xsl:value-of select="$newline"/>
<xsl:value-of select="$newline"/>

<sourceDesc>
<biblFull>
<titleStmt>
	<!-- title for print source (245) -->
	<xsl:apply-templates select="datafield[@tag='245']" mode="title245"/>

	<!-- related and uniform titles (various fields) -->
	<xsl:apply-templates select="datafield[@tag='130' or @tag='240' or @tag='730' or @tag='740']"/>

	<!-- alternate titles (246) -->
	<xsl:apply-templates select="datafield[@tag='246']"/>

	<!-- former titles (247) -->
	<xsl:apply-templates select="datafield[@tag='247']"/>

	<!-- statement of responsibility (245 c) -->
	<xsl:apply-templates select="datafield[@tag='245']" mode="resp245"/>

	<!-- author(s) (100) -->
	<xsl:apply-templates select="datafield[@tag='100' or @tag='110' or @tag='111']"/>

	<!-- editors and other contributors (700) -->
	<xsl:apply-templates select="datafield[@tag='700' or @tag='710' or @tag='711']"/>

	<xsl:if test="not($standaloneHeader = 'true')">
		<!-- indicate volume number, if any -->
		<xsl:call-template name="volumeNumber"/>
	</xsl:if>
</titleStmt>

<!-- edition statement for the print source (250) -->
<xsl:apply-templates select="datafield[@tag='250']"/>

<!-- extent (physical dimensions, page length, etc.) for the print source (300) -->
<xsl:apply-templates select="datafield[@tag='300']"/>
<!-- additional extent field for music (playing time, for a sound recording or the stated duration of performance of printed or manuscript music) (306) -->
<xsl:apply-templates select="datafield[@tag='306']"/>

<publicationStmt>
	<!-- publication (260) -->
	<xsl:apply-templates select="datafield[@tag='260']"/>

	<!-- LC call numbers (050 and 090) -->
	<xsl:apply-templates select="datafield[@tag='050']"/>
	<xsl:apply-templates select="datafield[@tag='090']"/>

	<!-- UVa call numbers (099) -->
	<xsl:apply-templates select="datafield[@tag='099']"/>

	<!-- ID numbers for the print source -->
	<idno type="UVa Virgo ID">
		<xsl:choose>
			<xsl:when test="boolean($virgoID)">
				<xsl:value-of select="$virgoID"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not($quiet = 'true')">
					<xsl:message>marc2tei.xsl: Warning: No Virgo ID provided</xsl:message>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</idno>
	<idno type="UVa Title Control Number"><xsl:value-of select="datafield[@tag='910']/subfield[@code='a']"/></idno>
	<!-- publisher ID number for printed music, sound recordings, etc. -->
	<xsl:apply-templates select="datafield[@tag='028']"/>
</publicationStmt>

<!-- series statement, if any (440 or 830) -->
<xsl:apply-templates select="datafield[@tag='440' or @tag='830']"/>

<!-- notes (500, etc.) -->
<xsl:variable name="notes" select="datafield[@tag='490' or @tag='500' or @tag='501' or @tag='502' or @tag='504' or @tag='505' or @tag='506' or @tag='507' or @tag='508' or @tag='510' or @tag='511' or @tag='513' or @tag='514' or @tag='515' or @tag='516' or @tag='518' or @tag='520' or @tag='521' or @tag='522' or @tag='524' or @tag='525' or @tag='526' or @tag='530' or @tag='533' or @tag='534' or @tag='535' or @tag='536' or @tag='538' or @tag='540' or @tag='541' or @tag='544' or @tag='545' or @tag='546' or @tag='547' or @tag='550' or @tag='552' or @tag='555' or @tag='556' or @tag='561' or @tag='562' or @tag='563' or @tag='565' or @tag='567' or @tag='580' or @tag='581' or @tag='583' or @tag='584' or @tag='585' or @tag='586' or @tag='590' or @tag='599']"/>
<xsl:variable name="musicPresentation" select="datafield[@tag='254']"/>
<xsl:variable name="musicCodes" select="datafield[@tag='047' or @tag='048']"/>
<xsl:if test="$notes or $musicPresentation or $musicCodes">
	<notesStmt>
		<xsl:apply-templates select="$notes"/>
		<xsl:apply-templates select="$musicPresentation"/>
		<xsl:apply-templates select="$musicCodes"/>
	</notesStmt>
</xsl:if>

</biblFull>
</sourceDesc>
</fileDesc>
<xsl:value-of select="$newline"/>
<xsl:value-of select="$newline"/>

<encodingDesc>
<xsl:text disable-output-escaping="yes">
&amp;projectDesc;
</xsl:text>
<editorialDecl>
<xsl:text disable-output-escaping="yes">
&amp;editorial_correction;
&amp;editorial_normalization;
&amp;editorial_hyphenation;
&amp;editorial_quotation;
&amp;editorial_stdVals;
</xsl:text>
</editorialDecl>
<classDecl>

<xsl:if test="$LCSH">
	<taxonomy id="LCSH"><bibl>Library of Congress Subject Headings</bibl></taxonomy>
</xsl:if>

<xsl:if test="$MESH">
	<taxonomy id="MESH"><bibl>Medical Subject Headings</bibl></taxonomy>
</xsl:if>

<xsl:if test="$gsafd">
	<taxonomy id="gsafd"><bibl>Guidelines on Subject Access to Individual Works of Fiction, Drama, Etc.</bibl></taxonomy>
</xsl:if>

<xsl:if test="$other75x">
	<taxonomy id="Other"><bibl>Other keyword terms</bibl></taxonomy>
</xsl:if>

<taxonomy id="uva-form"><bibl>UVa Library Form Categories</bibl></taxonomy>
</classDecl>
</encodingDesc>

<profileDesc>
<!-- creation date -->
<xsl:apply-templates select="datafield[@tag='045']"/>

<!-- language usage -->
<xsl:call-template name="langUsage"/>

<textClass>
<!-- subject terms -->
<xsl:if test="$LCSH">
	<keywords scheme="LCSH">
		<xsl:apply-templates select="$LCSH"/>
	</keywords>
</xsl:if>
<xsl:if test="$MESH">
	<keywords scheme="MESH">
		<xsl:apply-templates select="$MESH"/>
	</keywords>
</xsl:if>
<xsl:if test="$gsafd">
	<keywords scheme="gsafd">
		<xsl:apply-templates select="$gsafd"/>
	</keywords>
</xsl:if>
<xsl:if test="$other75x">
	<keywords scheme="Other">
		<xsl:apply-templates select="$other75x"/>
	</keywords>
</xsl:if>

<!-- UVa Library keywords -->
<keywords scheme="uva-form">
	<xsl:choose>
		<xsl:when test="$standaloneHeader = 'true'">
			<term>monographic set</term>
			<xsl:comment> ATTN Cataloging: If not a monographic set, change as appropriate: monographic set, newspaper, periodical, serial</xsl:comment>
			<xsl:value-of select="$newline"/>
		</xsl:when>
		<xsl:otherwise>
			<term>monograph</term>
			<xsl:comment> ATTN Cataloging: If not a monograph, change as appropriate: article, manuscript, monograph, monographic volume, newspaper issue, periodical issue, periodical volume, serial volume </xsl:comment>
			<xsl:value-of select="$newline"/>
		</xsl:otherwise>
	</xsl:choose>
</keywords>
</textClass>
</profileDesc>
</teiHeader>
</xsl:template>


<!-- ======================================================================= -->
<!-- NUMBER AND CODE FIELDS                                                  -->
<!-- ======================================================================= -->

<!-- 028: publisher number for printed music, sound recordings, etc. -->
<xsl:template match="datafield[@tag='028']">
	<xsl:if test="subfield[@code='a']">
		<xsl:choose>
			<xsl:when test="subfield[@code='b']">
				<idno n="028">
					<xsl:attribute name="type"><xsl:value-of select="dlps:trim(subfield[@code='b'])"/><xsl:text> number</xsl:text></xsl:attribute>
					<xsl:value-of select="dlps:trim(subfield[@code='a'])"/>
				</idno>
			</xsl:when>
			<xsl:otherwise>
				<idno n="028" type="publisher number">
					<xsl:value-of select="dlps:trim(subfield[@code='a'])"/>
				</idno>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<!-- 045: time period of content (creation date) -->
<xsl:template match="datafield[@tag='045']">
	<xsl:if test="subfield[@code='b']">
		<!-- value should be "c" (B.C.) or "d" (C.E.) followed by digits, the first four digits indicating the year -->
		<xsl:analyze-string select="subfield[@code='b']" regex="^([cd])(\d\d\d\d)">
			<xsl:matching-substring>
				<xsl:variable name="era" select="regex-group(1)"/>
				<xsl:variable name="year" select="dlps:stripLeadingZeros(regex-group(2))"/>
				<creation>
					<xsl:choose>
						<xsl:when test="$era = 'c'">
							<!-- "c" indicates BC -->
							<date n="045|b" value="B{$year}"><xsl:value-of select="$year"/><xsl:text> B.C.</xsl:text></date>
						</xsl:when>
						<xsl:otherwise>
							<date n="045|b" value="{$year}"><xsl:value-of select="$year"/></date>
						</xsl:otherwise>
					</xsl:choose>
				</creation>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:message>Warning: Unexpected format for value of field 045 subfield b</xsl:message>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:if>
</xsl:template>

<!-- 047 and 048: music-related codes -->
<xsl:template match="datafield[@tag='047' or @tag='048']">
	<xsl:variable name="tag" select="@tag"/>
	<xsl:if test="subfield[@code='a' or @code='b']">
		<note n="{$tag}">
			<xsl:for-each select="subfield">
				<xsl:choose>
					<xsl:when test="@code='2' or @code='8'"/>
					<xsl:otherwise>
						<xsl:variable name="code" select="@code"/>
						<p n="{$tag}|{$code}"><xsl:value-of select="."/></p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</note>
	</xsl:if>
</xsl:template>


<!-- ======================================================================= -->
<!-- LANGUAGE CODES (041)                                                    -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='041']">
	<xsl:param name="mainLangCode"/>
	<!-- if 2nd indicator is blank, the field uses MARC language codes (ignore non-MARC language codes) -->
	<xsl:if test="matches(@ind2, '^\s*$')">
		<!-- each subfield of field 041 strings together 3-char MARC language codes,
		     undelimited - e.g. freger to indicate French and German -->
		<xsl:for-each select="subfield">
			<xsl:choose>
				<xsl:when test="@code='2' or @code='6' or @code='8'"/>
				<xsl:otherwise>
					<xsl:variable name="code" select="@code"/>
					<xsl:analyze-string select="." regex="[a-z]{{3}}">
						<xsl:matching-substring>
							<xsl:variable name="langCode" select="."/>
							<xsl:choose>
								<xsl:when test="($langCode = $mainLangCode) and ($code = 'a')"/><!-- don't repeat main language -->
								<xsl:otherwise>
									<xsl:variable name="langDesc" select="dlps:getLangDesc(.)"/>
									<xsl:variable name="usage" select="dlps:getLangUsage($code)"/>
									<xsl:choose>
										<xsl:when test="$langDesc = $langCode">
											<xsl:value-of select="$newline"/>
											<xsl:comment> ATTN Cataloging: Unexpected language code; please supply language name </xsl:comment>
											<xsl:value-of select="$newline"/>
											<language n="041|{$code}" id="{$langCode}" usage="{$usage}">[<xsl:value-of select="$langCode"/>]</language>
										</xsl:when>
										<xsl:otherwise>
											<language n="041|{$code}" id="{$langCode}" usage="{$usage}"><xsl:value-of select="$langDesc"/></language>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:if>
</xsl:template>


<!-- ======================================================================= -->
<!-- CALL NUMBERS (050, 090 and 099)                                         -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='050' or @tag='090' or @tag='099']">
	<idno>
		<xsl:attribute name="n"><xsl:value-of select="@tag"/></xsl:attribute>
		<xsl:attribute name="type">
			<xsl:choose>
				<xsl:when test="@tag='099'">UVa call number</xsl:when>
				<xsl:otherwise>LC call number</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<!-- subfield a is repeatable, so loop through all; combine into one string, separated by spaces -->
		<xsl:for-each select="subfield[@code='a']">
			<xsl:choose>
				<xsl:when test="position()=1">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> </xsl:text><xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<!-- if subfield b (non-repeatable) is present, append it, preceded by a space -->
		<xsl:if test="subfield[@code='b']">
			<xsl:text> </xsl:text><xsl:value-of select="subfield[@code='b']"/>
		</xsl:if>
	</idno>
</xsl:template>


<!-- ======================================================================= -->
<!-- AUTHOR (100 etc.)                                                       -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='100' or @tag='110' or @tag='111']">
	<xsl:variable name="tag"><xsl:value-of select="@tag"/></xsl:variable>
    <xsl:if test="subfield[@code='a']">
		<!-- test whether this is an author or an editor -->
		<xsl:variable name="e" select="dlps:trimPunctuation( dlps:trim(subfield[@code='e']) )"/>
		<xsl:choose>
			<xsl:when test="matches($e, '^(ed\.|editor)$', 'i')">
				<!-- use <editor> element -->
				<editor n="{$tag}">
					<xsl:choose>
						<xsl:when test="$tag='110'">
							<!-- corporate name; use subfield a (non-repeatable) -->
							<name n="{$tag}|a" type="corporate"><xsl:value-of select="subfield[@code='a']"/></name>
		
							<!-- include subfield b if present; it is repeatable, so loop through all -->
							<xsl:for-each select="subfield[@code='b']">
								<name n="{$tag}|b" type="sub-unit"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(.) )"/></name>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$tag='111'">
							<!-- meeting name; use subfield a (non-repeatable) -->
							<name n="{$tag}|a" type="meeting"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/></name>
						</xsl:when>
						<xsl:otherwise>
							<!-- personal name -->
							<xsl:call-template name="formatPersonalName"/>
						</xsl:otherwise>
					</xsl:choose>
				</editor>
			</xsl:when>
			<xsl:otherwise>
				<!-- use <author> element -->
				<author n="{$tag}">
					<xsl:choose>
						<xsl:when test="$tag='110'">
							<!-- corporate name; use subfield a (non-repeatable) -->
							<name n="{$tag}|a" type="corporate"><xsl:value-of select="subfield[@code='a']"/></name>
		
							<!-- include subfield b if present; it is repeatable, so loop through all -->
							<xsl:for-each select="subfield[@code='b']">
								<name n="{$tag}|b" type="sub-unit"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(.) )"/></name>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$tag='111'">
							<!-- meeting name; use subfield a (non-repeatable) -->
							<name n="{$tag}|a" type="meeting"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/></name>
						</xsl:when>
						<xsl:otherwise>
							<!-- personal name -->
							<xsl:call-template name="formatPersonalName"/>
						</xsl:otherwise>
					</xsl:choose>
				</author>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="testUnauthorized"/>
    </xsl:if>
</xsl:template>


<!-- ======================================================================= -->
<!-- TITLE (245)                                                             -->
<!-- ======================================================================= -->

<!-- title (subfields a and b) -->

<xsl:template match="datafield[@tag='245']" mode="title245">
	<!-- main title: subfield a (non-repeatable) -->
	<xsl:if test="subfield[@code='a']">
		<title n="245|a" type="main">
			<xsl:value-of select="dlps:trimPunctuation( dlps:trim ( dlps:formatTitle(subfield[@code='a']) ) )"/>
		</title>
		<title type="sort"><xsl:value-of select="dlps:getSortTitle(subfield[@code='a'], @ind2)"/></title>
	</xsl:if>

	<!-- subtitle: subfield b (non-repeatable) -->
	<xsl:if test="subfield[@code='b']">
		<title n="245|b" type="sub">
			<xsl:value-of select="dlps:trimPunctuation( dlps:trim( dlps:formatTitle(subfield[@code='b']) ) )"/>
		</title>
	</xsl:if>

	<!-- test for certain other subfields indicating part/section -->
	<!-- some subfields are repeatable, so loop through all -->
	<xsl:for-each select="subfield[@code='n' or @code='p']">
		<xsl:choose>
			<xsl:when test="@code='n'">
				<!-- subfield n = 'Number of part/section of a work' -->
				<title n="245|n" type="number"><xsl:value-of select="."/></title>
			</xsl:when>
			<xsl:when test="@code='p'">
				<!-- subfield p = 'Name of part/section of a work' -->
				<title n="245|p" type="part"><xsl:value-of select="."/></title>
			</xsl:when>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<!-- responsibility statement (subfield c) -->

<xsl:template match="datafield[@tag='245']" mode="resp245">
	<!-- responsibility statement: subfield c (non-repeatable) -->
	<xsl:if test="subfield[@code='c']">
		<respStmt>
			<resp n="245|c">
				<xsl:value-of select="dlps:trimPunctuation( dlps:trim ( dlps:formatTitle(subfield[@code='c']) ) )"/>
			</resp>
		</respStmt>
	</xsl:if>
</xsl:template>


<!-- ======================================================================= -->
<!-- RELATED AND UNIFORM TITLES (various fields)                             -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='130' or @tag='240' or @tag='730' or @tag='740']">
	<xsl:if test="subfield[@code='a']">
		<xsl:variable name="n" select="@tag"/>
		<xsl:variable name="type" select="dlps:getRelatedTitleType(@tag)"/>
		<title n="{$n}" type="{$type}">
			<!-- get main value from subfield a (non-repeatable) -->
			<xsl:value-of select="subfield[@code='a']"/>
			
			<!-- test for certain other subfields to append to main value -->
			<!-- some subfields are repeatable, so loop through all -->
			<xsl:for-each select="subfield[@code='n' or @code='p']">
				<xsl:choose>
					<xsl:when test="@code='n'">
						<!-- subfield n = 'Number of part/section of a work'; use space as separator -->
						<xsl:text> </xsl:text>
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:when test="@code='p'">
						<!-- subfield p = 'Name of part/section of a work'; use space as separator -->
						<xsl:text> </xsl:text>
						<xsl:value-of select="."/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</title>
    </xsl:if>
</xsl:template>


<!-- ======================================================================= -->
<!-- ALTERNATE TITLES (246)                                                  -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='246']">
	<xsl:if test="subfield[@code='a']">
		<xsl:variable name="type" select="dlps:getAlternateTitleType(@ind2)"/>
		<title n="246" type="{$type}">
			<!-- if title type is just "alternate", test for subfield i (non-repeatable),
			     which contains "display text"; if present, include in square brackets -->
			<xsl:if test="$type = 'alternate' and subfield[@code='i']">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="replace(subfield[@code='i'], ':$', '')"/>
				<xsl:text>:] </xsl:text>
			</xsl:if>

			<!-- get main value from subfield a (non-repeatable) -->
			<xsl:value-of select="subfield[@code='a']"/>

			<!-- test for certain other subfields to append to main value -->
			<!-- some subfields are repeatable, so loop through all -->
			<xsl:for-each select="subfield[@code='b' or @code='n' or @code='p']">
				<xsl:choose>
					<xsl:when test="@code='b'">
						<!-- subfield b = 'Remainder of title'; use space as separator -->
						<xsl:text> </xsl:text>
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:when test="@code='n'">
						<!-- subfield n = 'Number of part/section of a work'; use space as separator -->
						<xsl:text> </xsl:text>
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:when test="@code='p'">
						<!-- subfield p = 'Name of part/section of a work'; use space as separator -->
						<xsl:text> </xsl:text>
						<xsl:value-of select="."/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</title>
	</xsl:if>
</xsl:template>


<!-- ======================================================================= -->
<!-- FORMER TITLES (247)                                                     -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='247']">
	<xsl:if test="subfield[@code='a']">
		<title n="247" type="former">
			<!-- get main value from subfield a (non-repeatable) -->
			<xsl:value-of select="subfield[@code='a']"/>

			<!-- test for certain other subfields to append to main value -->
			<!-- some subfields are repeatable, so loop through all -->
			<xsl:for-each select="subfield[@code='f' or @code='n' or @code='p']">
				<xsl:choose>
					<xsl:when test="@code='f'">
						<!-- subfield f = 'Date or sequential designation'; use space as separator -->
						<xsl:text> </xsl:text>
						<xsl:value-of select="."/>
						<!-- subfield f = 'Date or sequential designation'; wrap in parentheses
						<xsl:text> (</xsl:text>
						<xsl:value-of select="replace( replace(., '^\(', ''), '\)$', '' )"/>
						<xsl:text>)</xsl:text>
						-->
					</xsl:when>
					<xsl:when test="@code='n'">
						<!-- subfield n = 'Number of part/section of a work'; use space as separator -->
						<xsl:text> </xsl:text>
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:when test="@code='p'">
						<!-- subfield p = 'Name of part/section of a work'; use space as separator -->
						<xsl:text> </xsl:text>
						<xsl:value-of select="."/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</title>
	</xsl:if>
</xsl:template>


<!-- ======================================================================= -->
<!-- EDITION (250)                                                           -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='250']">
	<!-- subfields are non-repeatable -->
	<xsl:if test="subfield[@code='a']">
		<editionStmt>
			<edition n="250">
				<xsl:value-of select="subfield[@code='a']"/>
				<xsl:if test="subfield[@code='b']">
					<!-- subfield b = 'Remainder of edition statement'; use space as separator -->
					<xsl:text> </xsl:text>
					<xsl:value-of select="subfield[@code='b']"/>
				</xsl:if>
			</edition>
		</editionStmt>
	</xsl:if>
</xsl:template>

<!-- ======================================================================= -->
<!-- MUSICAL PRESENTATION STATEMENT (254)                                                       -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='254']">
	<!-- subfields are non-repeatable -->
	<xsl:if test="subfield[@code='a']">
		<note n="254">
			<p n="254|a"><xsl:value-of select="subfield[@code='a']"/></p>
		</note>
	</xsl:if>
</xsl:template>


<!-- ======================================================================= -->
<!-- PUBLICATION (260)                                                       -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='260']">
	<!-- subfield b (publisher) is repeatable, so get all -->
	<xsl:for-each select="subfield[@code='b']">
		<publisher n="260|b"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(.) )"/></publisher>
	</xsl:for-each>

	<!-- subfield a (place of publication) is repeatable, so get all -->
	<xsl:for-each select="subfield[@code='a']">
		<pubPlace n="260|a"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(.) )"/></pubPlace>
	</xsl:for-each>

	<!-- subfield c (date of publication) is repeatable, so get all -->
	<xsl:for-each select="subfield[@code='c']">
		<date n="260|c">
			<xsl:attribute name="value"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(.) )"/></xsl:attribute>
			<xsl:value-of select="dlps:trimPunctuation( dlps:trim(.) )"/>
		</date>
	</xsl:for-each>
</xsl:template>


<!-- ======================================================================= -->
<!-- EXTENT (300)                                                            -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='300']">
	<extent n="300">
		<!-- combine subfields into one string; use space as separator -->
		<!-- some subfields are repeatable, so loop through all, excluding unwanted -->
		<xsl:for-each select="subfield">
			<xsl:choose>
				<xsl:when test="@code='6' or @code='8'"/>
				<xsl:when test="position()=1">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> </xsl:text><xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</extent>
</xsl:template>

<!-- 306: playing time (for sound recording or stated duration of performance of printed or manuscript music) -->
<xsl:template match="datafield[@tag='306']">
	<!-- technically, subfield a is repeatable; use for-each -->
	<xsl:for-each select="subfield[@code='a']">
		<!-- value should be a 6-digit number indicating time as hhmmss -->
		<xsl:analyze-string select="." regex="^\s*(\d\d)(\d\d)(\d\d)">
			<xsl:matching-substring>
				<xsl:variable name="hours" select="regex-group(1)"/>
				<xsl:variable name="minutes" select="regex-group(2)"/>
				<xsl:variable name="seconds" select="regex-group(3)"/>
				<!-- format as hh:mm:ss -->
				<extent n="306" type="duration"><xsl:value-of select="$hours"/>:<xsl:value-of select="$minutes"/>:<xsl:value-of select="$seconds"/></extent>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:message>Warning: Unexpected format for value of field 306 subfield a</xsl:message>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:for-each>
</xsl:template>


<!-- ======================================================================= -->
<!-- SERIES STATEMENT (440 or 830)                                           -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='440' or @tag='830']">
	<xsl:variable name="tag" select="@tag"/>
	<seriesStmt>
		<xsl:attribute name="n"><xsl:value-of select="$tag"/></xsl:attribute>
		<xsl:if test="subfield[@code='a']">
			<xsl:variable name="a">
				<xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/>
			</xsl:variable>
			<!--<title n="{$tag}|a"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/></title>-->
			<title n="{$tag}|a"><xsl:value-of select="$a"/></title>
			<title type="sort"><xsl:value-of select="dlps:getSortTitle(subfield[@code='a'], @ind2)"/></title>
		</xsl:if>
		<xsl:if test="subfield[@code='x']">
			<idno n="{$tag}|x"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='x']) )"/></idno>
		</xsl:if>
		<xsl:if test="subfield[@code='v']">
			<xsl:variable name="v" select="dlps:trimPunctuation( dlps:trim(subfield[@code='v']) )"/>
			<biblScope n="{$tag}|v" type="volume">
				<num>
					<xsl:attribute name="value">
						<xsl:analyze-string select="$v" regex="^v\. (.+)$">
							<xsl:matching-substring>
									<xsl:value-of select="regex-group(1)"/>
							</xsl:matching-substring>
						</xsl:analyze-string>
					</xsl:attribute>
					<xsl:value-of select="$v"/>
				</num>
			</biblScope>
		</xsl:if>
	</seriesStmt>
</xsl:template>


<!-- ======================================================================= -->
<!-- NOTES (500 etc.)                                                        -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='490' or @tag='500' or @tag='501' or @tag='502' or @tag='504' or @tag='505' or @tag='506' or @tag='507' or @tag='508' or @tag='510' or @tag='511' or @tag='513' or @tag='514' or @tag='515' or @tag='516' or @tag='518' or @tag='520' or @tag='521' or @tag='522' or @tag='524' or @tag='525' or @tag='526' or @tag='530' or @tag='533' or @tag='534' or @tag='535' or @tag='536' or @tag='538' or @tag='540' or @tag='541' or @tag='544' or @tag='545' or @tag='546' or @tag='547' or @tag='550' or @tag='552' or @tag='555' or @tag='556' or @tag='561' or @tag='562' or @tag='563' or @tag='565' or @tag='567' or @tag='580' or @tag='581' or @tag='583' or @tag='584' or @tag='585' or @tag='586' or @tag='590' or @tag='599']">
	<xsl:choose>
		<xsl:when test="@tag='490' and @ind1='1'"/> <!-- ignore 490 fields if first indicator is "1" -->
		<xsl:otherwise>
			<xsl:variable name="tag" select="@tag"/>
			<note n="{$tag}">
				<!-- make each subfield a <p> within the <note> -->
				<p>
					<xsl:attribute name="n"><xsl:value-of select="$tag"/><xsl:text>|</xsl:text><xsl:value-of select="subfield[position()=1]/@code"/></xsl:attribute>
					<xsl:value-of select="subfield[position()=1]"/>
				</p>
				<!-- some subfields are repeatable, so loop through all, excluding unwanted -->
				<xsl:for-each select="subfield">
					<xsl:choose>
						<xsl:when test="position()=1"/>
						<xsl:when test="@code='6' or @code='8'"/>
						<xsl:otherwise>
							<p>
								<xsl:attribute name="n"><xsl:value-of select="$tag"/><xsl:text>|</xsl:text><xsl:value-of select="@code"/></xsl:attribute>
								<xsl:value-of select="."/>
							</p>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</note>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- ======================================================================= -->
<!-- SUBJECT ACCESS FIELDS (600 etc.)                                        -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='600' or @tag='610' or @tag='611' or @tag='630' or @tag='648' or @tag='650' or @tag='651' or @tag='653' or @tag='654' or @tag='655' or @tag='656' or @tag='657' or @tag='658']">
	<xsl:if test="subfield[@code='a']">
		<term>
			<xsl:attribute name="n"><xsl:value-of select="@tag"/></xsl:attribute>
			<!-- some subfields are repeatable, so loop through all, excluding unwanted, with special treatment for a and d -->
			<xsl:for-each select="subfield">
				<xsl:choose>
					<xsl:when test="@code='a'">
						<!-- no need to prepend vertical bar for main subject -->
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:when test="@code='d'">
						<!-- use a space to separate main subject (subfield a) from date (subfield d) -->
						<xsl:text> </xsl:text><xsl:value-of select="."/>
					</xsl:when>
					<xsl:when test="@code='2' or @code='6' or @code='8'"/>
					<xsl:otherwise>
						<!-- prepend vertical bar plus subfield label -->
						<xsl:text>|</xsl:text><xsl:value-of select="@code"/><xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</term>
		<xsl:call-template name="testUnauthorized"/>
	</xsl:if>
</xsl:template>


<!-- ======================================================================= -->
<!-- EDITORS AND OTHER CONTRIBUTORS (700 etc.)                               -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='700' or @tag='710' or @tag='711']">
	<xsl:variable name="tag"><xsl:value-of select="@tag"/></xsl:variable>

	<!-- test whether this is an editor, or some other contributor -->
	<xsl:choose>
		<xsl:when test="subfield[@code='e']">
			<xsl:variable name="e" select="dlps:trimPunctuation( dlps:trim(subfield[@code='e']) )"/>
			<xsl:choose>
				<xsl:when test="matches($e, '^(ed\.|editor)$', 'i')">
					<!-- use <editor> element -->
					<editor n="{$tag}">
						<xsl:choose>
							<xsl:when test="$tag='710'">
								<!-- corporate name; use subfield a (non-repeatable) -->
								<name n="{$tag}|a" type="corporate"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/></name>
							</xsl:when>
							<xsl:when test="$tag='711'">
								<!-- meeting name; use subfield a (non-repeatable) -->
								<name n="{$tag}|a" type="meeting"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/></name>
							</xsl:when>
							<xsl:otherwise>
								<!-- personal name -->
								<xsl:call-template name="formatPersonalName"/>
							</xsl:otherwise>
						</xsl:choose>
					</editor>
				</xsl:when>
				<xsl:otherwise>
					<!-- use <resp> - <name> pair within <respStmt> -->
					<respStmt>
						<resp n="{$tag}|e"><xsl:value-of select="$e"/></resp>
						<name>
						<xsl:choose>
							<xsl:when test="$tag='710'">
								<!-- corporate name; use subfield a (non-repeatable) -->
								<name n="{$tag}|a" type="corporate"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/></name>
							</xsl:when>
							<xsl:when test="$tag='711'">
								<!-- meeting name; use subfield a (non-repeatable) -->
								<name n="{$tag}|a" type="meeting"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/></name>
							</xsl:when>
							<xsl:otherwise>
								<!-- personal name -->
								<xsl:call-template name="formatPersonalName"/>
							</xsl:otherwise>
						</xsl:choose>
						</name>
					</respStmt>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="testUnauthorized"/>
		</xsl:when>
		<xsl:otherwise>
			<!-- no subfield e; use <resp> - <name> pair within <respStmt>; supply "[Contributor]" and alert Cataloging -->
			<respStmt>
				<resp>[Contributor]</resp>
				<xsl:comment> ATTN Cataloging: Please supply responsibility, if possible </xsl:comment>
				<xsl:value-of select="$newline"/>
				<name>
					<xsl:choose>
						<xsl:when test="$tag='710'">
							<!-- corporate name; use subfield a (non-repeatable) -->
							<name n="{$tag}|a" type="corporate"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/></name>
						</xsl:when>
						<xsl:when test="$tag='711'">
							<!-- meeting name; use subfield a (non-repeatable) -->
							<name n="{$tag}|a" type="meeting"><xsl:value-of select="dlps:trimPunctuation( dlps:trim(subfield[@code='a']) )"/></name>
						</xsl:when>
						<xsl:otherwise>
							<!-- personal name -->
							<xsl:call-template name="formatPersonalName"/>
						</xsl:otherwise>
					</xsl:choose>
				</name>
			</respStmt>
			<xsl:call-template name="testUnauthorized"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- ======================================================================= -->
<!-- OTHER SUBJECT HEADINGS (75X)                                            -->
<!-- ======================================================================= -->

<xsl:template match="datafield[@tag='752' or @tag='753' or @tag='754' or @tag='755']">
	<xsl:if test="subfield[@code='a']">
		<term>
			<xsl:attribute name="n"><xsl:value-of select="@tag"/></xsl:attribute>
			<xsl:for-each select="subfield">
				<xsl:choose>
					<xsl:when test="@code='a'">
						<!-- no need to prepend vertical bar for main subject -->
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<!-- prepend vertical bar plus subfield label -->
						<xsl:text>|</xsl:text><xsl:value-of select="@code"/><xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</term>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>

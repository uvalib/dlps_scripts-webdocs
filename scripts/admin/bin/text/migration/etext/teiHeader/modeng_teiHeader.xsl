<?xml version="1.0" encoding="UTF-8"?>

<!--

  modeng_teiHeader.xsl - XSLT stylesheet for programmatically converting TEI
    header markup (but not header content) of Modern English files inherited
    from Etext Center for minimal compliance with current QA requirements

  Outputs a TEI.2 document conforming to the uva-dl-tei (TEI P4 + local
  customizations) DTD. This output can subsequently be used to replace the
  original document's <teiHeader> element in its entirety (without affecting
  the remainder of the original document).

  Greg Murray <gpm2a@virginia.edu>
  Written: 2008-01-08
  Last modified: 2008-03-26

  This stylesheet uses some Saxon extensions, so it should be processed using
  the Saxon XSLT processor. For info on Saxon, see http://saxon.sourceforge.net/

-->

<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:dlps="http://dlps.lib.virginia.edu/"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="dlps">

<xsl:include href="http://pogo.lib.virginia.edu/dlps/xsl/strings.xsl"/>

<!-- When the output encoding is US-ASCII, Saxon outputs non-ASCII characters
     from the input document as numeric character entities. This allows the
     output document to be readable by any text editor and therefore completely
     portable. Also, by specifying hexadecimal representation of numeric
     character entities we ensure that those numeric entities can be converted
     programmatically to named/mnemonic character entities without difficulty. -->
<xsl:output
	method="xml"
	encoding="US-ASCII"
	omit-xml-declaration="yes"
	indent="yes"
	saxon:indent-spaces="0"
	saxon:character-representation="hex"/>

<xsl:param name="filename"/>

<!-- ======================================================================= -->
<!-- NAMED TEMPLATES                                                         -->
<!-- ======================================================================= -->

<!-- Add <change> to <revisionDesc> indicating migration from TEI Lite to uva-dl-tei -->
<xsl:template name="add_change">
<!--
	<change>
		<date value="2007-09">September 2007</date>
		<respStmt>
			<resp>Migration</resp>
			<name>Ethan Gruber, University of Virginia Library</name>
		</respStmt>
		<item>Converted XML markup from TEI Lite to uva-dl-tei (TEI P4 with local customizations).</item>
	</change>
	<change>
		<date value="2008-01">January 2008</date>
		<respStmt>
			<resp>Migration</resp>
			<name>Greg Murray, University of Virginia Library</name>
		</respStmt>
		<item>Programmatically updated TEI header markup (but not header content) for minimal compliance with current QA requirements.</item>
	</change>
-->
</xsl:template>

<!-- Add <taxonomy id="uva-form"> -->
<xsl:template name="add_taxonomy_uva-form">
	<taxonomy id="uva-form">
		<bibl>UVa Library Form Categories</bibl>
	</taxonomy>
</xsl:template>

<!-- Copy current node to output, continue processing -->
<xsl:template name="copyout">
	<xsl:copy>
	  <xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>


<!-- ======================================================================= -->
<!-- FUNCTIONS                                                               -->
<!-- ======================================================================= -->

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

<xsl:function name="dlps:ltrim">
	<!-- left trim: removes leading whitespace (but not trailing) from a string -->
	<xsl:param name="in"/>
	<xsl:sequence select="replace($in, '^\s+', '')"/>
</xsl:function>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<xsl:function name="dlps:rtrim">
	<!-- right trim: removes trailing (but not leading) whitespace from a string -->
	<xsl:param name="in"/>
	<xsl:sequence select="replace($in, '\s+$', '')"/>
</xsl:function>


<!-- ======================================================================= -->
<!-- TEMPLATES                                                               -->
<!-- ======================================================================= -->

<!-- Create output document named [basename]_header.xml -->
<xsl:template match="/">
	<xsl:variable name="outfile" select="concat('headers/', replace($filename, '\.xml$', ''), '_header.xml')"/>
  <xsl:result-document href="{$outfile}">
		<!-- DOCTYPE declaration and internal subset -->
		<xsl:text disable-output-escaping="yes"><![CDATA[<?xml version="1.0"?>
<!DOCTYPE TEI.2 SYSTEM "http://text.lib.virginia.edu/dtd/tei/tei-p4/tei2.dtd" [
<!ENTITY % POSTKB "INCLUDE">
<!ENTITY % TEI.extensions.ent SYSTEM "http://text.lib.virginia.edu/dtd/tei/uva-dl-tei/uva-dl-tei.ent">
<!ENTITY % TEI.extensions.dtd SYSTEM "http://text.lib.virginia.edu/dtd/tei/uva-dl-tei/uva-dl-tei.dtd">

<!ENTITY % ISOlat1 SYSTEM "http://text.lib.virginia.edu/charent/iso-lat1.ent"> %ISOlat1;
<!ENTITY % ISOlat2 SYSTEM "http://text.lib.virginia.edu/charent/iso-lat2.ent"> %ISOlat2;
<!ENTITY % ISOnum  SYSTEM "http://text.lib.virginia.edu/charent/iso-num.ent">  %ISOnum;
<!ENTITY % ISOpub  SYSTEM "http://text.lib.virginia.edu/charent/iso-pub.ent">  %ISOpub;
<!ENTITY % ISOtech SYSTEM "http://text.lib.virginia.edu/charent/iso-tech.ent"> %ISOtech;
<!ENTITY % UVAsupp SYSTEM "http://text.lib.virginia.edu/charent/uva-supp.ent"> %UVAsupp;
]>
]]></xsl:text>
		<xsl:apply-templates select="TEI.2"/>
		<xsl:value-of select="$newline"/>
  </xsl:result-document>
</xsl:template>

<!-- Set up a TEI.2 document (because DLPS teiHeader QA stylesheet assumes document starts with TEI.2 element) -->
<xsl:template match="TEI.2">
	<TEI.2>
		<!-- add 'id' attribute with Etext ID, if needed -->
		<xsl:variable name="etext_id" select="teiHeader/fileDesc/publicationStmt/idno[@type='ETC']"/>
		<xsl:choose>
			<xsl:when test="not(@id) and $etext_id">
				<!-- strip "Modern English" from Etext ID -->
				<xsl:variable name="temp" select="replace(normalize-space($etext_id), '^Modern English,?\s+', '')"/>
				<xsl:attribute name="id" select="replace($temp, ',?\s+Modern English$', '')"/>
				<xsl:apply-templates select="@*[not(local-name()='id')]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="@*"/>
			</xsl:otherwise>
		</xsl:choose>

		<!-- process <teiHeader> only -->
		<xsl:apply-templates select="teiHeader"/>

		<!-- add dummy body for validation purposes -->
		<text>
			<body>
				<div1 type="section">
					<p>...</p>
				</div1>
			</body>
		</text>
	</TEI.2>
</xsl:template>

<xsl:template match="teiHeader">
	<teiHeader type="migrated" creator="Etext">
		<!-- process attributes, but omit 'type': this header is not derived from a MARC record and so should not carry type="AACR2" -->
		<xsl:apply-templates select="@*[not(local-name()='type')]"/>

		<!-- process all but revisionDesc, which we'll get to in a second -->
		<xsl:apply-templates select="node()[not(self::revisionDesc)]"/>

		<!-- add <profileDesc> if needed (because <langUsage> is required by header QA program) -->
		<xsl:if test="not(profileDesc)">
			<profileDesc>
				<langUsage>
					<language id="eng" usage="main">English</language>
				</langUsage>
			</profileDesc>
		</xsl:if>

		<!-- process <revisionDesc> if it exists, or add it -->
		<xsl:choose>
			<xsl:when test="revisionDesc">
				<xsl:apply-templates select="revisionDesc"/>
			</xsl:when>
			<xsl:otherwise>
				<!--
				<revisionDesc>
					<xsl:call-template name="add_change"/>
				</revisionDesc>
				-->
			</xsl:otherwise>
		</xsl:choose>

	</teiHeader>
</xsl:template>

<!-- Add "sort" title to titleStmt -->
<xsl:template match="titleStmt">
	<xsl:variable name="main_title" select="dlps:trim( replace(title[1], '\[a\s+machine-readable\s+transcription\]', '') )"/>
	<titleStmt>
		<!-- process attributes -->
		<xsl:apply-templates select="@*"/>
		<!-- process <title> elements -->
		<xsl:apply-templates select="title"/>
		<!-- add sort title -->
		<xsl:choose>
			<xsl:when test="normalize-space($main_title)=''">
				<xsl:message><xsl:value-of select="$filename"/>: WARNING: Main title is empty</xsl:message>
			</xsl:when>
			<xsl:otherwise>
					<title type="sort">
						<!-- since there's no MARC record (field 245, second indicator)
							specifying the number of nonfiling characters, guess at it simply by
							looking for 'A', 'An', and 'The' -->
						<xsl:choose>
							<xsl:when test="matches($main_title, '^A ', 'i')">
								<!-- 2 nonfiling characters -->
								<xsl:value-of select="dlps:getSortTitle($main_title, 2)"/>
							</xsl:when>
							<xsl:when test="matches($main_title, '^An ', 'i')">
								<!-- 3 nonfiling characters -->
								<xsl:value-of select="dlps:getSortTitle($main_title, 3)"/>
							</xsl:when>
							<xsl:when test="matches($main_title, '^The ', 'i')">
								<!-- 4 nonfiling characters -->
								<xsl:value-of select="dlps:getSortTitle($main_title, 4)"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- 0 nonfiling characters -->
								<xsl:value-of select="dlps:getSortTitle($main_title, 0)"/>
							</xsl:otherwise>
						</xsl:choose>
					</title>
			</xsl:otherwise>
		</xsl:choose>
		<!-- process all except <title> elements, which have already been processed -->
		<xsl:apply-templates select="*[not(self::title)]"/>
	</titleStmt>
</xsl:template>

<xsl:template match="title">
	<xsl:choose>
		<xsl:when test="normalize-space(.)=''"/><!-- empty; omit -->
		<xsl:when test="normalize-space(.)='[a machine-readable transcription]'"/><!-- contains nothing but this phrase; omit -->
		<!-- make first title type="main" -->
		<xsl:when test="position() = 1 and not(@type)">
			<title>
				<!-- add type="main" -->
				<xsl:attribute name="type">main</xsl:attribute>
				<xsl:apply-templates select="@*"/>
				<xsl:apply-templates/>
			</title>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Remove "[a machine-readable transcription]" from fileDesc title -->
<xsl:template match="fileDesc/titleStmt/title/text()">
	<xsl:value-of select="dlps:trim( replace(., '\[a\s+machine-readable\s+transcription\]', '') )"></xsl:value-of>
</xsl:template>

<!-- Omit empty <respStmt>, except in revisionDesc/change (where it is required) -->
<xsl:template match="respStmt">
	<xsl:choose>
		<xsl:when test="normalize-space(.)='' and not(parent::change)"/><!-- empty; omit -->
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Omit empty <resp>, except in a resp + name pair -->
<xsl:template match="respStmt/resp">
	<xsl:choose>
		<xsl:when test="normalize-space(.)='' and normalize-space(following-sibling::name[1])='' and not(ancestor::change)"/><!-- empty; omit -->
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Omit empty <name>, except in a resp + name pair -->
<xsl:template match="respStmt/name">
	<xsl:choose>
		<xsl:when test="normalize-space(.)='' and normalize-space(preceding-sibling::resp[1])='' and not(ancestor::change)"/><!-- empty; omit -->

		<xsl:when test="matches(normalize-space(.), 'UALR American Native Press Archives and Sequoyah Research Center')">
			<!-- add URL for this name, so it doesn't get dropped when <availability> is normalized -->
			<!-- also expand abbreviation of "UALR" -->
			<name>
				<xsl:apply-templates select="@*"/>
				<xsl:text>American Native Press Archives and Sequoyah Research Center, University of Arkansas at Little Rock (http://www.anpa.ualr.edu)</xsl:text>
			</name>
		</xsl:when>

		<xsl:when test="matches(normalize-space(.), 'Readex')">
			<name>
				<xsl:apply-templates select="@*"/>
				<xsl:text>Readex &#x2014; a division of NewsBank Inc.</xsl:text>
			</name>
		</xsl:when>

		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Strip "Modern English" from start of Etext ID -->
<xsl:template match="idno">
	<xsl:choose>
		<xsl:when test=" normalize-space(.) = '' "/><!-- empty; omit -->
		<xsl:when test="@type='ETC' and contains(normalize-space(.), 'Modern English')">
			<idno>
				<xsl:apply-templates select="@*"/>
				<xsl:variable name="temp" select="replace(normalize-space(.), '^Modern English,?\s+', '')"/>
				<xsl:value-of select="replace($temp, ',?\s+Modern English$', '')"/>
			</idno>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="fileDesc/publicationStmt">
	<publicationStmt>
		<!-- process attributes -->
		<xsl:apply-templates select="@*"/>

		<!-- warn if unexpected fileDesc publisher -->
		<xsl:if test="not( contains(normalize-space(publisher), 'University of Virginia Library') )">
			<xsl:message><xsl:value-of select="$filename"/>: WARNING: fileDesc/publisher does not contain "University of Virginia Library": <xsl:value-of select="normalize-space(publisher)"/></xsl:message>
		</xsl:if>
		<!-- add/replace publisher and pubPlace -->
		<publisher>University of Virginia Library</publisher>
		<pubPlace>Charlottesville, Virginia</pubPlace>

		<!-- add <idno type="ETC"> if needed -->
		<xsl:if test="not(idno[@type='ETC'])">
			<xsl:choose>
				<xsl:when test="ancestor::TEI.2/@id">
					<idno type="ETC"><xsl:value-of select="normalize-space(ancestor::TEI.2/@id)"/></idno>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message><xsl:value-of select="$filename"/>: WARNING: No Etext ID</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

		<!-- process all but publisher, pubPlace, and availability which we're replacing -->
		<xsl:apply-templates select="node()[not(self::publisher)][not(self::pubPlace)][not(self::availability)]"/>

		<!-- determine fileDesc year of publication -->
		<xsl:variable name="pubyear">
			<xsl:choose>
				<xsl:when           test="matches(normalize-space(date[1]/@value), '^\d\d\d\d')">
					<xsl:value-of select="substring(normalize-space(date[1]/@value), 1, 4)"/>
				</xsl:when>
				<!-- no publication date; try first revisionDesc/change -->
				<xsl:when           test="matches(normalize-space(ancestor::teiHeader/revisionDesc/change[1]/date/@value), '^\d\d\d\d')">
					<xsl:value-of select="substring(normalize-space(ancestor::teiHeader/revisionDesc/change[1]/date/@value), 1, 4)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message><xsl:value-of select="$filename"/>: WARNING: No fileDesc publication date</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- add publication <date> if needed -->
		<xsl:if test="not(date)">
			<date value="{$pubyear}"><xsl:value-of select="$pubyear"/></date>
		</xsl:if>

		<!-- add <availability> -->
		<availability status="public">
			<p n="copyright">Copyright &#xA9; <xsl:value-of select="$pubyear"/> by the Rector and Visitors of the University of Virginia</p>
			<p n="access">Publicly accessible</p>
		</availability>
	</publicationStmt>

	<!-- Add <seriesStmt> indicating text collection -->
	<seriesStmt>
		<title>University of Virginia Library, Text collection</title>
		<idno type="uva-set">UVA-LIB-Text</idno>
	</seriesStmt>
</xsl:template>

<!-- Omit empty <date> in most cases -->
<xsl:template match="date">
	<xsl:choose>
		<xsl:when test="normalize-space(.)='' and normalize-space(@value)='' and not(parent::change)"/><!-- empty; omit -->
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Handle an empty sourceDesc -->
<!-- sourceDesc is required, so if empty, normalize to empty <p> (rather than omit) -->
<xsl:template match="sourceDesc">
	<xsl:choose>
		<xsl:when test="normalize-space(.)=''">
			<sourceDesc>
				<xsl:apply-templates select="@*"/>
				<p/>
			</sourceDesc>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Handle an empty publicationStmt -->
<!-- publicationStmt is required, so if empty, normalize to empty <p> (rather than omit) -->
<xsl:template match="sourceDesc/biblFull/publicationStmt">
	<xsl:choose>
		<xsl:when test="normalize-space(.)=''">
			<publicationStmt>
				<xsl:apply-templates select="@*"/>
				<p/>
			</publicationStmt>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- If <langUsage> is empty, supply <language> declaration for English -->
<xsl:template match="langUsage">
	<langUsage>
		<xsl:apply-templates select="@*"/>
		<xsl:choose>
			<xsl:when test="normalize-space(.)=''">
				<language id="eng" usage="main">English</language>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</langUsage>
</xsl:template>

<!-- For <language> declaration for English, add id="eng" and usage="main" -->
<!-- For all common languages, add 'id' attribute if needed -->
<xsl:template match="language">
	<xsl:choose>
		<xsl:when test="normalize-space(.)=''">
			<!-- empty; try 'id' attribute -->
			<xsl:choose>
				<xsl:when test="matches(normalize-space(@id), '^eng?', 'i')">
					<language id="eng" usage="main">
						<xsl:apply-templates select="@*[not(local-name()='id')]"/>
						<xsl:text>English</xsl:text>
					</language>
				</xsl:when>
				<xsl:when test="@id">
					<!-- no element content, but has 'id' attribute; keep but warn -->
					<xsl:message><xsl:value-of select="$filename"/>: WARNING: language declaration is empty</xsl:message>
					<xsl:call-template name="copyout"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- empty and no 'id' attribute; omit -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<xsl:when test="matches(normalize-space(@id), '^eng?', 'i')">
			<!-- language ID indicates English; normalize to "English" -->
			<language id="eng" usage="main">
				<xsl:apply-templates select="@*[not(local-name()='id')]"/>
				<xsl:text>English</xsl:text>
			</language>
		</xsl:when>

		<xsl:otherwise>
			<!-- for common languages, add 'id' attribute if needed (required by header QA program) -->
			<xsl:choose>
				<xsl:when test="not(@id)">
					<xsl:choose>
						<xsl:when test="normalize-space(.)='English'">
							<language id="eng" usage="main">
								<xsl:apply-templates select="@*"/>
								<xsl:apply-templates/>
							</language>
						</xsl:when>
						<xsl:when test="normalize-space(.)='French'">
							<language id="fre">
								<xsl:apply-templates select="@*"/>
								<xsl:apply-templates/>
							</language>
						</xsl:when>
						<xsl:when test="normalize-space(.)='German'">
							<language id="ger">
								<xsl:apply-templates select="@*"/>
								<xsl:apply-templates/>
							</language>
						</xsl:when>
						<xsl:when test="normalize-space(.)='Greek'">
							<language id="grc">
								<xsl:apply-templates select="@*"/>
								<xsl:apply-templates/>
							</language>
						</xsl:when>
						<xsl:when test="normalize-space(.)='Latin'">
							<language id="lat">
								<xsl:apply-templates select="@*"/>
								<xsl:apply-templates/>
							</language>
						</xsl:when>
						<xsl:when test="normalize-space(.)='Russian'">
							<language id="rus">
								<xsl:apply-templates select="@*"/>
								<xsl:apply-templates/>
							</language>
						</xsl:when>
						<xsl:otherwise>
							<!-- not a common language; copy as is -->
							<xsl:call-template name="copyout"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- already has 'id' attribute; copy as is -->
					<xsl:call-template name="copyout"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Omit classDecl/taxonomy for "Library of Congress Subject Headings" (because not used properly) -->
<xsl:template match="classDecl">
	<xsl:choose>
		<xsl:when test="normalize-space(.)='Library of Congress Subject Headings'"/><!-- omit -->
		<xsl:otherwise>
			<xsl:message><xsl:value-of select="$filename"/>: WARNING: classDecl retained: check for appropriate content</xsl:message>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Omit <textClass> if empty, or if only consists of "LCSH" (because not used properly) -->
<xsl:template match="textClass">
	<xsl:choose>
		<xsl:when test="normalize-space(.)=''"/><!-- empty; omit -->
		<xsl:when test="normalize-space(.)='LCSH'"/><!-- omit -->
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Omit <keywords> if empty, or if only consists of "LCSH" (because not used properly) -->
<xsl:template match="keywords">
	<xsl:choose>
		<xsl:when test="normalize-space(.)=''"/><!-- empty; omit -->
		<xsl:when test="normalize-space(.)='LCSH'"/><!-- omit -->
		<xsl:when test="@scheme='LCSH'">
			<keywords>
				<!-- omit scheme="LCSH" attribute; these aren't always really LCSH terms -->
				<xsl:apply-templates select="@*[not(local-name()='scheme')]"/>
				<xsl:apply-templates/>
			</keywords>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Omit empty keywords/term -->
<xsl:template match="keywords/term">
	<xsl:choose>
		<xsl:when test="normalize-space(.)=''"/><!-- empty; omit -->
		<xsl:when test="@type='Field650'">
			<term>
				<!-- omit type="Field650" -->
				<xsl:apply-templates select="@*[not(local-name()='type')]"/>
				<xsl:apply-templates/>
			</term>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Add <langUsage> to <profileDesc> if needed -->
<xsl:template match="profileDesc">
	<profileDesc>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="creation"/>
		<!-- insert <langUsage> after <creation> if needed -->
		<xsl:if test="not(langUsage)">
			<langUsage>
				<language id="eng" usage="main">English</language>
			</langUsage>
		</xsl:if>
		<!-- process all but <creation>, which we already handled -->
		<xsl:apply-templates select="node()[not(self::creation)]"/>
	</profileDesc>
</xsl:template>

<!-- Add entry to <revisionDesc> -->
<xsl:template match="revisionDesc">
	<revisionDesc>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates/>
		<xsl:call-template name="add_change"/>
	</revisionDesc>
</xsl:template>

<!-- Omit empty <p> in most cases -->
<xsl:template match="p">
	<xsl:choose>
		<xsl:when test="normalize-space(.)='' and not(parent::publicationStmt)"/><!-- empty; omit -->
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Omit empty elements not already handled elsewhere -->
<xsl:template match="author|creation|editor|extent|editionStmt|note|notesStmt|publisher|pubPlace|refsDecl|seriesStmt|term">
	<xsl:choose>
		<xsl:when test="normalize-space(.)=''"/><!-- empty; omit -->
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- ======================================================================= -->
<!-- DEFAULT TEMPLATES                                                       -->
<!-- ======================================================================= -->

<!-- Default template for elements, comments, PI's: copy to output -->
<xsl:template match="*|comment()|processing-instruction()">
	<xsl:call-template name="copyout"/>
</xsl:template>

<!-- Default template for attributes: copy to output, with some exceptions -->
<xsl:template match="@*">
	<xsl:choose>
		<xsl:when test="local-name()='TEIform'"/><!-- skip -->
		<xsl:when test="local-name()='default'"/><!-- skip -->
		<xsl:when test="local-name()='doctype' and parent::refsDecl"/><!-- skip -->
		<xsl:when test="local-name()='status' and parent::teiHeader"/><!-- skip -->
		<xsl:when test="local-name()='role' and .='editor' and parent::editor"/><!-- skip -->
		<xsl:when test="local-name()='n' and matches(., '^\d\d\d\|[a-z]')"/><!-- 'n' attribute used to indicate MARC field; omit -->
		<xsl:otherwise>
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Default template for text nodes: clean up leading/trailing whitespace as appropriate -->
<xsl:template match="text()">
	<xsl:choose>
		<xsl:when test="preceding-sibling::node() and not( following-sibling::node() )">
			<!-- trim trailing whitespace -->
			<xsl:value-of select="dlps:rtrim(.)"/>
		</xsl:when>
		<xsl:when test="not( preceding-sibling::node() ) and following-sibling::node()">
			<!-- trim leading whitespace -->
			<xsl:value-of select="dlps:ltrim(.)"/>
		</xsl:when>
		<xsl:when test="not( preceding-sibling::node() ) and not( following-sibling::node() )">
			<!-- trim leading and trailing whitespace -->
			<xsl:value-of select="dlps:trim(.)"/>
		</xsl:when>
		<xsl:otherwise>
			<!-- copy as is -->
			<xsl:call-template name="copyout"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

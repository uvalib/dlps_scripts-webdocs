<?xml version='1.0'?>

<!--

  qa_teiHeader.xsl - XSLT stylesheet for markup QA of TEI headers.

  Intended to be run from the command line; output is text, not XML or HTML.

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2004-03-29
  Last modified: 2010-04-29

  [Changes made through 2008-08-18 are not documented]

  2010-04-29: gpm2a: Updated <idno type="..."> values to accommodate more
  recent terminology. Changed as follows:
    * In <fileDesc>, allow either <idno type="DLPS ID"> (old, for backward
      compatibility) or <idno type="Digitization Services, UVa Library"> (new)
    * In <sourceDesc>, allow either <idno type="UVa Title Control Number">
      (old) or <idno type="UVa CatKey"> (new)

  2010-04-30: gpm2a: Added check requiring @type on <teiHeader>. This
  requirement was previously enforced by the DTD, but for practical/workflow
  reasons, it's more convenient to enforce it here.

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- INCLUDES -->
  <xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_globals.xsl"/>


  <!-- PARAMETERS -->
  <xsl:param name="filename"/>
  <xsl:param name="errorsOnly"/>


  <!-- OUTPUT -->
  <xsl:output method="text"/>


  <!-- TOP-LEVEL TEMPLATE -->
  <xsl:template match="/">
    <xsl:apply-templates select="TEI.2"/>
    <xsl:apply-templates select="standaloneHeader"/>
  </xsl:template>

  <xsl:template match="TEI.2 | standaloneHeader">
    <!-- <teiHeader> is required, obviously -->
    <xsl:if test="not(teiHeader)">
      <xsl:call-template name="outputMsg">
        <xsl:with-param name="msg">No TEI header found!</xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <!-- @type attribute is required -->
    <xsl:if test="not(teiHeader/@type)">
      <xsl:call-template name="outputMsg">
        <xsl:with-param name="msg">No 'type' attribute found on &lt;teiHeader&gt;</xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <!-- <availability> is required -->
    <xsl:if test="not(teiHeader/fileDesc/publicationStmt/availability)">
      <xsl:call-template name="outputMsg">
        <xsl:with-param name="msg">No fileDesc/publicationStmt/availability found</xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <!-- <seriesStmt> containing <idno type="uva-set"> is required -->
    <xsl:if test="not(teiHeader/fileDesc/seriesStmt/idno[@type='uva-set'])">
      <xsl:call-template name="outputMsg">
        <xsl:with-param name="msg">fileDesc/seriesStmt containing &lt;idno type="uva-set"&gt; is required</xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <!-- <title> is required in both fileDesc and sourceDesc -->
    <!-- except for migrated headers, where only fileDesc title is required (sourceDesc can use informal <p>) -->
    <xsl:choose>
      <xsl:when test="teiHeader/fileDesc/titleStmt/title[@type='main']">
        <!-- "sort" title is also required when <title> is used -->
        <xsl:if test="not(teiHeader/fileDesc/titleStmt/title[@type='sort'])">
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">No "sort" title found in fileDesc/titleStmt</xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="outputMsg">
          <xsl:with-param name="msg">No main title found in fileDesc/titleStmt</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/title[@type='main']">
        <!-- "sort" title is also required when <title> is used -->
        <xsl:if test="not(teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/title[@type='sort'])">
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">No "sort" title found in sourceDesc...titleStmt</xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="not(teiHeader/@type = 'migrated')">
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">No main title found in sourceDesc...titleStmt</xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>

    <!-- sort title is also required on sourceDesc/biblFull/seriesStmt (if any), if it uses <title> (rather than <p>) -->
    <xsl:if test="teiHeader/fileDesc/sourceDesc/biblFull/seriesStmt/title">
      <xsl:if test="not(teiHeader/fileDesc/sourceDesc/biblFull/seriesStmt/title[@type='sort'])">
        <xsl:call-template name="outputMsg">
          <xsl:with-param name="msg">No "sort" title found in fileDesc/sourceDesc/biblFull/seriesStmt</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>

    <!-- Either <idno type="DLPS ID"> or <idno type="Digitization Services, UVa Library"> is required if not standalone, and not a migrated header -->
    <xsl:if test="not(/standaloneHeader) and not(teiHeader/@type = 'migrated')">
      <xsl:choose>
        <xsl:when test="teiHeader/fileDesc/publicationStmt/idno[@type='DLPS ID']"/>
        <xsl:when test="teiHeader/fileDesc/publicationStmt/idno[@type='Digitization Services, UVa Library']"/>
        <xsl:otherwise>
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">Either &lt;idno type="DLPS ID"&gt; or &lt;idno type="Digitization Services, UVa Library"&gt; is required</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <!-- <idno type="UVa Virgo ID"> is required if not a newspaper issue, and not a migrated header -->
    <xsl:if test="not(teiHeader/profileDesc/textClass/keywords[@scheme='uva-form']/term='newspaper issue') and not(teiHeader/@type = 'migrated')">
      <xsl:if test="not(teiHeader/fileDesc/sourceDesc/biblFull/publicationStmt/idno[@type='UVa Virgo ID'])">
        <xsl:call-template name="outputMsg">
          <xsl:with-param name="msg">No &lt;idno type="UVa Virgo ID"&gt; found</xsl:with-param>
          <xsl:with-param name="type">W</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>

    <!-- Either <idno type="UVa Title Control Number"> or <idno type="UVa CatKey"> is required if not a migrated header -->
    <xsl:if test="not(teiHeader/@type = 'migrated')">
      <xsl:choose>
        <xsl:when test="teiHeader/fileDesc/sourceDesc/biblFull/publicationStmt/idno[@type='UVa Title Control Number']"/>
        <xsl:when test="teiHeader/fileDesc/sourceDesc/biblFull/publicationStmt/idno[@type='UVa CatKey']"/>
        <xsl:otherwise>
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">Either &lt;idno type="UVa Title Control Number"&gt; or &lt;idno type="UVa CatKey"&gt; is required</xsl:with-param>
            <xsl:with-param name="type">W</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <!-- teiHeader/profileDesc/langUsage is required -->
    <xsl:if test="not(teiHeader/profileDesc/langUsage)">
      <xsl:call-template name="outputMsg">
        <xsl:with-param name="msg">No &lt;langUsage&gt; found</xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <!-- teiHeader/profileDesc/textClass is required if not a migrated header -->
    <xsl:if test="not(teiHeader/@type = 'migrated')">
      <xsl:if test="not(teiHeader/profileDesc/textClass)">
        <xsl:call-template name="outputMsg">
          <xsl:with-param name="msg">No &lt;textClass&gt; found</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>

    <!-- test all <title> elements, not just those in the header -->
    <xsl:apply-templates select="//title"/>

    <xsl:apply-templates select="teiHeader"/>
  </xsl:template>

  <xsl:template match="teiHeader">
    <xsl:apply-templates select="fileDesc/titleStmt"/>
    <xsl:apply-templates select="fileDesc/extent"/>
    <xsl:apply-templates select="fileDesc/publicationStmt/availability"/>
    <xsl:apply-templates select="fileDesc/seriesStmt"/>
    <xsl:apply-templates select="encodingDesc/classDecl"/>
    <xsl:apply-templates select="profileDesc/langUsage"/>
    <xsl:apply-templates select="profileDesc/textClass"/>
  </xsl:template>

  <xsl:template match="titleStmt">
    <!-- Warn if no main title in fileDesc -->
    <xsl:if test="not(title[@type='main'])">
      <xsl:call-template name="outputMsg">
        <xsl:with-param name="msg">No main title found in fileDesc/titleStmt</xsl:with-param>
        <xsl:with-param name="type">W</xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <!-- sort title in fileDesc and sourceDesc should be the same, if not a migrated header -->
    <xsl:if test="title[@type='sort'] and ancestor::teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/title[@type='sort']">
      <!-- for migrated headers (not derived programmatically from MARC record), title in fileDesc and sourceDesc might differ -->
      <xsl:if test="not(ancestor::teiHeader/@type = 'migrated')">
        <xsl:if test="not(normalize-space(title[@type='sort']) = normalize-space(ancestor::teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/title[@type='sort']))">
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">Sort titles in fileDesc and in sourceDesc are not the same</xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="extent">
    <xsl:if test=". = '? kilobytes'">
      <xsl:call-template name="outputMsg">
        <xsl:with-param name="msg">&lt;extent&gt; has not been updated with filesize; run refresh_filesize</xsl:with-param>
        <xsl:with-param name="type">W</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="availability">
    <!-- attribute 'status' is required by DTD -->

    <!-- test for <p n="copyright"> -->
    <xsl:if test="not(p[@n='copyright'])">
      <xsl:call-template name="outputMsg">
        <xsl:with-param name="msg">No fileDesc/publicationStmt/availability/p n="copyright" found</xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <!-- test for <p n="access"> -->
    <xsl:choose>
      <xsl:when test="p[@n='access']">
        <!-- test that value of 'status' attribute and content of <p n="access"> correspond -->
        <xsl:choose>
          <xsl:when test="@status='public'">
            <xsl:if test="not(p[@n='access']='Publicly accessible')">
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">fileDesc/publicationStmt/availability: status attribute and &lt;p n="access"&gt; do not correspond</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>

          <xsl:when test="@status='viva'">
            <xsl:if test="not(p[@n='access']='Accessible to VIVA community only')">
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">fileDesc/publicationStmt/availability: status attribute and &lt;p n="access"&gt; do not correspond</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>

          <xsl:when test="@status='uva'">
            <xsl:if test="not(p[@n='access']='UVA only')">
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">fileDesc/publicationStmt/availability: status attribute and &lt;p n="access"&gt; do not correspond</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>

          <xsl:when test="@status='restricted'">
            <xsl:if test="not(p[@n='access']='Access restricted')">
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">fileDesc/publicationStmt/availability: status attribute and &lt;p n="access"&gt; do not correspond</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="outputMsg">
          <xsl:with-param name="msg">No fileDesc/publicationStmt/availability/p n="access" found</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="seriesStmt">
    <!-- <title> is required by DTD -->

    <!-- existence of <idno type="uva-set"> is verified elsewhere; here we're checking the content -->
    <xsl:if test="idno[@type='uva-set']">
      <!-- test for specific vocabulary for <idno type="uva-set">, and that the value used corresponds with <title> -->
      <xsl:variable name="msg" select="concat('&lt;idno type=&quot;uva-set&quot;&gt;', idno[@type='uva-set'], '&lt;/idno&gt; and its &lt;title&gt; value do not correspond')"/>
      <xsl:choose>
        <xsl:when test="idno[@type='uva-set']='UVA-LIB-ModEngl'">
          <!-- "Modern English" is no longer being used -->
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">The value "UVA-LIB-ModEngl" is outdated. Use this instead: &lt;title&gt;University of Virginia Library, Text collection&lt;/title&gt;&lt;idno type="uva-set"&gt;UVA-LIB-Text&lt;/idno&gt;</xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <xsl:when test="idno[@type='uva-set']='UVA-LIB-Text'">
          <xsl:if test="not(title='University of Virginia Library, Text collection')">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>

        <xsl:when test="idno[@type='uva-set']='UVA-LIB-LewisClark'">
          <xsl:if test="not(title='University of Virginia Library, Lewis and Clark collection')">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>

        <xsl:when test="idno[@type='uva-set']='UVA-LIB-WestwardExplor'">
          <xsl:if test="not(title='University of Virginia Library, Westward Exploration collection')">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>

        <xsl:when test="idno[@type='uva-set']='UVA-LIB-EarlyAmFict1789-1875'">
          <xsl:if test="not(title='University of Virginia Library, Early American Fiction, 1789-1875')">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>

        <xsl:when test="idno[@type='uva-set']='CH-DatabaseAfrAmPoetry'">
          <xsl:if test="not(title='Chadwyck-Healey, Database of African-American poetry, 1760-1900')">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>

        <xsl:when test="idno[@type='uva-set']='CH-AmPoetry'">
          <xsl:if test="not(title='Chadwyck-Healey, American Poetry')">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>

        <xsl:when test="idno[@type='uva-set']='CH-EnglPoetry'">
          <xsl:if test="not(title='Chadwyck-Healey, English Poetry')">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>

        <xsl:when test="idno[@type='uva-set']='CH-EnglVerseDrama'">
          <xsl:if test="not(title='Chadwyck-Healey, English Verse Drama')">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>

        <xsl:when test="idno[@type='uva-set']='UVA-LIB-ValleyOfTheShadow'">
          <xsl:if test="not(title='University of Virginia Library, Valley of the Shadow collection')">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg" select="$msg"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>

        <xsl:otherwise>
          <!-- unrecognized value for <idno type="uva-set"> -->
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg" select="concat('Unrecognized value: &lt;idno type=&quot;uva-set&quot;&gt;', idno[@type='uva-set'], '&lt;/idno&gt;')"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="langUsage">
    <!-- if the primary language is not English, test for <hyphenation eol="all"> indicating that end-of-line hyphenation has been retained -->
    <xsl:choose>
      <xsl:when test="language[@usage='main']">
        <!-- there is a language designated as main -->
        <xsl:if test="language[@usage='main'][@id!='eng']">
          <xsl:if test="ancestor::teiHeader/encodingDesc/editorialDecl/hyphenation">
            <xsl:if test="not(ancestor::teiHeader/encodingDesc/editorialDecl/hyphenation[@eol='all'])">
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="type">W</xsl:with-param>
                <xsl:with-param name="msg">The language declared as usage="main" is not English, but the hyphenation declaration is not correct -- should be &lt;hyphenation eol="all"&gt; indicating that all end-of-line hyphenation has been retained (if, in fact, it has been retained).</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <!-- no language is designated as main; look at the first language declared -->
        <xsl:if test="language[position()=1][@id!='eng']">
          <xsl:if test="not(ancestor::teiHeader/encodingDesc/editorialDecl/hyphenation[@eol='all'])">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="type">W</xsl:with-param>
              <xsl:with-param name="msg">The first language declared (no language is declared as usage="main") is not English, but the hyphenation declaration is not correct -- should be &lt;hyphenation eol="all"&gt; indicating that all end-of-line hyphenation has been retained (if, in fact, it has been retained).</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="language"/>
  </xsl:template>

  <xsl:template match="language">
    <!-- each language declaration should have an 'id' attribute, unless that language has already been declared -->
    <xsl:if test="not(@id)">
      <xsl:choose>
        <xsl:when test="normalize-space(preceding-sibling::language) = normalize-space(.)">
          <!-- ok; this language has already been declared -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">&lt;language&gt; has no 'id' attribute, but the language (<xsl:value-of select="."/>) has not previously been declared</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <!-- if attribute 'usage' is used, make sure it has an expected value -->
    <xsl:if test="@usage">
      <xsl:choose>
        <xsl:when test="@usage='main'"/>
        <!-- MARC 008 or 041$a -->
        <xsl:when test="@usage='summary/abstract'"/>
        <!-- MARC 041$b -->
        <xsl:when test="@usage='sung/spoken'"/>
        <!-- MARC 041$d -->
        <xsl:when test="@usage='libretto'"/>
        <!-- MARC 041$e -->
        <xsl:when test="@usage='table of contents'"/>
        <!-- MARC 041$f -->
        <xsl:when test="@usage='accompanying material'"/>
        <!-- MARC 041$g -->
        <xsl:when test="@usage='translation'"/>
        <!-- MARC 041$h -->
        <xsl:otherwise>
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">Unexpected value (<xsl:value-of select="@usage"/>) for 'usage' attribute on &lt;language&gt;</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="classDecl">
    <!-- test for <taxonomy id="uva-form"> if applicable -->
    <xsl:if test="ancestor::teiHeader/profileDesc/textClass/keywords[@scheme='uva-form']">
      <xsl:choose>
        <xsl:when test="taxonomy[@id='uva-form']">
          <xsl:apply-templates select="taxonomy[@id='uva-form']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">No &lt;taxonomy id="uva-form"&gt; in encodingDesc/classDecl</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <!-- test for <taxonomy id="LCSH"> if applicable -->
    <xsl:if test="ancestor::teiHeader/profileDesc/textClass/keywords[@scheme='LCSH']">
      <xsl:choose>
        <xsl:when test="taxonomy[@id='LCSH']">
          <xsl:apply-templates select="taxonomy[@id='LCSH']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="outputMsg">
            <xsl:with-param name="msg">No &lt;taxonomy id="LCSH"&gt; in encodingDesc/classDecl</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="taxonomy">
    <!-- must contain exactly one <bibl> -->
    <xsl:choose>
      <xsl:when test="count(bibl) = 1">
        <!-- <bibl> must contain an appropriate value -->
        <xsl:choose>
          <xsl:when test="@id='uva-form'">
            <xsl:if test="not(bibl='UVa Library Form Categories')">
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">&lt;taxonomy id="uva-form"&gt; must declare "UVa Library Form Categories"</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:when test="@id='LCSH'">
            <xsl:if test="not(bibl='Library of Congress Subject Headings')">
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">&lt;taxonomy id="LCSH"&gt; must declare "Library of Congress Subject Headings"</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="outputMsg">
          <xsl:with-param name="msg">&lt;taxonomy&gt; must contain exactly one &lt;bibl&gt;</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="textClass">
    <!-- test for keywords using the "uva-form" scheme -->
    <xsl:choose>
      <xsl:when test="keywords[@scheme='uva-form']">
        <xsl:apply-templates select="keywords[@scheme='uva-form']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="ancestor::teiHeader/@type = 'migrated'"/>
          <!-- uva-form not required for migrated headers -->
          <xsl:otherwise>
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg">No &lt;keywords&gt; using scheme "uva-form" in profileDesc/textClass</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

    <!-- test for <textClass><keywords scheme="uva-etc"><term>LCSH</term>
         (EAF headers) as it is not a valid term; Erin Stalberg has asked
         us to exclude it -->
    <xsl:if test="keywords[@scheme='uva-etc']/term='LCSH'">
      <xsl:call-template name="outputMsg">
        <xsl:with-param name="msg">&lt;term&gt;LCSH&lt;/term&gt; is not allowed within &lt;keywords scheme="uva-etc"&gt;; remove it</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="keywords">
    <!-- must contain exactly one <term> -->
    <xsl:choose>
      <xsl:when test="count(term) = 1">
        <!-- content of <term> must be one of the predefined allowable values -->
        <xsl:choose>
          <xsl:when test="ancestor::TEI.2">
            <!-- allowable terms for TEI.2 documents -->
            <xsl:choose>
              <xsl:when test="term='article'"/>
              <xsl:when test="term='broadside'"/>
              <xsl:when test="term='manuscript'"/>
              <xsl:when test="term='monograph'"/>
              <xsl:when test="term='monographic volume'"/>
              <xsl:when test="term='newspaper issue'"/>
              <xsl:when test="term='periodical issue'"/>
              <xsl:when test="term='periodical volume'"/>
              <xsl:when test="term='selection'"/>
              <xsl:when test="term='serial volume'"/>
              <xsl:otherwise>
                <xsl:call-template name="outputMsg">
                  <xsl:with-param name="msg">&lt;term&gt; must be one of: article, broadside, manuscript, monograph, monographic volume, newspaper issue, periodical issue, periodical volume, serial volume</xsl:with-param>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="ancestor::standaloneHeader">
            <!-- allowable terms for standalone header documents -->
            <xsl:choose>
              <xsl:when test="term='monographic set'"/>
              <xsl:when test="term='newspaper'"/>
              <xsl:when test="term='periodical'"/>
              <xsl:when test="term='serial'"/>
              <xsl:otherwise>
                <xsl:call-template name="outputMsg">
                  <xsl:with-param name="msg">&lt;term&gt; must be one of: monographic set, newspaper, periodical, serial</xsl:with-param>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg">File is neither a &lt;TEI.2&gt; document nor a &lt;standaloneHeader&gt; document</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="outputMsg">
          <xsl:with-param name="msg">&lt;keywords&gt; for scheme "uva-form" must contain exactly one &lt;term&gt;</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

    <!-- for a non-standalone header, if term is anything other than
         monograph | manuscript | selection, one or more <biblScope> elements
         is required to indicate the scope of this particular
         monographic volume, newspaper issue, etc. -->
    <xsl:if test="not(ancestor::standaloneHeader)">
      <xsl:choose>
        <xsl:when test="term='monograph'"/>
        <xsl:when test="term='manuscript'"/>
        <xsl:when test="term='selection'"/>

        <xsl:when test="term='newspaper issue'">
          <!-- 3 biblScope elements are required, for volume, issue, and date -->
          <!-- volume -->
          <xsl:choose>
            <xsl:when test="ancestor::teiHeader/fileDesc/titleStmt/biblScope[@type='volume']">
              <xsl:if test="not(ancestor::teiHeader/fileDesc/titleStmt/biblScope[@type='volume']/num/@value)">
                <xsl:call-template name="outputMsg">
                  <xsl:with-param name="msg">&lt;num value="..."&gt; is required within &lt;biblScope type="volume"&gt;</xsl:with-param>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">newspaper issue: &lt;biblScope type="volume"&gt; is required within fileDesc/titleStmt</xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="ancestor::teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/biblScope[@type='volume']">
              <xsl:if test="not(ancestor::teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/biblScope[@type='volume']/num/@value)">
                <xsl:call-template name="outputMsg">
                  <xsl:with-param name="msg">&lt;num value="..."&gt; is required within &lt;biblScope type="volume"&gt;</xsl:with-param>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">newspaper issue: &lt;biblScope type="volume"&gt; is required within fileDesc/sourceDesc/biblFull/titleStmt</xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>

          <!-- issue -->
          <xsl:choose>
            <xsl:when test="ancestor::teiHeader/fileDesc/titleStmt/biblScope[@type='issue']">
              <xsl:if test="not(ancestor::teiHeader/fileDesc/titleStmt/biblScope[@type='issue']/num/@value)">
                <xsl:call-template name="outputMsg">
                  <xsl:with-param name="msg">&lt;num value="..."&gt; is required within &lt;biblScope type="issue"&gt;</xsl:with-param>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">newspaper issue: &lt;biblScope type="issue"&gt; is required within fileDesc/titleStmt</xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="ancestor::teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/biblScope[@type='issue']">
              <xsl:if test="not(ancestor::teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/biblScope[@type='issue']/num/@value)">
                <xsl:call-template name="outputMsg">
                  <xsl:with-param name="msg">&lt;num value="..."&gt; is required within &lt;biblScope type="issue"&gt;</xsl:with-param>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">newspaper issue: &lt;biblScope type="issue"&gt; is required within fileDesc/sourceDesc/biblFull/titleStmt</xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>

          <!-- date -->
          <xsl:choose>
            <xsl:when test="ancestor::teiHeader/fileDesc/titleStmt/biblScope[@type='date']">
              <xsl:if test="not(ancestor::teiHeader/fileDesc/titleStmt/biblScope[@type='date']/date/@value)">
                <xsl:call-template name="outputMsg">
                  <xsl:with-param name="msg">&lt;date value="..."&gt; is required within &lt;biblScope type="date"&gt;</xsl:with-param>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">newspaper issue: &lt;biblScope type="date"&gt; is required within fileDesc/titleStmt</xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="ancestor::teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/biblScope[@type='date']">
              <xsl:if test="not(ancestor::teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/biblScope[@type='date']/date/@value)">
                <xsl:call-template name="outputMsg">
                  <xsl:with-param name="msg">&lt;date value="..."&gt; is required within &lt;biblScope type="date"&gt;</xsl:with-param>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="outputMsg">
                <xsl:with-param name="msg">newspaper issue: &lt;biblScope type="date"&gt; is required within fileDesc/sourceDesc/biblFull/titleStmt</xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:otherwise>
          <!-- test for one or more <biblScope> elements -->
          <xsl:if test="not(ancestor::teiHeader/fileDesc/titleStmt/biblScope)">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg">
                <xsl:value-of select="concat('This is a ', term, ', so there should be one or more biblScope elements within fileDesc/titleStmt')"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="not(ancestor::teiHeader/fileDesc/sourceDesc/biblFull/titleStmt/biblScope)">
            <xsl:call-template name="outputMsg">
              <xsl:with-param name="msg">
                <xsl:value-of select="concat('This is a ', term, ', so there should be one or more biblScope elements within fileDesc/sourceDesc/biblFull/titleStmt')"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="title">
    <xsl:if test="@n='245|c'">
      <xsl:call-template name="outputMsg">
        <xsl:with-param name="msg">&lt;title n="245|c" type="resp"&gt; should not be used; use &lt;respStmt&gt; instead</xsl:with-param>
        <xsl:with-param name="type">W</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

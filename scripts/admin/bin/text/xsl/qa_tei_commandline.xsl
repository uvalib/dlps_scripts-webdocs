<?xml version='1.0'?>

<!--

  qa_tei_commandline.xsl - XSLT stylesheet for markup QA of TEI texts
    from the Unix command line.

  Intended to be run from the command line; output is text, not XML or HTML.

  Greg Murray <gpm2a@virginia.edu>
  Digital Library Production Services, University of Virginia Library
  Written: 2004-12-07
  Last modified: 2006-01-12

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon">

<!-- INCLUDES -->
<xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_globals.xsl"/>
<xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_corr.xsl"/>
<xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_empty.xsl"/>
<xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_foreign.xsl"/>
<xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_misc.xsl"/>
<xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_notes.xsl"/>
<xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_pb.xsl"/>
<xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_structure.xsl"/>
<xsl:import href="http://pogo.lib.virginia.edu/dlps/xsl/qa_lib_tables.xsl"/>


<!-- OUTPUT -->
<xsl:output method="text"/>


<!-- PARAMETERS -->
<xsl:param name="filename"/>
<xsl:param name="errorsOnly"/>
<xsl:param name="finalization"/>
<xsl:param name="all"/>

<xsl:param name="corr"/>
<xsl:param name="empty"/>
<xsl:param name="foreign"/>
<xsl:param name="misc"/>
<xsl:param name="notes"/>
<xsl:param name="pb"/>
<xsl:param name="structure"/>
<xsl:param name="tables"/>


<!-- TOP-LEVEL TEMPLATE -->
<xsl:template match="/">

    <xsl:if test="$structure or $all">
        <xsl:apply-templates mode="structure"/>
    </xsl:if>

    <xsl:if test="$notes or $all">
        <xsl:apply-templates mode="notes"/>
    </xsl:if>

    <xsl:if test="$tables or $all">
        <xsl:apply-templates mode="tables"/>
    </xsl:if>

    <xsl:if test="$foreign or $all">
        <xsl:apply-templates mode="foreign"/>
    </xsl:if>

    <xsl:if test="$corr or $all">
        <xsl:apply-templates mode="corr"/>
    </xsl:if>

    <xsl:if test="$empty or $all">
        <xsl:apply-templates mode="empty"/>
    </xsl:if>

    <xsl:if test="$pb or $all">
        <xsl:apply-templates mode="pb"/>
    </xsl:if>

    <xsl:if test="$misc or $all">
        <xsl:apply-templates mode="misc"/>
    </xsl:if>

</xsl:template>

<!-- These templates prevent unwanted newlines in the output -->
<xsl:template match="text()" mode="corr"/>
<xsl:template match="text()" mode="empty"/>
<xsl:template match="text()" mode="foreign"/>
<xsl:template match="text()" mode="misc"/>
<xsl:template match="text()" mode="notes"/>
<xsl:template match="text()" mode="pb"/>
<xsl:template match="text()" mode="structure"/>
<xsl:template match="text()" mode="tables"/>

</xsl:stylesheet>

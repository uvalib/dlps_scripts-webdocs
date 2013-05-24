#!/usr/bin/perl -w

# controls.pl - provides banner page containing HTML controls for DLPS Proofreader application

# Greg Murray <gpm2a@virginia.edu>
# Written: 2002-07-03
# Last modified: 2009-04-28

# Edited by Andrew Curley
# Date: 2009-04-28
# Change: Altered the expected file extension from gif to jpg.  This reflects a change in workflow
# adopted by DSSR to create jpg files for vedor TEI markup rather than gifs.  If this needs to be changed
# in the future, please change back.


use strict;
use CGI 'param';
require '/www/cgi-dlps/common.pl';

my ($img, $entity, $number, $pagelist, $regex);

$img = param('img') or $img = "1";

my $id = param('id');
my $view = param('view') || '';

# read XML file; build drop-down list of pages
open(IN, "$common::proofreaderImagesPath/$id/$id.xml")
    or common::print_error("Cannot open file '$common::proofreaderImagesPath/$id/$id.xml' for reading: $!");
while (<IN>) {
    if ( /<pb/ ) {
	if ( /<pb[^>]*entity=["']([^"']+)["']/ ) {
	    $entity = $1;
	} else {
	  common::print_error("Page breaks do not have required 'entity' attribute.");
	}

	if ( /<pb[^>]*n=["']([^"']+)["']/ ) {
	    $number = $1;
	} else {
	    $number = "";
	}

	$pagelist .= "<option value='$entity'>$entity";
	if ($number) { $pagelist .= " = $number"; }
	$pagelist .= "\n";
    }
}
close IN;

$regex = '/^\d{1,4}$/';

# print HTML
print <<EOD;
Content-type: text/html

<html>
<head>
<script language="JavaScript" type="text/javascript">
function jump() {
    var pageid = document.frm.pagelist.options[document.frm.pagelist.selectedIndex].value;
    var markup_view = document.frm.markupview.options[document.frm.markupview.selectedIndex].value;

    top.img.document.pageimage.src = "$common::proofreaderImagesUrl/$id/" + pageid + ".jpg";

    refresh_text(pageid, markup_view);
}

function refresh_text(pageid, markup_view) {
    if (markup_view == "3") {
	top.text.location = "$common::proofreaderImagesUrl/$id/$id.html#" + pageid;
    } else if (markup_view == "4") {
	// should already be on blank.html, so do nothing
    } else {
	top.text.location = "proof.pl?id=$id&img=" + pageid + 
	    "&markupview=" + markup_view;
    }
}

function clickJumpButton() {
    var value = document.frm.jumpbox.value;
    var regex = $regex;

    if (regex.test(value)) {
	if (value <= document.frm.pagelist.length && value > 0) {
	    document.frm.pagelist.selectedIndex = value - 1;
	    jump();
	} else {
	    alert("Page sequence number is out of range.");
	}
    } else {
	alert("Page image must be a number (1 to 4 digits).");
    }

    document.frm.jumpbox.select();
}

function changeMarkupView() {
    var pageid = document.frm.pagelist.options[document.frm.pagelist.selectedIndex].value;
    var markup_view = document.frm.markupview.options[document.frm.markupview.selectedIndex].value;

    if (markup_view == "3") {
	// markup view option is "3" for "Formatted Text"; go to HTML page with named anchor
	top.text.location = "$common::proofreaderImagesUrl/$id/$id.html#" + pageid;
    } else if (markup_view == "4") {
	// markup view option is "4" for "None (images only)"; go to blank HTML page
	top.text.location = "$common::proofreaderHtmlUrl/blank.html";
    } else {
	// show markup; go to proof.pl
	top.text.location = "proof.pl?id=$id&img=" + pageid + 
	    "&markupview=" + markup_view;
    }
}

function change_border() {
    if (document.frm.border.checked) {
        top.img.document.pageimage.border = 2;
    } else {
        top.img.document.pageimage.border = 0;
    }
}

function loaded() {
    document.frm.pagelist.focus();

    // refresh text display
    var pageid = document.frm.pagelist.options[document.frm.pagelist.selectedIndex].value;
    var markup_view = document.frm.markupview.options[document.frm.markupview.selectedIndex].value;
    refresh_text(pageid, markup_view);
}
</script>
<style>
    body, p, td, select, input {
	font-family: Verdana;
	font-size: 10pt;
    }
</style>
</head>
<body onLoad="loaded();">
<form name="frm"  onSubmit="clickJumpButton(); return false;">
<table width="100%">
<tr>
<td><a href="start.pl?oldId=$id&view=$view" target="_top">Select New ID</a></td>
<td align="right"><a href="$common::proofreaderHtmlUrl/help/help.html" target="text">Help</a></td>
</tr>
</table>
<table>
<tr>
<td align="right">Text:</td>
<td colspan="2">
<select name="markupview" onChange="changeMarkupView();">
<option value="2">Markup Highlighted
<option value="1" selected>Markup Dimmed
<option value="0">Markup Hidden
<!--<option value="3">Formatted Text-->
<option value="4">None (images only)
</select>
</td>
</tr>

<tr>
<td align="right">Image:</td>

<td>
<select name="pagelist" onChange="jump();">
$pagelist
</select>
</td>

<td>
&nbsp;&nbsp;
<input type="text" name="jumpbox" size="5">
<input type="submit" name="jumpbutton" value="Jump to Image">
</td>
</tr>

<tr>
<td colspan="3">Show border: <input type="checkbox" name="border" onClick="change_border();"></td>
</tr>
</table>
</form>
</body>
</html>
EOD

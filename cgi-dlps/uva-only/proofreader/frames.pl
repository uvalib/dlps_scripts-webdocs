#!/usr/bin/perl

# frames.pl - start page for DLPS Proofreader application

# Greg Murray <gpm2a@virginia.edu>
# Written: 2002-07-03
# Last modified: 2009-04-28

# Modified by: Andrew Curley
# Date: 2009-04-28
# Change: Altered the expected file extension from gif to jpg.  This reflects a change in workflow
# adopted by DSSR to create jpg files for vedor TEI markup rather than gifs.  If this needs to be changed
# in the future, please change back.


# If id argument, validate id; if id ok, show frameset.
# If no id argument, show form for entering DLPS item id.

use strict;
use CGI 'param';
require '/www/cgi-dlps/common.pl';

my $title = 'DLPS Proofreader';

my $id = param('id');
my $view = param('view') || '';

if ($id) {
    common::check_id($id);
    if (not -e "$common::proofreaderImagesPath/$id/$id.xml") {
	common::print_error("The XML file for ID $id is not available.");
    }
    print_frames();
} else {
    print_form();
}

#----------------------------------------------------------------------

sub print_form {
    my ($name, $path, %dirs, $dirlist);

    # build list of available proofreading directories
    opendir(DIR, $common::proofreaderImagesPath)
	or common::print_error("Cannot read directory '$common::proofreaderImagesPath': $!");
    while ($name = readdir(DIR)) {
	next if ( $name =~ /^\./ );
	$path = "$common::proofreaderImagesPath/$name";
	#if (-d $path and $name =~ /^[bz]\d{9}$/) {
	if (-d $path) {
	    $dirs{$name} = '';
	}
    }
    closedir DIR;

    foreach $name (sort(keys(%dirs))) {
	$dirlist .= "<option value='$name'>$name\n";
    }

    $dirlist = "<select name='id' size='10'>\n" . $dirlist;
    $dirlist .= "</select>\n";

    print <<EOD;
Content-type: text/html

<html>
<head>
<title>$title</title>
<style>
    body, p, td, select, input {
	font-family: Verdana;
	font-size: 10pt;
    }
</style>
</head>
<body onLoad="document.frm.id.focus();">
<h2>DLPS Proofreader</h2>
<form name="frm" method="post">
<table>
<tr>
<td align="right" valign="top">DLPS item ID:</td>
<td>
<!--<input type="text" name="id">-->
$dirlist
</td>
</tr>
<tr>
<td>&nbsp;</td>
<td><input type="submit" value="Continue"></td>
</tr>
</table>
</form>
</body>
</html>
EOD
}

#----------------------------------------------------------------------

sub print_frames {
    print <<EOD;
Content-type: text/html

<html>
<head>
<title>$title</title>
<script language="JavaScript" type="text/javascript">
function frameset_loaded() {
    // display first image
    controls.document.frm.pagelist.selectedIndex = 0;
    var pageid = controls.document.frm.pagelist.options[0].value;
    img.document.pageimage.src = "$common::proofreaderImagesUrl/$id/" + pageid + ".jpg";

    // turn on image border
    controls.document.frm.border.checked = true;
    controls.document.frm.border.onclick();
}
</script>
</head>
<frameset frameborder="1" cols="50%,50%" onload="frameset_loaded();">
    <frame name="img" src="$common::proofreaderHtmlUrl/image.html">
    <frameset frameborder="1" rows="18%,*">
	<frame name="controls" src="controls.pl?id=$id&view=$view">
	<frame name="text" src="$common::proofreaderHtmlUrl/blank.html">
    </frameset>
</frameset>
</html>
EOD
}

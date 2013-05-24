#!/usr/bin/perl

# imageview.pl - part of the DLPS Proofreader application; allows
#   viewing page images without accompanying XML file

# Greg Murray <gpm2a@virginia.edu>
# Written: 2002-07-03
# Last modified: 2006-01-06

# If id argument, validate id; if id ok, show frameset.
# If no id argument, show form for selecting DLPS item id.

use strict;
use CGI 'param';
require '/www/cgi-dlps/common.pl';

my $title = 'DLPS Image Viewer';

my $id = param('id');
my $view = param('view') || '';

if ($id) {
    common::check_id($id);
    print_frames();
} else {
    print_form();
}

#----------------------------------------------------------------------

sub print_form {
    my ($name, $path, %dirs, $dirlist);

    # build list of available image directories
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
<h2>DLPS Page Image Viewer</h2>
<form name="frm" method="post">
<table>
<tr>
<td align="right" valign="top">DLPS item ID:</td>
<td>
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
</head>
<frameset frameborder="1" cols="20%,*" onLoad="nav.document.frm.filelist.selectedIndex = 0; nav.jump(); nav.change_border(); nav.document.frm.filelist.focus();">
  <frame name="nav" src="nav.pl?id=$id&view=$view">
  <frame name="content" src="$common::proofreaderHtmlUrl/image.html">
</frameset>
</html>
EOD
}

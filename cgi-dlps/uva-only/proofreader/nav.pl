#!/usr/bin/perl

# nav.pl - navigation page for DLPS Image Viewer web-based
#   application; displays list of image files available for viewing

# Greg Murray <gpm2a@virginia.edu>
# Written: 2002-07-03
# Last modified: 2006-01-06

use strict;
use CGI 'param';
require '/www/cgi-dlps/common.pl';

my $regex = '/^\d{1,4}$/';

my $id = param('id');
my $view = param('view') || '';

if (not $id) {
    common::print_error("No image directory selected for viewing");
}

my ($name, %files, $filelist);

# build list of image files
opendir(DIR, "$common::proofreaderImagesPath/$id")
    or common::print_error("Cannot read directory '$common::proofreaderImagesPath/$id': $!");
foreach $name (readdir DIR) {
    if ( $name =~ /(\.gif|\.jpe?g)$/ and not $name =~ /^\./ ) {
	$files{$name} = "";
    }
}
closedir DIR;

foreach $name (sort(keys(%files))) {
    $filelist .= "<option value='$name'>$name\n";
}

print <<EOD;
Content-type: text/html

<html>
<head>
<link rel="stylesheet" type="text/css" href="/dlps/css/proofreader_nav.css">
<script language="JavaScript">
function change_border() {
    if (document.frm.border.checked) {
	parent.content.document.pageimage.border = 2;
    } else {
	parent.content.document.pageimage.border = 0;
    }
}

function clickJumpButton() {
    var value = document.frm.jumpbox.value;
    var regex = $regex;

    if (regex.test(value)) {
        if (value <= document.frm.filelist.length && value > 0) {
            document.frm.filelist.selectedIndex = value - 1;
            jump();
        } else {
            alert("Page sequence number is out of range.");
        }
    } else {
        alert("Page image must be a number (1 to 4 digits).");
    }

    document.frm.jumpbox.select();
}

function jump() {
    var filename = document.frm.filelist.options[document.frm.filelist.selectedIndex].value;
    parent.content.document.pageimage.src = "$common::proofreaderImagesUrl/$id/" + filename;
}
</script>
</head>
<!--<body onLoad="document.frm.filelist.selectedIndex = 0; jump(); change_border(); document.frm.filelist.focus();">-->
<body>
<form name="frm" onSubmit="clickJumpButton(); return false;">
<table>
<tr>
<td><a href="start.pl?oldId=$id&view=$view" target="_top">Select New ID</a></td>
</tr><tr>
<td><a href="$common::proofreaderHtmlUrl/help/help_imageview.html" target="proofreader_help">Help</a></td>
</tr><tr>
<td>&nbsp;</td>
</tr><tr>
<td>
<select name="filelist" size="10" onChange="jump();">
$filelist
</select>
</td>
</tr><tr>
<td>
<input type="text" name="jumpbox" size="5">
<input type="submit" name="jumpbutton" value="Jump">
</td>
</tr><tr>
<td>Show border: <input type="checkbox" name="border" onClick="change_border();" checked></td>
</tr>
</table>
</form>
</body>
</html>
EOD

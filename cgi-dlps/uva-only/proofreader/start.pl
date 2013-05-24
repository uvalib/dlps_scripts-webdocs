#!/usr/bin/perl -w

# start.pl - start page for DLPS Proofreader application; allows
#   either searching for a DLPS ID or picking one from a list

# Greg Murray <gpm2a@virginia.edu>
# Written: 2004-07-22
# Last modified: 2006-01-06

# If id argument, look for that ID in data directory and redirect to
# it if found; if no id argument, show search form and picklist.

use strict;
use CGI 'param';
require '/www/cgi-dlps/common.pl';

my $id = param('id');
my $view = param('view') || '';
my $oldId = param('oldId') || '';

my ($lead, $digits, $location, $selected, $checkedImages, $checkedBoth);

if ($id) {
    # for DLPS IDs starting with 'b' or 'z', supply leading zeros as needed
    if ( $id =~ /^(b|z)(\d+)/ ) {
	$lead = $1;
	$digits = $2;
	if ( length($digits) < 9 ) {
	    # format as 9 digits; use 0 as padding character
	    $digits = sprintf('%09d', $digits);
	    $id = $lead . $digits;
	}
    }

    common::check_id($id);

    # redirect browser
    if ( $view eq 'images' ) {
	$location = "imageview.pl?id=$id&view=$view";
    } else {
	$location = "frames.pl?id=$id&view=$view";
    }
    print "Location: $location\n\n";

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
	if ($name eq $oldId) { $selected = ' selected'; } else { $selected = ''; }
        $dirlist .= "<option value='$name'$selected>$name\n";
    }

    $dirlist = "<select name='id' size='10'>\n" . $dirlist;
    $dirlist .= "</select>\n";

    if ($view eq 'images') {
	$checkedImages = ' checked';
	$checkedBoth = '';
    } else {
	$checkedImages = '';
	$checkedBoth = ' checked';
    }

    print <<EOD;
Content-type: text/html

<html>
<head>
<title>DLPS Proofreader</title>
<link rel="stylesheet" type="text/css" href="/dlps/css/proofreader_content.css">
</head>
<body onload="document.frm1.id.select();">
<h2>DLPS Proofreader</h2>

<p>Either enter a DLPS ID, or select one from the list provided.</p>

<p><b>TIP:</b> When entering an ID, leading zeros will be supplied for
you. For example, entering z123 actually searches for z000000123.</p>

<form name="frm1" method="POST">
<table cellpadding="6">
<tr>
<td align="right">DLPS ID:</td>
<td><input type="text" name="id" value="$oldId"></td>
</tr>
<tr>
<td colspan="2" align="right"><input type="submit" value="Search"></td>
</tr>
</table>
<p><input type="radio" name="view" value="both"$checkedBoth> View text and images
<br><input type="radio" name="view" value="images"$checkedImages> View images only</p>
</form>

<hr>

<form name="frm2" method="POST">
<table>
<tr>
<td align="right" valign="top">DLPS ID:</td>
<td>
$dirlist
</td>
</tr>
<tr>
<td>&nbsp;</td>
<td><input type="submit" value="View"></td>
</tr>
</table>
<p><input type="radio" name="view" value="both"$checkedBoth> View text and images
<br><input type="radio" name="view" value="images"$checkedImages> View images only</p>
</form>

</body>
</html>
EOD
}

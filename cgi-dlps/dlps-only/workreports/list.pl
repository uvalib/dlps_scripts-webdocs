#!/usr/bin/perl

# list.pl - report-listing page for DLPS work reports

# Greg Murray <gpm2a@virginia.edu>
# Written: 2006-01-06
# Last modified: 2006-01-06

# Lists HTML files in specified directory as a series of hyperlinks.

#======================================================================
# main logic
#======================================================================

use strict;
use CGI 'param';
require '/www/cgi-dlps/common.pl';

common::print_error("'$common::workreportsPath' is not a directory") if (! -d $common::workreportsPath);

my $path = $common::workreportsPath;

my $title = 'DLPS Work Reports';

my ($type, $filename, $filepath, %files, %filesizes, $id, $i, $class);
my (@stat, $bytes, $unit, $value);

# print start of HTML page
print <<EOD;
Content-type: text/html

<html>
<head>
<title>$title</title>
<link rel="stylesheet" type="text/css" href="/dlps/css/markupQA.css">
</head>
EOD

$type = param('type');
if ($type) {
    displayList();
} else {
    displayTOC();
}

print "<html>\n";


#======================================================================
# subroutines
#======================================================================

sub displayTOC {

    # display a table of contents with a link for each type of report

    print <<EOD;
<body>
<h1>$title</h1>

<ul>
<li><a href="list.pl?type=rehyphenate">Rehyphenate</a></li>
<li><a href="list.pl?type=unclears">Unclears</a></li>
<li><a href="list.pl?type=figures_rend">Figures: Rendering</a></li>
<li><a href="list.pl?type=figures_filenames">Figures: Filenames</a></li>
</ul>

<hr>
<p><a href="list.pl?type=review">Items for further review</a></p>
</body>
EOD
}

#----------------------------------------------------------------------

sub displayList {

    # display a list of HTML files

    my ($subtitle, $href);

    my $url = "$common::workreportsUrl/$type";
    $path .= "/$type";

    # determine page subtitle for display
    if ($type eq 'figures_filenames') {
	$subtitle = 'Figures: Filenames';
    } elsif ($type eq 'figures_rend') {
	$subtitle = 'Figures: Rendering';
    } elsif ($type eq 'rehyphenate') {
	$subtitle = 'Rehyphenate';
    } elsif ($type eq 'unclears') {
	$subtitle = 'Unclears';
    } elsif ($type eq 'review') {
	$subtitle = 'Items for further review';
    } else {
	$subtitle = $type;
    }

    # build list of HTML files
    opendir(DIR, $path) || common::print_error("Cannot open directory '$path' for reading: $!");
    while ($filename = readdir(DIR)) {
	$filepath = "$path/$filename";

	if (-f $filepath and $filename =~ /\.(html|review)$/) {
	    # get ID for display
	    if ( $filename =~ /^(\w+\.\w+)\.review$/ ) {
		$id = $1;
	    } elsif ( $filename =~ /^(\w+)\./ ) {
		$id = $1;
	    } else {
		$id = $filename;
	    }

	    $files{$filename} = $id;

	    # get file size in bytes
	    @stat = stat($filepath);
	    $bytes = $stat[7];

	    # convert to most convenient/readable unit of measure
	    if ($bytes >= 1048576) {
		$unit = 'MB';
		$value = $bytes / 1048576;
		$value = sprintf("%.1f", $value);   # round to 1 decimal place
	    } elsif ($bytes >= 1024) {
		$unit = 'KB';
		$value = $bytes / 1024;
		$value = sprintf("%d", $value);     # round to integer
	    } else {
		$unit = 'bytes';
		$value = $bytes;
	    }

	    $filesizes{$filename} = "$value $unit";
	}
    }
    closedir DIR;

    print <<EOD;
<body>
<h1>$title</h1>
<h2>$subtitle</h2>
<table cellpadding="6" cellspacing="0" class="listing">
<tr class="head"><td>Report ID</td><td>Size</td></tr>
EOD

    # print one table row for each file
    $i = 1;
    foreach $filename (sort(keys(%files))) {
	$href = "$url/$filename";

	if ($i%2 == 0) { $class = " class='hiRow'"; } else { $class = ''; }
	print "<tr$class><td class='listing'><a href='$href'>$files{$filename}</a></td>";
	print "<td class='listing' align='right'>$filesizes{$filename}</td></tr>\n";
	$i++;
    }

    print <<EOD;
</table>
</body>
EOD

}  # END sub displayList

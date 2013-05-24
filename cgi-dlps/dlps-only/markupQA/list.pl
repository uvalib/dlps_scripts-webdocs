#!/usr/bin/perl -w

# list.pl - start page for DLPS markup QA reports

# Greg Murray <gpm2a@virginia.edu>
# Written: 2003-05-22
# Last modified: 2006-01-05

# Lists XML files in specified directory as a series of hyperlinks
# (namely, links to a URL for dynamically generating HTML reports on
# markup features for internal QA purposes).


use strict;
use CGI 'param';
require '/www/cgi-dlps/common.pl';

my ($filename, $filepath, %files, $title, $url, $i, $class);
my ($structure, $notes, $tables, $foreign, $corr, $empty, $pb, $misc, $all);
my ($temp, $in_fileDesc, $in_sourceDesc);

common::print_error("'$common::xmlPath' is not a directory") if (! -d $common::xmlPath);

# get parameters
$structure = param('structure');
$notes = param('notes');
$tables = param('tables');
$foreign = param('foreign');
$corr = param('corr');
$empty = param('empty');
$pb = param('pb');
$misc = param('misc');

if ($structure or $notes or $tables or $foreign or $corr or $empty or $pb or $misc) {
    $all = 0;
} else {
    $all = 1;
}

# build list of XML files
opendir(DIR, $common::xmlPath)
    || common::print_error("Cannot open directory '$common::xmlPath' for reading: $!");
while ($filename = readdir(DIR)) {
    $filepath = "$common::xmlPath/$filename";

    if (-f $filepath and $filename =~ /\.xml$/) {
	# read TEI XML file; get title and author
	open(TEI, $filepath) || common::print_error("Cannot read file '$filepath': $!");
        $in_fileDesc = 0;
        $in_sourceDesc = 0;
	$title = '';
	while (<TEI>) {
            if ( /<fileDesc/ ) { $in_fileDesc = 1; }
            if ( /<sourceDesc/ ) { $in_sourceDesc = 1; }

            # get title from teiHeader/fileDesc/titleStmt
            if ($in_fileDesc and not $in_sourceDesc) {
                if ( /<title(>| [^>]*?>)([^<]*)/ ) {
                    $temp = $2;
                    if (not /<\/title>/) { chomp $temp; $temp .= '...'; }
                    if ($title) {
                        $title .= ' / ' . $temp;
                    } else {
                        $title = $temp;
                    }
                }
            }

            if ( /<\/sourceDesc>/ ) { $in_sourceDesc = 0; }
            if ( /<\/fileDesc>/ ) { $in_fileDesc = 0; }

	    last if ( /<\/teiHeader>/ );
	}
	close TEI;

	$files{$filename} = $title;
    }
}
closedir DIR;

# print start of HTML page
print <<EOD;
Content-type: text/html

<html>
<head>
<title>DLPS Markup QA Programs</title>
<link rel="stylesheet" type="text/css" href="/dlps/css/markupQA.css">
</head>
<body>
<h1>DLPS Markup QA Programs</h1>
<table cellpadding="6" cellspacing="0" class="listing">
<tr class="head"><td>Filename</td><td>Title</td></tr>
EOD

# print one table row for each XML file
$i = 1;
foreach $filename (sort(keys(%files))) {
    $url = 'http://pogo.lib.virginia.edu/cgi-dlps/saxon/SaxonCGI.pl';
    $url .= '?source=http://pogo.lib.virginia.edu/dlps/xml/' . $filename;
    $url .= '&style=http://pogo.lib.virginia.edu/dlps/xsl/qa_tei_html.xsl';
    $url .= '&filename=' . $filename;

    $url .= '&all=1'       if $all;
    $url .= '&structure=1' if $structure;
    $url .= '&notes=1'     if $notes;
    $url .= '&tables=1'    if $tables;
    $url .= '&foreign=1'   if $foreign;
    $url .= '&corr=1'      if $corr;
    $url .= '&empty=1'     if $empty;
    $url .= '&pb=1'        if $pb;
    $url .= '&misc=1'      if $misc;

    if ($i%2 == 0) { $class = " class='hiRow'"; } else { $class = ''; }
    print "<tr$class><td class='listing'><a href='$url'>$filename</a></td>";
    print "<td class='listing'>$files{$filename}</td></tr>\n";
    $i++;
}

# print end of HTML page
print <<EOD;
</table>
</body>
</html>
EOD

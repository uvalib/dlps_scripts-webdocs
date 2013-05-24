#!/usr/bin/perl -w

# list.pl - start page for TEI Preview, a DLPS in-house web-based tool
# for previewing TEI texts for QA purposes

# Greg Murray <gpm2a@virginia.edu>, Ethan Gruber <ewg4x@virginia.edu>
# Written: 2003-05-08
# Last modified: 2008-07-09

# Lists XML files in specified directory as a series of hyperlinks
# (namely, links to a URL for dynamically performing XSLT
# transformation of TEI XML to HTML for web display).

#This was modified 2008-07-09 by Ethan Gruber to add the DL View simulation,
#which is a link that runs saxon with a slightly mofified version of the TEI
#stylesheet used by the current Fedora interface to simulate the way
#that the file will look in Fedora.

use strict;
require '/www/cgi-dlps/common.pl';

my ($filename, $path, $docid, %files, $in_fileDesc, $in_sourceDesc, $title);
my ($temp, $image_ext, $url, $i, $class, $dtd, $repo_url);
my %paths;

common::print_error("'$common::xmlPath' is not a directory") if (! -d $common::xmlPath);

# build list of XML files
opendir(DIR, $common::xmlPath) || common::print_error("Cannot read directory '$common::xmlPath': $!");
while ($filename = readdir(DIR)) {
    $path = "$common::xmlPath/$filename";
    if (-f $path and $filename =~ /^(.*?)\.xml$/) {
	# determine document ID; default to filename without .xml extension, but use [bz]\d{9} if available
	$docid = $1;
	if ( $filename =~ /[bz]\d{9}/ ) {
	    $docid = $&;
	}

	# read TEI XML file; get title and page-images type (bitonal or color)
	open(TEI, $path) || common::print_error("Cannot read file '$path': $!");
	$in_fileDesc = 0;
	$in_sourceDesc = 0;
	$title = '';
	$image_ext = '.gif';
	$dtd = '';
	while (<TEI>) {
	    # get page-images type (bitonal or color)
	    if ( /<\?dlps [^>]*page-images=("|')([^\1]+?)\1/ ) {
		if ($2 eq 'color') {
		    $image_ext = '.jpg';
		}
	    }

            # get name of DTD (base filename of extension files, e.g. "uva-dl-tei" or "teitech")
            if ( /<!ENTITY % TEI\.extensions\.dtd SYSTEM ("|')[^\1]+\/([\w\-]+)\.dtd\1/ ) {
                $dtd = $2;
            }

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

	$files{$filename} = "$title|$docid|$image_ext|$dtd";
    }
}
closedir DIR;

# print start of HTML page
print <<EOD;
Content-type: text/html

<html>
<head>
<title>DLPS TEI Preview</title>
<link rel="stylesheet" type="text/css" href="/dlps/css/markupQA.css">
</head>
<body>
<h1>DLPS TEI Preview</h1>
<p><a href="/dlps/dlps-only/preview/about.html">About TEI Preview</a></p>
<table cellpadding="6" cellspacing="0" class="listing">
<tr class="head">
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>Filename</td>
  <td>Title</td>
</tr>
EOD

# print one table row for each XML file
$i = 1;
foreach $filename (sort(keys(%files))) {
    ($title, $docid, $image_ext, $dtd) = split(/\|/, $files{$filename});
    $url = 'http://pogo.lib.virginia.edu/cgi-dlps/saxon/SaxonCGI.pl';
    $url .= '?source=http://pogo.lib.virginia.edu/dlps/xml/' . $filename;
    $url .= '&style=http://pogo.lib.virginia.edu/dlps/xsl/tei_preview.xsl';
    $url .= '&docid=' . $docid;
    $url .= '&filename=' . $filename;
    $url .= '&image_ext=' . $image_ext;
    #$url .= '&dtd=' . $dtd;

    #build the repo_url, which contains a different stylesheet call.
    $repo_url = 'http://pogo.lib.virginia.edu/cgi-dlps/saxon/SaxonCGI.pl';
    $repo_url .= '?source=http://pogo.lib.virginia.edu/dlps/xml/' . $filename;
    $repo_url .= '&style=http://pogo.lib.virginia.edu/dlps/xsl/tei_dl.xsl';

    if ($i%2 == 0) { $class = " class='hiRow'"; } else { $class = ''; }
    print "<tr$class>";
    print "<td class='listing'><a href='$url'>Basic&nbsp;view</a></td>";
    print "<td class='listing'><a href='$repo_url'>DL&nbsp;view</a></td>";
    print "<td class='listing'>$filename</td>";
    print "<td class='listing'>$title</td>";
    print "</tr>\n";
    $i++;
}

# print end of HTML page
print <<EOD;
</table>
</body>
</html>
EOD

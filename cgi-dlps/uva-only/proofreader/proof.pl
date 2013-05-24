#!/usr/bin/perl

# proof.pl - text viewing script for DLPS Proofreader application

# Greg Murray <gpm2a@virginia.edu>
# Written: 2002-07-03
# Last modified: 2006-01-06

#===========
# main logic
#===========

use strict;
use CGI 'param';
require '/www/cgi-dlps/common.pl';

my ($id, $img, $markupview, $is_first_img);

$id = param('id');
$img = param('img');
$markupview = param('markupview');  # 0=Markup Hidden, 1=Markup Dimmed, 2=Markup Highlighted
if (not defined($markupview)) { $markupview = 1; }  # set 'Markup Dimmed' as default view
$markupview += 0;  # convert from string to integer

if ($img) {
    load($img);
} else {
    $is_first_img = 1;
    $img = get_first_img();
    load($img);
}

#============
# subroutines
#============

sub get_first_img {
    my $first_img = "";
    my $infile = "$id/$id.xml";
    open(IN, $infile) or common::print_error("Cannot open file '$infile' for reading: $!");
    while (<IN>) {
	if ( /<pb [^>]*entity=["']([^"']+)["']/ ) {
	    $first_img = $1;
	    last;
	}
    }
    close IN;

    if ($first_img) {
	return $first_img;
    } else {
	common::print_error("No page image file is referenced in the markup.");
    }
}

#----------------------------------------------------------------------

sub load {
    my $img = shift;
    my $infile = "$common::proofreaderImagesPath/$id/$id.xml";
    my $page_found= 0; my $prev = 0; my $next = 0;
    my $on_page = 0;
    my $out = '';

    # read the XML file, and grab the content for the page to be displayed
    open(IN, $infile) or common::print_error("Cannot read file '$infile': $!");
    while (<IN>) {
	if ( /<pb [^>]*entity=["']([^"']+)["']/ ) {
	    if ($on_page) {
		# this is the pb immediately following the page to be displayed; exit loop and display page content
		last;
	    } else {
		if ($1 eq $img) {
		    # this is the pb for the page to be displayed
		    $on_page = 1;
		    $out .= $_;
		} else {
		    # this is some page prior to the page to be displayed
		    next;
		}
	    }
	} elsif ($on_page) {
	    # this line is on the page to be displayed; grab line
	    $out .= $_;
	}
    }
    close IN;

    $out = prep_text($out, $markupview);
    print $out;
}

#----------------------------------------------------------------------

sub prep_text {
    # prepares TEI XML content for viewing in web browser
    my $text = shift;
    my $markupview = shift;
    my $style = ""; my $html; my $onload = "";

    # remove line breaks
    #$text =~ s:<lb\s*/>::g;
    #$text =~ s:\|::g;


    # define HTML <style> element
    $style = "<style>\n";
    if ($markupview == 1) {
	# render markup as 'dimmed' using gray color for markup
	$style .= "span.markup { color: #CCCCCC; }\n";
    } elsif ($markupview == 2) {
	# render markup visible using blue color for markup
	$style .= "span.markup { color: #000099; }\n";
    }
    $style .= "body, p, td { font-family: Verdana; font-size: 10pt; }\n";
    $style .= "</style>\n";

    if ($markupview == 1 or $markupview == 2) {
	# render markup using a CSS class
	$text =~ s:<:&html_lt;:g;                           # replace < with &html_lt;
	$text =~ s:>:&html_gt;:g;                           # replace > with &html_gt;
	$text =~ s:&html_lt;:<span class="markup">&lt;:g;   # replace &html_lt; with <span class="markup">&lt;
	$text =~ s:&html_gt;:&gt;</span>:g;                 # replace &html_gt; with &gt;</span>
    } else {
	# strip markup
	$text =~ s/<[^>]+>//g;
    }

    # insert HTML <br> line breaks for readability
    $text =~ s:\n:<br>:g;

    # if this is the first displaying of the page, load the first image
    if ($is_first_img) {
	$onload = " onLoad=\"top.img.location='$id/$img.gif';\"";
    }

    # wrap content in HTML
    $html = <<EOD;
Content-type: text/html

<html>
<head>
$style
</head>
<body$onload>
<p>
$text
</p>
</body>
</html>
EOD

    return $html;
}

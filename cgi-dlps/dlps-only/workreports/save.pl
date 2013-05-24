#!/usr/bin/perl -Tw

# save.pl - saves data from HTML forms to disk in a DLPS-defined
# format; data is later used to make corrections to TEI XML files
# programmatically

# Greg Murray <gpm2a@virginia.edu>
# Written: 2002-01-10
# Last modified: 2006-03-23

# 2004-02-13: gpm2a: Made changes to allow CavDaily_\d{8} IDs (in addition to [bz]\d{9} ones)
#
# 2004-06-04: gpm2a: Allowed cavdaily_\d{8} IDs as well
#
# 2004-09-02: gpm2a: Changed to allow any kind of DLPS ID
#
# 2005-12-29: gpm2a: Changed as needed to work on pogo.lib
#
# 2006-03-23: gpm2a: Changed to update DLPS tracking system -->
# Post-keyboarding Workflow --> Submit [report-type] report
#
# 2006-06-14: gpm2a: Added logic for saving rehyphenation reports: If
# user requests it, save the specified word to the list of known words
# (so that the word won't appear on future rehyphenation reports).


#======================================================================
# main logic
#======================================================================

use strict;
use CGI       qw(param);
use CGI::Carp qw(fatalsToBrowser);
use Fcntl     qw(:flock);

use lib '/www/cgi-dlps/dlps-only/lib';
use TrackSys;
require '/www/cgi-dlps/common.pl';

common::print_error("'$common::workreportsPath' is not a directory") if (! -d $common::workreportsPath);

my $out_path = $common::workreportsPath;
my $out_changes = '';
my $out_review = '';
my $out_dictionary = '';
my $dlpsId = '';

# get parameters, testing for presence of required parameters
my $form_id = param('form_id'); no_param('form_id') if (not $form_id);
my $item_count = param('item_count'); no_param('item_count') if (not $item_count);
my $operator = param('operator'); no_param('operator') if (not $operator);

# validate parameters; if ok, untaint using reg exp backreferences
if ( $form_id =~ /^(.+?)\.(rehyphenate|unclears|figures_rend|figures_filenames)$/ ) {
    $form_id = $1 . '.' . $2;
    $dlpsId = $1;
} else {
    bad_param('form_id', $form_id);
}
if ( $item_count =~ /^(\d{1,4})$/ ) {
    $item_count = $1;
} else {
    bad_param('item_count', $item_count);
}
if ( $operator =~ /^(.+)$/ ) {
    $operator = $1;
} else {
    bad_param('operator', $operator);
}

# set other global variables
my $page_title = $form_id;
my $return_link = '';

# take action based on form type
if ($form_id =~ /\.rehyphenate$/) {
    do_rehyphenate();
} elsif ($form_id =~ /\.unclears$/) {
    do_unclears();
} elsif ($form_id =~ /\.figures_rend$/) {
    do_figures_rend();
} elsif ($form_id =~ /\.figures_filenames$/) {
    do_figures_filenames();
} else {
    common::print_error("Unknown form type.");
}


#======================================================================
# subroutines
#======================================================================

sub bad_param {
    my $name = shift || '[unknown]';
    my $value = shift || '';
    common::print_error("Bad parameter: value '$value' for parameter '$name' is invalid.");
}

#----------------------------------------------------------------------

sub confirm {

    # display confirmation message to user

    my $warning = shift || '';
    my ($output, $output2, $display_changes, $display_dictionary, $display_review);

    if ($out_changes) {
	$output = "<p>The changes were saved successfully.</p>\n";

	$display_changes = $out_changes;
	$display_changes =~ s/&/&amp;/g;
	$display_changes =~ s/</&lt;/g;
	$display_changes =~ s/>/&gt;/g;
	$output .= "<pre>$display_changes</pre>\n";
    } else {
	$output = "<p>No items were selected, so no items were saved.</p>\n";
    }

    if ($out_dictionary) {
	$output .= "<hr>\n";
	$output .= "<p>The following items have been added to the local dictionary"
	    . " (so they won't appear on future reports):</p>\n";

	$display_dictionary = $out_dictionary;
	$display_dictionary =~ s/&/&amp;/g;
	$display_dictionary =~ s/</&lt;/g;
	$display_dictionary =~ s/>/&gt;/g;
	$output .= "<pre>$display_dictionary</pre>\n";
    }

    if ($out_review) {
	$output .= "<hr>\n";
	$output .= "<p>The following items have been marked for further review:</p>\n";

	$display_review = $out_review;
	$display_review =~ s/&/&amp;/g;
	$display_review =~ s/</&lt;/g;
	$display_review =~ s/>/&gt;/g;
	$output .= "<pre>$display_review</pre>\n";
    }

    if ($warning) {
	$output2 = "<p><span style='color: #990000; font-weight: bold;'>WARNING:</span> $warning</p>\n";
    } else {
	$output2 = '';
    }

    print <<EOD;
Content-type: text/html

<html>
<head>
<title>Confirmation: $page_title</title>
<link rel="stylesheet" type="text/css" href="/dlps/css/workreports.css">
</head>
<body>
<h2>Confirmation: $page_title</h2>
<p>$return_link</p>
<p><a href="/cgi-dlps/dlps-only/workreports/list.pl">Return to all reports</a></p>
<hr>
$output
$output2
<hr>
<p>$return_link</p>
<p><a href="/cgi-dlps/dlps-only/workreports/list.pl">Return to all reports</a></p>
</body>
</html>
EOD
}

#----------------------------------------------------------------------

sub do_figures_rend {

    my ($i, $id, $note, $pageimage, $pagenumber, $rend);
    my $warning = '';
    $return_link = '<a href="/cgi-dlps/dlps-only/workreports/list.pl?type=figures_rend">Return to Figures: Rendering reports</a>';

    for ($i = 1; $i <= $item_count; $i++) {
	$note = param("note_$i");

	# untaint parameters
	$id = param("id_$i");
	if ( $id =~ /^([\w\.\-]+)$/ ) { $id = $1; } else { bad_param("id_$i", $id); }

	$rend = param("rend_$i");
	if (not defined($rend)) { no_param("rend_$i"); }
	if ($rend =~ /^(page|block|inline)$/) { $rend = $1; } else { bad_param("rend_$i", $rend); }

	# add item to output for .changes file
	$out_changes .= "$id|$rend\n";

	if ($note) {
	    # item marked as needing further review
	    # untaint parameters
	    if ( $note =~ /^(.*)$/ ) { $note = $1; } else { bad_param("note_$i", $note); }

	    $pagenumber = param("pagenumber_$i");
	    if ( defined($pagenumber) ) {
		if ( $pagenumber =~ /^()$/ or $pagenumber =~ /^(\d+|[ivxlcm]+)$/i ) { $pagenumber = $1; }
                    else { bad_param("pagenumber_$i", $pagenumber); }
	    } else {
		no_param("pagenumber_$i");
	    }

	    $pageimage = param("pageimage_$i");
	    if ( defined($pageimage) ) {
		#if ( $pageimage =~ /^([bz]\d{9}_\d{3,4}|[cC]av[dD]aily_\d{8}_\d{2})(_.+)?$/ ) { $pageimage = $&; }
                #    else { bad_param("pageimage_$i", $pageimage); }
	    } else {
		no_param("pageimage_$i");
	    }

	    # add item to output for .review file
	    $out_review .= "Figure id: $id\n";
	    $out_review .= "Rendering: $rend\n";
	    $out_review .= "Note: $note\n";
	    $out_review .= "Page number: $pagenumber\n";
	    $out_review .= "Page image: $pageimage\n";
	    $out_review .= "\n";
	}
    }

    if ($out_changes) {
	$out_changes = "#operator=$operator\n#datetime=" . scalar(localtime()) . "\n" 
	    . $out_changes;
	save_changes();
    }

    if ($out_review) {
	$out_review = "$form_id: Items for further review\n\n"
	    . "Operator: $operator\nDate/time: " . scalar(localtime()) . "\n\n"
	    . $out_review;
	save_review();
    }

    # update DLPS tracking system
    TrackSys::connect();
    my $affected = 0;
    my $sql = "UPDATE postkb SET submitFiguresRendReport = 1 WHERE dlpsId = '$dlpsId' LIMIT 1";
    $affected = TrackSys::query($sql);
    if ($affected != 1) {
        $warning = "Cannot update DLPS tracking system for record '$dlpsId'. Update manually.\n";
    }
    TrackSys::disconnect();

    # show confirmation page
    confirm($warning);
}

#----------------------------------------------------------------------

sub do_figures_filenames {

    my ($exists, $i, $id, $note, $pageimage, $pagenumber);
    my $warning = '';
    $return_link = '<a href="/cgi-dlps/dlps-only/workreports/list.pl?type=figures_filenames">Return to Figures: Filenames reports</a>';

    for ($i = 1; $i <= $item_count; $i++) {
	$note = param("note_$i");

	# untaint parameters
	$id = param("id_$i");
	if ( $id =~ /^([\w\.\-]+)$/ ) { $id = $1; } else { bad_param("id_$i", $id); }

	$exists = param("exists_$i");
	if (not defined($exists)) { no_param("exists_$i"); }
	if ($exists =~ /^(true|false)$/) { $exists = $1; } else { bad_param("exists_$i", $exists); }

	# add item to output for .changes file
	$out_changes .= "$id|$exists\n";

	if ($note) {
	    # item marked as needing further review
	    # untaint parameters
	    if ( $note =~ /^(.*)$/ ) { $note = $1; } else { bad_param("note_$i", $note); }

	    $pagenumber = param("pagenumber_$i");
	    if ( defined($pagenumber) ) {
		if ( $pagenumber =~ /^()$/ or $pagenumber =~ /^(\d+|[ivxlcm]+)$/i ) { $pagenumber = $1; }
                    else { bad_param("pagenumber_$i", $pagenumber); }
	    } else {
		no_param("pagenumber_$i");
	    }

	    $pageimage = param("pageimage_$i");
	    if ( defined($pageimage) ) {
		#if ( $pageimage =~ /^([bz]\d{9}_\d{3,4}|[cC]av[dD]aily_\d{8}_\d{2})(_.+)?$/ ) { $pageimage = $&; }
                #    else { bad_param("pageimage_$i", $pageimage); }
	    } else {
		no_param("pageimage_$i");
	    }

	    # add item to output for .review file
	    $out_review .= "Figure id: $id\n";
	    $out_review .= "Image file exists: $exists\n";
	    $out_review .= "Note: $note\n";
	    $out_review .= "Page number: $pagenumber\n";
	    $out_review .= "Page image: $pageimage\n";
	    $out_review .= "\n";
	}
    }

    if ($out_changes) {
	$out_changes = "#operator=$operator\n#datetime=" . scalar(localtime()) . "\n" 
	    . $out_changes;
	save_changes();
    }

    if ($out_review) {
	$out_review = "$form_id: Items for further review\n\n"
	    . "Operator: $operator\nDate/time: " . scalar(localtime()) . "\n\n"
	    . $out_review;
	save_review();
    }

    # update DLPS tracking system
    TrackSys::connect();
    my $affected = 0;
    my $sql = "UPDATE postkb SET submitFiguresFilenamesReport = 1 WHERE dlpsId = '$dlpsId' LIMIT 1";
    $affected = TrackSys::query($sql);
    if ($affected != 1) {
        $warning = "Cannot update DLPS tracking system for record '$dlpsId'. Update manually.\n";
    }
    TrackSys::disconnect();

    # show confirmation page
    confirm($warning);
}

#----------------------------------------------------------------------

sub do_rehyphenate {

    my ($change, $i, $dictionary, $note, $pageimage, $pagenumber, $reg, $word);
    my $warning = '';
    $return_link = '<a href="/cgi-dlps/dlps-only/workreports/list.pl?type=rehyphenate">Return to Rehyphenate reports</a>';

    for ($i = 1; $i <= $item_count; $i++) {
	$change = param("change_$i");
	if ( defined($change) ) {
	    # item checked as a correction to be made

	    # untaint parameters
	    if ( $change =~ /^(on)$/ ) { $change = $1; } else { bad_param("change_$i", $change); }

	    # record value of <reg>...</reg> element, so when corrections
	    # are made this value will be searched for and replaced with
	    # value of orig attribute
	    $reg = param("reg_$i");
	    if ( defined($reg) ) {
		if ( $reg =~ /^(.+)$/ ) { $reg = $1; } else { bad_param("reg_$i", $reg); }
	    } else {
		no_param("reg_$i");
	    }

	    # add item to output for .changes file
	    $out_changes .= "$reg\n";
	}

	$dictionary = param("dictionary_$i");
	if ($dictionary) {
	    # word should be saved to dictionary (so it won't appear on future reports)
	    # untaint parameters
	    if ( $dictionary =~ /^(on)$/ ) { $dictionary = $1; } else { bad_param("dictionary_$i", $dictionary); }

	    $reg = param("reg_$i");
	    if ( defined($reg) ) {
		if ( $reg =~ /^(.+)$/ ) { $reg = $1; } else { bad_param("reg_$i", $reg); }
	    } else {
		no_param("reg_$i");
	    }

	    # add item to output for dictionary file
	    $out_dictionary .= "$reg\n";
	}

	$note = param("note_$i");
	if ($note) {
	    # item marked as needing further review
	    # untaint parameters
	    if ( $note =~ /^(.*)$/ ) { $note = $1; } else { bad_param("note_$i", $note); }

	    $pagenumber = param("pagenumber_$i");
	    if ( defined($pagenumber) ) {
		if ( $pagenumber =~ /^()$/ or $pagenumber =~ /^(\d+|[ivxlcm]+)$/i ) { $pagenumber = $1; }
                    else { bad_param("pagenumber_$i", $pagenumber); }
	    } else {
		no_param("pagenumber_$i");
	    }

	    $pageimage = param("pageimage_$i");
	    if ( defined($pageimage) ) {
		#if ( $pageimage =~ /^([bz]\d{9}_\d{3,4}|[cC]av[dD]aily_\d{8}_\d{2})(_.+)?$/ ) { $pageimage = $&; }
                #    else { bad_param("pageimage_$i", $pageimage); }
	    } else {
		no_param("pageimage_$i");
	    }

	    if ($change) {
		# user checked this item for rehyphenation; record original (hyphenated) form
		$word = param("orig_$i");
		if ( defined($word) ) {
		    if ( $word =~ /^(.+)$/ ) { $word = $1; } else { bad_param("orig_$i", $word); }
		} else {
		    no_param("orig_$i");
		}
	    } else {
		$word = param("reg_$i");
		if ( defined($word) ) {
		    if ( $word =~ /^(.+)$/ ) { $word = $1; } else { bad_param("reg_$i", $word); }
		} else {
		    no_param("reg_$i");
		}
	    }

	    # add item to output for .review file
	    $out_review .= "Word: $word\n";
	    $out_review .= "Note: $note\n";
	    $out_review .= "Page number: $pagenumber\n";
	    $out_review .= "Page image: $pageimage\n";
	    $out_review .= "\n";
	}
    }

    if ($out_changes) {
	$out_changes = "#operator=$operator\n#datetime=" . scalar(localtime()) . "\n" 
	    . $out_changes;
	save_changes();
    }

    if ($out_dictionary) {
	save_dictionary();
    }

    if ($out_review) {
	$out_review = "$form_id: Items for further review\n\n"
	    . "Operator: $operator\nDate/time: " . scalar(localtime()) . "\n\n"
	    . $out_review;
	save_review();
    }

    # update DLPS tracking system
    TrackSys::connect();
    my $affected = 0;
    my $sql = "UPDATE postkb SET submitRehyphenateReport = 1 WHERE dlpsId = '$dlpsId' LIMIT 1";
    $affected = TrackSys::query($sql);
    if ($affected != 1) {
        $warning = "Cannot update DLPS tracking system for record '$dlpsId'. Update manually.\n";
    }
    TrackSys::disconnect();

    # show confirmation page
    confirm($warning);
}

#----------------------------------------------------------------------

sub do_unclears {

    my ($change, $i, $id, $new, $note, $pageimage, $pagenumber);
    my $warning = '';
    $return_link = '<a href="/cgi-dlps/dlps-only/workreports/list.pl?type=unclears">Return to Unclears reports</a>';

    for ($i = 1; $i <= $item_count; $i++) {
	$change = param("change_$i");
	$note = param("note_$i");

	if ($change or $note) {
	    # get value of id attribute
	    $id = param("id_$i");
	    if ( $id =~ /^([ug]\d+)$/ ) { $id = $1; } else { bad_param("id_$i", $id); }

	    # get user-entered replacement value
	    $new = param("new_$i");
	    if ( $new =~ /^(.*)$/ ) { $new = $1; } else { bad_param("new_$i", $new); }
	}

	if ($change) {
	    # item checked as a correction to be made
	    # untaint parameters
	    if ( $change =~ /^(on)$/ ) { $change = $1; } else { bad_param("change_$i", $change); }

	    # add item to output for .changes file
	    $out_changes .= "$id|$new\n";
	}

	if ($note) {
	    # item marked as needing further review
	    # untaint parameters
	    if ( $note =~ /^(.*)$/ ) { $note = $1; } else { bad_param("note_$i", $note); }

	    $pagenumber = param("pagenumber_$i");
	    if ( defined($pagenumber) ) {
		if ( $pagenumber =~ /^()$/ or $pagenumber =~ /^(\d+|[ivxlcm]+)$/i ) { $pagenumber = $1; }
                    else { bad_param("pagenumber_$i", $pagenumber); }
	    } else {
		no_param("pagenumber_$i");
	    }

	    $pageimage = param("pageimage_$i");
	    if ( defined($pageimage) ) {
		#if ( $pageimage =~ /^([bz]\d{9}_\d{3,4}|[cC]av[dD]aily_\d{8}_\d{2})(_.+)?$/ ) { $pageimage = $&; }
                #    else { bad_param("pageimage_$i", $pageimage); }
	    } else {
		no_param("pageimage_$i");
	    }

	    # add item to output for .review file
	    $out_review .= "Unclear id: $id\n";
	    $out_review .= "Changed to: ";
	    if ($change) { $out_review .= "$new\n"; } else { $out_review .= "[no change]\n"; }
	    $out_review .= "Note: $note\n";
	    $out_review .= "Page number: $pagenumber\n";
	    $out_review .= "Page image: $pageimage\n";
	    $out_review .= "\n";
	}
    }

    if ($out_changes) {
	$out_changes = "#operator=$operator\n#datetime=" . scalar(localtime()) . "\n" 
	    . $out_changes;
	save_changes();
    }

    if ($out_review) {
	$out_review = "$form_id: Items for further review\n\n"
	    . "Operator: $operator\nDate/time: " . scalar(localtime()) . "\n\n"
	    . $out_review;
	save_review();
    }

    # update DLPS tracking system
    TrackSys::connect();
    my $affected = 0;
    my $sql = "UPDATE postkb SET submitUnclearsReport = 1 WHERE dlpsId = '$dlpsId' LIMIT 1";
    $affected = TrackSys::query($sql);
    if ($affected != 1) {
        $warning = "Cannot update DLPS tracking system for record '$dlpsId'. Update manually.\n";
    }
    TrackSys::disconnect();

    # show confirmation page
    confirm($warning);
}

#----------------------------------------------------------------------

sub no_param {
    my $name = shift() || "[unknown]";
    common::print_error("Missing parameter: '$name' is required.");
}

#----------------------------------------------------------------------

sub save_changes {
    # write data output string (list of corrections) to .changes file
    my $outfile = "$out_path/changes/${form_id}.changes";

    open(OUT, ">$outfile") || common::print_error("Cannot write '$outfile': $!");
    flock OUT, LOCK_EX;
    print OUT $out_changes;
    close OUT;
}

#----------------------------------------------------------------------

sub save_dictionary {
    # append additions to dictionary file
    my $outfile = "$out_path/hyphenation_dictionary.txt";

    open(OUT, ">>$outfile") || common::print_error("Cannot write '$outfile': $!");
    flock OUT, LOCK_EX;
    print OUT $out_dictionary;
    close OUT;
}

#----------------------------------------------------------------------

sub save_review {
    # write review output string (list of items for further review) to .review file
    my $outfile = "$out_path/review/${form_id}.review";

    open(OUT, ">>$outfile") || common::print_error("Cannot append to '$outfile': $!");
    flock OUT, LOCK_EX;
    print OUT $out_review;
    close OUT;
}

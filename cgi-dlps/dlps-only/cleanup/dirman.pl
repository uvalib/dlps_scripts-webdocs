#!/usr/bin/perl

##############################################################################
#
# dirman.pl
#
# Description: This script creates a file (/usr/tmp/dirman_delete.txt)
# that lists the subdirectories and files on pogo.lib under
# /shares/image1/01bookscanning and/or /shares/text/04postkb that DLPS
# staff have selected for deletion.  This script is intended to work
# with the deldir.pl script run by cron.
#
# Author: S. Munson
# December 16, 2002
#
#
# Revision history:
# 2005-03-30: gpm2a (Greg Murray, DLPS): Removed requirement that DLPS
# IDs must conform to pattern ^[bz]\d{9} -- IDs can be any string.
#
# 2005-12-21: gpm2a: Revised as needed for script to work on pogo.lib.
#
# 2006-01-03: gpm2a: Added "proofreader", "workreports", and "xml"
# (TEI Preview) directories to list of directories to be searched for
# candidates for deletion.
#
##############################################################################

use strict;
use CGI;
use File::Find;
require '/www/cgi-dlps/common.pl';

my $query = CGI::new();
my $idstr;
my @dirs = ();
my @files = ();

my $tempfile = '/usr/tmp/dirman_delete.txt';


#======================================================================
# main logic
#======================================================================

common::print_error("'$common::bookscanningPath' is not a directory")      if (! -d $common::bookscanningPath);
common::print_error("'$common::postkbPath' is not a directory")            if (! -d $common::postkbPath);
common::print_error("'$common::proofreaderImagesPath' is not a directory") if (! -d $common::proofreaderImagesPath);
common::print_error("'$common::workreportsPath' is not a directory")       if (! -d $common::workreportsPath);
common::print_error("'$common::xmlPath' is not a directory")               if (! -d $common::xmlPath);

print $query->header;

print <<EOD;
<html>
<head>
<title>DLPS Cleanup Manager</title>
<link rel="stylesheet" type="text/css" href="/dlps/css/dlpsdoc.css">
</head>
<body>
EOD

if (($query->param('delete') ne "") || ($query->param('cancel') ne "")) {
    &CreateFile();
} elsif ($query->param('search') eq "Search") {
    &SetUpMatch();
    &Display_Form2();
} elsif ($query->param('continue') eq "Continue") {
    &Verify();
} else {
    &Display_Form1();
}

print $query->end_html;


#======================================================================
# subroutines
#======================================================================

sub Display_Form1 {
    my $temp = '';
    if ( defined($query->param('id')) ) {
	$temp = ' value="' . $query->param('id') . '"';
    }
    print <<EOD;
<center>
<h1>DLPS CLEANUP MANAGER</h1>
<hr width="80%">
<form method="post">
<table cellpadding="4">
<tr>
<th align="right" valign="top">Directories to search:</th>
<td>
<input type="checkbox" name="path" value="01bookscanning" checked> 01bookscanning <br>
<input type="checkbox" name="path" value="04postkb" checked> 04postkb <br>
<input type="checkbox" name="path" value="proofreader" checked> Proofreader <br>
<input type="checkbox" name="path" value="preview" checked> TEI Preview <br>
<input type="checkbox" name="path" value="workreports" checked> Work Reports
<!--
<select name="path" multiple>
<option value="01bookscanning">01bookscanning</option>
<option value="04postkb">04postkb</option>
<option value="proofreader">Proofreader</option>
<option value="workreports">Work Reports</option>
<option value="preview">TEI Preview</option>
</select>
-->
</td>
</tr>
<tr>
<th align="right">DLPS ID:</th>
<td><input type="text" name="id" size="40" $temp></td>
</tr>
<tr>
<th></th>
<td><input type="submit" name="search" value="Search"></td>
</tr>
</table>
<p>To search for more than one DLPS ID, separate each ID with a comma or semicolon.</p>
</form>
</center>
EOD
}

#----------------------------------------------------------------------

sub Display_Form2 {
    print <<EOD;
<center>
<h1>DLPS CLEANUP MANAGER</h1>
<hr width="80%">
<form method="post">
EOD

    my $dirsize = @dirs;
    my $filesize = @files;

    if ($dirsize == 0) {
	print "<p><b>There were no directories matching the required parameters.</b></p>\n";
    } else {
	print "<p><b>Directories:</b></p>\n<table><tr><td>\n",
	      $query->checkbox_group(-name=>'directories',
				     -values=>\@dirs,
				     -linebreak=>'true'),
	      "\n</td></tr></table>\n";
    }

    if ($filesize == 0) {
	print "<p><b>There were no files matching the required parameters.</b></p>\n";
    } else {
	print "<p><b>Files:</b></p>\n<table><tr><td>\n",
	      $query->checkbox_group(-name=>'files',
				     -values=>\@files,
				     -linebreak=>'true'),
	      "\n</td></tr></table>\n";
    }

    if (($dirsize == 0) and ($filesize == 0)) {
	print "<hr width='80%'>\n";
	print "<p align='center'><a href='dirman.pl'><b>Search for more files/directories</b></a></p>\n";
    } else {
	print "<p>",
	      $query->submit(-name=>'continue',
			     -value=>'Continue'),
	      "</p>\n";
    }
    print "</form>\n";
    print "</center>\n";
}

#----------------------------------------------------------------------

sub Verify {
    print <<EOD;
<center>
<h1>DLPS CLEANUP MANAGER</h1>
<hr width="80%">
<form method="post">
EOD

    my @checked1 = $query->param('directories');
    my @checked2 = $query->param('files');
    my $dirsize = @checked1;
    my $filesize = @checked2;
    print $query->hidden('directories');
    print $query->hidden('files');

    if ($dirsize == 0 and $filesize == 0) {
	print "<h2>No directories or files were selected for deletion.</h2>\n";
    } else {
	print "<h2>The following directories and/or files will be deleted:</h2>\n";
    }

    if ($dirsize != 0) {
	print "\n<p><b>Directories:</b></p>\n<table><tr><td>\n";
	print "<ul>\n";
	foreach my $one (@checked1) {
	    print "<li>$one</li>\n";
	}
	print "</ul>\n</td></tr></table>\n";
    }

    if ($filesize != 0) {
	print "\n<p><b>Files:</b></p>\n<table><tr><td>\n";
	print "<ul>\n";
	foreach my $item (@checked2) {
	    print "<li>$item</li>\n";
	}
	print "</ul>\n</td></tr></table>\n";
    }

    unless ($dirsize == 0 and $filesize == 0) {
	print "<p>",
	      $query->submit(-name=>'delete', -value=>'DELETE'),
              "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",
	      $query->submit(-name=>'cancel', -value=>'Cancel'),
	      "</p>\n";
    }

    print "</form>\n";
    print "</center>\n";
}

#----------------------------------------------------------------------

sub CreateFile {
    print <<EOD;
<center>
<h1>DLPS CLEANUP MANAGER</h1>
<hr width="80%">
EOD

    my $error = 0;
    my @checked = $query->param('directories');
    @checked = (@checked, $query->param('files'));

    if ($query->param('delete') eq "DELETE") {
	if ( open(OUT,">> $tempfile") ) {
	    foreach my $one (@checked) {
		print OUT "$one\n";
	    }
	    close(OUT);
	    print "<center><h2><font color='green'>SPECIFIED FILES/DIRECTORIES WILL BE DELETED."
		. "</font></h2></center>\n";
	} else {
	    $error = 1;
	    print "<p><b><font color='red'>ERROR: Cannot open file '$tempfile' for writing: $!"
		. "</font></b></p>\n";
	}
    }

    if ($query->param('cancel') eq "Cancel") {
	if (-s "$tempfile") {
	    if ( open(IN,"$tempfile") ) {
		if ( open(OUT,"> $tempfile.new") ) {
		    print "<center><h2><font color='red'>SPECIFIED FILE/DIRECTORY DELETIONS ARE CANCELLED."
			. "</font></h2>\n<table><tr><td>\n<ul>\n";
		    while (<IN>) {
			chomp;
			my($x) = index(join(" ",@checked), $_);
			if ($x == -1) {  # if it doesn't find the substring
			    print OUT "$_\n";
			    #print "<li>$_</li>";
			}
		    }

		    print "\n</td></tr></table>\n</ul>\n</center>\n";
		    close(OUT);
		} else {
		    $error = 1;
		    print "<p><b><font color='red'>ERROR: Cannot open file '$tempfile.new' for writing: $!"
			. "</font></b></p>\n";
		}
		close(IN);
		system("/bin/mv -f $tempfile.new $tempfile") if (not $error);
	    } else {
		$error = 1;
		print "<p><b><font color='red'>ERROR: Cannot open file '$tempfile' for reading: $!"
		    . "</font></b></p>\n";
	    }
	}
    }

    if (! $error) {
	if (-s $tempfile) {
	    if ( open(IN,"$tempfile") ) {
		print "<center><h2>CURRENT FILE/DIRECTORY DELETION LISTING:</h2>\n<table><tr><td>\n<ul>\n";
		while (<IN>) {
		    chomp;
		    print "<li>$_</li>";
		}
		print "\n</td></tr></table>\n</ul>\n</center>\n";
		close(IN);
	    } else {
		print "<p><b><font color='red'>ERROR: Cannot open file '$tempfile' for reading: $!"
		    . "</font></b></p>\n";
	    }
	} else {
	    print "<center><h2><font color='red'>THERE ARE NO FILES/DIRECTORIES LISTED FOR DELETION."
		. "</font></h2></center>\n";
	}
    }

    print "<hr width='80%'>\n";
    print "<p align='center'><a href='dirman.pl'><b>Search for more files/directories</b></a></p>\n";
}

#----------------------------------------------------------------------

sub SetUpMatch {
    $idstr = $query->param('id');
    my @paths = $query->param('path');
    my %paths = ();

    # convert list of directories to search from an array to a hash for easier access
    foreach my $dir (@paths) {
	$paths{$dir} = '';
    }

    if ($idstr ne '') {
	$idstr =~ s#[,;]\s*$##;        # remove final delimiter, if present
	$idstr =~ s#[,;]\s*#\)\|\(#g;  # replace delimiter with )|( for reg exp
	$idstr = "($idstr)";           # add preceding ( and final ) characters

	if ( exists($paths{'01bookscanning'}) ) {
	    find(\&findDirs, $common::bookscanningPath);
	}
	if ( exists($paths{'04postkb'}) ) {
	    find(\&findFiles, $common::postkbPath);
	}
	if ( exists($paths{'proofreader'}) ) {
	    find(\&findDirs, $common::proofreaderImagesPath);
	}
	if ( exists($paths{'preview'}) ) {
	    find(\&findFiles, $common::xmlPath);
	}
	if ( exists($paths{'workreports'}) ) {
	    find(\&findFiles, $common::workreportsPath);
	}
    }

    @files = sort(@files);
    @dirs = sort(@dirs);
}

#----------------------------------------------------------------------

sub findFiles {
    if ( /^$idstr/i ) {
        push(@files, $File::Find::name);
    }
}

#----------------------------------------------------------------------

sub findDirs {
    if ( (-d) && (/^$idstr/i) ) {
	push(@dirs, $File::Find::name);
	$File::Find::prune = 1;
    }
}

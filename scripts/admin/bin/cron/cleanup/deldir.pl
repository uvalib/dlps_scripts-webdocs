#!/usr/bin/perl

######################################################################
#
# deldir.pl
#
# Description: This script deletes files and directories under
# /shares/image1/01bookscanning and/or /shares/text/04postkb on
# pogo.lib.  It is intended to work in conjunction with the dirman.pl
# script on pogo.lib in /www/cgi-dlps/cleanup.  The dirman.pl script
# creates a file (/usr/tmp/dirman_delete.txt) which is a list of the
# subdirectories that DLPS staff have selected for deletion.  The
# deldir.pl script is run as a cron job by root.  As a precaution, the
# script will only make deletions under the specified directories.
#
# Author: S. Munson
# January 2, 2003
#
#
# Revision history:
# Added: March 24, 2003 - email feature
#
# Added: August 1, 2003 - delete all files under dlps_work with
# filenames that contain "deleteme".
#
# 2005-12-28: gpm2a (Greg Murray, DLPS): Revised as needed for script
# to work on pogo.lib.
#
# 2006-01-03: gpm2a: Added "proofreader", "workreports", and "xml"
# (TEI Preview) directories to list of directories for which deletions
# are allowed.
#
# 2006-03-01: gpm2a: Rewrote script so it wouldn't send email with
# list of deleted files before attempting to delete anything. Instead,
# deletions are now monitored; errors are added to an array; email
# notification is now accurate.
#
######################################################################

use strict;
use File::Find;
require '/www/cgi-dlps/common.pl';

my (@errors, @deleted, $msg);

my $bookscanningDir = $common::bookscanningPath;
my $postkbDir = $common::postkbPath;
my $proofreaderDir = $common::proofreaderImagesPath;
my $workreportsDir = $common::workreportsPath;
my $previewDir = $common::xmlPath;

my $tempfile = '/usr/tmp/dirman_delete.txt';


#======================================================================
# main logic
#======================================================================

FatalError("ERROR: '$bookscanningDir' is not a directory\n") if (! -d $bookscanningDir);
FatalError("ERROR: '$postkbDir' is not a directory\n")       if (! -d $postkbDir);
FatalError("ERROR: '$proofreaderDir' is not a directory\n")  if (! -d $proofreaderDir);
FatalError("ERROR: '$workreportsDir' is not a directory\n")  if (! -d $workreportsDir);
FatalError("ERROR: '$previewDir' is not a directory\n")      if (! -d $previewDir);

GetDeleteMeFiles();

if (-s $tempfile) {
    if (open(IN,"$tempfile")) {
	while (<IN>) {
	    chomp;
	    next if (/^\s*$/);  # skip blank lines

	    if (-e $_) {
		if (/^$bookscanningDir/ or /^$postkbDir/ or /^$proofreaderDir/ or /^$workreportsDir/ or /^$previewDir/) {
		    if (system("/bin/rm -rf $_") == 0) {
			push(@deleted, $_);
		    } else {
			$msg = "ERROR: Cannot delete '$_': rm command failed\n";
			warn $msg;
			push(@errors, $msg);
		    }
		} else {
		    $msg = "ERROR: Cannot delete '$_': Not an allowed location for deletion\n";
		    warn $msg;
		    push(@errors, $msg);
		}
	    }
	}
	close IN;

#	if (! @errors) {
	    if (system("/bin/rm -f $tempfile") != 0) {
		$msg = "ERROR: Cannot delete list of files '$tempfile'\n";
		warn $msg;
		push(@errors, $msg);
	    }
#	}
    } else {
	$msg = "ERROR: Cannot open file '$tempfile' for reading: $!\n";
	warn $msg;
	push(@errors, $msg);
    }
}

if (@errors || @deleted) {
    Send_Mail();
}


#======================================================================
# subroutines
#======================================================================

sub FatalError {
    my $msg = shift;
    push(@errors, $msg);
    Send_Mail();
    die $msg;
}

#----------------------------------------------------------------------

{
    my @files = ();

    sub GetDeleteMeFiles {
	find(\&want, $bookscanningDir);
	find(\&want, $postkbDir);
	find(\&want, $proofreaderDir);
	find(\&want, $workreportsDir);
	find(\&want, $previewDir);

	if (@files) {
	    if (open(OUT,">> $tempfile")) {
		foreach (@files) {
		    print OUT "$_\n";
		}
		close OUT;
	    } else {
		$msg = "Cannot open file '$tempfile' for writing: $!\n";
		warn $msg;
		push(@errors, $msg);
	    }
	}
    }

    sub want {
	my $file = $File::Find::name;
	if ($file =~ /deleteme/i) {
	    push(@files, $file);
	}
    }
}

#----------------------------------------------------------------------

sub Send_Mail {

    my ($day, $month, $year) = (localtime)[3,4,5];
    $month = $month + 1;
    $year = sprintf("%02d", $year - 100);
    my $date ="$month/$day/$year";

    open(MAIL,"| /usr/lib/sendmail -i -t");
    print MAIL "To: ul-dlpsscripts\@virginia.edu\n";
    print MAIL "From: ul-dlpsscripts\@virginia.edu\n";

    if (@errors) {
        print MAIL "Subject: Error deleting files/directories\n\n";
        print MAIL "Errors occurred when running the 'deldir.pl' script on $date:\n\n";
	foreach my $err (@errors) {
	    print MAIL $err;
	}
	print MAIL "\n";
	print MAIL "-" x 75 . "\n\n";
    }
    else {
        print MAIL "Subject: Deleted files/directories\n\n";
    }

    if (@deleted) {
	print MAIL "List of deleted files/directories from $date:\n\n";
	foreach my $thing (@deleted) {
	    print MAIL "$thing\n";
	}
	print MAIL "\n";
	print MAIL "-" x 75 . "\n\n";
    }

    close MAIL;
}

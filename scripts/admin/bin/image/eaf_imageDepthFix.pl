#!/usr/bin/perl -w
#
# @(#)eaf_imageDepthFix.pl			1.0		2006/05/19
#
# Copyright (c) 2006 Digital Library Production Services, University of Virginia Library
# All rights reserved.
#
# This script will traverse a directory structure and modify the bits per channel per image
# so that they are set to 8.
#
# @version	1.0		2006/05/19
# @author	Jack Kelly


use strict;
use Getopt::Std;
use File::Find;
use Image::Magick;

my $me = 'eaf_imageDepthFix.pl';
my (%opts, @progress, $msg, $error, $errorCount, $ok, @errors);
my $mailFrom = 'jlk4p';
my $mailTo = 'ul-dlpsscripts';
#$mailTo = 'jlk4p';
my $eafImageTotalCount = 0;
my $eafImageModifiedCount = 0;

my $usage = <<EOD;

$me - will traverse the IMAGE1 and IMAGE2 volumes searching for EAF 
TIFF image files and modify them if necessary so that the images are 24 
bit (8 bit per channel) images. 

Usage: $me [-v] [-i] directories
  -i Identify image files that are not 24 bit only. Do not modify them.
  -v (verbose) Show status messages

In:  Top level directories that should be searched.
Out: The script performs the following actions for each input directory:
       - Traverse the directory tree for EAF TIFF images.
       - Modify (default) each image that is not 24 bits to be 24 bits.
       - Generate an email listing of all files found and modified.
       
EOD

getopts('iv', \%opts) || die $usage;
die $usage unless (@ARGV);

$msg = "Started at "  . (scalar localtime) . "\n\n";
push(@progress,$msg);

#======================================================================
# main logic
#======================================================================
foreach my $dir (sort(@ARGV)) {
    $error = 0;
    $ok = 1;
    $dir =~ s:/$::;  # remove final slash, if present

    $msg = "$me: Processing path '$dir' ...\r\n";
    print $msg if ($opts{'v'});
    push(@progress,$msg);
        
    find(\&updateEafImages,$dir);

}
continue {
    if ($ok) {
	$msg = "    Directory '$dir' was processed successfully.\r\n\r\n";
	print $msg if ($opts{'v'});
	push(@progress,$msg);
    } else {
	$msg = "$me: ERROR: Processing of directory '$dir' FAILED!\r\n\r\n";
	warn $msg;
	push(@errors,$msg);
    }

}

if ($opts{'i'}) {
	$msg = "EAF images identified with depth problem = $eafImageModifiedCount\n";
} else {
	$msg = "EAF images with depth modified = $eafImageModifiedCount\n";
}
print $msg if ($opts{'v'});
push(@progress,$msg);
$msg = "EAF total images found = $eafImageTotalCount\n";
print $msg if ($opts{'v'});
push(@progress,$msg);

$msg = "\nFinished at "  . (scalar localtime) . "\n";
push(@progress,$msg);

Send_Mail();

#======================================================================
# subroutines
#======================================================================

sub updateEafImages {
	my $fileName = $_;

	# Ignore hidden system files or the . reference to the current directory.
	if ($fileName =~ m/^\./) {

	} elsif  (-d $fileName) {	# if it is a directory...
		unless (-r $fileName) {
		    $msg = "$me: ERROR: Need read permission for directory '$File::Find::name'\r\n";
		    warn $msg;
		    push(@errors,$msg);
		    $ok = 0;
		}
		unless (-w $fileName) {
		    $msg = "$me: ERROR: Need write permission for directory '$File::Find::name'\r\n";
		    warn $msg;
		    push(@errors,$msg);
		    $ok = 0;
		}
 		$msg = "	Checking $File::Find::name\n";
	    print $msg if ($opts{'v'});
		push(@progress,$msg);

	} else {	# It is a file we are looking at.
		#If a file, check to see if it is an EAF TIFF image.
		if (($fileName =~ m/^eaf/i) and ($fileName =~ m/\.tif$/i)) {
			$eafImageTotalCount++;
			my $image = Image::Magick->new;
			my $exception1 = $image->Read("$File::Find::name");
			if (($exception1 eq "") or 
				(($exception1 =~ m/^Exception 350/) and 
				($exception1 =~ m/unknown field with tag/) and 
				(($exception1 =~ m/ignored/) or ($exception1 =~ m/encountered/)) )) {
				
				# Check to see if the bits per channel needs to be corrected.
				if ($image->Get('depth') > 8) {
					# If just interested in identifying the images then print.
					if ($opts{'i'}) {
						$msg = "    * $File::Find::name is not 8 bits/channel\n";
						push(@progress,$msg);
						$eafImageModifiedCount++;
					} else {	# Otherwise change the depth and save it.
						$image->Set(depth=>8);
						my $exception2 = $image->Write("$File::Find::name");
						if ($exception2 ne "") {
							$msg = "$me: ERROR: Writing file $$File::Find::name\r\n";
							warn $msg;
							push(@errors, $msg);
							push(@errors, $exception2 . "\r\n");
							$errorCount++;
							$ok = 0;
						} else {
							$msg = "    * $File::Find::name changed to 8 bits/channel\n";
							push(@progress,$msg);
							$eafImageModifiedCount++;
						}
					}
				}
			} else {
				$msg = "$me: ERROR: Reading file $File::Find::name\r\n";
				warn $msg;
				push(@errors, $msg);
				push(@errors, $exception1 . "\r\n");
				$errorCount++;
			    $ok = 0;
			}
			undef $image;
		} else { # Since not an EAF TIFF image, ignore.
		}
	}	
}

sub Send_Mail {

    my @time = localtime(time);
    my $today = $time[3];
    my $month = (1,2,3,4,5,6,7,8,9,10,11,12)[(localtime)[4]];
    my $year = $time[5];
    $year = $year - 100;

    $year = sprintf("%02d",$year);
    $month = sprintf("%02d",$month);
    $today = sprintf("%02d",$today);

    my($date)="$month/$today/$year";
    my($messageto) = $mailTo . "\@virginia.edu";

    open(MAIL,"| /usr/lib/sendmail -i -t");
#    open(MAIL,"| /usr/sbin/sendmail -i -t");
    print MAIL "To: $messageto\n"; 
    print MAIL "From: $mailFrom\@virginia.edu\n";
    if (@errors) {
	print MAIL "Subject: Error parsing Pogo for EAF images\n\n";
	print MAIL "There was an error from the $me script on $date:\n\n";
    }
    else {
	print MAIL "Subject: Report on parsing Pogo for EAF images\n\n";
	print MAIL "$me script completed with no errors on $date.\n\n";
    }
    foreach my $err (@errors) {
	print MAIL "$err";
    }
    foreach my $noerr (@progress) {
	print MAIL "$noerr" ;
    }
    print MAIL "-" x 75 . "\n\n";
    close(MAIL);
}

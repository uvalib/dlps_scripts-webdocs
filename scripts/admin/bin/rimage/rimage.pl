#!perl -w

use strict;
use Getopt::Std;
use File::Find;
use Win32::File;

# rimage.pl - creates archival discs using the Rimage DVD burner
# Greg Murray <gpm2a@virginia.edu>
# Digital Library Production Services, University of Virginia Library

my $version = "1.5";
my $versionDate = "2006-11-15";

# 2004-09-24: 1.0: gpm2a: First production version in Perl
#
# 2005-07-25: 1.1: gpm2a: Added -b (base ID) option to allow
# specifying base volume IDs. (Still defaults to a 6-digit YYMMDD
# date. Volume ID still consists of base ID plus underscore plus
# 3-digit sequence number.) Also added -t (test) option. In test mode,
# performs normal operations except that it does not write any files
# (editlists, logs, etc.) and does not attempt to burn any discs;
# reports how many discs will be needed and what their volume IDs will
# be.
#
# 2005-07-27: 1.2: gpm2a: Added -l (label) option for specifying a
# disc label template other than the default. Added list of
# directories and disc sequence number to merge-file output for
# optional inclusion on the disc label.
#
# 2006-01-11: 1.3: gpm2a: Changed values for -l (label) option to:
# DLPS, FKL, TBRC, SPEC, or THDL
#
# 2007-09-04: 1.4: rpj2f: Added DS4F label for projects digitized for 
# Digitization Services for Faculty
#
# 2006-05-10: 1.4: gpm2a: The File::Find::find() function does not always
# process subdirectories in alphabetic/numeric order, especially when
# reading a directory that has been mapped as a network drive in
# Windows but is actually a Unix/Linux directory. The ordering of
# files burned to DVD by the Rimage can therefore be confusing and
# appear mis-ordered. For this reason, I added logic to look at the
# project directory passed as an argument; if it contains only
# subdirectories, I sort those subdirectories myself before passing
# them to File::Find::find.
#
# 2006-11-15: 1.5: gpm2a: Added -R (read) option for possible
# reading/loading of existing discs, but in practice this option will
# not be documented or used. Changed version number to 1.5 to coincide
# with the new 1.5 version number for the accompanying Java app.
#
# 2007-04-12: 1.6: aec6v: Added a label option for RMDS using RMDS.btw.
#


# Originally written in Python by Steve Majewski <sdm7g@virginia.edu>.
# Rewritten in Perl for Win32 by Greg Murray <gpm2a@virginia.edu>.

# This script performs these tasks:
#   - recursively processes each file and subdirectory in the specified directory
#   - calculates how many files will fit on a single disc
#   - creates a "merge" file for each disc -- a comma-separated file with
#       summary info that gets merged into a label template for the disc label
#   - creates an "editlist" file for each disc -- a list of files to be burned to the disc
#   - creates a configuration file for the Java application
#   - runs a Java command-line application that handles all communication with the Rimage system

# The format for editlist files is:
#
# ; Comment lines begin with a semicolon
# "destination-path1" "source-path1"
# "destination-path2" "source-path2"
# ...

# Note: This script is written for Perl on Win32, but it uses / (slash)
# rather than \ (backslash) internally (in the code) as the directory
# separator, because Perl allows it (even on Win32) and because
# slashes are easier to work with in Perl.


#================================================================================
# main logic
#================================================================================

my ($me, $usage, $usageSummary, %opts, $copies, $media, $format, $label, $verbose);
my ($maxsize, $totalSize, $filename, $filepath, $parts, $size, $partSize);
my ($filename2, $filepath2);
my ($year, $month, $day, $today);
my ($thisSeq, $highSeq, $volumeSeq, $baseId, $id);
my (%filelist, $editlistFile, $mergeFile, $logFile, %parentDirs);
my ($prevSubdir, $subdirPartCount) = ('', 1);
my @ids = ();
my $outputDir;

our $projectDir;


#----------------------------------------------------------------------
# set constants
#----------------------------------------------------------------------

# use somewhat less than max disc capacity, to allow for overhead like directories
my $CD_SIZE = 688 * 1024 * 1024;
my $DVD_SIZE = 2183040 * 2048;

# these are the default directories installed by the Rimage software
my $RIMAGE_ROOT = 'C:/Rimage/';
my $EDITLIST_DIR = $RIMAGE_ROOT . 'Editlist/';
my $IMAGE_DIR = 'E:/Images/';
my $LOG_DIR = $RIMAGE_ROOT . 'Logs/';
my $MERGE_DIR = $RIMAGE_ROOT . 'Merge/';
my $LABEL_FILE;  # gets set below based on -l option

# XML config file to be read by the DLPSRimage Java app
my $CONFIG_FILE = $RIMAGE_ROOT . 'DLPSRimageConfig.xml';

# paths to disc label templates
my %labels = (
    'DLPS' => $RIMAGE_ROOT . 'Labels/DEFAULT.btw',
    'FKL'  => $RIMAGE_ROOT . 'Labels/fkl.btw',
    'TBRC' => $RIMAGE_ROOT . 'Labels/tbrc.btw',
    'THDL' => $RIMAGE_ROOT . 'Labels/thdl.btw',
    'SPEC' => $RIMAGE_ROOT . 'Labels/special.btw',
    'RMDS' => $RIMAGE_ROOT . 'Labels/RMDS.btw',
    'DS4F' => $RIMAGE_ROOT . 'Labels/DS4F.btw'
);


#----------------------------------------------------------------------
# set usage summary
#----------------------------------------------------------------------

$me = 'rimage.pl';
$usageSummary = "Usage: $me [-b base-id] [-c copies] [-k]
  [-l DLPS|FKL|TBRC|THDL|SPEC|DS4F] [-m DVD|CD] [-t] [-v] [-I|-P] paths";
$usage = <<EOD;

$me - creates archival discs using the Rimage DVD burner
Version $version, $versionDate

$usageSummary
  -b (base ID)    Base ID for volume IDs; defaults to a 6-digit date in YYMMDD
                  format
  -c (copies)     Number of copies to burn (defaults to 2)
  -k (keep)       Keep disc image files after burning (default is to delete
                  images after burning)
  -l (label)      Informal name of label template; use one of these values:
                  'DLPS', 'FKL', 'TBRC', 'SPEC', 'DS4F' or 'THDL' (defaults to DLPS)
  -m (media)      Type of media: use 'DVD' or 'CD' (defaults to DVD)
  -t (test)       Report how many discs will be needed and what their volume
                  IDs will be, but do not write any editlists, log files, etc.
                  and do not actually burn any discs
  -v (verbose)    Display all status messages (in addition to error messages)
  -I (imaging)    Only create disc images; do not produce discs
  -P (production) Only produce (burn) discs from existing disc images; do not
                  create disc images
  paths           Directories to process. If using -P, directory (only one)
                  containing disc images; otherwise, directories (one or more)
                  containing data files.

EOD
#  -R (read)       Read existing discs (rather than burning new discs)
#  paths           Directories to process. If using -P, directory (only one)
#                  containing disc images; otherwise, directories (one or more)
#                  containing data files. If using -R, directory (only one)
#                  to which to copy data loaded from existing discs.


#----------------------------------------------------------------------
# get and test arguments
#----------------------------------------------------------------------

getopts('b:c:kl:m:tvIP', \%opts) || die "$usageSummary\n";
$copies = $opts{'c'} || '2';
$media = $opts{'m'} || 'DVD';
$label = $opts{'l'} || 'DLPS';

if ($copies =~ /^\d+$/) {
    $copies = $copies + 0;
} else {
    die "-c option must be an integer\n$usageSummary\n";
}

if ( exists($labels{$label}) ) {
    $LABEL_FILE = $labels{$label};
} else {
    die "Unrecognized value used for -l option\n$usageSummary\n";
}

if ($media =~ /^DVD$/i) {
    $media = 'DVDR';
    $format = 'UDF102';
} elsif ($media =~ /^CD$/i) {
    $media = 'CDR';
    $format = 'ISO 9660';
} else {
    die "-m option must be either 'DVD' or 'CD'\n$usageSummary\n";
}

if ($media =~ /^CD/) {
    $maxsize = $CD_SIZE;
} else {
    $maxsize = $DVD_SIZE;
}

die $usage if (not @ARGV);


#----------------------------------------------------------------------
# test default directories/files
#----------------------------------------------------------------------

if (not -e $RIMAGE_ROOT) { die "Required directory '$RIMAGE_ROOT' does not exist\n"; }
if (not -d $RIMAGE_ROOT) { die "'$RIMAGE_ROOT' is not a directory\n"; }

if (not -e $EDITLIST_DIR) { die "Required directory '$EDITLIST_DIR' does not exist\n"; }
if (not -d $EDITLIST_DIR) { die "'$EDITLIST_DIR' is not a directory\n"; }
if (not -w $EDITLIST_DIR) { die "Need write permission on directory '$EDITLIST_DIR'\n"; }

if (not -e $LABEL_FILE) { die "Required label file '$LABEL_FILE' does not exist\n"; }
if (not -f $LABEL_FILE) { die "'$LABEL_FILE' is not a file\n"; }

if (not -e $LOG_DIR) { die "Required directory '$LOG_DIR' does not exist\n"; }
if (not -d $LOG_DIR) { die "'$LOG_DIR' is not a directory\n"; }
if (not -w $LOG_DIR) { die "Need write permission on directory '$LOG_DIR'\n"; }

if (not -e $MERGE_DIR) { die "Required directory '$MERGE_DIR' does not exist\n"; }
if (not -d $MERGE_DIR) { die "'$MERGE_DIR' is not a directory\n"; }
if (not -w $MERGE_DIR) { die "Need write permission on directory '$MERGE_DIR'\n"; }


#----------------------------------------------------------------------
# determine sequence number for first volume
#----------------------------------------------------------------------

# volume ID numbers are in the form base_nnn, where 'base' is the base
# ID (defaults to 6-digit date in YYMMDD format) plus underscore plus
# 3-digit sequence number

# get today's date
($day, $month, $year) = (localtime)[3,4,5];
$today = sprintf("%04d%02d%02d", $year+1900, $month+1, $day);
$today = substr($today, 2);

# determine base ID
if ($opts{'b'}) {
    $baseId = $opts{'b'};
} else {
    $baseId = $today;
}

# check editlist directory for existing editlist files with base ID to
# determine next sequence number to use
$highSeq = 0;
opendir(DIR, $EDITLIST_DIR) || die "$me: ERROR: Cannot open directory '$EDITLIST_DIR': $!\n";
while ( defined($filename = readdir(DIR)) ) {
    if ( $filename =~ /^${baseId}_(\d\d\d)/ ) {
	$thisSeq = $1 + 0;
	if ($thisSeq > $highSeq) {
	    $highSeq = $thisSeq;
	}
    }
}
closedir DIR;
$volumeSeq = $highSeq;


#----------------------------------------------------------------------
# process
#----------------------------------------------------------------------

if ( $opts{'P'} ) {
    $projectDir = shift;
    if (not -d $projectDir) { die "'$projectDir' is not a directory\n" . $usage; }
    if (not -r $projectDir) { die "Need read permission on directory '$projectDir'\n"; }
    $projectDir = normalizePathname($projectDir);

    getExistingVolumes($projectDir);
} elsif ( $opts{'R'} ) {
    $outputDir = shift;
    if (not -d $outputDir) { die "'$outputDir' is not a directory\n" . $usage; }
    if (not -w $outputDir) { die "Need write permission on directory '$outputDir'\n"; }
    $outputDir = normalizePathname($outputDir);
    # proceed to creating config file for Java app
} else {
    foreach $projectDir (@ARGV) {
	if (not -d $projectDir) { die "'$projectDir' is not a directory\n" . $usage; }
	if (not -r $projectDir) { die "Need read permission on directory '$projectDir'\n"; }
	$projectDir = normalizePathname($projectDir);

	startVolume();

	print "Media: $media\n";
	print "Copies: $copies\n";
	print "Project directory: $projectDir\n";
	print "First volume ID: $id\n";

	# read project directory to see if it contains subdirectories only
	my $nonDirFound = 0;
	my @subdirs = ();
	opendir(DIR, $projectDir) || die "$me: ERROR: Cannot open directory '$projectDir': $!\n";
	while ( defined($filename = readdir(DIR)) ) {
	    next if ($filename =~ /^\./);
	    if ( -d "$projectDir$filename" ) {
		push @subdirs, "$projectDir$filename";
	    } else {
		$nonDirFound = 1;
	    }
	}
	closedir DIR;

	# File::Find::find() recursively processes all files and subdirectories in
	# given directory; for each file or dir found, it calls buildFileList()
	if ($nonDirFound) {
	    # project directory contains files (not just subdirectories); pass project directory directly to File::Find::find
	    find \&buildFilelist, ($projectDir);
	} else {
	    # project directory only contains subdirectories; pass sorted list of subdirectories to File::Find::find
	    find \&buildFilelist, (sort(@subdirs));
	}

	if (scalar(%filelist)) {
	    # file list contains entries; end this final volume
	    endVolume();
	}
    }
}

print "Last volume ID:  $id\n" unless ($opts{'P'} or $opts{'R'});

# create configuration file to be used by Java application
writeConfigFile() unless $opts{'t'};

# run Java application to communicate with Rimage system and process all volumes
unless ( $opts{'t'} ) {
    if ( chdir($RIMAGE_ROOT) ) {
	if ($opts{'v'}) { $verbose = '-v '; } else { $verbose = ''; }
	$CONFIG_FILE =~ s:/:\\:g;  # convert to backslashes
	my $retval = system("java edu.virginia.lib.dlps.rimage.CLUI $verbose$CONFIG_FILE");
	if ( $retval != 0 ) { print "Java process return value: $retval\n"; }
    } else {
	die "$me: ERROR: Cannot change to directory '$RIMAGE_ROOT': $!";
    }
}


#================================================================================
# subroutines
#================================================================================

sub addFile {

    # addFile - adds specified file to current volume (set of files to be burned
    #   to a single disc)

    my $filepath = shift || die;
    my ($relPath, $subdir, $seqLetter, $dirLength, $parentDir);

    # determine destination path
    $dirLength = length($projectDir);
    $relPath = substr($filepath, $dirLength - 1);
    if ( $relPath =~ m:^/([^/]+)/: ) {
	# path relative to project root includes at least one subdirectory
	$subdir = $1;
	if ( $subdir eq $prevSubdir ) {
	    if ( not scalar(keys(%filelist)) ) {
		# new volume, but same subdirectory as previous volume; increment subdirectory part counter
		$subdirPartCount++;
	    }
	} else {
	    # new subdirectory; reset subdirectory part counter
	    $subdirPartCount = 1;
	    $prevSubdir = $subdir;
	}

	# get lower-case ASCII letter(s) corresponding to subdirectory part counter (1 = a, 2 = b, ... 27 = aa, 28 = ab, etc.)
	$seqLetter = number2letters($subdirPartCount);
	$relPath =~ s:$subdir:${subdir}_$seqLetter:;
    }

    if ($label ne 'DLPS') {
	# get name of second directory in path
	if ( $filepath =~ m#^([A-Z]:)?/[^/]+/([^/]+)# ) {
	     $parentDir = $2;
	     # add parent directory to hash (for inclusion in merge file)
	     $parentDirs{$parentDir} = '';
	 }
    }

    # add file to list; hash key is source path, value is destination path (path relative to project root directory)
    $filelist{$filepath} = $relPath;
    $totalSize += $size;
}

#----------------------------------------------------------------------

sub buildFilelist {

    # buildFilelist - called by File::Find::find for each file or directory it
    #   finds. If adding this file would exceed max size, volume is ended and a
    #   new volume is started; otherwise, file is added to current volume

    my $filename = $_;
    my $filepath = $File::Find::name;

    $filepath =~ s:\\:/:g;  # convert to forward slashes
    $filepath =~ s://:/:g;  # convert // to / (File::Find::name contains a double dir separator; maybe a bug only on Win32?)

    return if ( -d $filepath );
    return if ( skipFilename($filename) );
    return if ( skipFilepath($filepath) );

    $size = -s $filepath;
    if ($totalSize + $size > $maxsize) {
	# end this volume and start a new one
	endVolume();
	startVolume($filepath);
	return;
    } else {
	# add this file to the current volume
	addFile($filepath);
    }
}

#----------------------------------------------------------------------

sub endVolume {

    # endVolume - finish the current volume (set of files to be burned to a
    #   single disc) by writing the merge file and editlist file to disk

    my ($day, $month, $year, $today, $expires, @keys, $fileCount);
    my ($firstFile, $lastFile) = ('', '');
    my ($labelInfo, $sourcePath, $destPath);
    my ($parentDir, $parentDirList);
    my ($field1, $field2, $field3, $field4, $field5, $field6, $field7);

    #------------------------------------------------
    # write merge file (contains info for disc label)
    #------------------------------------------------

    ($day, $month, $year) = (localtime)[3,4,5];
    $today   = ($month+1) . '/' . $day . '/' . ($year+1900);
    $expires = ($month+1) . '/' . $day . '/' . ($year+1900+5);

    @keys = sort(keys(%filelist));
    $fileCount = scalar(@keys);
    if ( $fileCount > 0 ) { $firstFile = $filelist{$keys[0]}; }
    if ( $fileCount > 1 ) { $lastFile = $filelist{$keys[$fileCount-1]}; }
    $firstFile =~ s:/:\\:g;
    $lastFile  =~ s:/:\\:g;

    $parentDirList = '';
    foreach $parentDir (sort(keys(%parentDirs))) {
	$parentDirList .= "$parentDir; ";
    }
    $parentDirList =~ s/; $//;

    $field1 = $id;
    $field2 = "Date: $today";
    $field3 = "Expires: $expires";

    if ($label eq 'DLPS') {
	$field4 = $firstFile;
	$field5 = $lastFile;
    } elsif ($label eq 'RMDS') {
	$field4 = $firstFile;
	$field5 = $lastFile;
    } else {
	$field4 = $parentDirList;
	$field5 = 'Disc #' . $volumeSeq;
    }

    $field6 = $format;
    $field7 = "$fileCount files";

    $labelInfo = "$field1, $field2, $field3, $field4, $field5, $field6, $field7\n";

    unless ( $opts{'t'} ) {
	open(MERGE, ">$mergeFile") || die "$me: ERROR: Cannot write '$mergeFile': $!\n";
	print MERGE $labelInfo;
	close MERGE;
    }

    %parentDirs = ();

    #-------------------------------------------------------------
    # write edit list (list of files to burn to a particular disc)
    #-------------------------------------------------------------

    unless ( $opts{'t'} ) {
	open(LIST, ">$editlistFile") || die "$me: ERROR: Cannot write '$editlistFile': $!\n";
	print LIST "; First file: $firstFile\n";
	print LIST "; Last file:  $lastFile\n";
	print LIST "; File count: $fileCount\n";
	print LIST "; Total size: " . translateBytes($totalSize) . " ($totalSize bytes)\n";
	foreach $sourcePath ( sort(keys(%filelist)) ) {
	    $destPath = $filelist{$sourcePath};
	    $sourcePath =~ s:/:\\:g;
	    $destPath   =~ s:/:\\:g;
	    print LIST "\"$destPath\" \"$sourcePath\"\n";
	}
	close LIST;
    }

    #---------------
    # write log file
    #---------------

    my $projectDirWin32Path = $projectDir;
    $projectDirWin32Path =~ s:/$::;
    $projectDirWin32Path =~ s:/:\\:g;

    my $editlistFileWin32Path = $editlistFile;
    $editlistFileWin32Path =~ s:/:\\:g;

    my $labelFileWin32Path = $LABEL_FILE;
    $labelFileWin32Path =~ s:/:\\:g;

    my $mergeFileWin32Path = $mergeFile;
    $mergeFileWin32Path =~ s:/:\\:g;

    unless ( $opts{'t'} ) {
	open(LOG, ">$logFile") || die "$me: ERROR: Cannot write '$logFile': $!\n";
	print LOG "Project = $projectDirWin32Path\n";
	print LOG "Date = $today\n";
	print LOG "Expires = $expires\n";
	print LOG "Format = $format\n";
	print LOG "NumberOfFiles = $fileCount\n";
	print LOG "copies = $copies\n";
	print LOG "file = $editlistFileWin32Path\n";
	print LOG "filetype = EDITLIST\n";
	print LOG "fixrate = \n";
	print LOG "imtype = \n";
	print LOG "label = $labelFileWin32Path\n";
	print LOG "logmessage = \n";
	print LOG "media = $media\n";
	print LOG "merge = $mergeFileWin32Path\n";
	print LOG "order_id = \n";
	print LOG "volume = $id\n\n";
	foreach $sourcePath ( sort(keys(%filelist)) ) {
	    $destPath = $filelist{$sourcePath};
	    $destPath   =~ s:/:\\:g;
	    print LOG "$destPath\n";
	}
	close LOG;
    }

    #---------------------------------------------
    # add this volume ID to list of all volume IDs
    #---------------------------------------------

    push @ids, $id;
}

#----------------------------------------------------------------------

sub getExistingVolumes {

    # getExistingVolumes - reads a directory for .img (disc image) files;
    #   builds list of volume IDs to be burned

    my $dir = shift;
    my $filename;

    opendir(DIR, $dir) || die "Cannot read directory '$dir': $!\n";
    while ( defined($filename = readdir(DIR)) ) {
	next if (-d $filename);  # skip any subdirectories
	if ( $filename =~ /^(.+?)\.img$/ ) {
	    push @ids, $1;
	}
    }
    closedir DIR;

}

#----------------------------------------------------------------------

sub getSize {

    # getSize - determines total size of directory or file passed

    my $path = shift || die;
    my @dirs = ($path);
    my $sum = 0;

    if (-d $path) {
	find(sub {$sum += -s}, @dirs);
	return $sum;
    } else {
	return (-s $path);
    }
}

#----------------------------------------------------------------------

sub normalizePathname {

    # normalizePathname - converts backslashes (DOS) to slashes (UNIX) for
    # convenience (since backslashes are more cumbersome to work with in Perl),
    # and adds final slash if neeeded

    my $s = shift || die;

    $s =~ s:\\:/:g;

    if ( not $s =~ m:/$: ) {
	$s = $s . '/';
    }
    return $s;
}

#----------------------------------------------------------------------

sub number2letters {

    # number2letters - takes an integer between 1 (for "a") and 702 (for "zz")
    #   and returns ASCII lower-case letter(s) corresponding to that number:
    #   1 = a, 2 = b, ... 26 = z, 27 = aa, 28 = ab, ... 52 = az, 53 = ba, etc.

    my $num = shift || die;
    my ($out, $letter1, $letter2, $times, $remainder);

    my $err = "$me: ERROR: Invalid argument to subroutine 'number2letters': "
	. "must be an integer between 1 (for 'a') and 702 (for 'zz').\n";

    $num = int($num);
    die $err unless ($num >= 1 and $num <= 702);  # (26 * 26) + 26 = 702 = zz

    if ($num <= 26) {
	# one output letter: 1 = a, 2 = b, ... 26 = z
	$out = chr($num + 96);
    } else {
	# two output letters: 27 = aa, 28 = ab, ... 52 = az, 53 = ba, 54 = bb, etc.
	$remainder = $num % 26;
	$times = int($num / 26);
	if ($remainder == 0) {
	    # this is the last letter for this sequence (az or bz etc.), so reduce by 1 to get first letter
	    $letter1 = chr(($times - 1) + 96);
	    # use 26 instead of 0 to get "z"
	    $letter2 = chr(26 + 96);
	} else {
	    $letter1 = chr($times + 96);
	    $letter2 = chr($remainder + 96)
	}
	$out = $letter1 . $letter2;
    }

    return $out;
}

#----------------------------------------------------------------------

sub skipFilename {

    # skipFilename - returns true if the filename passed should not be processed

    my $filename = shift || die;

    return 1 if ($filename =~ /^\./);                     # skip filenames starting with .
    return 1 if ($filename =~ /^~/ or $filename =~ /~$/); # skip filenames starting or ending with ~
    return 1 if ($filename =~ /^2eDS_/i);                 # skip filenames starting with 2eDS_ or variant
    return 1 if ($filename eq 'tmp');                     # skip files named "tmp"

    return 0;
}

#----------------------------------------------------------------------

sub skipFilepath {

    # skipFilepath - returns true if the pathname passed should not be processed

    my $filepath = shift || die;
    my $attrib;

    Win32::File::GetAttributes($filepath, $attrib);
    return 1 if ($attrib & HIDDEN);  # skip hidden files/directories

    return 0;
}

#----------------------------------------------------------------------

sub startVolume {

    # startVolume - sets up variables to begin a new volume (set of files to be
    #   burned to a single disc). The filepath argument (optional) indicates
    #   the first file for the new volume.

    my $filepath = shift || '';

    $volumeSeq++;
    $id = $baseId . '_' . sprintf("%03d", $volumeSeq);
    $editlistFile = $EDITLIST_DIR . $id . '.lst';
    $mergeFile = $MERGE_DIR . $id . '.txt';
    $logFile = $LOG_DIR . $id . '.log';
    %filelist = ();
    $totalSize = 0;

    if ($filepath) {
	addFile($filepath);
    }
}

#----------------------------------------------------------------------

sub translateBytes {

    # translateBytes - takes number in bytes and converts to the most
    # human-readable unit of measure (kilobytes, megabytes, or gigabytes);
    # returns a string in the form "n type" -- for example, "123.4 megabytes"

    my $bytes = shift || die;
    my ($value, $type);

    if ($bytes >= 1073741824) {
	# 1 gig or more
	$type = 'gigabytes';
	$value = $bytes / 1073741824;
	$value = sprintf("%.1f", $value);   # round to 1 decimal place
    } elsif ($bytes >= 1048576) {
	# 1 meg or more
	$type = 'megabytes';
	$value = $bytes / 1048576;
	$value = sprintf("%.1f", $value);   # round to 1 decimal place
    } elsif ($bytes >= 1024) {
	# 1 kb or more
	$type = 'kilobytes';
	$value = $bytes / 1024;
	$value = sprintf("%d", $value);     # round to integer
    } else {
	$type = 'bytes';
	$value = $bytes;
    }

    return "$value $type";
}

#----------------------------------------------------------------------

sub writeConfigFile {

    # writeConfigFile - writes an XML configuration file, which provides
    # details needed by the accompanying Java application

    my ($id, $deleteImages, $verbose, $imageOnly, $productionOnly);
    my $editlistDir = $EDITLIST_DIR;
    my $imageDir = '';
    my $logDir = $LOG_DIR;
    my $mergeDir = $MERGE_DIR;
    my $labelFile = $LABEL_FILE;
    my $outputDirLocal = $outputDir;

    if ( $opts{'P'} ) {
	$imageDir = $projectDir;
    } else {
	$imageDir = $IMAGE_DIR;
    }

    $editlistDir    =~ s:/:\\:g if ($editlistDir);
    $imageDir       =~ s:/:\\:g if ($imageDir);
    $logDir         =~ s:/:\\:g if ($logDir);
    $mergeDir       =~ s:/:\\:g if ($mergeDir);
    $labelFile      =~ s:/:\\:g if ($labelFile);
    $outputDirLocal =~ s:/:\\:g if ($outputDirLocal);

    if ( $opts{'k'} ) {
	$deleteImages = 'false';
    } else {
	$deleteImages = 'true';
    }

    if ( $opts{'v'} ) {
	$verbose = 'true';
    } else {
	$verbose = 'false';
    }

    if ( $opts{'I'} ) {
	$imageOnly = 'true';
    } else {
	$imageOnly = 'false';
    }

    if ( $opts{'P'} ) {
	$productionOnly = 'true';
    } else {
	$productionOnly = 'false';
    }

    open(CONFIG, ">$CONFIG_FILE") || die "$me: ERROR: Cannot write '$CONFIG_FILE': $!\n";
    if ( $opts{'R'} ) {
	# write config file for reading discs
	print CONFIG <<EOD;
<?xml version="1.0"?>
<!DOCTYPE DLPSRimageConfig SYSTEM "DLPSRimageConfig.dtd">
<DLPSRimageConfig media="$media" isVerbose="$verbose">
    <options>
        <clientID>DLPSRimageClient</clientID>
        <directories>
            <outputDir>$outputDir</outputDir>
        </directories>
        <dtds>
            <productionServerRequestDTD>C:\\Rimage\\XML\\ProductionServerRequest_1.1.dtd</productionServerRequestDTD>
        </dtds>
    </options>
    <action>
        <read/>
    </action>
</DLPSRimageConfig>
EOD

    } else {

	# write config file for burning discs
	print CONFIG <<EOD;
<?xml version="1.0"?>
<!DOCTYPE DLPSRimageConfig SYSTEM "DLPSRimageConfig.dtd">
<DLPSRimageConfig media="$media" isVerbose="$verbose">
    <options>
        <clientID>DLPSRimageClient</clientID>
        <directories>
            <editlistDir>$editlistDir</editlistDir>
            <imageDir>$imageDir</imageDir>
            <logDir>$logDir</logDir>
            <mergeDir>$mergeDir</mergeDir>
        </directories>
        <dtds>
            <imageOrderDTD>C:\\Rimage\\XML\\ImageOrder_1.3.dtd</imageOrderDTD>
            <productionOrderDTD>C:\\Rimage\\XML\\ProductionOrder_1.4.DTD</productionOrderDTD>
        </dtds>
        <labelTemplate>$labelFile</labelTemplate>
    </options>
    <action>
        <burn copies="$copies" imageOnly="$imageOnly" productionOnly="$productionOnly" deleteImages="$deleteImages">
            <orders>
EOD
	foreach $id (sort(@ids)) {
	    print CONFIG "                <volumeID>$id</volumeID>\n";
	}
	print CONFIG <<EOD;
            </orders>
        </burn>
    </action>
</DLPSRimageConfig>
EOD
    }
    close CONFIG;
}

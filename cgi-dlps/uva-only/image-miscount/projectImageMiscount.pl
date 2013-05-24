#!/usr/bin/perl -lT
#
# @(#)projectImageMiscount.pl			1.00		2007/01/04
#
# Compare the images added to IRIS versus those exported from IRIS for a particular
# imaage project. This is intended to help identify why the image count may be off
# when a project cant be approved at step 4 in the image workflow. This script looks
# for the Iview exported text in the 70_burn directory on Image2 and looks for the 
# IRIS export file in the finearts iview_export directory on Dropbox.
#
# Copyright (c) 2007 Digital Library Production Services, University of 
# Virginia Library
# All rights reserved.
#
# @version	1.00	2007/01/04
# @author	Jack Kelly
#
# 2007/02/20 - (jlk4p) Modified the script to check in 50_prep4ReadyRepo first and then if 
#			project not found there look in 70_burn.

use strict;

my $scriptName = 'projectImageMiscount.pl';
my $iviewLocation1 = '/shares/image2/02_processed/50_prep4ReadyRepo/';	#image2
my $iviewLocation2 = '/shares/image2/02_processed/70_burn/';	#image2
my $irisLocation = '/shares/dropbox/inbox/finearts/iris_exports/';	#dropbox 2 locations, second is archive directory in this location
my (@progress,@errors);
my (%irisImagePIDs,%irisImageWorks);
my $usage = <<EOD;

$scriptName - compares the Iview exported text file (used to load 
image info into IRIS) to what was exported from IRIS for the specified 
project. The script returns a text string/report identifying images in 
each data set that are not in the other for the specified project.

Usage: $scriptName project_name

EOD

########### Begin main program ###########
# Make sure that a project name was specified when calling this script.
die $usage unless (@ARGV);
my $projectName = @ARGV[0];

# Read the Iview data into memory. If the Iview data does not exist in the expected file name, 
# then try an alternate file name for the data.
my %iviewImagePIDs = readIviewTextFile("$iviewLocation1$projectName",$projectName . '_iview.txt');
if (scalar(keys %iviewImagePIDs) eq 0) {
	%iviewImagePIDs = readIviewTextFile("$iviewLocation1$projectName","$projectName.txt");
}
if (scalar(keys %iviewImagePIDs) eq 0) {
	%iviewImagePIDs = readIviewTextFile("$iviewLocation2$projectName",$projectName . '_iview.txt');
}
if (scalar(keys %iviewImagePIDs) eq 0) {
	%iviewImagePIDs = readIviewTextFile("$iviewLocation2$projectName","$projectName.txt");
}

if (scalar(keys %iviewImagePIDs) eq 0) {
	push(@errors,"$scriptName: ERROR: '$projectName.txt' [_iview.txt] file not found at $iviewLocation1 nor $iviewLocation2.\n");
}

# If no errors occurred reading the Iview data, then read the IRIS exported image data.
if (scalar(@errors) eq 0) {
	# Read the IRIS image data into memory. If the IRIS data does not exist in the expected archive, 
	# directory then try the main directory in the event an error occurred.
	if (readIrisImageExportFile($irisLocation . "archive/","$projectName.images",$projectName) eq 1) {
	} else {
		readIrisImageExportFile($irisLocation,"$projectName.images",$projectName);
	}
	if (scalar(keys %irisImagePIDs) eq 0) {
		push(@errors,"$scriptName: ERROR: '$projectName.images' file not found at $irisLocation [archive].\n");
	}

	# If no errors occurred reading the IRIS data, then compare the images from both sets
	# for the project specified and generate a report of differences.
	if (scalar(keys %irisImagePIDs) ne 0) {
		my $iviewCount = scalar (keys %iviewImagePIDs);
		my $irisCount = scalar (keys %irisImagePIDs);
		push(@progress,"Results of Iview to IRIS Image Number Comparison for Project $projectName\n");
		push(@progress,"Iview image count = $iviewCount\n");
		push(@progress,"IRIS image count = $irisCount\n");
		
		# Identify Iview images that were not exported from IRIS.
		my @iviewNotExportedIris = ();
		foreach my $surrogateNo (sort keys %iviewImagePIDs) {
			if (not exists $irisImagePIDs{$surrogateNo}) {
				push(@iviewNotExportedIris,"$surrogateNo ($iviewImagePIDs{$surrogateNo})\n");
			}
		}
		if (scalar(@iviewNotExportedIris) ne 0) {
			push(@progress,"Iview Exported Images Not Found in the IRIS Exported Images\n");
			foreach my $line (@iviewNotExportedIris) {
				push(@progress,$line);
			}
		}
		
		# Identify IRIS images exported for the project that don't appear to have been in the
		# Iview data imported into IRIS.
		my @irisNotImportedIview = ();
		foreach my $surrogateNo (sort keys %irisImagePIDs) {
			$irisImageWorks{$surrogateNo} =~ s/(, )$//;
			if (not exists $iviewImagePIDs{$surrogateNo}) {
				push(@irisNotImportedIview,"$surrogateNo ($irisImagePIDs{$surrogateNo}), Work # $irisImageWorks{$surrogateNo}\n");
			}
		}
		if (scalar(@irisNotImportedIview) ne 0) {
			push(@progress,"IRIS Exported Images Not Found in the Iview Exported Images\n");
			foreach my $line (@irisNotImportedIview) {
				push(@progress,$line);
			}
		}
		
		# Output the results of the image number comparison.
		foreach my $line (@progress) {
			print("$line");
		}
	} else {
		foreach my $error (@errors) {
			print("$error");
		}
	}

} else {
	foreach my $error (@errors) {
		print("$error");
	}
}


########### End main program ###########

#####
# endOfLineChar - read the input file using the newline versus character return
#			at the end of the line. If the line count is greater with one versus the
#			other, then that is the appropriate end of line character and identifies
#			if the file was born on a PC versus a Mac versus Unix.
#
# parameters:
#	$filename - name of the file to check.
#####
sub endOfLineChar {
	my ($filename) = @_;
	my $macLineCount = 0;
	my $winLineCount = 0;
	
	# Check to see if this is a Mac created file.
	if (open(CHECK,"<",$filename)) {
		$/ = "\r";
		while (my $line = <CHECK>) {
			$macLineCount++;
		}
		close(CHECK);
	}
	
	# Check to see if this is a Windows created file.
	if (open(CHECK,"<",$filename)) {
		$/ = "\r\n";
		while (my $line = <CHECK>) {
			$winLineCount++;
		}
		close(CHECK);
	}
	
	if (($winLineCount eq 1) and ($macLineCount gt $winLineCount)) {
		return "\r";
	} elsif ($winLineCount gt 1) {
		return "\r\n";
	} else {
		return "\n";
	}
}

#####
# readIrisImageExportFile - read the text file exported from IRIS that was used to create
#		the GDMS/DESC objects for a project. Put the image, pid and work number into global 
#		arrays. Return 1 for successfully reading the file.
#
# parameters:
#	$inputDirectory - location of the input file.
#	$inputFile - name of the project file to be read.
#	$projName - name of the project being examined.
#####
sub readIrisImageExportFile {
	my ($inputDirectory,$inputFile,$projName) = @_;
	my $endOfRecord = endOfLineChar("$inputDirectory\/$inputFile");
	my $error = 0;
	
	if (open(INPUT,"$inputDirectory$inputFile")) {
		# Modify the default end of line character for reading lines from the
		# text files.
		$/ = $endOfRecord;
		# Get the Image data for the project.
		# Ignore the first line of the file since it contains header information.
		my $line = <INPUT>;
		my $imageCount = 0;
		while (my $line = <INPUT>) {
			my @inputRecord = split(/\t/,$line);
			my $imageProject = trim(@inputRecord[4]);
			# Only save image information if it is defined as being part of the project loaded from Iview data.
			if ($imageProject eq $projName) {
				# Image number is the third array entry, i.e. index 2.
				my $imageNo = trim(@inputRecord[2]);
				# Remove any commas from the work number.
				@inputRecord[0] =~ s/,//;
				# Metadata associated with the IRIS image number.
				if ($irisImageWorks{@inputRecord[2]} =~ m/@inputRecord[0]/) {
					# do nothing since the work number is associated with the image
				} else {
					$irisImageWorks{@inputRecord[2]} .= @inputRecord[0] . ", ";
				}
				$irisImagePIDs{@inputRecord[2]} = trim(@inputRecord[3]);
			}
		}
		close(INPUT);
		$error = 1;
	} else {
		push(@errors,"$scriptName: ERROR: Cannot read $inputDirectory$inputFile file.\n");
	}
	
	return $error;
}

#####
# readIviewTextFile - read the text file exported from Iview that was used to load
#		image information for the project into IRIS.
#
# parameters:
#	$inputDirectory - location of the input file.
#	$inputFile - name of the project file to be read.
#####
sub readIviewTextFile {
	my ($inputDirectory,$inputFile) = @_;
	my $endOfRecord = endOfLineChar("$inputDirectory\/$inputFile");
	my %PIDs = ();
	
	# Open the input file.
	if (open(INPUT,"$inputDirectory\/$inputFile")) {
		# Modify the default end of line character for reading lines from the
		# text files.
		$/ = $endOfRecord;
		
		# Read the first line containing the column headings.
		my $line = <INPUT>;
		
		# Remove control characters from being included with the data values.
		$line =~ s/$endOfRecord//;
		
		# Parse this to identify the number of columns and what they are.
		my @columns = split(/\t/,$line);
		my $columnCount = scalar(@columns);
		
		# Column locations for the fields needed for IRIS.
		my $fileNameCol = -1;
		my $surrogateNumCol = -1;
		
		# Identify which columns contain IRIS data.
		for (my $i=0; $i < $columnCount; $i++) {
			if (@columns[$i] eq "File Name") {
				$fileNameCol = $i;
			} elsif (@columns[$i] eq "iris_num") {
				$surrogateNumCol = $i;
			}
		}
		
		# Make sure that all the necessary fields were found in the Iview file.
		if (($fileNameCol ne -1) and ($surrogateNumCol ne -1)) {
			my %imageCount = ();
			# Read all the image records and write out the desired data into the
			# new file.
			while ($line = <INPUT>) {
				$line =~ s/$endOfRecord//;
				@columns = split(/\t/,$line);
				my $surrogateNo = @columns[$surrogateNumCol];
				my $digitalFileName = @columns[$fileNameCol];
				$digitalFileName =~ s/\//:/;	# leave in since current testing expects /
				$digitalFileName =~ s/_/:/;
				my $pid = $digitalFileName;
				$pid =~ s/\.[a-z]{3,4}$//i;
				$PIDs{$surrogateNo} = $pid;
				$imageCount{$surrogateNo}++;
			}
			
			# Inform the user if there are any image numbers repeated in the Iview export data.
			foreach my $imgNo (sort keys %imageCount) {
				if ($imageCount{$imgNo} gt 1) {
					push(@progress, "Image number $imgNo is repeated in the Iview catalog data.\n");
				}
			}
		} else {
			push(@errors,"$scriptName: ERROR: '$inputFile' does not contain the required fields for mapping to IRIS.\n");
		}
			
		close(INPUT);
	}

	return %PIDs;
}

#####
# trim - Strip whitespace from the beginning and ending of a string.
#
# @param $string - string to have whitespace removed.
#####
sub trim {
	my ($string) = @_;
	for ($string) {
		s/\x0B//g;		# remove vertical tabs throughout string
		s/^\s+//;		# discard leading whitespace
		s/\s+$//;		# remove trailing whitespace
	}
	return $string;
}

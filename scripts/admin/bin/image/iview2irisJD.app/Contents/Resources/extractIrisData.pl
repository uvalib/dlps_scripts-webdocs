#!/usr/bin/perl 
#
# @(#)extractIrisData.pl			1.00		2005/08/16
#
# This script will read a file that has been created from the text table
# feature in Iview and output a tab delimited file containing only the data 
# fields that will be imported into IRIS.
#
# Arguments: 	iviewExtract - the filename of the Iview extracted file to parse.
#				location - directory where the output file should be written.
#
# Copyright (c) 2005 Digital Library Production Services, University of 
# Virginia Library
# All rights reserved.
#
# @version	1.00	2005/08/16
# @author	Jack Kelly
#
# 2006/08/01 - (jlk4p) Added function to determine the end of line character, 
#		which would identify how to read the file in and parse it correctly.
# 2007/03/27 - (jlk4p) Modified version of the script for use in assigning
#		the Jackson Davis image PID/project information to the correct image
#		records using the Special Collections identifier field in the image
#		records in IRIS.

use strict;

my $scriptName = "extractIrisData.pl";

# Document how the script should be invoked.
my $usage = <<EOD;

$scriptName - Reads a file that has been created from the text table 
feature in Iview and outputs a tab delimited file containing the data fields 
needed for IRIS to the /tmp directory.

Usage: $scriptName  indirectory  filename.txt  outdirectory
Inputs: indirectory is the directory where the iview text file is located.
        filename.txt is the name of the Iview text table exported data.
        outdirectory is the location where the output file should be written.
Output: Creates a new tab delimited file (filename.iris) containing just the 
        fields that are needed for IRIS.

EOD

# Make sure that the fileName argument has been passed.
if (@ARGV) {
	# The script does not contain any special switches. So generate an error if 
	# one is found.
	foreach my $argument (@ARGV) {
    	if ($argument =~ /^-/) {
    		die($usage);
    	}
	}
	# Make sure the correct number of parameters were passed.
	if (scalar(@ARGV) eq 3) {
		# Open the file and parse it to create the desired output for importing 
		# to IRIS.
		my $inputDirectory = @ARGV[0];
		my $inputFile = @ARGV[1];
		my $outputDirectory = @ARGV[2];
		my $outputFile = $inputFile;
		$outputFile =~ s/.txt$/.iris/i;
		my $endOfRecord = endOfLineChar("$inputDirectory\/$inputFile");

		# Open the input file.
		if (open(INPUT,"$inputDirectory\/$inputFile")) {
			# Modify the default end of line character for reading lines from the
			# text files. Since all files were generated from a Mac process they
			# will have \r as the end of line rather than the Perl default of \n.
			$/ = $endOfRecord;
			
			if (open(OUTPUT,"> $outputDirectory/$outputFile")) {
				print(OUTPUT "Identifier No.\tPID\tDigital File Name\tProject Name\n");
				# Read the first line containing the column headings.
				my $line = <INPUT>;
				
				# Remove control characters from being included with the data values.
				$line =~ s/$endOfRecord//;
				
				# Parse this to identify the number of columns and what they are.
				my @columns = split(/\t/,$line);
				my $columnCount = scalar(@columns);
				
				# Column locations for the fields needed for IRIS.
				my $fileNameCol = -1;
				my $projectNameCol = -1;
				my $identifierNumCol = -1;
				
				# Identify which columns contain IRIS data.
				for (my $i=0; $i < $columnCount; $i++) {
					if (@columns[$i] eq "File Name") {
						$fileNameCol = $i;
					} elsif (@columns[$i] eq "project_name") {
						$projectNameCol = $i;
					} elsif (@columns[$i] eq "Description") {
						$identifierNumCol = $i;
					}
				}
				
				# Make sure that all the necessary fields were found in the Iview file.
				if (($fileNameCol ne -1) and ($projectNameCol ne -1) and ($identifierNumCol ne -1)) {
					# Read all the image records and write out the desired data into the
					# new file.
					while ($line = <INPUT>) {
						$line =~ s/$endOfRecord//;
						@columns = split(/\t/,$line);
						my $identifierNum = @columns[$identifierNumCol];
						$identifierNum =~ s/\.[a-z]{3,4}$//i;
						my $digitalFileName = @columns[$fileNameCol];
						$digitalFileName =~ s/\//:/;	# leave in since current testing expects /
						$digitalFileName =~ s/_/:/;
						my $pid = $digitalFileName;
						$pid =~ s/\.[a-z]{3,4}$//i;
						print(OUTPUT "$identifierNum\t$pid\t$digitalFileName\t@columns[$projectNameCol]\n");
					}
				} else {
					die("$scriptName: ERROR: '$inputFile' does not contain the required fields for mapping to IRIS.\n");
				}
				close(OUTPUT);
				# Make sure the permissions are modified so that the temp file can be deleted by another process if needed.
				chmod(0666,"$outputDirectory/$outputFile");
			} else {
				die("$scriptName: ERROR: Cannot write '$outputFile': $!\n");
			}
			close(INPUT);
		} else {
			die("$scriptName: ERROR: Cannot read '$inputFile': $!\n");
		}
	} else {
		die($usage);
	}
} else {
	die($usage);
}

########### Subroutines ###########

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
	} else {
		die("$scriptName: ERROR: Cannot read '$filename': $!\n");
	}
	
	# Check to see if this is a Windows created file.
	if (open(CHECK,"<",$filename)) {
		$/ = "\r\n";
		while (my $line = <CHECK>) {
			$winLineCount++;
		}
		close(CHECK);
	} else {
		die("$scriptName: ERROR: Cannot read '$filename': $!\n");
	}
	
	if (($winLineCount eq 1) and ($macLineCount gt $winLineCount)) {
		return "\r";
	} elsif ($winLineCount gt 1) {
		return "\r\n";
	} else {
		return "\n";
	}
}
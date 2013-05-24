#!/usr/bin/perl 
#
# @(#)ImageMagic.pl			1.01		2003/03/28
#
# Copyright (c) 2003 Digital Library Production Services, University of Virginia Library
# All rights reserved.
#
# ImageMagic.pl will allow for any number of imagemagick commands to be executed. Each
# command must have a corresponding source (directory) and destination (directory)
# that are used to get the images from and put the images into. This script looks
# for a corresponding ImageMagic.config file for retrieving all the source, command,
# and destination values from. The config file may contain comment lines (beginning 
# with #) to allow for documenting the commands being executed.
#
# @version	1.01	2003/03/28
# @author	Jack Kelly
#
# 2003/04/14 - (jlk4p) Fixed error message bug so that the correct variable 
#				($dirContent) was used.
# 2003/04/14 - (jlk4p) Modified the script so that it can be stored in a single
#				location and allow the configuration file name be passed as
#				a parameter when the command is invoked.
#

use strict;

my $version = "1.01";
my @source;
my @command;
my @destination;
my $errorMsg;
my $srcDirectory;
my $destDirectory;

# Confirm that a parameter has been passed (the config file name) before 
# attempting to run this script.
if (scalar(@ARGV) != 0) {
	# Read the configuration file passed to the script.
	if (readConfigFile(@ARGV[0])) {
		# Validate that the same number of source, command and destination lines
		# were read from the file. If not then execution cannot continue.
		my $srcCount = scalar(@source);
		my $cmdCount = scalar(@command);
		my $destCount = scalar(@destination);
		if (($srcCount == $cmdCount) && ($srcCount == $destCount) && ($cmdCount == $destCount)) {
			# Before beginning to execute each command, make sure that the source 
			# directories exist.
			foreach $srcDirectory (@source) {
				if (!opendir(SRCDIR,$srcDirectory)) {
					$errorMsg = $errorMsg . "ImageMagic error: $srcDirectory does not exist!\n";
				}
				closedir(SRCDIR);
			}
			
			# Check to see if each output directory exists. If a destination directory
			# does not exist then attempt to create it.
			foreach $destDirectory (@destination) {
				if (!opendir(DESTDIR,$destDirectory)) {
					# Create the directory. If it cannot be created then generate
					# an error.
					if (!createDirectory($destDirectory)) {
						$errorMsg = $errorMsg . "ImageMagic error: $destDirectory could not be created!\n";
					}
				}
				closedir(DESTDIR);
			}
			
			# If an error has been detected during the verification of source and
			# destination directories. Then return that error and stop execution
			# of the script.
			if ($errorMsg !~ /^\s*$/) {
				die("$errorMsg");
			}
			
			# Since no errors were found with the directories, proceed to execute
			# the commands submitted.
			for (my $i=0; $i < $srcCount; $i++) {
				my @sourceFiles = readDirectory(@source[$i]);
				my $numSourceFiles = scalar(@sourceFiles);
				chdir(@source[$i]);
				print("Changing to directory @source[$i] ...\n");
				print("Number of files found = $numSourceFiles\n");
					
				foreach my $fileName (@sourceFiles) {
					# Strip the extension from the file name.
					$fileName =~ s/\.(.*)$//;
					
					# Create the necessary output directory path and file name.
					my $outputFile = @destination[$i] . "/" . $fileName;
					
					# Modify the command so that it refers to a specific file from 
					# the source directory and the desired output destination.
					my @newCommand = split("source",$command[$i]);
					my $command = @newCommand[0] . $fileName . @newCommand[1];
					@newCommand = split("destination",$command);
					$command = @newCommand[0] . $outputFile . @newCommand[1];
					system($command);
					print("$command\n");
				}
			}		
		} else {
			die("ImageMagic error: source, command, and destination occurrences are not equal in number!\n");
		}
	} else {
		die("ImageMagic error: configuration file @ARGV[0] not found!\n");
	}

} else {
	print("ImageMagic $version\n");
	print("Copyright (c) 2003 DLPS, University of Virginia Library\n\n");
	print("   ImageMagic config\n\n");
	print("where config is the name of the configuration file to be used.\n\n");
	print("The configuration file may contain any repeating number of the following format:\n\n");
	print("   source=/directory_to_read\n");
	print("   command=Image Magick command... source.type1 destination.type2\n");
	print("   destination=/output_directory\n\n");
	print("where\n  - source is the absolute full path of a directory to be read for a list of filenames to use in place of the 'source' reference in the command.\n");
	print("  - command is the Image Magick command and must contain 'source.' as a marker for any file found in the source directory and must contain 'destination.' to represent the destination directory/file name for the output.\n");
	print("  - destination is the absolute full path where the Image Magick command resulting file is to be put.\n");
	print("  - type1 and type2 would be appropriate image file extensions for the command you want to execute.\n");
	exit();
}

# readDirectory - Read the list of filenames from the directory passed. 
#			Return the list of filenames via an array. 
#
# @param $dirContent - the current path/directory to read.
sub readDirectory {
	my ($dirContent) = @_;
	
	# Open the directory for reading.
	if (opendir(INDIR,$dirContent)) {
		my @allFiles = ();		# the files to be returned.
		
		# Read the contents of the directory in ascending order.
		my @contents = sort(readdir(INDIR));
		closedir(INDIR);
		
		# Exclude all . files.
		@contents = grep(!/^\./,@contents);
		
		# Exlude any directories from being included in the list.
		my $entry;
		# change to the directory being read before attempting to test if
		# it's a file, otherwise the results are not accurate.
		chdir($dirContent);
		foreach $entry (@contents) {
			# If the directory entry is a file then pass it along.
			if (-f $entry) {
				push(@allFiles,$entry);
			}
		}
		return @allFiles;
	} else {
		die("ImageMagic error: $dirContent cannot be read!\n");
	}
}

# createDirectory - Create the directory passed as a parameter. If the directory
#			cannot be created then attempt to create the parent directory and
#			then try creating the current directory again. If the directory
#			is successfully created then true is returned.
#
# @param $pathDir - the current path and directory to create.
sub createDirectory {
	my ($pathDir) = @_;
	
	# If the directory can be made then we are done...
	if (mkdir($pathDir)) {
		return 1;
	} else {
		# Otherwise we need to try creating the parent directory of the 
		# directory path passed to this function. Then attempt to create the
		# desired directory path again.
		my @directories = split("/",$pathDir);
		my $numDirsToTry = scalar(@directories) -1;
		my $parentDir = "";
		for (my $i=0; $i < $numDirsToTry; $i++) {
			if (@directories[$i] !~ /^\s*$/) {
				$parentDir = $parentDir. "/" . @directories[$i];
			}
		}
		if (createDirectory($parentDir)) {
			# If the parent directory gets created then try creating the current
			# directory again.
			if (mkdir($pathDir)) {
				return 1;
			}
		}
	}
	return 0;
}

# readConfigFile - Read the contents of the configuration file and throw
#			away any comment lines. It is assumed that the source, command
#			and destination values that are to be combined are in consecutive
#			lines; but their order consecutively is not important. If the file
#			is successfully read then true is returned; otherwise false.
#
# @param $configFile - the configuration file specified at the time the script
#				invoked.
sub readConfigFile {
	my ($configFile) = @_;
	if (open(CONFIG,"<",$configFile)) {
		$/ = "\n";	# make the input stream read one line at a time.

		while (<CONFIG>) {
			my $line = $_;		# get a line from the file
			# When we read a non-comment line then process it.
			if ($line !~ /^\s*#/) {
				# Strip leading and trailing white space from each line.
				$line =~ s/^\s+//;
				$line =~ s/\s+$//;
				
				# Only bother with lines that contain source, command, destination
				if ($line =~ m/^source=(.*)/i) {
					push(@source,$1);
				} elsif ($line =~ m/^command=(.*)/i) {
					push(@command,$1);
				} elsif ($line =~ m/^destination=(.*)/i) {
					push(@destination,$1);
				}
			}
		}
		return 1;
	} else {
		return 0;
	}
}
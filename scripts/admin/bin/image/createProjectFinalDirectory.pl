#!/usr/bin/perl -w
#
# License and Copyright:  The contents of this file are subject to the
# Educational Community License (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of the License
# at http://www.opensource.org/licenses/ecl1.txt.
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
# the specific language governing rights and limitations under the License.
#
# The entire file consists of original code.  Copyright (c) 2002-2006 by
# The Rector and Visitors of the University of Virginia.
# All rights reserved.
#
# Script: createProjectFinalDirectory.pl
# Version: 1.01
# Description: Creates the directory structure for all the image and metadata
#		files generated in the Art & Arch image workflow.
# Author: Jack Kelly <jlk4p@virginia.edu>
# Creation date: 2006/04/04

use strict;

my $finalDestination = "/shares/image2/02_processed/60_copy2ReadyRepo";
my $me = 'createProjectFinalDirectory.pl';
my $group = 'dlpswg';
my $success = 0;
my $usage = <<EOD;

$me - creates a directory structure for the 
     project's final data based on the content model.

Usage: $me project_name content_model

In:  Name of the project.
     Content model for the project output, i.e. uvaHighRes
Out: Directory structure created on the Image2 volume under the 
     $finalDestination 
     directory

EOD


########################
## Begin Main Program ##
########################

die $usage unless (@ARGV == 2);
my ($projectName, $contentModel) = @ARGV;


# uvaHighRes content model directory structure:
#   project_name (Note in ReadyRepo, image and text are high level with project below it.)
#      image
#         uvaHighRes
#            max
#            metadata
#               admin
#               desc
#               raw_meta
#            preview
#            screen
#      text
#         uvaGDMS
#            gdms
#               new
#               update

if ($contentModel eq "uvaHighRes") {
	my $error = "$me: ERROR: Problem creating $contentModel directory structure for project $projectName";
	my $projDir = $finalDestination . $projectName;
	my $imageDir = $projDir . "/image";
	my $textDir = $projDir . "/text";
	if (checkDirectory($projDir)) {
		if (checkDirectory($imageDir)) {
			$imageDir .= "/uvaHighRes";
			if (checkDirectory($imageDir)) {
				if (checkDirectory($imageDir . "/max")) {
					if (checkDirectory($imageDir . "/metadata")) {
						if (checkDirectory($imageDir . "/metadata/admin")) {
							if (checkDirectory($imageDir . "/metadata/desc")) {
								if (checkDirectory($imageDir . "/metadata/raw_meta")) {
									if (checkDirectory($imageDir . "/preview")) {
										if (checkDirectory($imageDir . "/screen")) {
											if (checkDirectory($textDir)) {
												$textDir .= "/uvaGDMS";
												if (checkDirectory($textDir)) {
													$textDir .= "/gdms";
													if (checkDirectory($textDir)) {
														if (checkDirectory($textDir . "/new")) {
															if (checkDirectory($textDir . "/update")) {
															} else {
																die($error);
															}
														} else {
															die($error);
														}
													} else {
														die($error);
													}
												} else {
													die($error);
												}
											} else {
												die($error);
											}
										} else {
											die($error);
										}
									} else {
										die($error);
									}
								} else {
									die($error);
								}
							} else {
								die($error);
							}
						} else {
							die($error);
						}
					} else {
						die($error);
					}
				} else {
					die($error);
				}
			} else {
				die($error);
			}
		} else {
			die($error);
		}
	} else {
		die($error);
	}

	$success = 1;
}

# If a valid content model was processed then return without an error.
if ($success) {
	exit(0);
} else {
	die("$me: ERROR: Content model $contentModel is not defined!\n");
}

######################
## End Main Program ##
######################


#####
# checkDirectory - Checks to see if the directory exists. If it
# 		does not, then it will create it. Returns true (1) if the directory exists
#		or is successfully created. Otherwise false (0) is returned;
#
# @param $fileName - the name of the file to be processed.
#####
sub checkDirectory{
	my ($pathDir) = @_;
	my $dirHandle;
	my $success = 1;
	# If the directory cannot be opened then maybe it's because it doesn't exist...
	if (!opendir($dirHandle,$pathDir)) {
		# If the directory cannot be created then there is a problem...
		if (!mkdir($pathDir)) {
			$success = 0;
		} else {
		    # set group and permissions for directory
		    chmod 0775, $pathDir;
		    system("chgrp $group $pathDir");
		}
	} else {
		closedir($dirHandle);
	}
	return $success;
}

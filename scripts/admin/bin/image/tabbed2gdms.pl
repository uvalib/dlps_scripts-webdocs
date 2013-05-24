#!/usr/bin/perl
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
# The entire file consists of original code.  Copyright (c) 2002-2005 by
# The Rector and Visitors of the University of Virginia.
# All rights reserved.
#
# Script: tabbed2gdms.pl
# Version: 1.01
# Description: Reads in the works and images files that were created from the
#		AppleScripts iris2tabbed13step1 and iris2tabbed13step2. Then builds
#		XML files that conform to the GDMS DTD. Files are created for new images, 
#		new works, and updated works in their appropriate directories. The 
#		function transformFile makes an external call to a Saxon servlet. The
#		function validateXmlFile makes an external call to the DLPS parse script,
#		which calls either onsgmls or Xerxes to do the validation.
# Author: Jack Kelly <jlk4p@virginia.edu>
# Creation date: 2003/12/02
#
# Modifications:
# 2004/01/22 - (jlk4p) Modify the script to change the header information that
#			is generated based on DTD changes.
# 2004/02/02 - (jlk4p) Cleaning up headers for the document by limiting the
#			items in @setsArray.
# 2004/04/01 - (jlk4p) Changed version number of GDMS. Changed @setsArray to 
#			$setCode since only a single set element is to be generated per
#			GDMS document.
# 2004/04/08 - (jlk4p) Updates to GDMS header information applied including
#			version number change. Addition of RIGHTS, NAME in AGENT, ADDRESS
#			with ADDRESSLINE, and PHYSDESC for the file size.
# 2004/04/20 - (jlk4p) Change the GDMS file naming to use underscore instead of
#			dash.
# 2004/04/26 - (jlk4p) Update this so as to be reading the new IRIS export file
#			which has new data added: creation authority, repository authority, 
#			work era, etc. Also updated the convertEntityReferences function
#			to use the same references used in TEI.
# 2004/05/24 - (jlk4p) Update this script to read the updated IRIS export file
#			which has new data added: work category, source accession type, and
#			source rights type. Dropped source copyright info. Then map these 
#			additions to the GDMS elements. Modified the notes in the header 
#			to reflect the actual steps needed to create the GDMS files.
# 2004/05/25 - (jlk4p) Move the extraction notes to pubstmt and assign the 
#			accession type and rights type without any condition testing.
# 2004/05/28 - (jlk4p) Reference text.lib instead of hatbox.lib as the location
#			of the GDMS DTD.
# 2004/06/17 - (jlk4p) Remove vertical tabs from all data string by adding this
#			step to the trim function used on all data elements. And update DTD
#			version number.
# 2004/06/18 - (jlk4p) Change date format to YYYYMMDD in header for creation date.
#			Changed type attribute to physicalobject for mediatype in divdesc.
#			Add Perl default specs for file i/o so output is UTF8 and input is text.
#			Add label attribute to resgrp element. Translate title qualifiers of
#			primary to main and variant to alternate. Move image format and type
#			from res - mediatype to res - source - mediatype. Drop source image
#			format from mapping. Drop digital format from mapping. Change timeinterval
#			subelement for agent information to date since numeric dates go in
#			date element. Combine the subject and subtypes with -- to create single
# 			terms for each repeating value combination. Change source rights type
# 			to map to adminrights and use IRIS values for the type attribute.
# 2004/06/21 - (jlk4p) Add Vendor/book copyright mapping to res-source-rights
#			[type=copyright] and drop out references to source accession type,
#			source image format, and digital format since these were dropped from
#			the mapping.
# 2004/06/24 - (jlk4p) Make cosmetic changes per the MGS. Change type=IRIS to
#			type=UVa Fine Arts. Combine view type and view description as one
#			description separated by comma/space in a RES element with type=view.
#			Move the type attribute in the geogname to its place parent element.
#			When start/end year are the same, drop the end year date element and
#			do not include a type attribute on the start year date element. Use
#			the IRIS era value for date and timeinterval era attributes. Only 
#			display century info if there are no work start/end dates. Drop the
#			country code from the site output in the place element.
# 2004/07/06 - (jlk4p) Have comma and space only included when both view type
#			and view description have values.
# 2004/07/20 - (jlk4p) Have added the byte header to the start of each XML file
#			in the writeHeaderXML function to indicate that each file is UTF8.
# 2004/07/26 - (jlk4p) Remove the optional UTF8 header bytes from the XML output.
#			And add the encoded utf8 character format to the xml element.
# 2004/08/02 - (jlk4p) Switch the substitution of quotes and apostrophes so that the
#			entity reference winds up in the XML file rather than the character.
#			This prevents having quotes embedded in quoted attributes.
# 2004/08/03 - (jlk4p) Changed output to go to file rather than standard output.
#			And cleaned up notes text written to document header.
# 2004/08/05 - (jlk4p) Modify the script to output more statistical information so
# 			that it is easier to tie the data back to the number of digital 
# 			files created and IRIS for potential data issues.
# 2004/08/06 - (jlk4p) Remove all but one resptr for images since that is all
#			that is necessary for creating the image object during ingestion.
#			And created global variable to define image content model to be 
#			created during ingestion process.
# 2004/09/02 - (jlk4p) Test to make sure that the subject or subtype is not empty 
#			before generating any subject element for the work or image.
# 2004/11/01 - (jlk4p) Check to make sure that the title is not empty before
#			generating any title element for the work.
# 2004/12/13 - (jlk4p) Update the GDMS mapping to include new fields based on changes due
#			to the inclusion of Artemis data to IRIS. Modified IRIS current site mapping.
#			Added IRIS former site, locality, dimensions, repository number, collector,
#			cataloger's notes, view date, and label copyright. Changed rights type text
#			values to be displayed.
# 2004/12/16 - (jlk4p) Name element required in agent element for collector mapping.
# 2005/01/10 - (jlk4p) Do not generate RESINC elements. All duplicate image references
#			should be created as another new image.
# 2005/01/25 - (jlk4p) The IRIS export Applescript was modified to use Batch Name
#			when selecting records to extract. The Batch Name was added to each
#			export record. Added this batch name to the input record structure.
# 2005/05/03 - (jlk4p) Updated the GDMS export process to include PIDs from the IRIS
#			application and write them to the XML files.
# 2005/05/09 - (jlk4p) Finishing up the changes for items with PIDs. And changed
#			the targettype to be application/Fedora per Thorny's decision.
# 2005/10/11 - (jlk4p) Rework this script to search a directory for project export files.
#			And read in two files instead of one. Plus create image metadata files.
# 2005/10/27 - (jlk4p) Added logic to make sure only generating image DESC files
#			for new images - not everything associated with a work.
# 2005/10/31 - (jlk4p) Changed the statistics process from being a data file to 
#			read to being an email message sent to DLPS.
# 2005/11/14 - (jlk4p) Modify the script to look for a directory of the project name. 
#			If it exists then just add the image/work metadata directory/files. 
#			Otherwise create the project directory and then create the other stuff.
# 2005/11/21 - (jlk4p) Restore the script with project modifications after having
#			problems with empty files. Also added error count at project level.
#			Plus added removed of project input file after successfully creating
#			xml files.
# 2005/11/21 - (jlk4p) Proceed to put in again (errors caused me to back everything
#			out) the XML transformation process and the XML validation for each file.
# 2005/11/22 - (jlk4p) Finishing up with setting up archive instead of deletion.
#			Resolved a problem of the descmeta files being invalidated by having the
#			GDMS dtd applied to them during the transformation.
# 2005/12/12 - (jlk4p) Changed output directory to be 02_processed since the directory name was 
#			changed since my last testing.
# 2005/12/13 - (jlk4p) Added chmod function to set group permissions for read/write on all output files.
# 2006/02/13 - (jlk4p) Switch to production email recipient list.
# 2006/03/27 - (jlk4p) Removed trim function from processing work title in descmeta file creation
#			in hopes that this is causing the undesired transformation problem.
# 2006/06/01 - (jlk4p) Added support for constructed title qualifier for work records. Added new
#			field references for data added to image IRIS export for vendor code and set number.
# 2006/06/02 - (jlk4p) Added new set code for image collection overall.
# 2006/06/06 - (jlk4p) Add the new source/image IRIS exported data to the input file process.
#			and incorporate an update of the tracking system.
# 2006/06/15 - (jlk4p) Final changes for updating the tracking system.
# 2006/06/20 - (jlk4p) Only have email sent when a project is processed.
# 2006/06/20 - (jlk4p) Updated email message to indicate that step 4 in the tracking system
#			can be updated/approved.
# 2006/06/26 - (jlk4p) Add to tracking system update the new and updated work counts.
# 2006/07/18 - (jlk4p) Updated to exclude work records with no images.
# 2006/08/01 - (jlk4p) Updated the path to the IRIS exported data since we modified the 
# 			directory structure on the dropbox volume.
# 2006/08/07 - (jlk4p) Changed the output directory to be 60_copy2ReadyRepo
# 2006/08/18 - (jlk4p) Updated so as to delete backup files after new XML files created after
#			transforming the entity references.
# 2006/08/22 - (jlk4p) Make sure that if the project directory does not exist that it is created
#			by this script process. Update process to change group for all files created.
# 2006/09/05 - (jlk4p) Resolved issue with project text directory structure not being created.
# 2006/10/05 - (jlk4p) Resolve issue with permissions/group not getting assigned correctly. And
#			the desc transformation not working with titles containing nonstandard characters.
# 2006/10/12 - (jlk4p) Figured out that the transformation process uses the encoding type of
#			the file being processed. Thus the descmeta needs to be utf-8 rather than ascii
#			when initially created.
# 2007/01/18 - (jlk4p) Drop Ray and Kristy from the email distribution list.
# 2007/03/20 - (jlk4p) Use image tracking system to identify content model so as to determine
# 			the directory structure to look for.
# 2007/03/21 - (jlk4p) Fix bug that causes & not to get converted when contained in image view
#			type and description once combined for desc meta file.
# 2007/05/14 - (jlk4p) Warn when content models are not found for projects, since no metadata files
#			will be generated.
#
# 2008/12/09 - (ms3uf) Changed chmod operation on directories from 0775 to 0777
#

use strict;
use open IN => ":utf8", OUT => ":utf8";

# For the DLPS image tracking system
use lib '/shares/admin/bin/text';
use TrackSys;

##################################
## Configuration Based Settings ##
##################################
my $fromEmailAddress = "ul-dlps\@virginia.edu";
my $toEmailAddressList = "ms3uf\@eservices.virginia.edu,lsc6v\@virginia.edu,rpj2f\@virginia.edu,jlk4p\@virginia.edu";
#$toEmailAddressList = "jlk4p\@virginia.edu";

my $SAXON_PATH = "/shares/admin/bin/text/jars";
my $transformationStyleSheetLocation = "/shares/admin/bin/image/";
my $descStyleSheet = "descmetaNumericEntities.xsl";
my $gdmsStyleSheet = "gdmsNumericEntities.xsl";

my $inputDirectory = "/shares/dropbox/inbox/finearts/iris_exports/";
my $outputDirectory = "/shares/image2/02_processed/60_copy2ReadyRepo/";
my $archiveDirectory = "/shares/dropbox/inbox/finearts/iris_exports/archive/";

my $errorCount = 0;
my $totalErrorCount = 0;

my $group = 'dlpswg';
#$group = 'cvsusers';

my $targetType = "application/Fedora";
my $gdmsVersion = 0.101;		# version of GDMS DTD that is used for scripting.
my $accessRights = "Publicly accessible";
my $copyrightYears = "2004";
my $gdmsDtdLocation = "http://text.lib.virginia.edu/dtd/gdms/gdms.dtd";
my $descmetaDtdLocation = "http://text.lib.virginia.edu/dtd/descmeta/descmeta.dtd";
my $fieldSeparator = chr(9);	# tab character used to delimit input file fields
my $valueSeparator = chr(31);	# unit separater used to delimit multi-value fields
my $setCode = "UVA-LIB-ArtArchit";
my $imageURL = "http://hitchcock.itc.virginia.edu/finearts";
my $notes = "These objects were extracted from IRIS using the iris2tabbed13 AppleScripts.";
$notes .= " Then the tabbed2gdms Perl script is run. This Perl script maps the data from";
$notes .= " IRIS based on the mapping that can be found in the IRIS to GDMS mapping Word document.";

######################
## Global variables ##
######################
my $statisticsLog;		# used to store stats which will be emailed at end of process.
my $createIDCounter;	# a static variable used by the createID function.
my %imageNumbers;		# array storing the image numbers from IRIS.
my %digitalFileNames;	# associative array using the image number as index
my %imageColors;		# associative array using the image number as index
my %imageViewTypes;		# associative array using the image number as index
my %imageViewDescriptions;	# associative array using the image number as index
my %imageViewDates;	# associative array using the image number as index
my %imageSubjects;		# associative array using the image number as index
my %imageSubjectAuthorities;	# associative array using the image number as index
my %imageSubjectSubtypes;	# associative array using the image number as index
my %imageSubtypeAuthorities;	# associative array using the image number as index
my %imagePIDs;
my %imageProjects;
my %imageExportDates;
my %imageVendorCodes;	# newly added for special collections records.
my %imageIdentifierTypes;	# newly added for special collections records.
my %imageIdentifierNumbers;	# newly added for special collections records.
my %imageSourceNumbers;	# associative array using the image number as index
my %sourceImageTypes;	# associative array using the source number as index
my %sourceRightsType;	# associative array using the source number as index
my %sourceLabelCopyright;	# associative array using the source number as index
my %sourceVendorCopyright;	# associative array using the source number as index
my %sourceVendorSetNum;	# added for special collections records.
my %imageWorkNumbers;	# relates images to works: image number is index, value is string of work numbers.
my %workNumbers;		# associative array using the work number as index
my %workPIDs;		# associative array using the work number as index
my %workProjects;		# associative array using the work number as index
my %workCategories;		# associative array using the work number as index
my %workSubjects;		# associative array using the work number as index
my %workSubjectAuthorities;	# associative array using the work number as index
my %workSubjectSubtypes;	# associative array using the work number as index
my %workSubtypeAuthorities;	# associative array using the work number as index
my %workMaterials;		# associative array using the work number as index
my %workCenturies;		# associative array using the work number as index
my %workStartYears;		# associative array using the work number as index
my %workEndYears;		# associative array using the work number as index
my %workDates;			# associative array using the work number as index
my %workEras;			# associative array using the work number as index
my %workCountries;		# associative array using the work number as index
my %workTypes;			# associative array using the work number as index
my %workTypeAuthorities;	# associative array using the work number as index
my %workCurrentSites;	# associative array using the work number as index
my %workCultures;		# associative array using the work number as index
my %workCultureAuthorities;	# associative array using the work number as index
my %workPeriods;		# associative array using the work number as index
my %workPeriodAuthorities;	# associative array using the work number as index
my %workTechniques;		# associative array using the work number as index
my %workRepositoryDisplays;	# associative array using the work number as index
my %workRepositoryAuthorities; # associative array using the work number as index
my %workTitleCounts;	# associative array using the work number as index
my %workTitles;			# associative array using the work number as index
my %workTitleQualifiers;	# associative array using the work number as index
my %workCreatorCounts;	# associative array using the work number as index
my %workCreatorNames;	# associative array using the work number as index
my %workCreatorQualifiers;	# associative array using the work number as index
my %workCreatorRoles;	# associative array using the work number as index
my %workCreatorDates;	# associative array using the work number as index
my %workCreatorAuthorities; # associative array using the work number as index
my %workFormerSites; # associative array using the work number as index
my %workLocalities; # associative array using the work number as index
my %workDimensions; # associative array using the work number as index
my %workRepositoryNumbers; # associative array using the work number as index
my %workCollectors; # associative array using the work number as index
my %workCatalogersNotes; # associative array using the work number as index
my %workExportDates;
my %imagesWrittenToWorks;		# associative array using image number as index
my %imageIDForImagesWritten;	# associative array using image number as index
my $recordCount = 0;
my $duplicateRecordCount = 0;
my @duplicateImageNumbers;
my $projDir;
my $projImgMetaDir;
my $projNewWrkMetaDir;
my $projUpdWrkMetaDir;
my $projectCount;
my $contentModel;

########################
## Begin Main Program ##
########################

# Search the input directory to see if there are any IRIS exported project files.
if (opendir(INDIR,$inputDirectory)) {
	# Create output file to hold stats that can be sent regarding the projects.
	$statisticsLog = "USE THIS EMAIL TO UPDATE STEP 4 IN THE IMAGE TRACKING SYSTEM.\n\n";
	$statisticsLog .= "Please contact someone in DLPS if you need assistance in resolving any issues you may have with the content of this email.\n\n";
	$statisticsLog .= "Start=" . (scalar localtime) . "\n";
	
	# See if there are IRIS exported project files found in the directory.
	# Only identify the project work files to get the list of exported projects.
	my @files = grep !/^\./, grep /\.works$/, readdir(INDIR);
	closedir(INDIR);
	$projectCount = scalar(@files);
	my %projects;
	$statisticsLog .= "Number of Projects = $projectCount\n";
	$statisticsLog .= "IRIS Exported Projects to be processed:";
	my $projectList = "";
	foreach my $fileName (@files) {
		$fileName =~ s/\.works$//;
		$projects{$fileName} = "";
		$projectList .= " $fileName,";
	}
	$projectList =~ s/,$//;
	$statisticsLog .= "$projectList\n\n";
	
	# Process each project separately.
	my $totalImageMetadataCount = 0;
	my $totalNewWorkCount = 0;
	my $totalUpdateWorkCount = 0;
	foreach my $project (sort (keys %projects)) {
		initializeArrays();
		$statisticsLog .= "Project $project\n";
		$statisticsLog .= "-------------------\n";
		
		# Make sure that both a works and images file exists for the project.
		my $worksFile = $inputDirectory . $project . ".works";
		my $imagesFile = $inputDirectory . $project . ".images";
		my $worksArchiveFile = $archiveDirectory . $project . ".works";
		my $imagesArchiveFile = $archiveDirectory . $project . ".images";
		if (open(INWRK,"<",$worksFile) && open(INIMG,"<",$imagesFile)) {
			# Identify the content model of the project
			TrackSys::connect();
			my $query = "select contentModel from imageProjects where projectName='$project'";
			my $resultRef = TrackSys::query($query);
			my $result = $$resultRef;	# de-reference the returned reference from the function.
			my $recordCount = $result->rows;
			if ($recordCount gt 0) {
				my @record = $result->fetchrow_array();
				$contentModel = $record[0];
			} else {
				$contentModel = '';
			}
			$result->finish;
			TrackSys::disconnect();

			# Don't bother creating any metadata if there is not a content model specified.
			if ($contentModel ne "") {
			
			# Before beginning output for the project. See if there is a project
			# directory in the output location and if not then create it.
			$projDir = $outputDirectory . "$project";
			my $imagesDirectory = "/image";
			my $newDirectory = "/text";
			my $updatesDirectory;
			if (checkProjectDirectory($projDir)) {
				if (checkProjectDirectory($projDir . $imagesDirectory)) {
					$imagesDirectory .= "/" . $contentModel;
					if (checkProjectDirectory($projDir . $imagesDirectory)) {
						$imagesDirectory .= "/metadata";
						if (checkProjectDirectory($projDir . $imagesDirectory)) {
							$imagesDirectory .= "/desc";
							$projImgMetaDir = $projDir . "$imagesDirectory/";
							if (checkProjectDirectory($projImgMetaDir)) {
								if (checkProjectDirectory($projDir . $newDirectory)) {
									$newDirectory .= "/uvaGDMS";
									if (checkProjectDirectory($projDir . $newDirectory)) {
										$newDirectory .= "/gdms";
										if (checkProjectDirectory($projDir . $newDirectory)) {
											$updatesDirectory = $newDirectory;
											$newDirectory .= "/new";
											$projNewWrkMetaDir = $projDir . "$newDirectory/";
											if (checkProjectDirectory($projNewWrkMetaDir)) {
												$updatesDirectory .= "/update";
												$projUpdWrkMetaDir = $projDir . "$updatesDirectory/";
												if (!checkProjectDirectory($projUpdWrkMetaDir)) {
													sendEmail($toEmailAddressList,$fromEmailAddress,"Error with project work metadata output directory",
													"ERROR: Unable to open/create project work metadata directory ($projUpdWrkMetaDir)\n");
													die("ERROR: Unable to open/create project work metadata directory ($projUpdWrkMetaDir)\n");
												}
											} else {
												sendEmail($toEmailAddressList,$fromEmailAddress,"Error with project work metadata output directory",
												"ERROR: Unable to open/create project work metadata directory ($projNewWrkMetaDir)\n");
												die("ERROR: Unable to open/create project work metadata directory ($projNewWrkMetaDir)\n");
											}
										} else {
											sendEmail($toEmailAddressList,$fromEmailAddress,"Error with project work metadata output directory",
											"ERROR: Unable to open/create project work metadata directory ($projDir$newDirectory)\n");
											die("ERROR: Unable to open/create project work metadata directory ($projDir$newDirectory)\n");
										}
									} else {
										sendEmail($toEmailAddressList,$fromEmailAddress,"Error with project work metadata output directory",
										"ERROR: Unable to open/create project work metadata directory ($projDir$newDirectory)\n");
										die("ERROR: Unable to open/create project work metadata directory ($projDir$newDirectory)\n");
									}
								} else {
									sendEmail($toEmailAddressList,$fromEmailAddress,"Error with project work metadata output directory",
									"ERROR: Unable to open/create project work metadata directory ($projDir$newDirectory)\n");
									die("ERROR: Unable to open/create project work metadata directory ($projDir$newDirectory)\n");
								}
							} else {
								sendEmail($toEmailAddressList,$fromEmailAddress,"Error with project image metadata output directory",
								"ERROR: Unable to open/create project image metadata directory ($projImgMetaDir)\n");
								die("ERROR: Unable to open/create project image metadata directory ($projImgMetaDir)\n");
							}
						} else {
							sendEmail($toEmailAddressList,$fromEmailAddress,"Error with project image metadata output directory",
							"ERROR: Unable to open/create project image metadata directory ($projDir$imagesDirectory)\n");
							die("ERROR: Unable to open/create project image metadata directory ($projDir$imagesDirectory)\n");
						}
					} else {
						sendEmail($toEmailAddressList,$fromEmailAddress,"Error with project image metadata output directory",
						"ERROR: Unable to open/create project image metadata directory ($projDir$imagesDirectory)\n");
						die("ERROR: Unable to open/create project image metadata directory ($projDir$imagesDirectory)\n");
					}
				} else {
					sendEmail($toEmailAddressList,$fromEmailAddress,"Error with project image metadata output directory",
					"ERROR: Unable to open/create project image metadata directory ($projDir$imagesDirectory)\n");
					die("ERROR: Unable to open/create project image metadata directory ($projDir$imagesDirectory)\n");
				}
			} else {
				sendEmail($toEmailAddressList,$fromEmailAddress,"Error with project output directory",
				"ERROR: Unable to open/create project directory ($projDir)\n");
				die("ERROR: Unable to open/create project directory ($projDir)\n");
			}
			
			# Get the Work data for the project.
			# Ignore the first line of the file since it contains header information.
			my $line = <INWRK>;
			my $workCount = 0;
			while (my $line = <INWRK>) {
				my $workNumber = parseWorkMetadata($line);
				$workCount++;
			}
			
			# Get the Image data for the project.
			# Ignore the first line of the file since it contains header information.
			my $line = <INIMG>;
			my $imageCount = 0;
			while (my $line = <INIMG>) {
				my $imageNumber = parseImageMetadata($line);
				$imageCount++;
			}
			
			# Output some counts to use for QA.
			$statisticsLog .= "Work count = $workCount\n";
			$statisticsLog .= "Image count = $imageCount\n";
			
			# Create the image metadata files.
			my $imageMetadataCount = 0;
			foreach my $imgNo (keys %imageNumbers) {
				# Only create image DESC files for new images, i.e. part of project sent to be scanned.
				if ($imageProjects{$imgNo} eq $project) {
					my $imageFileName = writeImageDescmetaFile($imgNo);
					if ($imageFileName ne "") {
						$imageMetadataCount++;
						# Transform the char entities to numeric
						transformFile($imageFileName,$descStyleSheet);
						# Validate the XML
						validateXmlFile($imageFileName);
						# Set correct group permissions
						chmod(0664,$imageFileName);
						system("chgrp $group $imageFileName") || warn("attempt to chgrp on image File $imageFileName failed.");
					}
				}
			}
			$statisticsLog .= "Image DESC files created = $imageMetadataCount\n";
			
			# Process each Work into a GDMS file.
			my $newWorkCount = 0;
			my $updateWorkCount = 0;
			foreach my $workNo (keys %workNumbers) {
				# Only generate a work file if it has a PID 
				# and the work has images associated with it.
print "creating GDMS file for $workNo (project $project)\n";
				if ((exists $workPIDs{$workNo}) and ($workPIDs{$workNo} ne "")) {
					if (getImageCount($workNo) gt 0) {
						# Identify whether the work is new or an update to determine where the
						# GDMS metadata file needs to go.
						my $workFile = "";
						if ($workExportDates{$workNo} ne "") {
							# Updated work record.
							$workFile = $projUpdWrkMetaDir . $workPIDs{$workNo} . ".xml";
							$updateWorkCount++;
						} else {
							# New work being exported.
							$workFile = $projNewWrkMetaDir . $workPIDs{$workNo} . ".xml";
							$newWorkCount++;
						}
						# Create the GDMS file.
						writeWorkGdmsFile($workNo,$workFile,$project) || warn("unable to write work GDMS file for $workFile\n");
						# Now update the file to get the filesize added to it.
						addFileSize($workFile);
						# Transform the entity references.
						transformFile($workFile,$gdmsStyleSheet) || warn("transformation of $workFile failed!\n");
						# Validate the XML file
						validateXmlFile($workFile) || warn("$workFile failed XML validation!\n");
						# Set correct group permissions
						chmod(0664,$workFile);
						system("chgrp $group $workFile") || warn("chgrp to grp $group on work file $workFile failed.\n");
					} else {
						$statisticsLog .= "Work # $workNo contains no images - a GDMS file was not generated for it.\n";
					}
				} else {
					$statisticsLog .= "Work # $workNo does not have a PID assigned - a GDMS file was not generated for it.\n";
				}
			} #end foreach
			$statisticsLog .= "New Work files created = $newWorkCount\n";
			$statisticsLog .= "Updated Work files created = $updateWorkCount\n";
			
			# Keep count of project items.
			$totalImageMetadataCount += $imageMetadataCount;
			$totalNewWorkCount += $newWorkCount;
			$totalUpdateWorkCount += $updateWorkCount;

			# Update the Image tracking system
			TrackSys::connect();
			my $query = "update imageProjects set numberMetadataFiles=$imageMetadataCount, 
				step4New=$newWorkCount, step4Updates=$updateWorkCount 
				where projectName='$project' limit 1";
			if (TrackSys::query($query) != 1) {
				$statisticsLog .= "ERROR: Cannot update DLPS tracking system for project '$project'\n";
				$errorCount++;
			}
			TrackSys::disconnect();
			
			} else { # content model not found
				$statisticsLog .= "ERROR: Content model not found for the project!\n";
				$errorCount++;
			} # content model exists.
			
		} else {
			$statisticsLog .= "ERROR: Missing images file. Project $project cannot be completed!\n";
			$errorCount++;
		}
		
		# If no errors occurred yet then the project files in the input directory
		# can be archived.
		if ($errorCount eq 0) {
			if (!rename($worksFile,$worksArchiveFile)) {
				$statisticsLog .= "ERROR: Unable to archive $worksFile!\n";
				$errorCount++;
			}
			if (!rename($imagesFile,$imagesArchiveFile)) {
				$statisticsLog .= "ERROR: Unable to archive $imagesFile!\n";
				$errorCount++;
			}
		} else {
			$statisticsLog .= "WARNING: Due to project errors, the input file(s) will not be archived.\n";
		}
		
		# Identify the number of errors that occurred for the project.
		if ($errorCount ne 0) {
			$statisticsLog .= "Error Count = $errorCount\n";
		}
		
		$statisticsLog .= "\n";
		$totalErrorCount += $errorCount;
		$errorCount = 0;
	}
	$statisticsLog .= "Total Image DESC File Count = $totalImageMetadataCount\n";
	$statisticsLog .= "Total New Work File Count = $totalNewWorkCount\n";
	$statisticsLog .= "Total Updated Work File count = $totalUpdateWorkCount\n\n";
} else {
	sendEmail($toEmailAddressList,$fromEmailAddress,"Error generating GDMS and Image DESC files",
		"ERROR: Unable to open IRIS export data directory ($inputDirectory)\n");
	die("ERROR: Unable to open IRIS export data directory ($inputDirectory)\n");
	$totalErrorCount += 1;
}
if ($totalErrorCount ne 0) {
	$statisticsLog .= "Total Error Count = $totalErrorCount\n\n";
}
$statisticsLog .= "End=" . (scalar localtime) . "\n";

# Send these statistics via email to DLPS to let them know that data has been
# exported, processed, and ready to go into the repository. Only of there were
# project files found.
if ($projectCount ne 0) {
	sendEmail($toEmailAddressList,$fromEmailAddress,"GDMS and Image DESC file status",$statisticsLog);
}

######################
## End Main Program ##
######################

#####
# addFileSize - opens each file and adds the file size to the appropriate
#			GDMS element. Makes a backup of the file before proceeding.
#
# @param $fileName - the name of the file to be processed.
#####
sub addFileSize{
	my ($fileName) = @_;
	my $type;
	my $value;
	
    # get file size in bytes
    my @stat = stat($fileName);
    my $bytes = $stat[7];

    # convert to most convenient/readable unit of measure
    if ($bytes >= 1048576) {
		$type = 'megabytes';
		$value = $bytes / 1048576;
		$value = sprintf("%.1f", $value);   # round to 1 decimal place
    } elsif ($bytes >= 1024) {
		$type = 'kilobytes';
		$value = $bytes / 1024;
		$value = sprintf("%d", $value);     # round to integer
    } else {
		$type = 'bytes';
		$value = $bytes;
    }

    # read input file
	my @infile = ();
    if (open(IN, $fileName)) {
	    @infile = <IN>;
    	close(IN);
    } else {
    	$statisticsLog .= "\nERROR: Cannot read '$fileName': $!\n";
		$errorCount++;
	}

    # make backup
    if (open(BAK, ">${fileName}.bak")) {
	    foreach (@infile) {
			print BAK;
    	}
    	close(BAK);
    } else {
    	$statisticsLog .= "\nERROR: Cannot write '${fileName}.bak': $!\n";
    	$errorCount++;
    }

    # make changes, overwriting input file
    if (open(OUT, ">$fileName")) {
	    my $in_fileDesc;
    	foreach (@infile) {
			if ( /<filedesc/ )	{ $in_fileDesc = 1; }
			if ( /<\/filedesc>/ )	{ $in_fileDesc = 0; }
			if ( /(<physdesc[^>]*>).*?<\/physdesc>/) {
			    if ($in_fileDesc) {
					my $out = $1 . "ca. <num type=\"$type\">$value</num> $type</physdesc>";
					$_ = $` . $out . $';
			    }
			}
			print(OUT);
    	}
    	close(OUT);
    } else {
    	$statisticsLog .= "\nERROR: Cannot write '$fileName': $!\n";
    	$errorCount++;
    }
}

#####
# checkProjectDirectory - Checks to see if the project directory exists. If it
# 		does not, then it will create it. Returns true (1) if the directory exists
#		or is successfully created. Otherwise false (0) is returned;
#
# @param $pathDir - the name of the directory to be checked.
#####
sub checkProjectDirectory{
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
		    chmod 0777, $pathDir;
		    system("chgrp $group $pathDir");
		}
	} else {
		closedir($dirHandle);
	}
	return $success;
}

#####
# convertEntities - Takes a string and converts any entity references to acceptable
#			values allowed in the GDMS structure.
#####
sub convertEntities {
	my ($string) = @_;
	$string=~s/ & / &amp\; /g;	
	$string=~s/\'/&apos\;/g;			
	$string=~s/\"/&quot\;/g;
	
	$string=~s/&cedil\;c/&ccedil\;/g;
	$string=~s/&cedil\;C/&Ccedil\;/g;
	
	$string=~s/&acute\;a/&aacute\;/g;
	$string=~s/&acute\;e/&eacute\;/g;
	$string=~s/&acute\;i/&iacute\;/g;
	$string=~s/&acute\;A/&Aacute\;/g;
	$string=~s/&acute\;E/&Eacute\;/g;
	$string=~s/&acute\;I/&Iacute\;/g;
	$string=~s/&acute\;O/&Oacute\;/g;
	$string=~s/&acute\;o/&oacute\;/g;
	$string=~s/&acute\;U/&Uacute\;/g;
	$string=~s/&acute\;u/&uacute\;/g;
	
	$string=~s/&grave\;a/&agrave\;/g;
	$string=~s/&grave\;e/&egrave\;/g;
	$string=~s/&grave\;i/&igrave\;/g;
	$string=~s/&grave\;A/&Agrave\;/g;
	$string=~s/&grave\;E/&Egrave\;/g;
	$string=~s/&grave\;I/&Igrave\;/g;
	$string=~s/&grave\;O/&Ograve\;/g;
	$string=~s/&grave\;o/&ograve\;/g;
	$string=~s/&grave\;U/&Ugrave\;/g;
	$string=~s/&grave\;u/&ugrave\;/g;
	
	$string=~s/&tilde\;a/&atilde\;/g;
	$string=~s/&tilde\;A/&Atilde\;/g;
	$string=~s/&tilde\;O/&Otilde\;/g;
	$string=~s/&tilde\;o/&otilde\;/g;
	$string=~s/&tilde\;n/&ntilde\;/g;
	$string=~s/&tilde\;N/&Ntilde\;/g;
	
	$string=~s/&uml\;A/&Auml\;/g;
	$string=~s/&uml\;a/&auml\;/g;
	$string=~s/&uml\;E/&Euml\;/g;
	$string=~s/&uml\;e/&euml\;/g;
	$string=~s/&uml\;I/&Iuml\;/g;
	$string=~s/&uml\;i/&iuml\;/g;
	$string=~s/&uml\;O/&Ouml\;/g;
	$string=~s/&uml\;o/&ouml\;/g;
	$string=~s/&uml\;U/&Uuml\;/g;
	$string=~s/&uml\;u/&uuml\;/g;

	return $string;
}

#####
# createID - Returns an identifier value that is unique for use within the
# 			GDMS document that is being generated.
#
# @param $prefix - the character prefix to be applied to the numeric identifier.
# @param $newDocument - if value is one then indicates that a new document
#				is being created.
# @param $randomMax - the random number Maximum value desired, which should only
#				be passed when creating an ID for the new document which initializes
#				the id counter for that document.
#####
sub createID {
	my ($prefix,$newDocument,$randomMax) = @_;
	
	# If a new document is being started then initialize the id to the timestamp.
	# Otherwise just increment the existing id value by one for a new id in the
	# same document.
	if ($newDocument == 1) {
		$createIDCounter = currentDate("date") . sprintf("%05d",int(rand($randomMax) + 1));
	} else {
		$createIDCounter++;
	}
		
	return $prefix . $createIDCounter;
}

#####
# currentDate - Returns a the current date formatted as YYYYMMDD.
#
# @param $format - pass the value of "string" or "date" to specify which format
# 				should be returned to the caller.
#####
sub currentDate {
	my ($format) = @_;
	my @monthName = ("January","February","March","April","May","June",
					"July","August","September","October","November","December");
	my $second;
	my $minute;
	my $hour;
	my $day;
	my $month;
	my $year;
	my $weekday;
	my $yearday;
	my $isdst;
	my $today;
	
	($second,$minute,$hour,$day,$month,$year,$weekday,$yearday,$isdst) = localtime();
	$year += 1900;
	
	if ($format eq "date") {
		$month += 1;
		$today = sprintf("%04d%02d%02d",$year,$month,$day);
	} elsif ($format eq "string") {
		$today = sprintf("%s %2d, %04d",$monthName[$month],$day,$year);
	} else {
		$today = "";
	}
	return $today;
}

#####
# getImageCount - returns the number of images associated with a work.
#
# @param $workNumber - the work number whose image count is desired.
#####
sub getImageCount {
	my ($workNumber) = @_;
	my $imageCount = 0;		# number of images in a work.
	
	foreach my $imageNumber (sort keys %imageWorkNumbers) {	
		if ($imageWorkNumbers{$imageNumber} =~ m/(.*)$workNumber(.*)/) {
			$imageCount++;
		}
	}
	return $imageCount;
}

#####
# getPrimaryWorkTitle
#
# @param $titleCount - a count of the number of titles found in the titles string.
# @param $titles - a string of titles separated using the value separator.
# @param $qualifiers - a string of title qualifiers separated using the value separator.
#####
sub getPrimaryWorkTitle {
	my ($titleCount,$titles,$titleQualifiers) = @_;
	my $primaryWorkTitle = "";
	
	# Put the titles and title qualifiers into an array for easier use.
	my @workTitles = split($valueSeparator,$titles);
	my @workTitleQualifiers = split($valueSeparator,$titleQualifiers);
	
	# Search the title qualifiers to identify which title is the primary one.
	for (my $i=0; $i < $titleCount; $i++) {
		if (@workTitleQualifiers[$i] =~ /primary/i) {
			$primaryWorkTitle = @workTitles[$i];
		}
	}
	
	# If no primary title was found then look for a constructed one.
	if ($primaryWorkTitle eq "") {
		for (my $i=0; $i < $titleCount; $i++) {
			if (@workTitleQualifiers[$i] =~ /constructed/i) {
				$primaryWorkTitle = @workTitles[$i];
			}
		}
	}
	
	return $primaryWorkTitle;
}

#####
# initializeArrays - Reset all the global work and image metadata arrays so 
# they are empty.
#
#####
sub initializeArrays {
	%imageNumbers = ();
	%digitalFileNames = ();
	%imageColors = ();	
	%imageViewTypes = ();	
	%imageViewDescriptions = ();
	%imageViewDates = ();
	%imageSubjects = ();	
	%imageSubjectAuthorities = ();
	%imageSubjectSubtypes = ();
	%imageSubtypeAuthorities = ();
	%imagePIDs = ();
	%imageProjects = ();
	%imageExportDates = ();
	%imageSourceNumbers = ();
	%sourceImageTypes = ();
	%sourceRightsType = ();
	%sourceLabelCopyright = ();
	%sourceVendorCopyright = ();
	%imageWorkNumbers = ();
	%workNumbers = ();	
	%workPIDs = ();	
	%workProjects = ();	
	%workCategories = ();	
	%workSubjects = ();	
	%workSubjectAuthorities = ();
	%workSubjectSubtypes = ();
	%workSubtypeAuthorities = ();
	%workMaterials = ();	
	%workCenturies = ();	
	%workStartYears = ();	
	%workEndYears = ();	
	%workDates = ();		
	%workEras = ();		
	%workCountries = ();	
	%workTypes = ();		
	%workTypeAuthorities = ();
	%workCurrentSites = ();
	%workCultures = ();	
	%workCultureAuthorities = ();
	%workPeriods = ();	
	%workPeriodAuthorities = ();
	%workTechniques = ();	
	%workRepositoryDisplays = ();
	%workRepositoryAuthorities = ();
	%workTitleCounts = ();
	%workTitles = ();		
	%workTitleQualifiers = ();
	%workCreatorCounts = ();
	%workCreatorNames = ();
	%workCreatorQualifiers = ();
	%workCreatorRoles = ();
	%workCreatorDates = ();
	%workCreatorAuthorities = ();
	%workFormerSites = ();
	%workLocalities = ();
	%workDimensions = ();
	%workRepositoryNumbers = ();
	%workCollectors = ();
	%workCatalogersNotes = ();
	%workExportDates = ();
}

#####
# parseImageMetadata - Read a text line from the image input file and split it out
#			into its various metadata items. Items are parsed out into global
#			variables so that the metadata is available to the entire program.
#			Return the IRIS image number (first field) for reference if there
#			is an issue with the data line being processed.
#
# @param $textLine - a text line from the input file.
#####
sub parseImageMetadata {
	my ($textLine) = @_;
	my @inputRecord = split($fieldSeparator,$textLine);
	# Image number is the third array entry, i.e. index 2.
	# Remove any commas from the work number.
	@inputRecord[0] =~ s/,//;
	# Metadata associated with the IRIS image number.
	if ($imageWorkNumbers{@inputRecord[2]} =~ m/@inputRecord[0]/) {
		# do nothing since the work number is associated with the image
	} else {
		$imageWorkNumbers{@inputRecord[2]} .= @inputRecord[0] . ",";
	}
	### Work project name is located in @inputRecord[1] element.
	$imageNumbers{@inputRecord[2]} = trim(@inputRecord[2]);
	$imagePIDs{@inputRecord[2]} = trim(@inputRecord[3]);
	$imageProjects{@inputRecord[2]} = trim(@inputRecord[4]);
	$digitalFileNames{@inputRecord[2]} = trim(@inputRecord[5]);
	$imageColors{@inputRecord[2]} = trim(@inputRecord[6]);
	$imageViewTypes{@inputRecord[2]} = trim(@inputRecord[7]);
	$imageViewDescriptions{@inputRecord[2]} = trim(@inputRecord[8]);
	$imageViewDates{@inputRecord[2]} = trim(@inputRecord[9]);
	$imageSubjects{@inputRecord[2]} = trim(@inputRecord[10]);
	$imageSubjectAuthorities{@inputRecord[2]} = trim(@inputRecord[11]);
	$imageSubjectSubtypes{@inputRecord[2]} = trim(@inputRecord[12]);
	$imageSubtypeAuthorities{@inputRecord[2]} = trim(@inputRecord[13]);
	$imageExportDates{@inputRecord[2]} = trim(@inputRecord[14]);
	$imageVendorCodes{@inputRecord[2]} = trim(@inputRecord[15]);
	$imageIdentifierTypes{@inputRecord[2]} = trim(@inputRecord[16]);
	$imageIdentifierNumbers{@inputRecord[2]} = trim(@inputRecord[17]);
	$imageSourceNumbers{@inputRecord[2]} = trim(@inputRecord[18]);
	$sourceImageTypes{@inputRecord[2]} = trim(@inputRecord[19]);
	$sourceRightsType{@inputRecord[2]} = trim(@inputRecord[20]);
	$sourceLabelCopyright{@inputRecord[2]} = trim(@inputRecord[21]);
	$sourceVendorCopyright{@inputRecord[2]} = trim(@inputRecord[22]);
	$sourceVendorSetNum{@inputRecord[2]} = trim(@inputRecord[23]);
	
	return @inputRecord[0];	# return the image number for the input line.
}

#####
# parseWorkMetadata - Read a text line from the work file and split it out
#			into its various metadata items. Items are parsed out into global
#			variables so that the metadata is available to the entire program.
#			Return the IRIS work number (first field) for reference if there
#			is an issue with the data line being processed.
#
# @param $textLine - a text line from the input file.
#####
sub parseWorkMetadata {
	my ($textLine) = @_;
	my @inputRecord = split($fieldSeparator,$textLine);
	# Remove any commas from the work number.
	@inputRecord[0] =~ s/,//;
	$workNumbers{@inputRecord[0]} = trim(@inputRecord[0]);
	# Metadata associated with the IRIS work number.
	$workPIDs{@inputRecord[0]} = trim(@inputRecord[1]);
	$workProjects{@inputRecord[0]} = trim(@inputRecord[2]);
	$workCategories{@inputRecord[0]} = trim(@inputRecord[3]);
	$workSubjects{@inputRecord[0]} = trim(@inputRecord[4]);
	$workSubjectAuthorities{@inputRecord[0]} = trim(@inputRecord[5]);
	$workSubjectSubtypes{@inputRecord[0]} = trim(@inputRecord[6]);
	$workSubtypeAuthorities{@inputRecord[0]} = trim(@inputRecord[7]);
	$workMaterials{@inputRecord[0]} = trim(@inputRecord[8]);
	$workCenturies{@inputRecord[0]} = trim(@inputRecord[9]);
	$workStartYears{@inputRecord[0]} = trim(@inputRecord[10]);
	$workEndYears{@inputRecord[0]} = trim(@inputRecord[11]);
	$workDates{@inputRecord[0]} = trim(@inputRecord[12]);
	$workEras{@inputRecord[0]} = trim(@inputRecord[13]);
	$workCountries{@inputRecord[0]} = trim(@inputRecord[14]);
	$workTypes{@inputRecord[0]} = trim(@inputRecord[15]);
	$workTypeAuthorities{@inputRecord[0]} = trim(@inputRecord[16]);
	$workCurrentSites{@inputRecord[0]} = trim(@inputRecord[17]);
	$workCultures{@inputRecord[0]} = trim(@inputRecord[18]);
	$workCultureAuthorities{@inputRecord[0]} = trim(@inputRecord[19]);
	$workPeriods{@inputRecord[0]} = trim(@inputRecord[20]);
	$workPeriodAuthorities{@inputRecord[0]} = trim(@inputRecord[21]);
	$workTechniques{@inputRecord[0]} = trim(@inputRecord[22]);
	$workRepositoryDisplays{@inputRecord[0]} = trim(@inputRecord[23]);
	$workRepositoryAuthorities{@inputRecord[0]} = trim(@inputRecord[24]);
	$workTitleCounts{@inputRecord[0]} = trim(@inputRecord[25]);
	$workTitles{@inputRecord[0]} = trim(@inputRecord[26]);
	$workTitleQualifiers{@inputRecord[0]} = trim(@inputRecord[27]);
	$workCreatorCounts{@inputRecord[0]} = trim(@inputRecord[28]);
	$workCreatorNames{@inputRecord[0]} = trim(@inputRecord[29]);
	$workCreatorQualifiers{@inputRecord[0]} = trim(@inputRecord[30]);
	$workCreatorRoles{@inputRecord[0]} = trim(@inputRecord[31]);
	$workCreatorDates{@inputRecord[0]} = trim(@inputRecord[32]);
	$workCreatorAuthorities{@inputRecord[0]} = trim(@inputRecord[33]);
	$workFormerSites{@inputRecord[0]} = trim(@inputRecord[34]);
	$workLocalities{@inputRecord[0]} = trim(@inputRecord[35]);
	$workDimensions{@inputRecord[0]} = trim(@inputRecord[36]);
	$workRepositoryNumbers{@inputRecord[0]} = trim(@inputRecord[37]);
	$workCollectors{@inputRecord[0]} = trim(@inputRecord[38]);
	$workCatalogersNotes{@inputRecord[0]} = trim(@inputRecord[39]);
	$workExportDates{@inputRecord[0]} = trim(@inputRecord[40]);	# get rid of trailing new line char.
	
	return @inputRecord[0];	# return the work number for the input line.
}

#####
# sendEmail - Sends an email message.
#
# @param $toAddr - address of who the message goes to
# @param $fromAddr - address that the message should appear from
# @param $subj - subject of the message
# @param $msg - content of the email to be sent out
#####
sub sendEmail {
	my ($toAddr,$fromAddr,$subj,$msg) = @_;
	
	open(MAIL,"| /usr/sbin/sendmail -i -t");
	print MAIL "To: $toAddr\n";
	print MAIL "From: $fromAddr\n";
	print MAIL "Subject: $subj\n\n";
	print MAIL "$msg\n";
	close(MAIL);
}

#####
# splitDate - Split a start/end year into text, year, and era parts.
#
# @param $strDate - start/end year date string to have split apart.
#####
sub splitDate {
	my ($strDate) = @_;
	my $type = "";
	my $year = "";
	my $era = "";
	
	if ($strDate =~ m/^([a-zA-Z]+\.)(.*)/) {
		$type = trim(convertEntities($1));
		$year = trim(convertEntities($2));
		if ($year =~ m/^([0-9]*)(.*)/) {
			$year = $1;
			$era = trim(convertEntities($2));
		} else {
			$era = "";
		}
	} elsif ($strDate =~ m/^([a-zA-Z]+)(.*)/) {
		$type = trim(convertEntities($1));
		$year = trim(convertEntities($2));
		if ($year =~ m/^([0-9]*)(.*)/) {
			$year = $1;
			$era = trim(convertEntities($2));
		}
	} elsif ($strDate =~ m/^([0-9]*)(.*)/) {
		$year = trim(convertEntities($1));
		$era = trim(convertEntities($2));
	} else {
		$year = trim(convertEntities($strDate));
	}
	
	return ($type, $year, $era);
}

#####
# transformFile - Runs an XSLT tranformation to convert character entity references
#		to numeric entities. Renames the file as a backup and then does the
#		transformation on the renamed file.
#
# @param $fileName - the name of the file to be processed.
#####
sub transformFile{
	my ($fileName,$styleSheet) = @_;
	my $backupFileName = $fileName . ".bak";
	
    # Move the current file to the backup file.
    if (rename($fileName,$backupFileName)) {
    	# Transform the file using Saxon.
		my $cp = "$SAXON_PATH/saxon_6.5.4/saxon.jar:$SAXON_PATH/saxon_6.5.4/saxon-xml-apis.jar";
		my $command = "java -cp $cp com.icl.saxon.StyleSheet -o $fileName $backupFileName $transformationStyleSheetLocation$styleSheet 2>&1";
		my $error = `$command`;
		if ($error) {
			$statisticsLog .= "\nERROR: Cannot transform $backupFileName\n";
    		$errorCount++;
		} else {
			if (unlink($backupFileName) ne 1) {
				$statisticsLog .= "\nERROR: Unable to delete $backupFileName\n";
				$errorCount++;
			}
		}
    } else {
    	$statisticsLog .= "\nERROR: Cannot rename $fileName to $backupFileName - transformation was not performed.\n";
    	$errorCount++;
    }
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

#####
# validateXmlFile - Runs the parse script created for text processing to validate
#			that the GDMS file conforms to the DTD specifications.
#
# @param $fileName - the name of the file to be processed.
#####
sub validateXmlFile{
	my ($fileName) = @_;
	
	my $error = `parse $fileName 2>&1`;
	if ($error) {
		$statisticsLog .= "\nERROR: $fileName is invalid XML.\n";
    	$errorCount++;
	}
}

#####
# writeCloseDivGDMS - Generates a closing DIV tag for the GDMS document.
#####
sub writeCloseDivGDMS {
   print(OUTPUT "\t</div>\n");
}

#####
# writeDivdescGDMS
#
# @param $workNumber - the IRIS work number being generated into a GDMS document.
#####
sub writeDivdescGDMS {
	my ($workNumber) = @_;
	my $i;					# for loop counter.
	my $numberOfElements;	# number of elements in an array.
	
	print(OUTPUT "\t\t<divdesc>\n");
	
	# Generate media tags for the work type.
	my @workTypes = split($valueSeparator,$workTypes{$workNumber});
	my @workTypesAuthority = split($valueSeparator,$workTypeAuthorities{$workNumber});
	$numberOfElements = scalar(@workTypes);
	if ($numberOfElements > 0) {
		print(OUTPUT "\t\t\t<mediatype type=\"physicalobject\">\n");
		for ($i=0; $i < $numberOfElements; $i++) {
			my $workType = trim(convertEntities(@workTypes[$i]));
			my $authority = trim(convertEntities(@workTypesAuthority[$i]));
			if ($workType ne "") {
				print(OUTPUT "\t\t\t\t<form>$workType");
				if ($authority ne "") {
					print(OUTPUT "<authority>$authority</authority>");
				}
				print(OUTPUT "</form>\n");
			}
		}
		print(OUTPUT "\t\t\t</mediatype>\n");
	}

	print(OUTPUT "\t\t\t<identifier type=\"UVa Fine Arts\">$workNumber</identifier>\n");
	
	# Generate a title tag for each work title using the qualifier to distinguish each title.
	my @workTitles = split($valueSeparator,$workTitles{$workNumber});
	my @workTitleQualifiers = split($valueSeparator,$workTitleQualifiers{$workNumber});
	for ($i=0; $i < $workTitleCounts{$workNumber}; $i++) {
		my $qualifier = trim(@workTitleQualifiers[$i]);
		# Translate the qualifier values if primary or variant
		if ($qualifier eq "Primary") {
			$qualifier =  "main";
		} elsif ($qualifier eq "Variant") {
			$qualifier = "alternate";
		}
		my $title = trim(convertEntities(@workTitles[$i]));
		if ($title ne "") {
			print(OUTPUT "\t\t\t<title");
			if ($qualifier ne "") {
				print(OUTPUT " type=\"$qualifier\"");
			}
			print(OUTPUT ">$title</title>\n");
		}
	}
	
	# Generate a subject tag for each work category.
	my @workSubjects = split($valueSeparator,$workCategories{$workNumber});
	$numberOfElements = scalar(@workSubjects);
	for ($i=0; $i < $numberOfElements; $i++) {
		my $subject = trim(convertEntities(@workSubjects[$i]));
		if ($subject ne "") {
			print(OUTPUT "\t\t\t<subject>$subject</subject>\n");
		}
	}	

	# Generate a subject and authority tag for each subject and sub-type.
	my @workSubjects = split($valueSeparator,$workSubjects{$workNumber});
	my @workSubjectsAuthority = split($valueSeparator,$workSubjectAuthorities{$workNumber});
	my @workSubjectSubtypes = split($valueSeparator,$workSubjectSubtypes{$workNumber});
	# With subject and subtypes combined, the subtype authority is not needed.
	#my @workSubjectSubtypesAuthority = split($valueSeparator,$workSubtypeAuthorities{$workNumber});
	$numberOfElements = scalar(@workSubjects);
	for ($i=0; $i < $numberOfElements; $i++) {
		my $subject = trim(convertEntities(@workSubjects[$i]));
		my $subtype = trim(convertEntities(@workSubjectSubtypes[$i]));
		my $authority = trim(convertEntities(@workSubjectsAuthority[$i]));
		if (($subject ne "") || ($subtype ne "")) {
			print(OUTPUT "\t\t\t<subject");
			if ($authority ne "") {
				print(OUTPUT " scheme=\"$authority\"");
			}
			print(OUTPUT ">$subject");
			if ($subtype ne "") {
				print(OUTPUT " -- $subtype");
			}
			print(OUTPUT "</subject>\n");
		}
	}	

	# Create a physdesc tag for each materials item for a work
	my @workMaterials = split($valueSeparator,$workMaterials{$workNumber});
	$numberOfElements = scalar(@workMaterials);
	for ($i=0; $i < $numberOfElements; $i++) {
		my $material = trim(convertEntities(@workMaterials[$i]));
		if ($material ne "") {
			print(OUTPUT "\t\t\t<physdesc type=\"medium\">$material</physdesc>\n");
		}
	}
	
	# Create time interval tags for the work era
	my $era = trim(convertEntities($workEras{$workNumber}));
	if (($era eq "BCE") or ($era eq "CE")) {
		if ($era eq "BCE") {
			$era = "bc";
		} else {
			$era = "ad";
		}
	} else {
		$era = "";
	}
	
	# If there are start and/or end years then we want to put them in time/date 
	# tags.
	my $displayCentury = 1;		# i.e. true
	my $startYear = trim($workStartYears{$workNumber});
	my $endYear = trim($workEndYears{$workNumber});
	if (($startYear ne "") || ($endYear ne "")) {
		print(OUTPUT "\t\t\t<time>\n");
		if ($startYear ne "") {
			if ($startYear ne $endYear) {
				print(OUTPUT "\t\t\t\t<date type=\"begin\"");
				if ($era ne "") {
					print(OUTPUT " era=\"$era\"");
				}
				print(OUTPUT ">$startYear</date>\n");
			} else {
				print(OUTPUT "\t\t\t\t<date");
				if ($era ne "") {
					print(OUTPUT " era=\"$era\"");
				}
				print(OUTPUT ">$startYear</date>\n");
			}
			$displayCentury = 0;
		}
		if ($endYear ne "") {
			if ($startYear ne $endYear) {
				print(OUTPUT "\t\t\t\t<date type=\"end\"");
				if ($era ne "") {
					print(OUTPUT " era=\"$era\"");
				}
				print(OUTPUT ">$endYear</date>\n");
			}
			$displayCentury = 0;
		}
		print(OUTPUT "\t\t\t</time>\n");
	}
	
	# Repeat the business logic used in IRIS to create a "work dates" field.
	# This is done so as to see if the work dates field in IRIS has been
	# modified from what the calculation would create. This will allow for
	# identifying if the work dates field needs to be included in the GDMS file
	# generation.
	my $calcWorkDate;
	if ($startYear eq $endYear) {
		$calcWorkDate = $endYear;
	} else {
		if ($endYear eq "") {
			$calcWorkDate = "";
		} else {
			$calcWorkDate = $startYear . "-" . $endYear;
		}
	}
	
	# If there is a work date value then check to see...	
	my $workDate = trim($workDates{$workNumber});
	if ($workDate ne "") {
		my $wdStartYear = "";
		my $wdEndYear = "";
	
		# If the start/end year combo is different than the work dates then we need
		# to parse and include the work dates.
		if ($calcWorkDate ne $workDate) { 
			if ($workDate =~ m/(.*)-(.*)/) {
				$wdStartYear = trim(convertEntities($1));
				$wdEndYear = trim(convertEntities($2));
			} elsif ($workDate =~ m/(.*)-$/) {
				$wdStartYear = trim(convertEntities($1));
			} elsif ($workDate =~ m/^-(.*)/) {
				$wdEndYear = trim(convertEntities($1));
			} else {
				$wdStartYear = $workDate;
			}

			if (($wdStartYear ne "") || ($wdEndYear ne "")) {
				print(OUTPUT "\t\t\t<time>\n");
				my $type;
				my $year;
				my $junkera;	# Era discarded since not necessarily ad|bc|cc|cd
				if ($wdStartYear ne "") {
					($type, $year, $junkera) = splitDate($wdStartYear);
					if ($type eq "") {
						$type = "begin";
					}
					print(OUTPUT "\t\t\t\t<date");
					print(OUTPUT " type=\"$type\"");
					print(OUTPUT ">$year</date>\n");
				}
				if ($wdEndYear ne "") {
					($type, $year, $junkera) = splitDate($wdEndYear);
					if ($type eq "") {
						$type = "end";
					}
					print(OUTPUT "\t\t\t\t<date");
					print(OUTPUT " type=\"$type\"");
					print(OUTPUT ">$year</date>\n");
				}	
				print(OUTPUT "\t\t\t</time>\n");
				$displayCentury = 0;
			}
		}
	}
	
	# Create time interval tags for each century item for a work ONLY if
	# no work dates existed.
	if ($displayCentury) {
		my @workCenturies = split($valueSeparator,$workCenturies{$workNumber});
		$numberOfElements = scalar(@workCenturies);
		for ($i=0; $i < $numberOfElements; $i++) {
			my $century = trim(convertEntities(@workCenturies[$i]));
			if ($century ne "") {
				if (($century eq "1") or ($century eq "21")) {
					$century .= "st";
				} elsif ($century eq "2") {
					$century .= "nd";
				} elsif ($century eq "3") {
					$century .= "rd";
				} else {
					$century .= "th";
				}
				print(OUTPUT "\t\t\t<time><timeinterval");
				if ($era ne "") {
					print(OUTPUT " era=\"$era\"");
				}
				print(OUTPUT ">$century century</timeinterval></time>\n");
			}
		}
	}

	# Generate a place tag for the work country information.
	my $country = trim(convertEntities($workCountries{$workNumber}));
	if ($country ne "") {
		print(OUTPUT "\t\t\t<place type=\"country\"><geogname>$country</geogname></place>\n");
	}
	
	# Put the current site into a place tag.
	my $currentSite = trim(convertEntities($workCurrentSites{$workNumber}));
	$currentSite =~ s/,[ A-Z]{3,5}$//;	# drop country code from site name
	if ($currentSite ne "") {
		print(OUTPUT "\t\t\t<place type=\"current site\"><geogname>$currentSite</geogname></place>\n");
	}
	
	# Put the former site into a place tag.
	my $formerSite = trim(convertEntities($workFormerSites{$workNumber}));
	$formerSite =~ s/,[ A-Z]{3,5}$//;	# drop country code from site name
	if ($formerSite ne "") {
		print(OUTPUT "\t\t\t<place type=\"former site\"><geogname>$formerSite</geogname></place>\n");
	}
	
	# Put the locality into a place tag.
	my $locality = trim(convertEntities($workLocalities{$workNumber}));
	if ($locality ne "") {
		print(OUTPUT "\t\t\t<place type=\"locality\"><geogname>$locality</geogname></place>\n");
	}
	
	# Generate a culture and authority tag for each IRIS work culture item.
	my @workCultures = split($valueSeparator,$workCultures{$workNumber});
	my @workCulturesAuthority = split($valueSeparator,$workCultureAuthorities{$workNumber});
	$numberOfElements = scalar(@workCultures);
	for ($i=0; $i < $numberOfElements; $i++) {
		my $culture = trim(convertEntities(@workCultures[$i]));
		my $authority = trim(convertEntities(@workCulturesAuthority[$i]));
		if ($culture ne "") {
			print(OUTPUT "\t\t\t<culture>$culture");
			if ($authority ne "") {
				print(OUTPUT "<authority>$authority</authority>");
			}
			print(OUTPUT "</culture>\n");
		}
	}
	
	# Generate a style and authority tag for each IRIS work period item.
	my @workPeriods = split($valueSeparator,$workPeriods{$workNumber});
	my @workPeriodsAuthority = split($valueSeparator,$workPeriodAuthorities{$workNumber});
	$numberOfElements = scalar(@workPeriods);
	for ($i=0; $i < $numberOfElements; $i++) {
		my $style = trim(convertEntities(@workPeriods[$i]));
		my $authority = trim(convertEntities(@workPeriodsAuthority[$i]));
		if ($style ne "") {
			print(OUTPUT "\t\t\t<style>$style");
			if ($authority ne "") {
				print(OUTPUT "<authority>$authority</authority>");
			}
			print(OUTPUT "</style>\n");
		}
	}	
	
	# Create a description tag for each work technique.
	my @workTechniques = split($valueSeparator,$workTechniques{$workNumber});
	$numberOfElements = scalar(@workTechniques);
	for ($i=0; $i < $numberOfElements; $i++) {
		my $technique = trim(convertEntities(@workTechniques[$i]));
		if ($technique ne "") {
			print(OUTPUT "\t\t\t<description type=\"technique\">$technique</description>\n");
		}
	}

	# Put the dimensions into a physdesc tag.
	my $dimensions = trim(convertEntities($workDimensions{$workNumber}));
	if ($dimensions ne "") {
		print(OUTPUT "\t\t\t<physdesc type=\"extent\">$dimensions</physdesc>\n");
	}
	
	# The repository is mapped to an agent tag.
	my $repository = trim(convertEntities($workRepositoryDisplays{$workNumber}));
	my $repositoryAuthority = trim(convertEntities($workRepositoryAuthorities{$workNumber}));
	my $repositoryNumber = trim(convertEntities($workRepositoryNumbers{$workNumber}));
	if ($repository ne "") {
		print(OUTPUT "\t\t\t<agent type=\"provider\" form=\"corpname\" role=\"repository\">\n");
		#print(OUTPUT "\t\t\t\t<name scheme=\"\">$repository</name>\n");
		print(OUTPUT "\t\t\t\t<name>$repository</name>\n");
		if ($repositoryNumber ne "") {
			print(OUTPUT "\t\t\t\t<identifier type=\"item ID\">$repositoryNumber</identifier>\n");
		}
		print(OUTPUT "\t\t\t</agent>\n");
	}
	
	# Put the collector in as an agent.
	my $collector = trim(convertEntities($workCollectors{$workNumber}));
	if ($collector ne "") {
		print(OUTPUT "\t\t\t<agent type=\"provider\" form=\"persname\" role=\"collector\"><name>$collector</name></agent>\n");
	}
	
	# Map work creators to agent tags.
	my @creatorNames = split($valueSeparator,$workCreatorNames{$workNumber});
	my @creatorQualifiers = split($valueSeparator,$workCreatorQualifiers{$workNumber});
	my @creatorRoles = split($valueSeparator,$workCreatorRoles{$workNumber});
	my @creatorDates = split($valueSeparator,$workCreatorDates{$workNumber});
	my @creatorAuthorities = split($valueSeparator,$workCreatorAuthorities{$workNumber});
	for ($i=0; $i < $workCreatorCounts{$workNumber}; $i++) {
		my $creator = trim(convertEntities(@creatorNames[$i]));
		my $qualifier = trim(convertEntities(@creatorQualifiers[$i]));
		my $role = trim(convertEntities(@creatorRoles[$i]));
		my $dateRange = trim(convertEntities(@creatorDates[$i]));
		my $authority = trim(convertEntities(@creatorAuthorities[$i]));
		my $startYear = "";
		my $endYear = "";
		if ($dateRange =~ m/(.*)-(.*)/) {
			$startYear = trim($1);
			$endYear = trim($2);
		} elsif ($dateRange =~ m/(.*)-$/) {
			$startYear = trim($1);
			$endYear = "";
		} elsif ($dateRange =~ m/^-(.*)/) {
			$startYear = "";
			$endYear = trim($2);
		} else {
			$startYear = trim($dateRange);
			$endYear = "";
		}
		print(OUTPUT "\t\t\t<agent type=\"creator\"");
		if ($role ne "") {
			print(OUTPUT " role=\"$role\"");
		}
		print(OUTPUT ">\n");
		if ($creator ne "") {
			print(OUTPUT "\t\t\t\t<name");
			if ($authority ne "") {
				print(OUTPUT " scheme=\"$authority\"");
			}
			print(OUTPUT ">$creator</name>\n");
		}
		if (($startYear ne "") || ($endYear ne "")) {
			print(OUTPUT "\t\t\t\t<time>\n");
			if ($startYear ne "") {
				print(OUTPUT "\t\t\t\t\t<date type=\"begin\">$startYear</date>\n");
			}
			if ($endYear ne "") {
				print(OUTPUT "\t\t\t\t\t<date type=\"end\">$endYear</date>\n");
			}
			print(OUTPUT "\t\t\t\t</time>\n");
		}
		if ($qualifier ne "") {
			print(OUTPUT "\t\t\t\t<note>$qualifier</note>\n");
		}
		print(OUTPUT "\t\t\t</agent>\n");
	}
	
	# Put the cataloger's notes in a description element.
	my $catalogersNotes = trim(convertEntities($workCatalogersNotes{$workNumber}));
	if ($catalogersNotes ne "") {
		print(OUTPUT "\t\t\t<description type=\"note\">$catalogersNotes</description>\n");
	}
	print(OUTPUT "\t\t</divdesc>\n");
}

#####
# writeImageDescmetaFile - Outputs the image descmeta data to an XML file. Return
#		the full path/name of the resulting image file.
#
# @param $imgNo - the value of the image number to be processed
#####
sub writeImageDescmetaFile {
	my ($imgNo) = @_;
	# Define the file name by including the full path to where it goes.
	my $imageMetadataFile = $projImgMetaDir . $imagePIDs{$imgNo} . ".xml";
print "attempting to write Image desc meta file $imageMetadataFile \n";
sleep 3;
	if (open(OUTIMG,">",$imageMetadataFile)) {
		print(OUTIMG "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
		print(OUTIMG "<!DOCTYPE descmeta SYSTEM \"$descmetaDtdLocation\">\n");
		print(OUTIMG "<descmeta>\n");
		print(OUTIMG "\t<pid>$imagePIDs{$imgNo}</pid>\n");
		print(OUTIMG "\t<mediatype type=\"image\"/>\n");
		# Identify the Works associated with this image and get their PIDs.
		my $workList = $imageWorkNumbers{$imgNo};
		$workList =~ s/\,$//;
		my @workArray = split(",",$workList);
		foreach my $workNo (@workArray) {
			print(OUTIMG "\t<identifier type=\"parent\">\n");
			print(OUTIMG "\t\t$workPIDs{$workNo}\n");
			print(OUTIMG "\t</identifier>\n");
		}
		# Generate a rights tag for the IRIS image source rights type.
		my $rights = trim(convertEntities($sourceRightsType{$imgNo}));
		if ($rights eq "") {
			$rights = "uva";
		}
		my $rightsText = "";
		if ($rights eq "uva") {
			$rightsText = "Accessible to UVa community only";
		} elsif ($rights eq "public") {
			$rightsText = "Publicly accessible";
		} elsif ($rights eq "viva") {
			$rightsText = "Accessible to VIVA* community only";
		} elsif ($rights eq "restricted") {
			$rightsText = "Restricted to Library staff for management only";
		}
		print(OUTIMG "\t<rights type=\"access\">$rightsText</rights>\n");
		# Get the title for just the first work associated with the image.
		my $listWorkTitles = $workTitles{@workArray[0]};
		my @workTitles = split($valueSeparator,$listWorkTitles);
		my $workTitle = trim(convertEntities(@workTitles[0]));
		print(OUTIMG "\t<title>$workTitle");
		# Get the first view type for the image.
		my @imageViewTypes = split($valueSeparator,$imageViewTypes{$imgNo});
		my $viewType = trim(convertEntities(@imageViewTypes[0]));
		my $viewDescription = trim(convertEntities($imageViewDescriptions{$imgNo}));
		my $description = "";
		# Combine the view type and description with comma space if both exist.
		if (($viewType ne "") && ($viewDescription ne "")) {
			$description = $viewType . ", " . $viewDescription;
		} else {
			$description = $viewType . $viewDescription;
		}
		$description = convertEntities($description);
		# Check for a non-empty description before bothering to output as part of the title.
		if ($description ne "") {
			print(OUTIMG " : $description");
		}
		print(OUTIMG "</title>\n");
		print(OUTIMG "</descmeta>\n");
		close(OUTIMG);
		return $imageMetadataFile;
	} else {
		$statisticsLog .= "\nERROR: Unable to create $imagePIDs{$imgNo} image metadata file.\n";
		$errorCount++;
		return "";
	}
}

#####
# writeOpenDivGDMS - Generates an opening DIV tag for the GDMS document.
#
# @param $id - the value for the id attribute of the DIV tag.
# @param $type - the value for the type attribute of the DIV tag.
# @param $label - the value for the label attribute of the DIV tag.
#####
sub writeOpenDivGDMS {
	my ($id,$type,$label) = @_;
   print(OUTPUT "\t<div id=\"$id\" type=\"$type\" label=\"$label\">\n");
}

#####
# writeFooterXML - Writes out the footer information for a GDMS XML document.
#####
sub writeFooterXML {
   print(OUTPUT "</gdms>");
}

#####
# writeHeaderXML - Writes out the header information for a GDMS XML document.
# 
# @param $version - the version of the GDMS DTD.
# @param $dtdLocation - the URL of the GDMS DTD the script is based on.
#####
sub writeHeaderXML {
	my ($version,$dtdLocation) = @_;
	
	# Create UTF-8 optional hexadecimal header.
	#print(OUTPUT chr(0xef));
	#print(OUTPUT chr(0xbb));
	#print(OUTPUT chr(0xbf));
	
	print(OUTPUT "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
	print(OUTPUT "<!DOCTYPE gdms SYSTEM \"$dtdLocation\" []>\n");
	print(OUTPUT "<gdms version=\"$version\">\n");
}

#####
# writeHeadGMDS - Writes out the header section for the GDMS document.
# 
# @param $gdmsIdType - identifies the type of GDMS id.
# @param $systemID - the unique identify for the GDMS document.
# @param $access - the access rights for the GDMS object.
# @param $copyrightYears - the years that the copyright notice should identify.
# @param $setString - the code value to be used in the SET element.
# @param $noteString - notes regarding the creation/scripting of the GDMS objects.
#####
sub writeHeadGDMS {
	my ($gdmsIdType,$systemID,$access,$copyrightYears,$setString,$noteString) = @_;

	print(OUTPUT "\t<gdmshead>\n");
	print(OUTPUT "\t\t<gdmsid");
	if ($gdmsIdType ne "") {
		print(OUTPUT " type=\"$gdmsIdType\"");
	}
	print(OUTPUT "><system>$systemID</system></gdmsid>\n");
	print(OUTPUT "\t\t<filedesc>\n");
	print(OUTPUT "\t\t\t<pubstmt>\n");
	print(OUTPUT "\t\t\t\t<agent type=\"creator\" form=\"corpname\" role=\"publisher\">\n");
	print(OUTPUT "\t\t\t\t\t<name>University of Virginia Library</name>\n");
	print(OUTPUT "\t\t\t\t</agent>\n");
	print(OUTPUT "\t\t\t\t<imprint>\n");
	print(OUTPUT "\t\t\t\t\t<address><addressline>Charlottesville, Virginia</addressline></address>\n");
	print(OUTPUT "\t\t\t\t</imprint>\n");
	print(OUTPUT "\t\t\t\t<note type=\"extraction\">$noteString</note>\n");
	print(OUTPUT "\t\t\t\t<rights type=\"access\">$access</rights>\n");
	print(OUTPUT "\t\t\t\t<rights type=\"copyright\">\n");
	print(OUTPUT "\t\t\t\t\tCopyright $copyrightYears, by the Rector and Visitors of the University of Virginia.\n");
	print(OUTPUT "\t\t\t\t</rights>\n");
	print(OUTPUT "\t\t\t</pubstmt>\n");
	print(OUTPUT "\t\t\t<setstmt>\n");
	print(OUTPUT "\t\t\t\t<set code=\"UVA-LIB-Image\" />\n");
	print(OUTPUT "\t\t\t\t<set code=\"$setString\" />\n");
	print(OUTPUT "\t\t\t</setstmt>\n");
	print(OUTPUT "\t\t\t<physdesc type=\"extent\">File size to be stored here later.</physdesc>\n");
	print(OUTPUT "\t\t\t<date type=\"creation\">" . currentDate("date") . "</date>\n");
	print(OUTPUT "\t\t</filedesc>\n");
	print(OUTPUT "\t</gdmshead>\n");
}

#####
# writeResGDMS - Generate the resource metadata information for an image.
#
# @param $image - the IRIS image number being written out as a resource.
# @param $imgID - the auto-generated unique identifier for the image.
#####
sub writeResGDMS {
	my ($image,$imgID) = @_;
	my $i;
	my $numberOfElements;
	
	# Save the image
	print(OUTPUT "\t\t\t<res id=\"$imgID\">\n");
	print(OUTPUT "\t\t\t\t<mediatype type=\"image\"><form>digital</form></mediatype>\n");
	
	# Identifier the image resource by its IRIS image number.
	print(OUTPUT "\t\t\t\t<identifier type=\"UVa Fine Arts\">$image</identifier>\n");

	# If this is from special collections there will be additional identifying information.
	if ($imageIdentifierNumbers{$image} ne "") {
		print(OUTPUT "\t\t\t\t<identifier");
		if ($imageIdentifierTypes{$image} ne "") {
			print(OUTPUT " type=\"$imageIdentifierTypes{$image}\"");
		}
		print(OUTPUT ">$imageIdentifierNumbers{$image}</identifier>\n");
	}
	if ($imageVendorCodes{$image} =~ m/^viu/i) {
		print(OUTPUT "\t\t\t\t<identifier type=\"UVa EAD ID\">$imageVendorCodes{$image}</identifier>\n");
	}
		
	# Generate description tags for the IRIS image view type and view description.
	# Combine them as one description with a comma and space between them.
	my @imageViewTypes = split($valueSeparator,$imageViewTypes{$image});
	my @imageViewDescriptions = split($valueSeparator,$imageViewDescriptions{$image});
	$numberOfElements = scalar(@imageViewTypes);
	for ($i=0; $i < $numberOfElements; $i++) {
		my $viewType = trim(convertEntities(@imageViewTypes[$i]));
		my $viewDescription = trim(convertEntities(@imageViewDescriptions[$i]));
		my $description = "";
		# Combine the view type and description with comma space if both exist.
		if (($viewType ne "") && ($viewDescription ne "")) {
			$description = $viewType . ", " . $viewDescription;
		} else {
			$description = $viewType . $viewDescription;
		}
		$description = convertEntities($description);
		if ($description ne "") {
			print(OUTPUT "\t\t\t\t<description type=\"view\">$description</description>\n");
		}
	}

	# Put the view date into a time element
	my $viewDate = trim(convertEntities($imageViewDates{$image}));
	if ($viewDate ne "") {
		print(OUTPUT "\t\t\t\t<time type=\"image date\">\n");
		print(OUTPUT "\t\t\t\t\t<date>$viewDate</date>\n");
		print(OUTPUT "\t\t\t\t</time>\n");
	}
	
	# Create subject tags for image subject and subtype terms in IRIS.
	my @imageSubjects = split($valueSeparator,$imageSubjects{$image});
	my @imageSubjectsAuthority = split($valueSeparator,$imageSubjectAuthorities{$image});
	my @imageSubjectSubtypes = split($valueSeparator,$imageSubjectSubtypes{$image});
	# Since subtype is concatenated with subject its authority is not needed.
	#my @imageSubjectSubtypesAuthority = split($valueSeparator,$imageSubtypeAuthorities{$image});
	$numberOfElements = scalar(@imageSubjects);
	for ($i=0; $i < $numberOfElements; $i++) {
		my $subject = trim(convertEntities(@imageSubjects[$i]));
		my $subtype = trim(convertEntities(@imageSubjectSubtypes[$i]));
		my $authority = trim(convertEntities(@imageSubjectsAuthority[$i]));
		if (($subject ne "") || ($subtype ne "")) {
			print(OUTPUT "\t\t\t\t<subject scheme=\"$authority\">$subject");
			if ($subtype ne "") {
				print(OUTPUT " -- $subtype");
			}
			print(OUTPUT "</subject>\n");
		}
	}
	
	# Create a source/mediatype/form for the image color specifications.
	print(OUTPUT "\t\t\t\t<source>\n");

	# Map the IRIS image type and format to the resource source mediatype in GDMS.
	my $color = trim(convertEntities($imageColors{$image}));
	my $imageType = trim(convertEntities($sourceImageTypes{$image}));
	if (($imageType ne "") || ($color ne "")) {
		print(OUTPUT "\t\t\t\t\t<mediatype type=\"image\">\n");
		if ($imageType ne "") {
			print(OUTPUT "\t\t\t\t\t\t<form>$imageType</form>\n");
		}
		if ($color ne "") {
			print(OUTPUT "\t\t\t\t\t\t<form>$color</form>\n");
		}
		print(OUTPUT "\t\t\t\t\t</mediatype>\n");
	}
	
	# Store the IRIS source number in the GDMS file in case we need to refer back to it for the copyright information.
	print(OUTPUT "\t\t\t\t\t<identifier type=\"UVa Fine Arts\">$imageSourceNumbers{$image}</identifier>\n");

	# If the material is from Special collections, identify its accession number.
	if ($sourceVendorSetNum{$image} =~ m/^MSS/i) {
		print(OUTPUT "\t\t\t\t\t<identifier type=\"UVa Special Collections accession number\">$sourceVendorSetNum{$image}</identifier>\n");
	}
	
	# Map the IRIS label and vendor copyrights to the source rights...
	my $labelCopyright = trim(convertEntities($sourceLabelCopyright{$image}));
	my $vendorCopyright = trim(convertEntities($sourceVendorCopyright{$image}));
	if ($labelCopyright ne "") {
		print(OUTPUT "\t\t\t\t\t<rights type=\"copyright\">$sourceLabelCopyright{$image}</rights>\n");
	}
	if ($vendorCopyright ne "") {
		if ($vendorCopyright ne $labelCopyright) {
			print(OUTPUT "\t\t\t\t\t<rights type=\"copyright\">$sourceVendorCopyright{$image}</rights>\n");
		}
	}
	
	print(OUTPUT "\t\t\t\t</source>\n");

	# Generate a adminrights tag for the IRIS image source rights type.
	my $rights = trim(convertEntities($sourceRightsType{$image}));
	if ($rights eq "") {
		$rights = "uva";
	}
	my $rightsText = "";
	if ($rights eq "uva") {
		$rightsText = "Accessible to UVa community only";
	} elsif ($rights eq "public") {
		$rightsText = "Publicly accessible";
	} elsif ($rights eq "viva") {
		$rightsText = "Accessible to VIVA* community only";
	} elsif ($rights eq "restricted") {
		$rightsText = "Restricted to Library staff for management only";
	}
	print(OUTPUT "\t\t\t\t<adminrights>\n");
	print(OUTPUT "\t\t\t\t\t<policy>\n");
	print(OUTPUT "\t\t\t\t\t\t<access type=\"$rights\">$rightsText</access>\n");
	print(OUTPUT "\t\t\t\t\t</policy>\n");
	print(OUTPUT "\t\t\t\t</adminrights>\n");
		
	# If the image already has been assigned a PID then just pass that PID as the href.
	# Otherwise reference the actual image file using the IRIS digital file name.
	my $fileName = trim($digitalFileNames{$image});
	print(OUTPUT "\t\t\t\t<resptrgrp>\n");
	if ((exists $imagePIDs{$image}) and ($imagePIDs{$image} ne "")) {
		print(OUTPUT "\t\t\t\t\t<resptr href=\"$imagePIDs{$image}\" title=\"$contentModel\" targettype=\"$targetType\" actuate=\"onRequest\" inline=\"true\" show=\"replace\" type=\"simple\" xlink=\"http://www.w3.org/1999/xlink\" />\n");
	} else {
		print(OUTPUT "\t\t\t\t\t<resptr href=\"$imageURL/preview/$fileName.jpg\" title=\"$contentModel\" targettype=\"$targetType\" actuate=\"onRequest\" inline=\"true\" show=\"replace\" type=\"simple\" xlink=\"http://www.w3.org/1999/xlink\" />\n");
	}
	print(OUTPUT "\t\t\t\t</resptrgrp>\n");
	
	print(OUTPUT "\t\t\t</res>\n");
}

#####
# writeResincGDMS
#
# @param $imageId - the auto-generated unique identifier for the image.
# @param $imgIdRef - the resource id for the image being referenced in another document.
# @param $externalFileName - the other IRIS work file name that contains the metadata for this image.
#####
sub writeResincGDMS {
	my ($imageId,$imgIdRef,$externalFileName) = @_;
	
	print(OUTPUT "\t\t\t<resinc id=\"$imageId\" actuate=\"onLoad\" href=\"$externalFileName\" parse=\"xml\" xpointer=\"id($imgIdRef)\" />\n");
}

#####
# writeResgrpGDMS - Create the resource group containing the image resource references.
#
# @param $workNumber - the IRIS work number being generated into a GDMS document.
# @param $workFileName - the GDMS file name that the resourcegroup is being written to.
#####
sub writeResgrpGDMS {
	my ($workNumber,$workFileName) = @_;
	my $i;					# for loop counter.
	my $numberOfImages;		# number of images in the array for a work.
	
	# Create an array containing the IRIS image numbers that are associated with the work.
	my @images;
	foreach my $imageNumber (sort keys %imageWorkNumbers) {	
		if ($imageWorkNumbers{$imageNumber} =~ m/(.*)$workNumber(.*)/) {
			push(@images,$imageNumber);
		}
	}	
	$numberOfImages = scalar(@images);
	
	print(OUTPUT "\t\t<resgrp label=\"Digital Images\">\n");
	for ($i=0; $i < $numberOfImages; $i++) {
		# Use the PID as a unique identifier for the image.
		my $imageId = $imagePIDs{@images[$i]};
		$imageId =~ s/\:/\-/;
		# Check to see if this image has already been written as part of another work document.
		if (! exists $imagesWrittenToWorks{@images[$i]}) {
			# Save the work's filename for reference if another work uses the same image.
			# This will allow us to reference the image in the other document and not repeat the image metadata.
			$imagesWrittenToWorks{@images[$i]} = $workFileName;
			
			# Save the image's unique identifier for reference if another work uses it.
			$imageIDForImagesWritten{@images[$i]} = $imageId;

			writeResGDMS(@images[$i],$imageId);
		} else {
			#For now do not generate RESINCs instead recreate the full image metadata.
			#writeResincGDMS($imageID,$imageIDForImagesWritten{@images[$i]},$imagesWrittenToWorks{@images[$i]});
			writeResGDMS(@images[$i],$imageId);
		}
	}
	print(OUTPUT "\t\t</resgrp>\n");
}

#####
# writeWorkGdmsFile - Creates a GDMS file containing an IRIS Work's metadata along
#		with all the image references.
#
# @param $workNo - Work number
# @param $workFile - Path and file name for the GDMS output
# @param $project - Name of the project export this work is a part of.
#####
sub writeWorkGdmsFile {
	my ($workNo,$workFile,$project) = @_;
	
	if (open(OUTPUT,">","$workFile")) {
		my $gdmsDocNotes = $notes . " This document was generated as part of the IRIS Export for project '$project'.";
		writeHeaderXML($gdmsVersion,$gdmsDtdLocation);
		writeHeadGDMS("uva-pid",$workPIDs{$workNo},$accessRights,$copyrightYears,$setCode,$gdmsDocNotes);
		# Use the IRIS primary title as the label for the work.
		my $label = getPrimaryWorkTitle($workTitleCounts{$workNo},$workTitles{$workNo},$workTitleQualifiers{$workNo});
		$label = convertEntities($label);
		my $workId = $workPIDs{$workNo};
		$workId =~ s/\:/\-/;
		writeOpenDivGDMS($workId,"work",$label);
		writeDivdescGDMS($workNo);
		writeResgrpGDMS($workNo,$workFile);
		writeCloseDivGDMS();
		writeFooterXML();
		close(OUTPUT);
	} else {
		$statisticsLog .= "\nERROR: Unable to create GDMS file $workFile\n";
		$errorCount++;
	}
}

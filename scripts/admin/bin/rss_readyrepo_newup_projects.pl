#!/usr/bin/perl -w
#
# @(#)rss_readyrepo_newup_projects.pl				1.00			2006/08/15
#
# Copyright (c) 2006 Digital Library Production Services, University of Virginia Library.
# All rights reserved.
#
# Programmer: Jack Kelly
#
# Description: This script will traverse the ReadyRepo location to identify new and updated
# items from the last month. An RSS file will be generated to indicate what those items are. 
# The RSS file contains detail down to the work title with agents (for image collections) or 
# the text title, volume, issue, date and authors for books, etc. Categories are defined in 
# the RSS file for use in sorting data in the event an RSS reader supports them.
#
# 2006/10/25 - (jlk4p) Ready to test against production directory location. Changed so an 
#			email is sent to me after each run to indicate success/failure.
# 2006/10/26 - (jlk4p) Found that uvaPageBook is another existing content model using TEI.
# 2006/10/27 - (jlk4p) Needed to include additional entity reference specs to catch all TEI content.
# 2007/04/02 - (jlk4p) XML feed file was not found after script ran successfully. Commented out
#			deletion of backup file when transformation is done to make sure backup is still there
#			in case the Saxon process is not creating the new file.

use strict;
use Cwd;
use open OUT => ":utf8";

my $me = "rss_readyrepo_newup_projects.pl";
my $SAXON_PATH = "/shares/admin/bin/text/jars";
my $transformationStyleSheetLocation = "/shares/admin/bin/";
my $rssStyleSheet = "rssTransformEntities.xsl";
my $readyRepo = "/cenrepo/ReadyRepo";
#my $rssFile = "/Users/jlk4p/Sites/dlps/rss/readyrepo_newup_projects.xml";
my $rssFile = "/www/doc/dlps/uva-only/rss/readyrepo_newup_projects.xml";
#my $rssCSS = "http://localhost/~jlk4p/dlps/rss/readyrepo_newup_projects.css";
my $rssCSS = "http://pogo.lib.virginia.edu/dlps/uva-only/rss/readyrepo_newup_projects.css";
my $rssURL = "http://pogo.lib.virginia.edu/dlps/uva-only/rss/readyrepo_newup_projects.xml";
my $sysAdminAddress = "jlk4p\@virginia.edu";
my $timeToLive = 30 * 24 * 60;	# in minutes: 30 days x 24 hours/day x 60 min/hour
my $objectPointer = "http://repo.lib.virginia.edu:18080/fedora/get/";
my $objectBehavior = "/uva-lib-bdef:100/getFullView";
my $currentTime = time();
my $priorMonthTime = lastMonthTime($currentTime);
my $currentDate = gmtDateString($currentTime);
my $lastMonthDate = gmtDateString($priorMonthTime);
my $status;	# indicates new versus update item.
my (@progress,@errors);	# used for documenting email content/error messages
my $group = 'dlpswg';
#$group = 'cvsusers';
my $msg;

$msg = "Started at "  . (scalar localtime) . "\n\n";
push(@progress, $msg);

# Create an RSS feed file containing recently received videos only if there are any records.
if (open(RSS,">$rssFile")) {
	print(RSS "<?xml version=\"1.0\" encoding=\"utf-8\"?>");
	print(RSS "\n<?xml-stylesheet type=\"text/css\" href=\"$rssCSS\"?>");
	print(RSS "\n<!DOCTYPE rss [");
	print(RSS "\n<!ENTITY % HTMLlat1 PUBLIC \"-//W3C//ENTITIES Latin 1 for XHTML//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml-lat1.ent\"> %HTMLlat1;");
	print(RSS "\n<!ENTITY % ISOlat1 SYSTEM \"http://text.lib.virginia.edu/charent/iso-lat1.ent\"> %ISOlat1;");
	print(RSS "\n<!ENTITY % ISOlat2 SYSTEM \"http://text.lib.virginia.edu/charent/iso-lat2.ent\"> %ISOlat2;");
	print(RSS "\n<!ENTITY % ISOnum SYSTEM \"http://text.lib.virginia.edu/charent/iso-num.ent\"> %ISOnum;");
	print(RSS "\n<!ENTITY % ISOpub SYSTEM \"http://text.lib.virginia.edu/charent/iso-pub.ent\"> %ISOpub;");
	print(RSS "\n<!ENTITY % ISOtech SYSTEM \"http://text.lib.virginia.edu/charent/iso-tech.ent\"> %ISOtech;");
	print(RSS "\n<!ENTITY % UVAsupp SYSTEM \"http://text.lib.virginia.edu/charent/uva-supp.ent\"> %UVAsupp;");
	print(RSS "\n]>");
	print(RSS "\n<rss version=\"2.0\">");
	print(RSS "\n\t<channel>");
	print(RSS "\n\t\t<language>en-us</language>");
	print(RSS "\n\t\t<title>Digital Library Production Services New and Updated Projects</title>");
	print(RSS "\n\t\t<description>This list contains items processed since $lastMonthDate that 
		are ready for ingestion into the repository. Items are categorized as new or updates
		to existing items in the repository.</description>");
	print(RSS "\n\t\t<link>$rssURL</link>");
	print(RSS "\n\t\t<category>University of Virginia</category>");
	print(RSS "\n\t\t<category>Digital Library Production Services</category>");
	print(RSS "\n\t\t<category>Digital Collections</category>");
	print(RSS "\n\t\t<category>New and Updated Projects</category>");
	print(RSS "\n\t\t<copyright>Copyright 2006 The Rector and Visitors of the University of Virginia</copyright>");
	print(RSS "\n\t\t<managingEditor>baumann\@virginia.edu (Melinda Baumann)</managingEditor>");
	print(RSS "\n\t\t<webMaster>jlk4p\@virginia.edu (Jack Kelly)</webMaster>");
	print(RSS "\n\t\t<pubDate>" . $currentDate . "</pubDate>");
	print(RSS "\n\t\t<docs>http://blogs.law.harvard.edu/tech/rss</docs>");
	print(RSS "\n\t\t<ttl>$timeToLive</ttl>");
	# Hour 0 is midnight, time is based on GMT. Skip midnight as an hour since the script
	# will run at that time on the first of each month.
	print(RSS "\n\t\t<skipHours><hour>4</hour></skipHours>");
	
	my @textDirectories = getDirectories("$readyRepo/text");
	push(@progress,"Traversed $readyRepo/text :\n");
	foreach my $directory (@textDirectories) {
		my $objectType = '';
		# If a directory has been modified in the last month then it is something that needs
		# to be included as a new item.
		my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat "$readyRepo/text/$directory";
		if ($mtime gt $priorMonthTime) {
			$status = "New";
			push(@progress,"   Project directory $directory processed as " . lc($status) . '.');
			
			my @subDirectories = getDirectories("$readyRepo/text/$directory");
			my $subDirList = join(',',@subDirectories);
			if ($subDirList =~ m/uvaGDMS/) {
				$objectType = 'Art/Architecture Works';
			} else {
				$objectType = 'Texts';
			}
			# Parse the subdirectory to identify the items/titles to be included in this listing.
			foreach my $subDir (@subDirectories) {
				if ($subDir eq 'uvaGDMS') {
					my @files = getXmlFiles("$readyRepo/text/$directory/$subDir/gdms");
					foreach my $fileName (@files) {
						my ($pid,$title,$agents) = getGdmsInfo("$readyRepo/text/$directory/$subDir/gdms/$fileName");
						# Concatenate information together to create a unique title
						if ($agents ne '') {
							$title .= " ($agents)";
						}
						my $item = generateItemElement($directory,$objectType,$subDir,$status,$pid,$title);
						print(RSS $item);
					}
				} elsif (($subDir eq 'uvaBook') or ($subDir eq 'uvaGenText') or ($subDir eq 'uvaPageBook')) {
					my @books = getXmlFiles("$readyRepo/text/$directory/$subDir/tei");
					foreach my $fileName (@books) {
						my ($pid,$title,$volume,$issue,$date,$authors) = getTeiHeaderInfo("$readyRepo/text/$directory/$subDir/tei/$fileName");
						# Concatenate Information together to create a unique title
						if ($volume ne '') {
							$title .= ", Volume $volume";
						}
						if ($issue ne '') {
							$title .= ", Issue $issue";
						}
						if ($date ne '') {
							$title .= ", $date";
						}
						if ($authors ne '') {
							$title .= "by $authors";
						}
						my $item = generateItemElement($directory,$objectType,$subDir,$status,$pid,$title);
						print(RSS $item);
					}
				} else {
					# Content model not currently supported by RSS. So document in an email.
					push(@progress,"WARNING: Content model $subDir is not supported by this RSS script!");
					push(@errors,"ERROR: Content model $subDir is not supported by this RSS script!");
				}
			}
		} else {
			# TRAVERSE THE DIRECTORY LOOKING FOR INDIVIDUAL MODIFIED FILES.
			$status = "Update";
			my $updateCount = 0;
			my @subDirectories = getDirectories("$readyRepo/text/$directory");
			my $subDirList = join(',',@subDirectories);
			if ($subDirList =~ m/uvaGDMS/) {
				$objectType = 'Art/Architecture Works';
			} else {
				$objectType = 'Texts';
			}
			# Parse the subdirectory to identify if any files have been modified.
			foreach my $subDir (@subDirectories) {
				if ($subDir eq 'uvaGDMS') {
					my @files = getXmlFiles("$readyRepo/text/$directory/$subDir/gdms");
					foreach my $fileName (@files) {
						my ($f_dev,$f_ino,$f_mode,$f_nlink,$f_uid,$f_gid,$f_rdev,$f_size,$f_atime,$f_mtime,$f_ctime,$f_blksize,$f_blocks) = stat "$readyRepo/text/$directory/$subDir/gdms/$fileName";
						if ($f_mtime gt $priorMonthTime) {
							my ($pid,$title,$agents) = getGdmsInfo("$readyRepo/text/$directory/$subDir/gdms/$fileName");
							# Concatenate information together to create a unique title
							if ($agents ne '') {
								$title .= " ($agents)";
							}
							my $item = generateItemElement($directory,$objectType,$subDir,$status,$pid,$title);
							print(RSS $item);
							$updateCount++;
						}
					}
				} elsif (($subDir eq 'uvaBook') or ($subDir eq 'uvaGenText') or ($subDir eq 'uvaPageBook')) {
					my @books = getXmlFiles("$readyRepo/text/$directory/$subDir/tei");
					foreach my $fileName (@books) {
						my ($f_dev,$f_ino,$f_mode,$f_nlink,$f_uid,$f_gid,$f_rdev,$f_size,$f_atime,$f_mtime,$f_ctime,$f_blksize,$f_blocks) = stat "$readyRepo/text/$directory/$subDir/tei/$fileName";
						if ($f_mtime gt $priorMonthTime) {
							my ($pid,$title,$volume,$issue,$date,$authors) = getTeiHeaderInfo("$readyRepo/text/$directory/$subDir/tei/$fileName");
							# Concatenate Information together to create a unique title
							if ($volume ne '') {
								$title .= ", Volume $volume";
							}
							if ($issue ne '') {
								$title .= ", Issue $issue";
							}
							if ($date ne '') {
								$title .= ", $date";
							}
							if ($authors ne '') {
								$title .= "by $authors";
							}
							my $item = generateItemElement($directory,$objectType,$subDir,$status,$pid,$title);
							print(RSS $item);
							$updateCount++;
						}
					}
				} else {
					# Content model not currently supported by RSS. So document in an email.
					push(@progress,"WARNING: Content model $subDir is not supported by this RSS script!");
					push(@errors,"ERROR: Content model $subDir is not supported by this RSS script!");
				}
			}
			$msg = "   Project directory $directory processed";
			if ($updateCount ne 0) {
				$msg .= " with $updateCount " . lc($status);
				if ($updateCount ne 1) {
					$msg .= 's';
				}
			}
			$msg .= '.';
			push(@progress,$msg);
		}
	}
	push(@progress,"\nNumber of directories examined = " . scalar(@textDirectories) . "\n");

	# Close the RSS file and make sure the file has appropriate permissions and group access.
	print(RSS "\n\t</channel>");
	print(RSS "\n</rss>");
	close(RSS);
	chmod(0664,$rssFile);
	system("chgrp $group $rssFile");
} else {
	push(@errors,"ERROR: Cannot write to $rssFile");
}

# Transform character entity references to numeric ones.
transformFile($rssFile,$rssStyleSheet);

$msg = "\nFinished at "  . (scalar localtime) . "\n";
push(@progress, $msg);

sendEmail();

############################# Subroutines #############################

#####
# generateItemElement - Returns a string representing the RSS item element tag with sub-elements
#		that represent a book or work or other appropriate object.
#
# @param $project - the project directory that this item was found in
# @param $objtyp - identifies this as text or an art/arch work
# @param $status - indicates whether new or updated item.
# @param $pid - the unique identifier for the object in the repository.
# @param $title - the title of the object (found in its metadata).
#####
sub generateItemElement {
	my ($project,$objtyp,$contentModel,$status,$pid,$title) = @_;

	my $link = $objectPointer . $pid . $objectBehavior;
	my $itemElementString = "\n\t\t<item>";
	$itemElementString .= "\n\t\t\t<title>$title</title>";
	$itemElementString .= "\n\t\t\t<category>Project: $project</category>";
	$itemElementString .= "\n\t\t\t<category>Type: $objtyp</category>";
	$itemElementString .= "\n\t\t\t<category>Status: $status object</category>";
	$itemElementString .= "\n\t\t\t<description>Project $project; Type $objtyp; PID $pid; $status object; Content model $contentModel</description>";
	$itemElementString .= "\n\t\t\t<link>$link</link>";
	$itemElementString .= "\n\t\t\t<guid isPermaLink=\"false\">$pid</guid>";
	$itemElementString .= "\n\t\t</item>";
	
	return $itemElementString;
}

#####
# getDirectories - Retrieves the directory names specified in the directory passed. Returns
#		an array containing the directory names.
#
# @param $directory - directory to retrieve the contents of.
#####
sub getDirectories {
	my ($directory) = @_;
	my @directories = ();
	
	# Open the directory for reading.
	if (opendir(IN,$directory)) {
		# Read the contents of the directory in ascending order.
		my @contents = sort(readdir(IN));
		closedir(IN);
		
		# Exclude all . files.
		@contents = grep(!/^\./,@contents);
		
		chdir($directory);
		foreach my $entry (@contents) {
			# If the directory entry is a directory then add it to the list of items.
			if (-d $entry) {
				push(@directories,$entry);
			}
		}
	} else {
		push(@errors,"ERROR: Unable to read $directory  directory");
	}
	
	return @directories;
}

#####
# getGdmsInfo - Parses the GMDS XML file and returns the object's pid, main title and agents
#			as list items/array.
#
# @param $filename - the name of the GDMS file to parse.
#####
sub getGdmsInfo {
	my ($filename) = @_;
	my $pid = '';
	my $title = '';
	my $agents = '';
	my @agents = ();
	my @roles = ();
	
	if (open(XML,"<",$filename)) {
		my @xmlFile = <XML>;
		close(XML);
		my $in_gdmshead = 0;
		my $in_div = 0;
		my $in_divDesc = 0;
		my $in_agent = 0;
		foreach (@xmlFile) {
			if ( /<gdmshead/ ) { $in_gdmshead = 1; }
			if ( /<\/gdmshead>/ ) { $in_gdmshead = 0; }
			if ( /<div/ ) { $in_div = 1; }
			if ( /<\/div>/ ) { $in_div = 0; }
			if ( /<divdesc/ )  { $in_divDesc = 1; }
			if ( /<\/divdesc>/ )  { $in_divDesc = 0; }
			if ( /<gdmsid type=\"uva-pid\"><system>(.*)<\/system><\/gdmsid>/ ) {
				if ($in_gdmshead eq 1) {
					$pid = $1;
				}
			}
			if ( /<agent type=\"([a-zA-Z ]*)\" role=\"([a-zA-Z ]*)\">/ ) { 
				$in_agent = 1;
				push(@roles,$2);
			}
			if ( /<\/agent>/ ) { $in_agent = 0; }
			if ( /<\/div>/ ) { $in_div = 0; }
			if ( /<title type=\"main\">(.*)<\/title>/ ) {
				my $tempTitle = $1;
				if (($in_div eq 1) and ($in_divDesc eq 1)) {
					if ($title eq '') {
						$title = $tempTitle;
					}
				}
			}
			if ( /<name scheme=\"([a-zA-Z ]*)\">(.*)<\/name>/ ) {
				if ($in_agent eq 1) {
					push(@agents,$2);
				}
			}
		}
		my $numAgents = scalar(@agents);
		if ($numAgents ne 0) {
			for (my $i=0; $i < $numAgents; $i++) {
				$agents .= $agents[$i] . ', ' . $roles[$i] . '; ';
			}
			$agents =~ s/; $//;
		}
	} else {
		push(@errors,"ERROR: Unable to read $filename");
	}
	
	return ($pid,$title,$agents);
}

#####
# getTeiHeaderInfo - Parses the TEI XML file and returns information about the text in a 
#		list/array. Items returned are the PID, title, volume, issue, date, and authors.
#
# @param $filename - the name of the TEI file to parse.
#####
sub getTeiHeaderInfo {
	my ($filename) = @_;
	my $pid = '';
	my $title = '';
	my $volume = '';
	my $issue = '';
	my $date = '';
	my $authors = '';
	my @lastNames = ();
	my @firstNames = ();
	
	if (open(XML,"<",$filename)) {
		my @xmlFile = <XML>;
		close(XML);
		my $in_fileDesc = 0;
		my $in_titleStmt = 0;
		my $in_publicationStmt = 0;
		my $in_author = 0;
		my $in_biblScopeVolume = 0;
		my $in_biblScopeDate = 0;
		my $in_biblScopeIssue = 0;
		foreach (@xmlFile) {
			if ( /<fileDesc/ ) { $in_fileDesc = 1; }
			if ( /<publicationStmt/ ) { $in_publicationStmt = 1; }
			if ( /<biblScope type=\"volume\">/  or /<biblScope n="(.*)" type=\"volume\">/ ) { $in_biblScopeVolume = 1; }
			if ( /<biblScope type=\"date\">/ ) { $in_biblScopeDate = 1; }
			if ( /<biblScope type=\"issue\">/ ) { $in_biblScopeIssue = 1; }
			if ( /<titleStmt/ )  { 
				if ($in_fileDesc eq 1) {
					$in_titleStmt = 1; 
				}
			}
			if ( /<\/titleStmt>/ )  { $in_titleStmt = 0; }
			if ( /<author/ ) { 
				if ($in_titleStmt eq 1) {
					$in_author = 1;
				}
			}
			if ( /<\/author>/ ) { $in_author = 0; }
			if ( /<title n=\"(.*)\" type=\"main\">(.*)<\/title>/ ) {
				my $tempTitle = $2;
				if (($in_fileDesc eq 1) and ($in_titleStmt eq 1)) {
					if ($title eq '') {
						$title = $tempTitle;
					}
				}
			}
			if ( /<num value=\"(.*)\">(.*)<\/num>/ ) {
				my $tempValue = $1;
				if (($in_fileDesc eq 1) and ($in_titleStmt eq 1) and ($in_biblScopeVolume eq 1)) {
					if ($volume eq '') {
						$volume = $tempValue;
					}
				} elsif (($in_fileDesc eq 1) and ($in_titleStmt eq 1) and $in_biblScopeIssue eq 1) {
					if ($issue eq '') {
						$issue = $tempValue;
					}
				}
			}
			if ( /<date value=\"(.*)\">(.*)<\/date>/ ) {
				my $tempDate = $1;
				if (($in_fileDesc eq 1) and ($in_titleStmt eq 1) and ($in_biblScopeDate eq 1)) {
					if ($date eq '') {
						$date = $tempDate;
					}
				}
			}
			if ( /<name n=\"(.*)\"type=\"([a-z]*)\">(.*)<\/name>/ ) {
				if ($in_author eq 1) {
					if ($1 eq 'last') {
						push(@lastNames,$2);
					}
					if ($1 eq 'first') {
						push(@firstNames,$2);
					}
				}
			}
			if ( /<idno type=\"uva-pid\">(.*)<\/idno>/ ) {
				if (($in_fileDesc eq 1) and ($in_publicationStmt eq 1)) {
					$pid = $1;
				}
			}
			if ( /<\/biblScope>/ ) { 
				if ($in_biblScopeVolume eq 1) {
					$in_biblScopeVolume = 0;
				} elsif ($in_biblScopeDate eq 1) {
					$in_biblScopeDate = 0; 
				}
			}
			if ( /<\/publicationStmt>/ ) { $in_publicationStmt = 0; }
			if ( /<\/fileDesc>/ ) { $in_fileDesc = 0; }
		}
		my $numAuthors = scalar(@lastNames);
		if ($numAuthors ne 0) {
			for (my $i=0; $i < $numAuthors; $i++) {
				$authors .= $firstNames[$i] . ' ' . $lastNames[$i] . ', ';
			}
			$authors =~ s/, $//;
		}
	} else {
		push(@errors,"ERROR: Unable to read $filename");
	}
	
	return ($pid,$title,$volume,$issue,$date,$authors);
}

#####
# getXmlFiles - Retrieves the XML file names found in the directory passed. Returns
#		an array containing the file names.
#
# @param $directory - directory to retrieve the contents of.
#####
sub getXmlFiles {
	my ($directory) = @_;
	my @files = ();
	
	# Open the directory for reading.
	if (opendir(IN,$directory)) {
		# Read the contents of the directory in ascending order.
		my @contents = sort(readdir(IN));
		closedir(IN);
		
		# Only interested in XML files.
		@contents = grep(/\.xml$/i,@contents);
		
		chdir($directory);
		foreach my $entry (@contents) {
			# If the directory entry is a directory then ignore it. Otherwise it is a file
			# so add it to the list.
			if (-d $entry) {
			} else {
				push(@files,$entry);
			}
		}
	} else {
		push(@errors,"ERROR: Unable to read $directory directory");
	}
	
	return @files;
}

#####
# gmtDateString - Returns the time formatted as day, date time zone:
#		where date is day month year and time is hours: minutes:seconds.
#
#####
sub gmtDateString {
	my ($timeSeconds) = @_;
	my @monthName = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
	my @weekDayString = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
	my $today;
	
	my ($second,$minute,$hour,$day,$month,$year,$weekday,$yearday,$isdst) = gmtime($timeSeconds);
	$year += 1900;
	
	$today = sprintf("%s, %02d %s %04d %02d:%02d:%02d GMT",$weekDayString[$weekday],$day,$monthName[$month],$year,$hour,$minute,$second);
	return $today;
}

#####
# lastMonthTime - Returns the time in seconds since the epoch for the same day
#		of the previous month.
#
# @param $epochTime - unix time in seconds since the Epoch...
#####
sub lastMonthTime {
	my ($epochTime) = @_;
	my $lastMonth;
	my $numDays;
	my $lastYear;
	
	my ($second,$minute,$hour,$day,$month,$year,$weekday,$yearday,$isdst) = localtime($epochTime);
	
	# Identify the previous month.
	if 	($month eq 1) {
		$lastMonth = 12;
		$lastYear = ($year + 1900) - 1;
	} else {
		$lastMonth = $month - 1;
		$lastYear = $year + 1900;
	}
	
	# Identify the number of days in the month
	if (($lastMonth eq 1) or ($lastMonth eq 3) or ($lastMonth eq 5) or ($lastMonth eq 7) or
		($lastMonth eq 8) or ($lastMonth eq 10) or ($lastMonth eq 12)) {
		$numDays = 31;
	} elsif (($lastMonth eq 4) or ($lastMonth eq 6) or ($lastMonth eq 9) or ($lastMonth eq 11)) {
		$numDays = 30;
	} elsif ($lastMonth eq 2) {
		# Take into account the leap year...
		if (($lastYear % 4) ne 0) {
			$numDays = 28;
		} elsif (($lastYear % 400) eq 0) {
			$numDays = 29;
		} elsif (($lastYear % 100) eq 0) {
			$numDays = 28;
		} else {
			$numDays = 29;
		}
	}
	
	return ($epochTime - ($numDays * 24 * 60 * 60));
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
	
	open(MAIL,"| /usr/sbin/sendmail -i -t");
	print(MAIL "To: $sysAdminAddress\n");
	print(MAIL "From: $sysAdminAddress\n");
	if (@errors) {
		print(MAIL "Subject: $me script error\n\n");
		print(MAIL "An error occurred during the execution of the $me script.\n\n");
	} else {
		print(MAIL "Subject: $me script results\n\n");
		print(MAIL "The $me script completed successfully.\n\n");
	}
	foreach my $msg (@errors) {
		print(MAIL "$msg\n\n");
	}
	foreach my $msg (@progress) {
		print(MAIL "$msg\n");
	}
	close(MAIL);
}

#####
# transformFile - Runs an XSLT tranformation to convert character entity references
#		to numeric entities. Renames the file as a backup and then does the
#		transformation on the renamed file.
#
# @param $fileName - the name of the file to be processed.
# @param $styleSheet - the style sheet to be applied to the XML file.
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
			push(@errors,"ERROR: Cannot transform $backupFileName");
			push(@errors,"  ==> $error");
# 		} else {
#			if (unlink($backupFileName) ne 1) {
#				push(@progress,"WARNING: Unable to delete $backupFileName");
#			}
		}
    } else {
    	push(@errors,"ERROR: Cannot rename $fileName to $backupFileName");
    }
}

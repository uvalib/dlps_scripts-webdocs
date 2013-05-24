#!/usr/bin/perl
#
# update adminmeta .xml files to add a note regarding the image.
#
# The only required argument is a adminmeta directory of xml files
# to process. I usually do a first run thru with the --readonly
# switch to check for problems, then (if no problems) run it again 
# without the switch to generate the files
#
# input should be a directory in /cenrepo/ReadyRepo/image/.../metadata/admin/
# that contains administrative technical metadata .xml files for images.
# (The program will take more than one directory, but it's better to feed
#  it one at a time, because it dies if something is out of wack in order
#  to bring it to your attention. ) 
# 
# There should be a corresponding raw_meta/*.txt file for each desc.xml file,
# somewhere in /cenrepo/workspace/image... 
# 
# If you run it with the --readonly switch, it won't write any files.
# You can use this to make it tell you where it's going to look for corresponding
# files, or as a check/file-count after it has already run.
# 
# 2006/07/27 - (jlk4p) created this by copying and modifying the imageadminmeta script
#				created by Steve Majewski.
# 2006/08/01 - (jlk4p) modified the note to use digitizing rather than preservation standards.

use strict;
use File::Basename;
use DirHandle;
use Getopt::Long;

my $note = "This image may have been resized to correct the aspect/ratio of the original page image scan. Other known problems with the original TIFF images may not have been fixed and therefore may not meet current digitizing standards.";

sub listdir { new DirHandle( $_[0] )->read(); }

my ($pid, $rights);
my ($verbose, $readonly);

umask 002;

GetOptions( 'verbose' => \$verbose, 'readonly' => \$readonly );

foreach my $inpath (@ARGV) {

    if ($verbose) {
	    print "--processing-> ", ( $readonly ? "[READONLY]" : "" ), " $inpath\n";
    }
    unless ( -d $inpath ) { die "Not a directory: $inpath" }

    my @adminmetas = glob( "$inpath/*.xml" );
    unless ( scalar(@adminmetas) > 0 ) { die "directory empty/no .xml files: $inpath" } 
    
	my @backupmetas;
    foreach  my $file (@adminmetas) {
    	print "reading $file\n" if $verbose; 
    	
    	#Read the contents of the file into a string.
    	open(XML,"<$file") or die "$! : $file";
    	my $xmlFileContents = "";
    	while (my $line = <XML>) { $xmlFileContents .= $line; }
    	close(XML);
    	
		#Create a backup of the file before updating it.
		my $backup = $file . ".bak";
		open(BACKUP,">$backup") or die "$! : $backup";
		print(BACKUP $xmlFileContents);
		close(BACKUP);
		push(@backupmetas,$backup);
		
		#Update the amin file with the added note.
		unless ( $readonly ) {
			#If a note element already exists then...
			if ($xmlFileContents =~ m/<note>/i) {
				#If this particular note is already in the file...
				if ($xmlFileContents =~ m/$note/i) {
					# do not modify it.
				} else {
					#otherwise add this note to the existing note field contents.
					$xmlFileContents =~ s/<\/note>/ $note<\/note>/;
				}
			} else {
				#otherwise add a note element with this note to the file.
				$xmlFileContents =~ s/<\/image>/   <note>$note<\/note>\n      <\/image>/;
			}
			
			print "writing $file\n"  if $verbose;
			open(XML,">$file") or die "$! : $file";
			print(XML $xmlFileContents);
			close(XML);
		}
    }
    
    #Delete the backup files now that all of the files have been successfully updated.
    unlink(@backupmetas);
}

__END__

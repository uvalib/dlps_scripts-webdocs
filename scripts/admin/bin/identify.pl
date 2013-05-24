#!/uva/bin/perl -w

#######################################################################################
# identify.pl - read book directories from 50QAed_OUT and run identify command to see 
# which files need compression and conversion.  Output is used by image_munge script.
#
# Sue Munson <sjm8k@virginia.edu>
# Date: 12/3/2003
#######################################################################################

use strict;

#my($indir) = "/dlps_work/01bookscanning/50QAed_OUT";
#my($workdir) = "/dlps_work/01bookscanning/52_CCITTCOMPRESS_IN";

my($indir) = "/dlps_work/01bookscanning/testin";
my($workdir) = "/dlps_work/01bookscanning/testwork";

my(@dirs, @errors)=();

#############################################

system("/bin/rm -f $workdir/*.txt") && die "Couldn't delete one of the txt work files: $!\n";

opendir(DIRS, "$indir") || die "Can't read $indir: $!\n";
@dirs=grep( (/^[BbZz].*/),(readdir(DIRS)));
closedir(DIRS);

# if no directories to process, then exit
unless (@dirs) {
   exit;
} 

my(@needs_600dpi)=();
my(@needs_compression)=();

foreach my $bookdir (@dirs) {
   unless (-d "$indir/$bookdir") {
      next;
   }
   opendir(DIR, "$indir/$bookdir") || die "Can't read $bookdir: $!\n";
   my(@files)=grep( (/^[BbZz].*\.tif$/),(readdir(DIR)));
   closedir(DIR);

   foreach my $file (@files) {
      my($filename)=$file;
      $filename =~ s/tif/txt/;
      my($error) = open(IDPROC, "/usr/local/bin/identify -verbose $indir/$bookdir/$file |");
      if ($error != 0) {
         push(@errors,"ERROR:  Identify failed for $file\n");
      }
      my(@stuff) = <IDPROC>;
      close(IDPROC);
      my($bigstr) = join(" ",@stuff);
      unless ($bigstr =~ /Compression Scheme: CCITT Group 4/s) {
         push(@needs_compression, $file);
      }
      unless (($bigstr =~ /Resolution: 600x600 pixels\/inch/s) || ($bigstr =~ /Resolution: 600, 600 pixels\/inch/s)) {
         push(@needs_600dpi, $file);
      }
   } 
}

if (@needs_compression) {
   open(OUT, "> $workdir/compress.txt");
   while(@needs_compression) {
      my($workfile) = shift(@needs_compression);
      print OUT "$workfile\n";
   }
   close OUT;
}

if (@needs_600dpi) {
   open(OUT, "> $workdir/resolve.txt");
   while(@needs_600dpi) {
      my($workfile) = shift(@needs_600dpi);
      print OUT "$workfile\n";
   }
   close OUT;
}

if (@errors) {
   &Send_Mail();
}


sub Send_Mail {
# get today's month, day, year

my @time = localtime(time);
my $today = $time[3];
my $month = (1,2,3,4,5,6,7,8,9,10,11,12)[(localtime)[4]];
my $year = $time[5];
$year = $year - 100;

$year = sprintf("%02d",$year);
$month = sprintf("%02d",$month);
$today = sprintf("%02d",$today);

my($date)="$month/$today/$year";

open(MAIL,"| /usr/lib/sendmail -i -t");
#print MAIL "To: ul-dlpsscripts\@virginia.edu\n";
#print MAIL "From: root\@virginia.edu\n";
print MAIL "To: sjm8k\@virginia.edu\n";
print MAIL "From: sjm8k\@virginia.edu\n";
print MAIL "Subject: Error attempting to identify files\n\n";
print MAIL "There was an error from the identify script on $date:\n\n";
foreach my $err (@errors) {
   print MAIL "$err\n";
}
print MAIL "-" x 75 . "\n\n";
close(MAIL);

}

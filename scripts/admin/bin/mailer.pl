#!/usr/bin/perl -w

# a borrowed sendmail subroutine from eaf_proofreader 
# modifications by ms3uf 4 Feb 2009
# not for production use!


#======================================================================
# setup
#======================================================================

use strict;
use Getopt::Std;
use Cwd;
use File::Copy;
use lib '/shares/admin/bin/text';
use Env qw(PATH HOME TERM);

my (%opts, $error, $ok, @outfiles, %infiles, @gifs, %gifs);
my ($dir, $id, $infile, $outfile, $command, $gif, $gifOut, $tifOut);
my (@errors, @progress, $msg);
my ($sql, $affected);

my $LOG_DIR = '/shares/admin/bin/text/logs/modeng_proofreader/';
my $MOGRIFY = 'mogrify';  # path to ImageMagick binaries has been added to system-wide profile

my $me = `basename $0`;
my $finalDir = '/shares/image1/01bookscanning/52_CCITTCOMPRESS_OUT/ModEng';
my $startDir = cwd();
my $group = 'dlpswg';
my $mailFrom = 'ms3uf';

my $gifDir = '/www/doc/dlps/uva-only/proofreader/images';
if (not -d $gifDir) {
    $msg = "$me: FATAL ERROR: Proofreader directory '$gifDir' does not exist\n";
    push(@errors, $msg);
    Send_Mail();
    die $msg;
}

my $usage = <<EOD;

$me - doesn't do much: just sends you an email! 

Usage: $me [-v] yourMessageHere 
  -v (verbose) Show status messages


EOD

getopts('v', \%opts) || die $usage;
die $usage unless (@ARGV);
my $message=$ARGV[0];

my $LD = 'LD_LIBRARY_PATH';
if ( defined $ENV{$LD} ) {
    $ENV{$LD} = '/usr/local/lib/:' . "$ENV{$LD}";
} else {
    $ENV{$LD} = '/usr/local/lib/';
}

Send_Mail();



#======================================================================
# subroutines
#======================================================================

sub Send_Mail {

$PATH .= ":/usr/sbin:/usr/lib";
my $mailer = `which sendmail`;
chomp($mailer);
my($username)=`whoami`;
chomp($username);

    my @time = localtime(time);
    my $today = $time[3];
    my $month = (1,2,3,4,5,6,7,8,9,10,11,12)[(localtime)[4]];
    my $year = $time[5];
    $year = $year - 100;

    $year = sprintf("%02d",$year);
    $month = sprintf("%02d",$month);
    $today = sprintf("%02d",$today);

    my($date)="$month/$today/$year";
    my($messageto) = "$username"."\@virginia.edu";
print "Sending e-mail notification to $messageto \nusing $mailer\n";

    open(MAIL,"| $mailer -i -t");
    print MAIL "To: $messageto\n"; 
#    print MAIL "Cc: ms3uf\@virginia.edu\n"; 
    print MAIL "From: $mailFrom\@virginia.edu\n";
    if ($message) {
        print MAIL "$message\n";
    }

    if (@errors) {
	print MAIL "Subject: Error processing Mod Eng images after QA\n\n";
	print MAIL "There was an error from the modeng_proofreader script on $date:\n\n";
    }
    else {
	print MAIL "Subject: Report on processing Mod Eng images after QA\n\n";
	print MAIL "modeng_proofreader script completed with no errors on $date.\n\n";
    }
    foreach my $err (@errors) {
	print MAIL "$err\n";
    }
    foreach my $noerr (@progress) {
	print MAIL "$noerr" ;
    }
    print MAIL "-" x 75 . "\n\n";
    close(MAIL);
}

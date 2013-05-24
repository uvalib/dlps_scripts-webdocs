#!/usr/bin/perl
use warnings;
## use strict; # my PITA!

unless ( $0 =~ m/UNDO/ ) {

    my ($dir) = $ARGV[0];
    -e $dir and -e $dir and chdir($dir) or die "$0 requires a directory path" ;

    my (@ds) = split( /\//, $dir );     $dir = $ds[$#ds];  # basename of dir
    @ds = split( /_/, $dir );     $prefix = $ds[0];	   # discard _suffix 

    opendir( DIR, '.' );
    my (@files) = grep /^[^.]/, readdir( DIR ); # drop '.dot files' 
    closedir( DIR );

    $logfile = ">../${dir}.$$.log" ;
    open( LOGFILE, $logfile ) or die "Can't open log file $logfile\n" ;

    $count = 0;
    foreach $FN ( @files ) {
	$dot = index $FN, "." ;      ## split into ( name,.ext )
	if ( $dot != -1 ) { 
	    ($name,$ext) = (substr($FN,0,$dot),substr($FN,$dot));
	} else { ($name,$ext) = ( $FN, '' ); }
	# split off last 11 chars of name
	($head,$tail) = (substr($name,0,length($name)-11),substr($name,-11));
	# generate new filename from prefix, new seq.no. 11 char tail and .ext 
	$newname = $prefix . sprintf( '_%04d_', ++$count ) . $tail . $ext;
	print ("rename $FN $newname\n");
	print LOGFILE  "rename $FN $newname\n" ;
	rename $FN, $newname;
    }

} else {

# if this is an undo, then arg should be the logfile
# read in the logfile and reverse the renames

   $logfile = $ARGV[0];
   open( LOG, $logfile ) or die "Can't open logfile: $logfile\n" ;
   @ds = split( /\./, $logfile ); $dir = $ds[0];
   chdir ( $dir ) or die "Can' chdir to $dir\n" ;

   while ( <LOG> ) {
       chomp;
       @files = split( / /, $_ );
       print "rename $files[2] $files[1]\n";
       rename $files[2], $files[1];
   }
}



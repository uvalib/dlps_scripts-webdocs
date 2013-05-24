package TrackSys;

# TrackSys.pm - Perl module containing utility subroutines for working
# with the DLPS Tracking System

# Greg Murray <gpm2a@virginia.edu>
# Written: 2005-12-01
# Last modified: 2008-10-30

# 2008-10-30: gpm2a: Changed database server from datastore.lib to
# mysql.lib


use strict;
use Crypt::RC4;
use DBI;

use constant PAGE_IMAGES_TYPE_NONE    => 0;
use constant PAGE_IMAGES_TYPE_BITONAL => 1;
use constant PAGE_IMAGES_TYPE_COLOR   => 2;

use constant TRANSCRIPTION_TYPE_NONE   => 0;
use constant TRANSCRIPTION_TYPE_VENDOR => 1;
use constant TRANSCRIPTION_TYPE_OCR    => 2;
use constant TRANSCRIPTION_TYPE_OTHER  => 3;

use constant TRANSCRIPTION_RESP_TECHBOOKS => 1;
use constant TRANSCRIPTION_RESP_APEX      => 2;
use constant TRANSCRIPTION_RESP_DLPS      => 3;

my $AUTH_FILE = '/home/gpm2a/bin/tracksys/tracksys.txt';

my $dbh;  # database handle

#----------------------------------------------------------------------

sub connect {
    # connects to database

    # optional argument indicates whether to continue processing after
    # a MySQL error; the default is to die upon MySQL error

    my $keepGoing = shift;
    my $raiseError = 1;
    if ($keepGoing) {
	$raiseError = 0;
    }

    my $dsn = "DBI:mysql:gpm2a_tracksys:mysql.lib.virginia.edu";
    my @cred = getCred();

    $dbh = DBI->connect($dsn, $cred[0], $cred[1], { RaiseError => $raiseError, PrintError => 1 });
}

#----------------------------------------------------------------------

sub disconnect {
    $dbh->disconnect();
}

#----------------------------------------------------------------------

sub getCred {

    # gets authentication credentials from a file, decrypts them, and
    # returns them as an array

#    open(AUTH, "$AUTH_FILE") || die "FATAL ERROR: Cannot read '$AUTH_FILE': $!";
#    my $key = <AUTH>; chop($key);
#    my $userid = <AUTH>; chop($userid);
#    my $password = <AUTH>; chop($password);
#    close AUTH;

#    $userid = RC4($key, $userid);
#    $password = RC4($key, $password);

   my $userid  = "";      # insert a valid user / password pair
   my  $password = "";
    my @out = ($userid, $password);
    return @out;
}

#----------------------------------------------------------------------

sub query {

    # executes SQL query
    # if SELECT statement, returns reference to DBI query object;
    # otherwise, returns number of rows affected

    my $sql = shift;

    my $sth = $dbh->prepare($sql);

    if ( $sql =~ /^SELECT/i ) {
	# execute query and return reference to query object, so
	# result set can be processed as needed
	$sth->execute();
	return \$sth;
    } else {
	# execute query and return number of rows affected (there is
	# no result set)
	my $rows = $sth->execute();
	$sth->finish;
	return $rows;
    }
}

#----------------------------------------------------------------------

return 1;

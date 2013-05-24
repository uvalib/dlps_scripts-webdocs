package DlpsText;

# DlpsText.pm - Perl module containing common variables and utility
# subroutines for DLPS text production

# Greg Murray <gpm2a@virginia.edu>
# Last modified: 2006-04-13


use strict;

my $LOG_PATH = '/shares/admin/bin/text/logs';

# The value of each property is a pipe-delimited string where first
# field is REQUIRED or IMPLIED (optional) and any subsequent fields
# are the allowable values.

my %propertyNames = (
    'id'               => 'REQUIRED',
    'page-images'      => 'REQUIRED|bitonal|color|none',
    'figure-images'    => 'REQUIRED|yes|no',
    'transcription'    => 'REQUIRED|vendor|ocr|other|none'
);

#    'page-images-show' => 'IMPLIED|yes|no',
#    'project'          => 'IMPLIED|amstudies|gordon|kinney|vcdh',
#    'set'              => 'IMPLIED|bruce|madison|thwaites|biddle',
#    'images-resp'      => 'IMPLIED|DLPS|Special Collections|Apex|Acme|Heckman',

#----------------------------------------------------------------------

sub formatDateLong {

    # In: String in yyyy-mm-dd format
    # Out: String in "January 1, 2006" type of format

    my $iso = shift;
    my $out = '';
    my ($month, $day, $year);

    if ( $iso =~ /(\d{4})-(\d\d)-(\d\d)/ ) {
	$year = $1;
	$month = $2;
	$day = $3;

	if    ($month == 1)  { $month = 'January'; }
	elsif ($month == 2)  { $month = 'February'; }
	elsif ($month == 3)  { $month = 'March'; }
	elsif ($month == 4)  { $month = 'April'; }
	elsif ($month == 5)  { $month = 'May'; }
	elsif ($month == 6)  { $month = 'June'; }
	elsif ($month == 7)  { $month = 'July'; }
	elsif ($month == 8)  { $month = 'August'; }
	elsif ($month == 9)  { $month = 'September'; }
	elsif ($month == 10) { $month = 'October'; }
	elsif ($month == 11) { $month = 'November'; }
	elsif ($month == 12) { $month = 'December'; }
	else { $month = ''; }

	$day =~ s/^0//;

	if ($month) {
	    $out = "$month $day, $year";
	}
    }

    return $out;
}

#----------------------------------------------------------------------

sub formatPropertyValues {
    # In: Reference to hash containing <?dlps ...?> properties,
    #   integer for number of spaces to use for left padding
    # Out: String containing the properties formatted for display

    my $propertiesRef = shift;         # take hash reference
    my $pad = shift || 0;

    my %properties = %$propertiesRef;  # dereference hash
    my $len = 0;
    my $out = '';
    my $key;

    # get length of longest property name
    foreach $key (keys(%properties)) {
	if (length($key) > $len) { $len = length($key); }
    }
    $len += $pad;  # provide padding

    # pretty print property values
    foreach $key (sort(keys(%properties))) {
	$out .= sprintf("%${len}s", $key) . ": $properties{$key}\n";
    }

    return $out;
}

#----------------------------------------------------------------------

sub getDate {

    # returns a string representing current date, formatted as yyyy-mm-dd

    my ($day, $month, $year) = (localtime)[3..5];
    return sprintf("%04d-%02d-%02d", $year+1900, $month+1, $day);
}

#----------------------------------------------------------------------

sub getDateTime {

    # returns a string representing current date and time, formatted
    # as yyyy-mm-dd hh:mm:ss

    my ($second, $minute, $hour, $day, $month, $year) = (localtime)[0..5];
    return sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year+1900, $month+1, $day,
		   $hour, $minute, $second);
}

#----------------------------------------------------------------------

sub getDlpsId {

    # In: reference to hash containing <?dlps ...?> properties;
    # reference to array containing input file; string containing
    # filename of input file

    # Out: returns a string containing the DLPS ID, or an empty string
    # if DLPS ID cannot be determined

    my $id = '';
    my $propertiesRef = shift;  # reference to hash of <?dlps ...?> properties
    my $infileRef = shift;      # reference to array of input file contents
    my $infile = shift;         # string containing filename of input file

    my %properties = %$propertiesRef;  # dereference hash
    my @infile = @$infileRef;          # dereference array

    if ($properties{'id'}) {
	# first choice: <?dlps id="..."?>
	$id = $properties{'id'};
    } else {
	# second choice: <TEI.2 id="..."> or <idno type="DLPS ID">...</idno>
	foreach (@infile) {
	    if ( /<TEI.2\s[^>]*id=("|')([^\1]+)\1/ ) {
		$id = $2;
		last;
	    }
	    if ( /<idno\s[^>]*type=["']DLPS ID["'][^>]*>([^<]+)<\/idno>/ ) {
		$id = $1;
	    }
	}
    }
    if (!$id) {
	# third choice: filename with typical DLPS ID
	if ( $infile =~ /^([bz]\d{9})/ ) {
	    $id = $1;
	} else {
	    # last resort: filename minus extension
	    if ( $infile =~ /\.\w{3,4}$/ ) {
		$id = $infile;
		$id =~ s/\.\w{3,4}$//;  # remove filename extension
	    }
	}
    }

    return $id;
}

#----------------------------------------------------------------------

sub getLogFileName {

    # Generates a filename for a log file, incorporating the current
    #   date and time formatted as yyyy-mm-dd_hh.mm

    # In: optional string for start of filename (defaults to "log_");
    #     optional string for end of filename (defaults to ".log")
    # Out: string containing filename

    my $prefix = shift || 'log_';
    my $suffix = shift || '.log';
    my ($timestamp, $second, $minute, $hour, $day, $month, $year);

    ($second, $minute, $hour, $day, $month, $year ) = (localtime)[0..5];
    $timestamp = sprintf("%04d-%02d-%02d_%02d.%02d", $year+1900, $month+1, $day,
			 $hour, $minute);

    return $prefix . $timestamp . $suffix;
}

#----------------------------------------------------------------------

sub getTempFileName {

    my $prefix = shift || 'temp_';
    my $suffix = shift || '.tmp';

    return getLogFileName($prefix, $suffix);
}

#----------------------------------------------------------------------

sub get_plural {
    if ($_[0] == 1) { return ''; } else { return 's'; }
}

#----------------------------------------------------------------------

sub getProperties {
    # In: filename of DLPS TEI XML file to read
    # Out: returns a hash of file properties from the 'property sheet'
    #   of <?dlps ...?> processing instructions in a DLPS TEI XML file

    my $infile = shift;
    my (%properties, $key);
    my $all = '';

    foreach $key (keys(%propertyNames)) {
	$properties{$key} = '';
    }

    open(PROPS, $infile) || die "ERROR: Cannot read '$infile': $!\n";
    while (<PROPS>) {
	# <?dlps ...?> processing instructions are assumed to be either before DOCTYPE declaration or within TEI header
	if ( m:</teiHeader>: ) {
	    last;
	}

	if ( /<\?dlps\s/ ) {
	    $all .= $_;
	    chomp $all;
	}
    }
    close PROPS;

    foreach $key (keys(%propertyNames)) {
	if ( $all =~ /<\?dlps\s[^\?>]*$key=("|')([^\1]*?)\1/ ) {
	    $properties{$key} = $2;
	}
    }

    return %properties;
}

#----------------------------------------------------------------------

sub getScriptName {
    # returns the name of the currently running script, but without
    # the full path that $0 includes

    my $name = $0;
    if ($name =~ /^.*\/(.*)$/) {
	$name = $1;
    }
    return $name;
}

#----------------------------------------------------------------------

sub log {
    # In: filename of file currently being processed; message indicating action performed
    # Appends a line to the log file for the file currently being processed
    # Out: no return value

    my $scriptname = shift;
    my $filename = shift;
    my $msg = shift || '';
    my $is_subentry = shift;
    my ($log, $out, $second, $minute, $hour, $day, $month, $year, $login);

    # determine log file name
    if ($filename =~ /^.*\/(.*)$/) {
        $filename = $1;  # trim leading path
    }
    if ( $filename =~ /^(.*)\.xml$/ ) {
	$log = "$LOG_PATH/$1.log";
    } else {
	$log = "$LOG_PATH/$filename.log";
    }

    if ($is_subentry) {
	# for sub-entries, just print message
	$out = $msg;
    } else {
	# output format: script-name,timestamp,user-id,message
	$out = "$scriptname,";

	($second, $minute, $hour, $day, $month, $year ) = (localtime)[0..5];
	$out .= sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year+1900, $month+1, $day,
			$hour, $minute, $second) . ',';

	$login = getlogin || getpwuid($<) || '';
	$out .= "$login,$msg\n";
    }

    # write to log file
    if ( -e $log ) {
	# log file exists; append
	if ( open(LOG, ">>$log") ) {
	    print LOG $out;
	    close LOG;
	} else {
	    warn "$scriptname: WARNING: Cannot append to logfile '$log': $!\n";
	}
    } else {
	# log file doesn't exist; create it and set permissions to include group write
	if ( open(LOG, ">$log") ) {
	    print LOG $out;
	    close LOG;
	    chmod 0664, $log;
	} else {
	    warn "$scriptname: WARNING: Cannot write logfile '$log': $!\n";
	}
    }
}

#----------------------------------------------------------------------

sub normalize_path {
    # In: string indicating a Unix path
    # Strips leading and trailing whitespace, adds final "/" if needed
    # Out: resulting string

    my $s = shift;

    # strip leading and trailing whitespace, if any
    $s =~ s/^\s+//;
    $s =~ s/\s+$//;

    # append final "/" character, if needed
    if (not $s =~ /\/$/) {
	$s = $s . "/";
    }

    return $s;
}

#----------------------------------------------------------------------

sub proper_case {
    # converts a string to 'proper' case -- each significant word gets capitalized
    # assumes you need to convert from lower case to proper case (not upper to proper)

    my $s = shift;
    return '' if not $s;

    my (@words, $word, $i);
    my %insig = ('a'=>'', 'an'=>'', 'the'=>'',
		 'and'=>'', 'but'=>'', 'for'=>'', 'yet'=>'', 'so'=>'', 'or'=>'', 'nor'=>'',
		 'against'=>'', 'as'=>'', 'between'=>'', 'by'=>'', 'from'=>'', 'in'=>'',
		 'of'=>'', 'on'=>'', 'to'=>'', 'with'=>'');

    @words = split(/ /, $s);
    for ($i = 0; $i < @words; $i++) {
	$word = $words[$i];
	if ($i == 0 or $i == $#words ) {
	    # always capitalize first word and last word
	    $words[$i] = ucfirst($word);
	} elsif ( exists($insig{$word}) ) {
	    # insignificant word; do nothing
	} else {
	    # capitalize
	    $words[$i] = ucfirst($word);
	}
    }
    return join(' ', @words);
}

#----------------------------------------------------------------------

sub strip_markup {

    # strips XML tags (but not element content) from input string

    my $s = shift;

    $s =~ s/<[^>]*?>//g;

    return $s;
}

#----------------------------------------------------------------------

sub trim {
    # trims leading and trailing whitespace from a string

    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

#----------------------------------------------------------------------

sub validateProperties {
    # In: Reference to hash of properties; reference to scalar for error message
    # Action: Validates completeness of DLPS "property sheet" (<?dlps ...?> processing instructions)
    # Out: Returns boolean integer (0 for failure, 1 for success); also sets error message on error

    my ($propertiesRef, $msgRef) = @_;
    my ($ok, $key, $required, @values, $value, $match, $temp);

    $ok = 1;
    $$msgRef = '';

    foreach $key (sort(keys(%propertyNames))) {
	($required, @values) = split(/\|/, $propertyNames{$key});

	if ( $$propertiesRef{$key} ) {
	    # has value; test against allowable values
	    if ( scalar(@values) ) {
		# property has list of allowable values
		$match = 0;
		foreach $value (@values) {
		    if ($$propertiesRef{$key} eq $value) {
			$match = 1;
			last;
		    }
		}
		if (not $match) {
		    $ok = 0;
		    $$msgRef .= "\tBad value '$$propertiesRef{$key}' for property '$key': must match one of: "
			. join(", ", @values) . ".\n";
		}
	    } else {
		# property 'id' is a special case: no predefined values, but needs to be validated via reg exp
		if ($key eq 'id') {
		    if ( $$propertiesRef{$key} =~ /^([bz])\d/ ) {
			# begins with 'b' or 'z'; must be 'b' or 'z' followed by 9 digits
			$temp = $1;
			if ( not $$propertiesRef{$key} =~ /^[bz]\d{9}$/ ) {
			    $ok = 0;
			    $$msgRef .= "\tBad value '$$propertiesRef{$key}' for property '$key': "
				. "Value begins with '$temp' but is not '$temp' followed by 9 digits\n";
			}
		    } elsif ( $$propertiesRef{$key} =~ /^cavdaily/ ) {
			# begins with 'cavdaily'; must be 'cavdaily_' followed by 8-digit date
			if ( not $$propertiesRef{$key} =~ /^cavdaily_\d{8}$/ ) {
			    $ok = 0;
			    $$msgRef .= "\tBad value '$$propertiesRef{$key}' for property '$key': "
				. "Value begins with 'cavdaily' but is not 'cavdaily_' followed by an 8-digit date\n";
			}
		    }
		}
	    }
	} else {
	    # no value present for this property; error if required
	    if ($required eq 'REQUIRED') {
		$ok = 0;
		$$msgRef .= "\tMissing required property '$key'\n";
	    }
	}
    }

    # strip initial tab and final newline from message string
    $$msgRef =~ s/^\t//;
    $$msgRef =~ s/\n$//;

    return $ok;
}

#----------------------------------------------------------------------

return 1;

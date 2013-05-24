package DlpsTextWorkreports;

# DlpsTextWorkreports.pm - Perl module providing shared subroutines
# for the post-keyboarding scripts named "report_..." which generate
# HTML "workreports" for DLPS text production

# Greg Murray <gpm2a@virginia.edu>
# Last modified: 2006-06-14

# 2004-09-01: Changed sub init to allow any filename that begins with
# a DLPS ID or ends with a 3-character extension.
#
# 2005-10-14: Added 'use strict' and declared variables.
#
# 2005-12-30: gpm2a: Changed for use on pogo.
#
# 2006-02-06: gpm2a: Added global variable $action for use with <form action="...">
#
# 2006-03-23: gpm2a: Added get_changes_file() and get_changes_file_archive() subroutines.
#
# 2006-06-14: gpm2a: Added get_path() subroutine.


use strict;

my $path = '/www/doc/dlps/dlps-only/workreports/';
my $changes_path = $path . 'changes/';
my $review_path = $path . 'review/';

our $action = '/cgi-dlps/dlps-only/workreports/save.pl';

my ($changes_file, $changes_file_archive, $review_file, $outfile, $spellfile, $tempfile);
my ($form_id, $html_path);

sub changes_file_ok {
    # tests whether a non-empty .changes file already exists,
    # indicating that someone has submitted the form (saved proposed
    # changes to .changes file), but the changes haven't been
    # committed (written to the file) yet

    # if non-empty .changes file exists, user is alerted with option
    # to cancel

    # returns 1 for OK to proceed, 0 for cancel

    my ($input, $ok);

    if (-e $changes_file && -s $changes_file) {
	print <<EOD;

A file of proposed changes for $main::infile already exists and
contains data, indicating that someone has already done the work of
determining which changes need to be made. If you proceed, you will
create a new form for $main::infile which, if submitted, will
OVERWRITE the existing list of changes to be made.

EOD

        print "Are you sure you want to proceed with processing $main::infile? (y/n) ";
	$input = <STDIN>;
	chomp $input;
	if ( $input =~ /^(y|yes)$/i ) {
	    $ok = 1;
	} else {
	    $ok = 0;
	}

	if ($ok) {
	    print "$main::me: $main::infile: Processing...\n";
	} else {
	    print "$main::me: $main::infile: OK, $main::infile has NOT been processed.\n";
	}
    } else {
	$ok = 1;
    }

    return $ok;
}

#----------------------------------------------------------------------

sub create_empties {
    # if the files don't already exist, create empty '.change' and
    # '.review' files to be later used by corresponding CGI script
    # save.cgi to save data (from HTML form created above) to disk

    if (not -e $changes_file) {
	# create empty .change file
        if ( open(OUT, "> $changes_file") ) {
            close OUT;

	    # set permissions to rw-rw-rw- so webuser will be able to overwrite this empty file
	    if ( not chmod(0666, $changes_file) ) {
		warn "$main::me: $main::infile: WARNING: Unable to set"
		    . " needed permissions on file '$changes_file': $!\n";
	    }
        } else {
            warn "$main::me: $main::infile: WARNING: Cannot create file '$changes_file': $!\n";
        }
    }

    if (not -e $review_file) {
        if ( open(OUT, "> $review_file") ) {
            close OUT;

	    # set permissions to rw-rw-rw- so webuser will be able to overwrite this empty file
	    if ( not chmod(0666, $review_file) ) {
		warn "$main::me: $main::infile: WARNING: Unable to set"
		    . " needed permissions on file '$review_file': $!\n";
	    }
        } else {
            warn "$main::me: $main::infile: WARNING: Cannot create file '$review_file': $!\n";
        }
    }
}

#----------------------------------------------------------------------

sub get_changes_file {
    return $changes_file;
}

sub get_changes_file_archive {
    return $changes_file_archive;
}

sub get_outfile {
    return $outfile;
}

sub get_path {
    return $path;
}

sub get_spellfile {
    return $spellfile;
}

sub get_tempfile {
    return $tempfile;
}

#----------------------------------------------------------------------

sub html_end {
    my $item_count = shift;

    my $out = <<EOD;
</table>

<input type="hidden" name="form_id" value="$form_id">
<input type="hidden" name="item_count" value="$item_count">

<br><br>
<table>
<tr><td><input type="button" class="button_default" value="Save Data" onClick="document.frm.submit();"></td></tr>
</table>

</form>
</body>
</html>
EOD

    return $out;
}

#----------------------------------------------------------------------

sub init {
    my $infile = shift;
    my $report_type = shift;

    $html_path = $path . $report_type . '/';

    my $ok = 0;

    # determine output filenames
    if ( $infile =~ /^([bz]\d{9}|[cC]av[dD]aily_\d{8})/ ) {
	$form_id = $1 . '.' . $report_type;
	$ok = 1;
    } elsif ( $infile =~ /^(.+?)\.\w{3}$/ ) {
	$form_id = $1 . '.' . $report_type;
	$ok = 1;
    } else {
        warn "$main::me: WARNING: Bad filename: Cannot determine ID from filename."
            . " File '$infile' could NOT be processed.\n";
    }

    if ($ok) {
	$outfile =  $html_path . $form_id . ".html";
	$changes_file = $changes_path . $form_id . '.changes';
	$changes_file_archive = $changes_path . 'Committed/' . $form_id . '.changes';
	$review_file = $review_path . $form_id . '.review';

	if ($report_type eq 'rehyphenate') {
	    $tempfile = $form_id . ".temp";
	    $spellfile = $form_id . ".spell";
	}
    }

    return $ok;
}

#----------------------------------------------------------------------

sub write_outfile {
    # Prints strings passed to output file.
    # Sets permissions to 664 (to ensure group write) if file doesn't already exist.

    my ($string, $set_perm);

    if (-e $outfile) { $set_perm = 0; } else { $set_perm = 1; }
    open(OUT, ">$outfile") || die "$main::me: ERROR: Cannot write '$outfile': $!\n";
    foreach $string (@_) {
	print OUT $string;
    }
    close OUT;
    if ( $set_perm ) { chmod 0664, $outfile; }
}

#----------------------------------------------------------------------

return 1;

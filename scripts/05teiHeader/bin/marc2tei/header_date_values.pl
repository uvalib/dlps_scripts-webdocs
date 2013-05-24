#!perl -w

# header_date_values - corrects common problems with 'value' attributes
#   on <date> elements in TEI header

# Greg Murray <gpm2a@virginia.edu>
# Written: 2006-08-29
# Last modified: 2006-12-20

# 2006-10-24: gpm2a: Tweaked to check for &ndash; in addition to -
# (hyphen) when determining whether to use <dateRange>.
#
# 2006-11-30: gpm2a: If date value starts with "after" use
# certainty="after". Ditto for "before". If in <publicationStmt>,
# <dateRange> must be wrapped in a <date> element. Also added logic to
# check all value/from/to attribute values; if not a 4-digit year,
# print a warning for Cataloging; made this behavior optional (-C
# switch).
#
# 2006-12-20: gpm2a: Added conversions:
# (1) If date has this format:
#   <date value="1653 or 4-1723">1653 or 4-1723</date>
# convert to dateRange like so:
#   <dateRange from="1653" to="1723" exact="from">1653 or 4-1723</dateRange>
# (2) If date has format:
#   <date value="1584 or 5">1584 or 5</date>
# convert to:
#   <date value="1584" certainty="ca">1584 or 5</date>
# (3) If date has this format:
#   <date value="1847-">1847-</date>
# and it's inside an <author> element, convert to:
#   <date value="1847" type="birth">1847-</date>


use strict;
use Getopt::Std;

my ($me, $usage, %opts, $infile, @infile, $inTeiHeader, $inPubStmt, $inAuthor);
my ($att, $value, $new, $from, $to, $exact, $n, $printWarning);

my $warning = '<!-- ATTN Cataloging: The following date value is not a 4-digit year; please correct as needed -->';

$me = 'header_date_values';
$usage = <<EOD;

$me - corrects common problems with 'value' attributes
  on <date> elements in TEI header

Usage: $me [-C] filenames
  -C (Cataloging mode) Output will include an "ATTN Cataloging..." XML comment
     for any date value in the TEI header that is not a 4-digit year

In: TEI XML file(s)
Out: Copies each input file to [filename].bak, then overwrites original input file

Notes:
  * This script only changes values in the TEI header; no other part
    of the file is affected.
  * This script only changes attribute values; it does not change the
    content of the <date> element.
  * This script fixes the following problems:
      - if value is enclosed by square brackets, removes them
      - if value ends with "?", removes ? and adds certainty="ca"
      - if value starts with "ca." or "c.", removes it and adds certainty="ca"
      - if value has form "1584 or 5", removes " or #" and adds certainty="ca"
      - if value starts with "after", removes it and adds certainty="after"
      - if value starts with "before", removes it and adds certainty="before"
      - if value starts with "b.", removes b. and adds type="birth"
      - if value has form "1847-" and occurs inside <author>, removes hyphen and
        adds type="birth"
      - if value starts with "d.", removes d. and adds type="death"
      - if value starts with "fl.", removes fl. and adds type="fl"
      - if value is two years separated by a hyphen, converts to <dateRange>

EOD

getopts('C', \%opts) || die $usage;
die $usage if (! @ARGV);

foreach $infile (@ARGV) {
    $inTeiHeader = 0;
    $inPubStmt = 0;
    $inAuthor = 0;

    # read input file
    open(IN, $infile) || die "$me: ERROR: Cannot read '$infile': $!\n";
    @infile = <IN>;
    close IN;

    # make backup
    open(BAK, ">${infile}.bak") || die "$me: ERROR: Cannot write '${infile}.bak': $!\n";
    foreach (@infile) {
	print BAK;
    }
    close BAK;

    # make changes, overwriting input file
    open(OUT, ">$infile") || die "$me: ERROR: Cannot write '$infile': $!\n";
    foreach (@infile) {
	if ( /<teiHeader/ ) {
	    $inTeiHeader = 1;
	}

	if ( m:</teiHeader>: ) {
	    $inTeiHeader = 0;
	}

	if ($inTeiHeader) {
	    if ( /<publicationStmt/ ) {
		$inPubStmt = 1;
	    }
	    if ( m:</publicationStmt>: ) {
		$inPubStmt = 0;
	    }

	    if ( /<author/ ) {
		$inAuthor = 1;
	    }
	    if ( m:</author>: ) {
		$inAuthor = 0;
	    }

DATETEST:   if ( /<date\s+[^>]*(value=("|')([^\2]+?)\2)/ ) {
		$att = $1;
		$value = $3;

		# escape regular expression characters so substitutions will work
		$att =~ s/\[/\\\[/g;
		$att =~ s/\]/\\\]/g;
		$att =~ s/\?/\\\?/g;

		if ( $value =~ /^\[/ && $value =~ /\]$/ ) {
		    # value enclosed by square brackets; remove them
		    $value =~ s/^\[//;
		    $value =~ s/\]$//;
		    $new = qq/value="$value"/;
		    s/$att/$new/;
		    goto DATETEST;
		}

		if ( $value =~ /^(ca\.\s?)?(\d{3,4})( or \d{1,4})?(\??)(-|&ndash;)\s?(ca\.\s?)?(\d{3,4})( or \d{1,4})?(\??)$/ ) {
		    # use <dateRange> instead of <date>
		    $from = $2;
		    $to = $7;
		    if ( ($1 || $3 || $4) && ($6 || $8 || $9) ) {
			$exact = ' exact="none"';
		    } elsif ($1 || $3 || $4) {
			$exact = ' exact="to"';
		    } elsif ($6 || $8 || $9) {
			$exact = ' exact="from"';
		    } else {
			$exact = '';
		    }
		    $new = qq/from="$from" to="$to"$exact/;
		    s/$att/$new/;
		    s/<date\s/<dateRange /;
		    s:</date>:</dateRange>:;

		    if ($inPubStmt) {
			# <dateRange> must be wrapped in <date> element for validity
			# get 'n' attribute
			if ( /<dateRange[^>]*\s(n=("|')([^\2]+?)\2)/ ) {
			    $n = " $1";
			} else {
			    $n = '';
			}
			# wrap <date> element around <dateRange> element
			s:<dateRange:<date$n value="$from">\n<dateRange:;
			s:</dateRange>:</dateRange>\n</date>:;
		    }
		}

		if ( $value =~ /\?$/ ) {
		    # value ends with question mark; use certainty="ca" instead
		    $value =~ s/\?$//;
		    $new = qq/value="$value" certainty="ca"/;
		    s/$att/$new/;
		    goto DATETEST;
		}

		if ( $value =~ /^ca?\.\s?/ ) {
		    # value starts with "ca." or "c."; use certainty="ca" instead
		    $value =~ s/^ca?\.\s?//;
		    $new = qq/value="$value" certainty="ca"/;
		    s/$att/$new/;
		    goto DATETEST;
		}

		if ( $value =~ /^\d{3,4} or \d{1,4}$/ ) {
		    # value has format like "1584 or 5"; use certainty="ca" instead
		    $value =~ s/ or \d{1,4}$//;
		    $new = qq/value="$value" certainty="ca"/;
		    s/$att/$new/;
		    goto DATETEST;
		}

		if ( $value =~ /^after\s/ ) {
		    # value starts with "after"; use certainty="after" instead
		    $value =~ s/^after\s//;
		    $new = qq/value="$value" certainty="after"/;
		    s/$att/$new/;
		    goto DATETEST;
		}

		if ( $value =~ /^before\s/ ) {
		    # value starts with "before"; use certainty="before" instead
		    $value =~ s/^before\s//;
		    $new = qq/value="$value" certainty="before"/;
		    s/$att/$new/;
		    goto DATETEST;
		}

		if ( $value =~ /^b\.\s?/ ) {
		    # value starts with "b."; use type="birth" instead
		    $value =~ s/^b\.\s?//;
		    $new = qq/value="$value" type="birth"/;
		    s/$att/$new/;
		    goto DATETEST;
		}

		if ( $value =~ /^(ca\.\s?)?(\d{3,4})( or \d{1,4})?(\??)(-|&ndash;)\s*$/ ) {
                    if ($inAuthor) {
		        # value ends with "-"; use type="birth" instead
		        $value =~ s/(-|&ndash;)\s*$//;
		        $new = qq/value="$value" type="birth"/;
		        s/$att/$new/;
		        goto DATETEST;
                    }
                }

		if ( $value =~ /^d\.\s?/ ) {
		    # value starts with "d."; use type="death" instead
		    $value =~ s/^d\.\s?//;
		    $new = qq/value="$value" type="death"/;
		    s/$att/$new/;
		    goto DATETEST;
		}

		if ( $value =~ /^fl\.\s?/ ) {
		    # value starts with "fl."; use type="fl" instead
		    $value =~ s/^fl\.\s?//;
		    $new = qq/value="$value" type="fl"/;
		    s/$att/$new/;
		    goto DATETEST;
		}
	    }

	    if ( $opts{'C'} && /<date/ ) {
		# test date value; if not a 4-digit year then print a warning for Cataloging
		$printWarning = 0;

		if ( /<date\s+[^>]*value=("|')([^\1]+?)\1/ ) {
		    $value = $2;
		    unless ( $value =~ /^\d{4}$/ ) {
			$printWarning = 1;
		    }
		}
		if ( /<dateRange\s+[^>]*from=("|')([^\1]+?)\1/ ) {
		    $from = $2;
		    unless ( $from =~ /^\d{4}$/ ) {
			$printWarning = 1;
		    }
		}
		if ( /<dateRange\s+[^>]*to=("|')([^\1]+?)\1/ ) {
		    $to = $2;
		    unless ( $to =~ /^\d{4}$/ ) {
			$printWarning = 1;
		    }
		}
		if ($printWarning) {
		    print OUT "$warning\n";
		}
	    }
	}
	print OUT;
    }
    close OUT;
}

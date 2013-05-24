#!perl -w

# tweakMarcXml - removes attributes from <collection> element of a MARC XML document

# Greg Murray (gpm2a@virginia.edu)
# Written: 2004-09-02
# Last modified: 2004-09-02

# The attributes on <collection> in a MARC XML document (as produced by the LC marcxml
# MARC binary-to-XML program) prevent Saxon from finding the <record> elements that
# <collection> contains, so the attributes must be removed prior to processing.

use strict;

my ($me, $usage, $infile, @infile);

$me = 'tweakMarcXml';
$usage = <<EOD;

$me - removes attributes from <collection> element of a MARC XML document

Usage: $me filenames
In: One or more MARC XML files
Out: Overwrites input file (no backup file)

The attributes on <collection> in a MARC XML document (as produced by the LC marcxml
MARC binary-to-XML program) prevent Saxon from finding the <record> elements that
<collection> contains, so the attributes must be removed prior to processing.

EOD

die $usage if (! @ARGV);

foreach $infile (@ARGV) {
    # read input file
    open(IN, $infile) || die "$me: ERROR: Cannot read '$infile': $!\n";
    @infile = <IN>;
    close IN;

    # make changes, overwriting input file
    open(OUT, ">$infile") || die "$me: ERROR: Cannot write '$infile': $!\n";
    foreach (@infile) {
        if ( /<collection[^>]*>/ ) {
            $_ = $` . '<collection>' . $';
        }
        print OUT;
    }
    close OUT;
}

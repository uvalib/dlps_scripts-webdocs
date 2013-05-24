#!perl -w

# clean_teiHeader - resolves specific validation errors in TEI header

# Greg Murray <gpm2a@virginia.edu>
# Written: 2006-11-30
# Last modified: 2007-03-02

# 2006-12-20: gpm2a: Remove encoding="US-ASCII" from XML declaration.
#
# 2007-01-08: gpm2a: Remove 'id' attribute on <language> for languages
# already declared. This can occur if the same language appears with
# two different usage attribute values, for example:
# <langUsage>
# <language n="008" id="ger" usage="main">German</language>
# <language n="041|g" id="eng" usage="accompanying material">English</language>
# <language n="041|g" id="fre" usage="accompanying material">French</language>
# <language n="041|g" id="ger" usage="accompanying material">German</language>
# </langUsage>
# Here German is the main language and is also listed in the MARC
# record for accompanying material, but the second id="ger" causes a
# validation error (ID not unique) and must be removed. (And it's
# easier to do this here than in the MARC-to-TEI XSLT stylesheet.)
#
# 2007-03-02: gpm2a: Fixed bug that caused 'id' attribute on
# <language> to be removed in cases where it should be left alone.


use strict;

my ($me, $usage, $infile, @infile, $inTeiHeader, %langs, $id);

$me = 'clean_teiHeader';
$usage = <<EOD;

$me - resolves specific validation errors in TEI header

Usage: $me filenames

In: TEI XML file(s)
Out: Copies each input file to [filename].bak, then overwrites original input file

Notes:
  This script performs the following tasks:
    - removes encoding="US-ASCII" from XML declaration
    - removes empty <notesStmt> elements
    - removes 'id' attribute on <language> for languages already declared

EOD

die $usage if (! @ARGV);

foreach $infile (@ARGV) {
    $inTeiHeader = 0;
    %langs = ();

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
	if ( /^<\?xml[^>]*? encoding="US-ASCII"/ ) {
	    s/ encoding="US-ASCII"//;
	}

	if ( /<teiHeader/ ) {
	    $inTeiHeader = 1;
	}
	if ( m:</teiHeader>: ) {
	    $inTeiHeader = 0;
	}

	if ($inTeiHeader) {
	    # remove empty <notesStmt> elements
	    if ( /<notesStmt/ ) {
		s#<notesStmt[^>]*?/>\s*##;
		s#<notesStmt[^>]*?>\s*</notesStmt>\s*##;
	    }

	    # remove duplicate IDs in language declarations
	    if ( /<language[^>]*? id=("|')([^\1]+?)\1/ ) {
		$id = $2;
		if ( exists($langs{$id}) ) {
		    # this language already declared; remove 'id' attribute
		    s#<language([^>]*?) id=("|')([^\2]+?)\2#<language$1#;
		} else {
		    # add to hash
		    $langs{$id} = '';
		}
	    }
	}
	print OUT;
    }
    close OUT;
}

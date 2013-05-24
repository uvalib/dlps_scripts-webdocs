#!perl -w

# flipent - flips character entity references from hex entity refs
#   (like &#xA9;) to mnemonic/named entity refs (like &copy;)

# Greg Murray <gpm2a@virginia.edu>
# Written: 2004-09-01
# Last modified: 2006-12-08

# 2005-10-25: gpm2a: Refreshed list of character entities following
# __END__ line.
#
# 2006-03-31: gpm2a: Changed list of character entities following
# __END__ line, so that the entity sets most commonly used by DLPS are
# listed before the more obscure ones. This prevents obscure entities
# from trumping common ones. (The script associates each Unicode
# character with only one corresponding entity -- the first one in the
# list.)
#
# 2006-09-21: gpm2a: Updated list of character entities following
# __END__ below.
#
# 2006-12-08: gpm2a: Added system call to declare_charents script,
# which looks at the character entities used in the document and
# declares/inserts any undeclared character-entity-set files. This
# change prevents flipent from creating validation errors by adding
# character entity refs (like &eacute;) without declaring/inserting
# the corresponding entity set (like iso-lat1.ent).


# NOTE: Following the __END__ line below, this file includes a
# comma-separated list of all character entities from the standard ISO
# 8879/SGML entity sets (iso-lat1.ent, etc.) plus uva-supp.ent; the
# list was created with the make_charent_list.sh script. This list is
# used to build a hash of entity-to-Unicode mappings.


use Getopt::Std;
use strict;

my ($me, $usage, %opts);
my ($infile, @infile);
my ($entityName, $charCode, %charents);
my ($test, $buffer, $match, %changed, %skipped, $ent, $key, $plural);

$me = 'flipent';
$usage = <<EOD;

$me - flips character entity references from hex entity refs
  (like &#xA9;) to mnemonic/named entity refs (like &copy;)

Usage: $me [-q] filenames
  -q (quiet) Do not show summary of replacements; only show error messages

In:  One or more XML files.
Out: Copies input file to [filename].bak, then overwrites input file.
     Also prints summary of replacements to standard output.

EOD

getopts('q', \%opts) || die $usage;
die $usage if (! @ARGV);


#-----------------------------------------
# build hash of entity-to-Unicode mappings
#-----------------------------------------

while (<DATA>) {
    if (/^(.+?),(.+?),/) {
	$entityName = $1;
	$charCode = $2;
	$charents{$charCode} = $entityName unless exists($charents{$charCode});
    }
}


#------------------------
# process each input file
#------------------------

foreach $infile (@ARGV) {
    %changed = ();
    %skipped = ();

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
    # read each line of this input file
    foreach (@infile) {
	# find all occurrences on this line
	if ( /&[^;]+?;/ ) {
	    $test = $_;
	    $buffer = '';
	    while ( $test =~ /&([^;]+?);/ ) {
		$match = $&;
		$buffer .= $`;
		$test = $';
		if ( $match =~ /^&#x(.+);$/ ) {
		    # format as 4-char upper-case hex number
		    $charCode = uc( sprintf("%04s", $1) );

		    # convert to mnemonic entity
		    if ( exists($charents{$charCode}) ) {
			$match = '&' . $charents{$charCode} . ';';
			if ( exists($changed{$charCode}) ) {
			    $changed{$charCode}++;
			} else {
			    $changed{$charCode} = 1;
			}
		    } else {
			if ( exists($skipped{$charCode}) ) {
			    $skipped{$charCode}++;
			} else {
			    $skipped{$charCode} = 1;
			}
		    }
		} else {
		    # not a hex entity ref
#		    $ent = $match;
#		    $ent =~ s/^&//;
#		    $ent =~ s/;$//;
#		    if ( exists($skipped{$ent}) ) {
#			$skipped{$ent}++;
#		    } else {
#			$skipped{$ent} = 1;
#		    }
		}
		$buffer .= $match;
	    } # end while
	    $buffer .= $test;
	    $_ = $buffer;
	}

	print OUT;
    }
    close OUT;

    if (not $opts{q}) {
	# print summary for this file
	if ( scalar(%changed) or scalar(%skipped) ) {
	    print "$infile:\n";
	}

	if ( scalar(%changed) ) {
	    print "    Changed:\n";
	}
	foreach $key ( sort(keys(%changed)) ) {
	    if ( $changed{$key} == 1 ) { $plural = ''; } else { $plural = 's'; }
	    print "        $key --> $charents{$key} ($changed{$key} occurrence$plural)\n";
	}

	if ( scalar(%skipped) ) {
	    print "    Not changed:\n";
	}
	foreach $key ( sort(keys(%skipped)) ) {
	    if ( $skipped{$key} == 1 ) { $plural = ''; } else { $plural = 's'; }
	    print "        $key ($skipped{$key} occurrence$plural)\n";
	}
    }

    # call declare_charents script to declare/insert any undeclared
    # character-entity-set files (like iso-lat1.ent, etc.)
#    system("declare_charents -B $infile");
}

__END__

AElig,00C6,LATIN CAPITAL LETTER AE,iso-lat1.ent
Aacgr,0386,GREEK CAPITAL LETTER ALPHA WITH TONOS,iso-grk2.ent
Aacute,00C1,LATIN CAPITAL LETTER A WITH ACUTE,iso-lat1.ent
Abreve,0102,LATIN CAPITAL LETTER A WITH BREVE,iso-lat2.ent
Acaron,01CD,LATIN CAPITAL LETTER A WITH CARON,uva-supp.ent
Acirc,00C2,LATIN CAPITAL LETTER A WITH CIRCUMFLEX,iso-lat1.ent
Agr,0391,GREEK CAPITAL LETTER ALPHA,iso-grk1.ent
Agrave,00C0,LATIN CAPITAL LETTER A WITH GRAVE,iso-lat1.ent
Amacr,0100,LATIN CAPITAL LETTER A WITH MACRON,iso-lat2.ent
Aogon,0104,LATIN CAPITAL LETTER A WITH OGONEK,iso-lat2.ent
Aring,00C5,LATIN CAPITAL LETTER A WITH RING ABOVE,iso-lat1.ent
Atilde,00C3,LATIN CAPITAL LETTER A WITH TILDE,iso-lat1.ent
Auml,00C4,LATIN CAPITAL LETTER A WITH DIAERESIS,iso-lat1.ent
Bgr,0392,GREEK CAPITAL LETTER BETA,iso-grk1.ent
Cacute,0106,LATIN CAPITAL LETTER C WITH ACUTE,iso-lat2.ent
Ccaron,010C,LATIN CAPITAL LETTER C WITH CARON,iso-lat2.ent
Ccedil,00C7,LATIN CAPITAL LETTER C WITH CEDILLA,iso-lat1.ent
Ccirc,0108,LATIN CAPITAL LETTER C WITH CIRCUMFLEX,iso-lat2.ent
Cdot,010A,LATIN CAPITAL LETTER C WITH DOT ABOVE,iso-lat2.ent
Dagger,2021,DOUBLE DAGGER,iso-pub.ent
Dcaron,010E,LATIN CAPITAL LETTER D WITH CARON,iso-lat2.ent
Dgr,0394,GREEK CAPITAL LETTER DELTA,iso-grk1.ent
Dot,00A8, ,iso-tech.ent
DotDot,20DC,COMBINING FOUR DOTS ABOVE,iso-tech.ent
Dstrok,0110,LATIN CAPITAL LETTER D WITH STROKE,iso-lat2.ent
EEacgr,0389,GREEK CAPITAL LETTER ETA WITH TONOS,iso-grk2.ent
EEgr,0397,GREEK CAPITAL LETTER ETA,iso-grk1.ent
ENG,014A,LATIN CAPITAL LETTER ENG,iso-lat2.ent
ETH,00D0,LATIN CAPITAL LETTER ETH,iso-lat1.ent
Eacgr,0388,GREEK CAPITAL LETTER EPSILON WITH TONOS,iso-grk2.ent
Eacute,00C9,LATIN CAPITAL LETTER E WITH ACUTE,iso-lat1.ent
Ebreve,0114,LATIN CAPITAL LETTER E WITH BREVE,uva-supp.ent
Ecaron,011A,LATIN CAPITAL LETTER E WITH CARON,iso-lat2.ent
Ecirc,00CA,LATIN CAPITAL LETTER E WITH CIRCUMFLEX,iso-lat1.ent
Edagr,1F19,GREEK CAPITAL LETTER EPSILON WITH DASIA,uva-supp.ent
Edot,0116,LATIN CAPITAL LETTER E WITH DOT ABOVE,iso-lat2.ent
Egr,0395,GREEK CAPITAL LETTER EPSILON,iso-grk1.ent
Egrave,00C8,LATIN CAPITAL LETTER E WITH GRAVE,iso-lat1.ent
Emacr,0112,LATIN CAPITAL LETTER E WITH MACRON,iso-lat2.ent
Eogon,0118,LATIN CAPITAL LETTER E WITH OGONEK,iso-lat2.ent
Euml,00CB,LATIN CAPITAL LETTER E WITH DIAERESIS,iso-lat1.ent
Ezh,01B7,LATIN CAPITAL LETTER EZH,uva-supp.ent
Gbreve,011E,LATIN CAPITAL LETTER G WITH BREVE,iso-lat2.ent
Gcedil,0122,LATIN CAPITAL LETTER G WITH CEDILLA,iso-lat2.ent
Gcirc,011C,LATIN CAPITAL LETTER G WITH CIRCUMFLEX,iso-lat2.ent
Gdot,0120,LATIN CAPITAL LETTER G WITH DOT ABOVE,iso-lat2.ent
Ggr,0393,GREEK CAPITAL LETTER GAMMA,iso-grk1.ent
Hcirc,0124,LATIN CAPITAL LETTER H WITH CIRCUMFLEX,iso-lat2.ent
Hstrok,0126,LATIN CAPITAL LETTER H WITH STROKE,iso-lat2.ent
IJlig,0132,LATIN CAPITAL LIGATURE IJ,iso-lat2.ent
Iacgr,038A,GREEK CAPITAL LETTER IOTA WITH TONOS,iso-grk2.ent
Iacute,00CD,LATIN CAPITAL LETTER I WITH ACUTE,iso-lat1.ent
Ibreve,012C,LATIN CAPITAL LETTER I WITH BREVE,uva-supp.ent
Icirc,00CE,LATIN CAPITAL LETTER I WITH CIRCUMFLEX,iso-lat1.ent
Idigr,03AA,GREEK CAPITAL LETTER IOTA WITH DIALYTIKA,iso-grk2.ent
Idot,0130,LATIN CAPITAL LETTER I WITH DOT ABOVE,iso-lat2.ent
Igr,0399,GREEK CAPITAL LETTER IOTA,iso-grk1.ent
Igrave,00CC,LATIN CAPITAL LETTER I WITH GRAVE,iso-lat1.ent
Imacr,012A,LATIN CAPITAL LETTER I WITH MACRON,iso-lat2.ent
Iogon,012E,LATIN CAPITAL LETTER I WITH OGONEK,iso-lat2.ent
Itilde,0128,LATIN CAPITAL LETTER I WITH TILDE,iso-lat2.ent
Iuml,00CF,LATIN CAPITAL LETTER I WITH DIAERESIS,iso-lat1.ent
Jcirc,0134,LATIN CAPITAL LETTER J WITH CIRCUMFLEX,iso-lat2.ent
KHgr,03A7,GREEK CAPITAL LETTER CHI,iso-grk1.ent
Kcedil,0136,LATIN CAPITAL LETTER K WITH CEDILLA,iso-lat2.ent
Kgr,039A,GREEK CAPITAL LETTER KAPPA,iso-grk1.ent
Lacute,0139,LATIN CAPITAL LETTER L WITH ACUTE,iso-lat2.ent
Lcaron,013D,LATIN CAPITAL LETTER L WITH CARON,iso-lat2.ent
Lcedil,013B,LATIN CAPITAL LETTER L WITH CEDILLA,iso-lat2.ent
Lgr,039B,GREEK CAPITAL LETTER LAMDA,iso-grk1.ent
Lmidot,013F,LATIN CAPITAL LETTER L WITH MIDDLE DOT,iso-lat2.ent
Lstrok,0141,LATIN CAPITAL LETTER L WITH STROKE,iso-lat2.ent
Mgr,039C,GREEK CAPITAL LETTER MU,iso-grk1.ent
Nacute,0143,LATIN CAPITAL LETTER N WITH ACUTE,iso-lat2.ent
Ncaron,0147,LATIN CAPITAL LETTER N WITH CARON,iso-lat2.ent
Ncedil,0145,LATIN CAPITAL LETTER N WITH CEDILLA,iso-lat2.ent
Ngr,039D,GREEK CAPITAL LETTER NU,iso-grk1.ent
Ntilde,00D1,LATIN CAPITAL LETTER N WITH TILDE,iso-lat1.ent
OElig,0152,LATIN CAPITAL LIGATURE OE,iso-lat2.ent
OHacgr,038F,GREEK CAPITAL LETTER OMEGA WITH TONOS,iso-grk2.ent
OHgr,03A9,GREEK CAPITAL LETTER OMEGA,iso-grk1.ent
Oacgr,038C,GREEK CAPITAL LETTER OMICRON WITH TONOS,iso-grk2.ent
Oacute,00D3,LATIN CAPITAL LETTER O WITH ACUTE,iso-lat1.ent
Obreve,014E,LATIN CAPITAL LETTER O WITH BREVE,uva-supp.ent
Ocaron,01D1,LATIN CAPITAL LETTER O WITH CARON,uva-supp.ent
Ocirc,00D4,LATIN CAPITAL LETTER O WITH CIRCUMFLEX,iso-lat1.ent
Odblac,0150,LATIN CAPITAL LETTER O WITH DOUBLE ACUTE,iso-lat2.ent
Ogr,039F,GREEK CAPITAL LETTER OMICRON,iso-grk1.ent
Ograve,00D2,LATIN CAPITAL LETTER O WITH GRAVE,iso-lat1.ent
Omacr,014C,LATIN CAPITAL LETTER O WITH MACRON,iso-lat2.ent
Oslash,00D8,LATIN CAPITAL LETTER O WITH STROKE,iso-lat1.ent
Otilde,00D5,LATIN CAPITAL LETTER O WITH TILDE,iso-lat1.ent
Ouml,00D6,LATIN CAPITAL LETTER O WITH DIAERESIS,iso-lat1.ent
PHgr,03A6,GREEK CAPITAL LETTER PHI,iso-grk1.ent
PSgr,03A8,GREEK CAPITAL LETTER PSI,iso-grk1.ent
Pgr,03A0,GREEK CAPITAL LETTER PI,iso-grk1.ent
Prime,2033,DOUBLE PRIME,iso-tech.ent
Racute,0154,LATIN CAPITAL LETTER R WITH ACUTE,iso-lat2.ent
Rcaron,0158,LATIN CAPITAL LETTER R WITH CARON,iso-lat2.ent
Rcedil,0156,LATIN CAPITAL LETTER R WITH CEDILLA,iso-lat2.ent
Rgr,03A1,GREEK CAPITAL LETTER RHO,iso-grk1.ent
Sacute,015A,LATIN CAPITAL LETTER S WITH ACUTE,iso-lat2.ent
Scaron,0160,LATIN CAPITAL LETTER S WITH CARON,iso-lat2.ent
Scedil,015E,LATIN CAPITAL LETTER S WITH CEDILLA,iso-lat2.ent
Scirc,015C,LATIN CAPITAL LETTER S WITH CIRCUMFLEX,iso-lat2.ent
Sgr,03A3,GREEK CAPITAL LETTER SIGMA,iso-grk1.ent
THORN,00DE,LATIN CAPITAL LETTER THORN,iso-lat1.ent
THgr,0398,GREEK CAPITAL LETTER THETA,iso-grk1.ent
Tcaron,0164,LATIN CAPITAL LETTER T WITH CARON,iso-lat2.ent
Tcedil,0162,LATIN CAPITAL LETTER T WITH CEDILLA,iso-lat2.ent
Tgr,03A4,GREEK CAPITAL LETTER TAU,iso-grk1.ent
Tstrok,0166,LATIN CAPITAL LETTER T WITH STROKE,iso-lat2.ent
Uacgr,038E,GREEK CAPITAL LETTER UPSILON WITH TONOS,iso-grk2.ent
Uacute,00DA,LATIN CAPITAL LETTER U WITH ACUTE,iso-lat1.ent
Ubreve,016C,LATIN CAPITAL LETTER U WITH BREVE,iso-lat2.ent
Ucaron,01D3,LATIN CAPITAL LETTER U WITH CARON,uva-supp.ent
Ucirc,00DB,LATIN CAPITAL LETTER U WITH CIRCUMFLEX,iso-lat1.ent
Udblac,0170,LATIN CAPITAL LETTER U WITH DOUBLE ACUTE,iso-lat2.ent
Udigr,03AB,GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA,iso-grk2.ent
Ugr,03A5, ,iso-grk1.ent
Ugrave,00D9,LATIN CAPITAL LETTER U WITH GRAVE,iso-lat1.ent
Umacr,016A,LATIN CAPITAL LETTER U WITH MACRON,iso-lat2.ent
Uogon,0172,LATIN CAPITAL LETTER U WITH OGONEK,iso-lat2.ent
Uring,016E,LATIN CAPITAL LETTER U WITH RING ABOVE,iso-lat2.ent
Utilde,0168,LATIN CAPITAL LETTER U WITH TILDE,iso-lat2.ent
Uuml,00DC,LATIN CAPITAL LETTER U WITH DIAERESIS,iso-lat1.ent
Verbar,2016,DOUBLE VERTICAL LINE,iso-tech.ent
Wcirc,0174,LATIN CAPITAL LETTER W WITH CIRCUMFLEX,iso-lat2.ent
Xgr,039E,GREEK CAPITAL LETTER XI,iso-grk1.ent
Yacute,00DD,LATIN CAPITAL LETTER Y WITH ACUTE,iso-lat1.ent
Ycirc,0176,LATIN CAPITAL LETTER Y WITH CIRCUMFLEX,iso-lat2.ent
Yogh,021C,LATIN CAPITAL LETTER YOGH,uva-supp.ent
Yuml,0178,LATIN CAPITAL LETTER Y WITH DIAERESIS,iso-lat2.ent
Zacute,0179,LATIN CAPITAL LETTER Z WITH ACUTE,iso-lat2.ent
Zcaron,017D,LATIN CAPITAL LETTER Z WITH CARON,iso-lat2.ent
Zdot,017B,LATIN CAPITAL LETTER Z WITH DOT ABOVE,iso-lat2.ent
Zgr,0396,GREEK CAPITAL LETTER ZETA,iso-grk1.ent
aacgr,03AC,GREEK SMALL LETTER ALPHA WITH TONOS,iso-grk2.ent
aacute,00E1,LATIN SMALL LETTER A WITH ACUTE,iso-lat1.ent
abreve,0103,LATIN SMALL LETTER A WITH BREVE,iso-lat2.ent
acaron,01CE,LATIN SMALL LETTER A WITH CARON,uva-supp.ent
acirc,00E2,LATIN SMALL LETTER A WITH CIRCUMFLEX,iso-lat1.ent
acute,00B4,ACUTE ACCENT,uva-supp.ent
adot,0227,LATIN SMALL LETTER A WITH DOT ABOVE,uva-supp.ent
aelig,00E6,LATIN SMALL LETTER AE,iso-lat1.ent
agr,03B1, ,iso-grk1.ent
agrave,00E0,LATIN SMALL LETTER A WITH GRAVE,iso-lat1.ent
agrgr,1F70,GREEK SMALL LETTER ALPHA WITH VARIA,uva-supp.ent
aleph,2135,ALEF SYMBOL,iso-tech.ent
amacr,0101,LATIN SMALL LETTER A WITH MACRON,iso-lat2.ent
and,2227, ,iso-tech.ent
ang90,221F,RIGHT ANGLE,iso-tech.ent
angsph,2222, ,iso-tech.ent
angst,212B,ANGSTROM SIGN,iso-tech.ent
aogon,0105,LATIN SMALL LETTER A WITH OGONEK,iso-lat2.ent
ap,2248, ,iso-tech.ent
apegr,1FB6,GREEK SMALL LETTER ALPHA WITH PERISPOMENI,uva-supp.ent
apos,0027,APOSTROPHE,iso-num.ent
apsgr,1F00,GREEK SMALL LETTER ALPHA WITH PSILI,uva-supp.ent
apsoxgr,1F04,GREEK SMALL LETTER ALPHA WITH PSILI AND OXIA,uva-supp.ent
aring,00E5,LATIN SMALL LETTER A WITH RING ABOVE,iso-lat1.ent
ast,002A,ASTERISK,iso-num.ent
asterism,2042,ASTERISM,uva-supp.ent
atilde,00E3,LATIN SMALL LETTER A WITH TILDE,iso-lat1.ent
auml,00E4,LATIN SMALL LETTER A WITH DIAERESIS,iso-lat1.ent
becaus,2235,BECAUSE,iso-tech.ent
bernou,212C,SCRIPT CAPITAL B,iso-tech.ent
bgr,03B2,GREEK SMALL LETTER BETA,iso-grk1.ent
blank,2423,OPEN BOX,iso-pub.ent
blk12,2592,MEDIUM SHADE,iso-pub.ent
blk14,2591,LIGHT SHADE,iso-pub.ent
blk34,2593,DARK SHADE,iso-pub.ent
block,2588,FULL BLOCK,iso-pub.ent
bottom,22A5, ,iso-tech.ent
brvbar,00A6,BROKEN BAR,iso-num.ent
bsol,005C,REVERSE SOLIDUS,iso-num.ent
bull,2022,BULLET,iso-pub.ent
cacute,0107,LATIN SMALL LETTER C WITH ACUTE,iso-lat2.ent
cap,2229, ,iso-tech.ent
caret,2041,CARET,iso-pub.ent
ccaron,010D,LATIN SMALL LETTER C WITH CARON,iso-lat2.ent
ccedil,00E7,LATIN SMALL LETTER C WITH CEDILLA,iso-lat1.ent
ccirc,0109,LATIN SMALL LETTER C WITH CIRCUMFLEX,iso-lat2.ent
cdot,010B,LATIN SMALL LETTER C WITH DOT ABOVE,iso-lat2.ent
cedil,00B8,CEDILLA,uva-supp.ent
cent,00A2,CENT SIGN,iso-num.ent
check,2713,CHECK MARK,iso-pub.ent
cir,25CB,WHITE CIRCLE,iso-pub.ent
clubs,2663,BLACK CLUB SUIT,iso-pub.ent
colon,003A,COLON,iso-num.ent
comLowbar,0333,COMBINING DOUBLE LOW LINE,uva-supp.ent
comacute,0301,COMBINING ACUTE ACCENT,uva-supp.ent
combreve,0306,COMBINING BREVE,uva-supp.ent
combreveb,032E,COMBINING BREVE BELOW,uva-supp.ent
comcaron,030C,COMBINING CARON,uva-supp.ent
comcaronb,032C,COMBINING CARON BELOW,uva-supp.ent
comcedil,0327,COMBINING CEDILLA,uva-supp.ent
comcirc,0302,COMBINING CIRCUMFLEX ACCENT,uva-supp.ent
comcircb,032D,COMBINING CIRCUMFLEX ACCENT BELOW,uva-supp.ent
comdasia,0314,COMBINING REVERSED COMMA ABOVE,uva-supp.ent
comdblac,030B,COMBINING DOUBLE ACUTE ACCENT,uva-supp.ent
comdot,0307,COMBINING DOT ABOVE,uva-supp.ent
comdotb,0323,COMBINING DOT BELOW,uva-supp.ent
comgrave,0300,COMBINING GRAVE ACCENT,uva-supp.ent
comibreve,0311,COMBINING INVERTED BREVE,uva-supp.ent
comibreveb,032F,COMBINING INVERTED BREVE BELOW,uva-supp.ent
comlowbar,0332,COMBINING LOW LINE,uva-supp.ent
comma,002C,COMMA,iso-num.ent
commacr,0304,COMBINING MACRON,uva-supp.ent
commacrb,0331,COMBINING MACRON BELOW,uva-supp.ent
commat,0040,COMMERCIAL AT,iso-num.ent
comogon,0328,COMBINING OGONEK,uva-supp.ent
comover,0305,COMBINING OVERLINE,uva-supp.ent
compfn,2218,RING OPERATOR,iso-tech.ent
compsili,0313,COMBINING COMMA ABOVE,uva-supp.ent
comring,030A,COMBINING RING ABOVE,uva-supp.ent
comringb,0325,COMBINING RING BELOW,uva-supp.ent
comtilde,0303,COMBINING TILDE,uva-supp.ent
comtildeb,0330,COMBINING TILDE BELOW,uva-supp.ent
comuml,0308,COMBINING DIAERESIS,uva-supp.ent
comumlb,0324,COMBINING DIAERESIS BELOW,uva-supp.ent
comvert,030D,COMBINING VERTICAL LINE ABOVE,uva-supp.ent
cong,2245, ,iso-tech.ent
conint,222E, ,iso-tech.ent
copy,00A9,COPYRIGHT SIGN,iso-num.ent
copysr,2117,SOUND RECORDING COPYRIGHT,iso-pub.ent
cross,2717,BALLOT X,iso-pub.ent
cross-latin,271D,LATIN CROSS,uva-supp.ent
cup,222A, ,iso-tech.ent
curren,00A4,CURRENCY SIGN,iso-num.ent
dagger,2020,DAGGER,iso-pub.ent
darr,2193,DOWNWARDS ARROW,iso-num.ent
dash,2010,HYPHEN,iso-pub.ent
dcaron,010F,LATIN SMALL LETTER D WITH CARON,iso-lat2.ent
deg,00B0,DEGREE SIGN,iso-num.ent
degmacr,00B0,degree with macron,uva-supp.ent
dgr,03B4,GREEK SMALL LETTER DELTA,iso-grk1.ent
diams,2666,BLACK DIAMOND SUIT,iso-pub.ent
divide,00F7,DIVISION SIGN,iso-num.ent
dlcrop,230D,BOTTOM LEFT CROP,iso-pub.ent
dollar,0024,DOLLAR SIGN,iso-num.ent
drcrop,230C,BOTTOM RIGHT CROP,iso-pub.ent
dstrok,0111,LATIN SMALL LETTER D WITH STROKE,iso-lat2.ent
dtri,25BF,WHITE DOWN-POINTING TRIANGLE,iso-pub.ent
dtrif,25BE,BLACK DOWN-POINTING TRIANGLE,iso-pub.ent
eacgr,03AD,GREEK SMALL LETTER EPSILON WITH TONOS,iso-grk2.ent
eacute,00E9,LATIN SMALL LETTER E WITH ACUTE,iso-lat1.ent
ebreve,0115,LATIN SMALL LETTER E WITH BREVE,uva-supp.ent
ecaron,011B,LATIN SMALL LETTER E WITH CARON,iso-lat2.ent
ecedil,0229,LATIN SMALL LETTER E WITH CEDILLA,uva-supp.ent
ecirc,00EA,LATIN SMALL LETTER E WITH CIRCUMFLEX,iso-lat1.ent
edagr,1F11,GREEK SMALL LETTER EPSILON WITH DASIA,uva-supp.ent
edaoxgr,1F15,GREEK SMALL LETTER EPSILON WITH DASIA AND OXIA,uva-supp.ent
edot,0117,LATIN SMALL LETTER E WITH DOT ABOVE,iso-lat2.ent
eeacgr,03AE,GREEK SMALL LETTER ETA WITH TONOS,iso-grk2.ent
eedagr,1F21,GREEK SMALL LETTER ETA WITH DASIA,uva-supp.ent
eegr,03B7,GREEK SMALL LETTER ETA,iso-grk1.ent
eegrgr,1F74,GREEK SMALL LETTER ETA WITH VARIA,uva-supp.ent
eepegr,1FC6,GREEK SMALL LETTER ETA WITH PERISPOMENI,uva-supp.ent
eepspegr,1F26,GREEK SMALL LETTER ETA WITH PSILI AND PERISPOMENI,uva-supp.ent
egr,03B5, ,iso-grk1.ent
egrave,00E8,LATIN SMALL LETTER E WITH GRAVE,iso-lat1.ent
egrgr,1F72,GREEK SMALL LETTER EPSILON WITH VARIA,uva-supp.ent
emacr,0113,LATIN SMALL LETTER E WITH MACRON,iso-lat2.ent
emsp,2003,EM SPACE,iso-pub.ent
emsp13,2004,THREE-PER-EM SPACE,iso-pub.ent
emsp14,2005,FOUR-PER-EM SPACE,iso-pub.ent
eng,014B,LATIN SMALL LETTER ENG,iso-lat2.ent
ensp,2002,EN SPACE,iso-pub.ent
eogon,0119,LATIN SMALL LETTER E WITH OGONEK,iso-lat2.ent
epsgr,1F10,GREEK SMALL LETTER EPSILON WITH PSILI,uva-supp.ent
epsoxgr,1F14,GREEK SMALL LETTER EPSILON WITH PSILI AND OXIA,uva-supp.ent
equals,003D,EQUALS SIGN,iso-num.ent
equiv,2261, ,iso-tech.ent
eth,00F0,LATIN SMALL LETTER ETH,iso-lat1.ent
etilde,1EBD,LATIN SMALL LETTER E WITH TILDE,uva-supp.ent
euml,00EB,LATIN SMALL LETTER E WITH DIAERESIS,iso-lat1.ent
excl,0021,EXCLAMATION MARK,iso-num.ent
exist,2203, ,iso-tech.ent
ezh,0292,LATIN SMALL LETTER EZH,uva-supp.ent
female,2640, ,iso-pub.ent
ffilig,FB03, ,iso-pub.ent
fflig,FB00, ,iso-pub.ent
ffllig,FB04, ,iso-pub.ent
filig,FB01, ,iso-pub.ent
flat,266D,MUSIC FLAT SIGN,iso-pub.ent
fllig,FB02, ,iso-pub.ent
fnof,0192,LATIN SMALL LETTER F WITH HOOK,iso-tech.ent
forall,2200, ,iso-tech.ent
frac12,00BD,VULGAR FRACTION ONE HALF,iso-num.ent
frac13,2153,VULGAR FRACTION ONE THIRD,iso-pub.ent
frac14,00BC,VULGAR FRACTION ONE QUARTER,iso-num.ent
frac15,2155,VULGAR FRACTION ONE FIFTH,iso-pub.ent
frac16,2159,VULGAR FRACTION ONE SIXTH,iso-pub.ent
frac18,215B, ,iso-num.ent
frac23,2154,VULGAR FRACTION TWO THIRDS,iso-pub.ent
frac25,2156,VULGAR FRACTION TWO FIFTHS,iso-pub.ent
frac34,00BE,VULGAR FRACTION THREE QUARTERS,iso-num.ent
frac35,2157,VULGAR FRACTION THREE FIFTHS,iso-pub.ent
frac38,215C, ,iso-num.ent
frac45,2158,VULGAR FRACTION FOUR FIFTHS,iso-pub.ent
frac56,215A,VULGAR FRACTION FIVE SIXTHS,iso-pub.ent
frac58,215D, ,iso-num.ent
frac78,215E, ,iso-num.ent
gacute,01F5,LATIN SMALL LETTER G WITH ACUTE,iso-lat2.ent
gammads,03DD,GREEK SMALL LETTER DIGAMMA,uva-supp.ent
gbreve,011F,LATIN SMALL LETTER G WITH BREVE,iso-lat2.ent
gcaron,01E7,LATIN SMALL LETTER G WITH CARON,uva-supp.ent
gcedil,0123,LATIN SMALL LETTER G WITH CEDILLA,uva-supp.ent
gcirc,011D,LATIN SMALL LETTER G WITH CIRCUMFLEX,iso-lat2.ent
gdot,0121,LATIN SMALL LETTER G WITH DOT ABOVE,iso-lat2.ent
ge,2265,GREATER-THAN OR EQUAL TO,iso-tech.ent
ggr,03B3,GREEK SMALL LETTER GAMMA,iso-grk1.ent
gt,003E,GREATER-THAN SIGN,iso-num.ent
hairsp,200A,HAIR SPACE,iso-pub.ent
half,00BD,VULGAR FRACTION ONE HALF,iso-num.ent
hamilt,210B,SCRIPT CAPITAL H,iso-tech.ent
hand,261E,WHITE RIGHT POINTING INDEX,uva-supp.ent
handl,261C,WHITE LEFT POINTING INDEX,uva-supp.ent
handlblk,261A,BLACK LEFT POINTING INDEX,uva-supp.ent
handr,261E,WHITE RIGHT POINTING INDEX,uva-supp.ent
handrblk,261B,BLACK RIGHT POINTING INDEX,uva-supp.ent
hcirc,0125,LATIN SMALL LETTER H WITH CIRCUMFLEX,iso-lat2.ent
hearts,2665,BLACK HEART SUIT,iso-pub.ent
hellip,2026,HORIZONTAL ELLIPSIS,iso-pub.ent
horbar,2015,HORIZONTAL BAR,iso-num.ent
hstrok,0127,LATIN SMALL LETTER H WITH STROKE,iso-lat2.ent
hybull,2043,HYPHEN BULLET,iso-pub.ent
hyphen,002D,HYPHEN-MINUS,iso-num.ent
iacgr,03AF,GREEK SMALL LETTER IOTA WITH TONOS,iso-grk2.ent
iacute,00ED,LATIN SMALL LETTER I WITH ACUTE,iso-lat1.ent
ibreve,012D,LATIN SMALL LETTER I WITH BREVE,uva-supp.ent
icaron,01D0,LATIN SMALL LETTER I WITH CARON,uva-supp.ent
icirc,00EE,LATIN SMALL LETTER I WITH CIRCUMFLEX,iso-lat1.ent
idagr,1F31,GREEK SMALL LETTER IOTA WITH DASIA,uva-supp.ent
idaoxgr,1F35,GREEK SMALL LETTER IOTA WITH DASIA AND OXIA,uva-supp.ent
idapegr,1F37,GREEK SMALL LETTER IOTA WITH DASIA AND PERISPOMENI,uva-supp.ent
idiagr,0390,GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS,iso-grk2.ent
idigr,03CA,GREEK SMALL LETTER IOTA WITH DIALYTIKA,iso-grk2.ent
idotb,1ECB,LATIN SMALL LETTER I WITH DOT BELOW,uva-supp.ent
iexcl,00A1,INVERTED EXCLAMATION MARK,iso-num.ent
iff,21D4,LEFT RIGHT DOUBLE ARROW,iso-tech.ent
igr,03B9,GREEK SMALL LETTER IOTA,iso-grk1.ent
igrave,00EC,LATIN SMALL LETTER I WITH GRAVE,iso-lat1.ent
igrgr,1F76,GREEK SMALL LETTER IOTA WITH VARIA,uva-supp.ent
ijlig,0133,LATIN SMALL LIGATURE IJ,iso-lat2.ent
imacr,012B,LATIN SMALL LETTER I WITH MACRON,iso-lat2.ent
imacrgr,1FD1,GREEK SMALL LETTER IOTA WITH MACRON,uva-supp.ent
incare,2105,CARE OF,iso-pub.ent
infin,221E, ,iso-tech.ent
inodot,0131,LATIN SMALL LETTER DOTLESS I,iso-lat2.ent
int,222B, ,iso-tech.ent
iogon,012F,LATIN SMALL LETTER I WITH OGONEK,iso-lat2.ent
ipegr,1FD6,GREEK SMALL LETTER IOTA WITH PERISPOMENI,uva-supp.ent
ipsgr,1F30,GREEK SMALL LETTER IOTA WITH PSILI,uva-supp.ent
ipsoxgr,1F34,GREEK SMALL LETTER IOTA WITH PSILI AND OXIA,uva-supp.ent
iquest,00BF,INVERTED QUESTION MARK,iso-num.ent
isin,220A, ,iso-tech.ent
itilde,0129,LATIN SMALL LETTER I WITH TILDE,iso-lat2.ent
iuml,00EF,LATIN SMALL LETTER I WITH DIAERESIS,iso-lat1.ent
jcirc,0135,LATIN SMALL LETTER J WITH CIRCUMFLEX,iso-lat2.ent
jgr,03F3,GREEK LETTER YOT,uva-supp.ent
kcedil,0137,LATIN SMALL LETTER K WITH CEDILLA,iso-lat2.ent
kgr,03BA,GREEK SMALL LETTER KAPPA,iso-grk1.ent
kgreen,0138,LATIN SMALL LETTER KRA,iso-lat2.ent
khei,03E7,COPTIC SMALL LETTER KHEI,uva-supp.ent
khgr,03C7,GREEK SMALL LETTER CHI,iso-grk1.ent
lArr,21D0,LEFTWARDS ARROW,iso-tech.ent
lacute,013A,LATIN SMALL LETTER L WITH ACUTE,iso-lat2.ent
lagran,2112,SCRIPT CAPITAL L,iso-tech.ent
lang,3008, ,iso-tech.ent
laquo,00AB,LEFT-POINTING DOUBLE ANGLE QUOTATION MARK,iso-num.ent
larr,2190,LEFTWARDS ARROW,iso-num.ent
lbbar,2114,L B BAR SYMBOL,uva-supp.ent
lbull,204C,BLACK LEFTWARDS BULLET,uva-supp.ent
lcaron,013E,LATIN SMALL LETTER L WITH CARON,iso-lat2.ent
lcedil,013C,LATIN SMALL LETTER L WITH CEDILLA,iso-lat2.ent
lcub,007B,LEFT CURLY BRACKET,iso-num.ent
ldlbtilde,FE22,COMBINING DOUBLE TILDE LEFT HALF,uva-supp.ent
ldotb,1E37,LATIN SMALL LETTER L WITH DOT BELOW,uva-supp.ent
ldquo,201C, ,iso-num.ent
ldquor,201E,DOUBLE LOW-9 QUOTATION MARK,iso-pub.ent
le,2264, ,iso-tech.ent
lgr,03BB,GREEK SMALL LETTER LAMDA,iso-grk1.ent
lhblk,2584,LOWER HALF BLOCK,iso-pub.ent
lhring,02BF,MODIFIER LETTER LEFT HALF RING,uva-supp.ent
llig,FE20,COMBINING LIGATURE LEFT HALF,uva-supp.ent
lmidot,0140,LATIN SMALL LETTER L WITH MIDDLE DOT,iso-lat2.ent
longs,017F,LATIN SMALL LETTER LONG S,uva-supp.ent
lowast,2217,ASTERISK OPERATOR,iso-tech.ent
lowbar,005F,LOW LINE,iso-num.ent
loz,25CA,LOZENGE,iso-pub.ent
lozf,2726, ,iso-pub.ent
lpar,0028,LEFT PARENTHESIS,iso-num.ent
lsaquo,2039,SINGLE LEFT-POINTING ANGLE QUOTATION MARK,uva-supp.ent
lsqb,005B,LEFT SQUARE BRACKET,iso-num.ent
lsquo,2018, ,iso-num.ent
lsquor,201A,SINGLE LOW-9 QUOTATION MARK,iso-pub.ent
lstrok,0142,LATIN SMALL LETTER L WITH STROKE,iso-lat2.ent
ltri,25C3,WHITE LEFT-POINTING TRIANGLE,iso-pub.ent
ltrif,25C2,BLACK LEFT-POINTING TRIANGLE,iso-pub.ent
macr,00AF,MACRON,uva-supp.ent
male,2642,MALE SIGN,iso-pub.ent
malt,2720,MALTESE CROSS,iso-pub.ent
marker,25AE,BLACK VERTICAL RECTANGLE,iso-pub.ent
mdash,2014,EM DASH,iso-pub.ent
mgr,03BC,GREEK SMALL LETTER MU,iso-grk1.ent
micro,00B5,MICRO SIGN,iso-num.ent
middot,00B7,MIDDLE DOT,iso-num.ent
midhalfring,02D3,MODIFIER LETTER CENTERED RIGHT HALF RING,uva-supp.ent
minus,2212,MINUS SIGN,iso-tech.ent
mldr,2026,HORIZONTAL ELLIPSIS,iso-pub.ent
mnplus,2213, ,iso-tech.ent
moonq1,263D,FIRST QUARTER MOON,uva-supp.ent
moonq4,263E,LAST QUARTER MOON,uva-supp.ent
nabla,2207,NABLA,iso-tech.ent
nacute,0144,LATIN SMALL LETTER N WITH ACUTE,iso-lat2.ent
napos,0149,LATIN SMALL LETTER N PRECEDED BY APOSTROPHE,iso-lat2.ent
natur,266E,MUSIC NATURAL SIGN,iso-pub.ent
nbsp,00A0,NO-BREAK SPACE,iso-num.ent
ncaron,0148,LATIN SMALL LETTER N WITH CARON,iso-lat2.ent
ncedil,0146,LATIN SMALL LETTER N WITH CEDILLA,iso-lat2.ent
ndash,2013,EN DASH,iso-pub.ent
ndot,1E45,LATIN SMALL LETTER N WITH DOT ABOVE,uva-supp.ent
ne,2260, ,iso-tech.ent
ngr,03BD,GREEK SMALL LETTER NU,iso-grk1.ent
ngrave,01F9,LATIN SMALL LETTER N WITH GRAVE,uva-supp.ent
ni,220D, ,iso-tech.ent
nldr,2025,TWO DOT LEADER,iso-pub.ent
not,00AC,NOT SIGN,iso-num.ent
notin,2209, ,iso-tech.ent
ntilde,00F1,LATIN SMALL LETTER N WITH TILDE,iso-lat1.ent
num,0023,NUMBER SIGN,iso-num.ent
numsp,2007,FIGURE SPACE,iso-pub.ent
oacgr,03CC,GREEK SMALL LETTER OMICRON WITH TONOS,iso-grk2.ent
oacute,00F3,LATIN SMALL LETTER O WITH ACUTE,iso-lat1.ent
obreve,014F,LATIN SMALL LETTER O WITH BREVE,uva-supp.ent
ocaron,01D2,LATIN SMALL LETTER O WITH CARON,uva-supp.ent
ocirc,00F4,LATIN SMALL LETTER O WITH CIRCUMFLEX,iso-lat1.ent
odagrgr,1F43,GREEK SMALL LETTER OMICRON WITH DASIA AND VARIA,uva-supp.ent
odaoxgr,1F45,GREEK SMALL LETTER OMICRON WITH DASIA AND OXIA,uva-supp.ent
odblac,0151,LATIN SMALL LETTER O WITH DOUBLE ACUTE,iso-lat2.ent
odota,022F,LATIN SMALL LETTER O WITH DOT ABOVE,uva-supp.ent
odotb,1ECD,LATIN SMALL LETTER O WITH DOT BELOW,uva-supp.ent
oelig,0153,LATIN SMALL LIGATURE OE,iso-lat2.ent
ogr,03BF,GREEK SMALL LETTER OMICRON,iso-grk1.ent
ograve,00F2,LATIN SMALL LETTER O WITH GRAVE,iso-lat1.ent
ogrgr,1F78,GREEK SMALL LETTER OMICRON WITH VARIA,uva-supp.ent
ohacgr,03CE,GREEK SMALL LETTER OMEGA WITH TONOS,iso-grk2.ent
ohdaoxgr,1F65,GREEK SMALL LETTER OMEGA WITH DASIA AND OXIA,uva-supp.ent
ohgr,03C9,GREEK SMALL LETTER OMEGA,iso-grk1.ent
ohm,2126,OHM SIGN,iso-num.ent
ohpegr,1FF6,GREEK SMALL LETTER OMEGA WITH PERISPOMENI,uva-supp.ent
ohpeypgr,1FF7,GREEK SMALL LETTER OMEGA WITH PERISPOMENI AND YPOGEGRAMMENI,uva-supp.ent
ohpsoxgr,1F64,GREEK SMALL LETTER OMEGA WITH PSILI AND OXIA,uva-supp.ent
ohypgr,1FF3,GREEK SMALL LETTER OMEGA WITH YPOGEGRAMMENI,uva-supp.ent
omacr,014D,LATIN SMALL LETTER O WITH MACRON,iso-lat2.ent
opsoxgr,1F44,GREEK SMALL LETTER OMICRON WITH PSILI AND OXIA,uva-supp.ent
or,2228, ,iso-tech.ent
order,2134,SCRIPT SMALL O,iso-tech.ent
ordf,00AA,FEMININE ORDINAL INDICATOR,iso-num.ent
ordm,00BA,MASCULINE ORDINAL INDICATOR,iso-num.ent
oslash,00F8,LATIN SMALL LETTER O WITH STROKE,iso-lat1.ent
otilde,00F5,LATIN SMALL LETTER O WITH TILDE,iso-lat1.ent
ouml,00F6,LATIN SMALL LETTER O WITH DIAERESIS,iso-lat1.ent
pacute,1E55,LATIN SMALL LETTER P WITH ACUTE,uva-supp.ent
par,2225,PARALLEL TO,iso-tech.ent
para,00B6,PILCROW SIGN,iso-num.ent
part,2202, ,iso-tech.ent
percnt,0025,PERCENT SIGN,iso-num.ent
period,002E,FULL STOP,iso-num.ent
permil,2030,PER MILLE SIGN,iso-tech.ent
perp,22A5, ,iso-tech.ent
pgr,03C0,GREEK SMALL LETTER PI,iso-grk1.ent
phgr,03C6,GREEK SMALL LETTER PHI,iso-grk1.ent
phmmat,2133,SCRIPT CAPITAL M,iso-tech.ent
phone,260E,TELEPHONE SIGN,iso-pub.ent
plus,002B,PLUS SIGN,iso-num.ent
plusmn,00B1,PLUS-MINUS SIGN,iso-num.ent
pound,00A3,POUND SIGN,iso-num.ent
prime,2032,PRIME,iso-tech.ent
prop,221D, ,iso-tech.ent
psgr,03C8,GREEK SMALL LETTER PSI,iso-grk1.ent
psili,1FBF,GREEK PSILI,uva-supp.ent
puncsp,2008,PUNCTUATION SPACE,iso-pub.ent
quest,003F,QUESTION MARK,iso-num.ent
quot,0022,QUOTATION MARK,iso-num.ent
rArr,21D2,RIGHTWARDS ARROW,iso-tech.ent
racute,0155,LATIN SMALL LETTER R WITH ACUTE,iso-lat2.ent
radic,221A, ,iso-tech.ent
rang,3009, ,iso-tech.ent
raquo,00BB,RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK,iso-num.ent
rarr,2192,RIGHTWARDS ARROW,iso-num.ent
rcaron,0159,LATIN SMALL LETTER R WITH CARON,iso-lat2.ent
rcedil,0157,LATIN SMALL LETTER R WITH CEDILLA,iso-lat2.ent
rcub,007D,RIGHT CURLY BRACKET,iso-num.ent
rdlbtilde,FE23,COMBINING DOUBLE TILDE RIGHT HALF,uva-supp.ent
rdquo,201D,RIGHT DOUBLE QUOTATION MARK,iso-num.ent
rdquor,201C, ,iso-pub.ent
rect,25AD,WHITE RECTANGLE,iso-pub.ent
reg,00AE,REG TRADE MARK SIGN,iso-num.ent
rgr,03C1,GREEK SMALL LETTER RHO,iso-grk1.ent
rlig,FE21,COMBINING LIGATURE RIGHT HALF,uva-supp.ent
rpar,0029,RIGHT PARENTHESIS,iso-num.ent
rsaquo,203A,SINGLE RIGHT-POINTING ANGLE QUOTATION MARK,uva-supp.ent
rsqb,005D,RIGHT SQUARE BRACKET,iso-num.ent
rsquo,2019,RIGHT SINGLE QUOTATION MARK,iso-num.ent
rsquor,2018, ,iso-pub.ent
rtri,25B9,WHITE RIGHT-POINTING TRIANGLE,iso-pub.ent
rtrif,25B8,BLACK RIGHT-POINTING TRIANGLE,iso-pub.ent
rx,211E,PRESCRIPTION TAKE,iso-pub.ent
sacute,015B,LATIN SMALL LETTER S WITH ACUTE,iso-lat2.ent
scaron,0161,LATIN SMALL LETTER S WITH CARON,iso-lat2.ent
scedil,015F,LATIN SMALL LETTER S WITH CEDILLA,iso-lat2.ent
schwa,0259,LATIN SMALL LETTER SCHWA,uva-supp.ent
scirc,015D,LATIN SMALL LETTER S WITH CIRCUMFLEX,iso-lat2.ent
scriptP,2118,SCRIPT CAPITAL P,uva-supp.ent
sect,00A7,SECTION SIGN,iso-num.ent
semi,003B,SEMICOLON,iso-num.ent
sext,2736,SIX POINTED BLACK STAR,iso-pub.ent
sfgr,03C2, ,iso-grk1.ent
sgr,03C3,GREEK SMALL LETTER SIGMA,iso-grk1.ent
sharp,266F,MUSIC SHARP SIGN,iso-pub.ent
shy,00AD,SOFT HYPHEN,iso-num.ent
sim,223C, ,iso-tech.ent
sime,2243, ,iso-tech.ent
sol,002F,SOLIDUS,iso-num.ent
spades,2660,BLACK SPADE SUIT,iso-pub.ent
squ,25A1,WHITE SQUARE,iso-pub.ent
square,25A1,WHITE SQUARE,iso-tech.ent
squf,25AA, ,iso-pub.ent
star,22C6,STAR OPERATOR,iso-pub.ent
starf,2605,BLACK STAR,iso-pub.ent
sub,2282, ,iso-tech.ent
sube,2286, ,iso-tech.ent
sun,2609,SUN,uva-supp.ent
sung,2669, ,iso-num.ent
sup,2283, ,iso-tech.ent
sup1,00B9,SUPERSCRIPT ONE,iso-num.ent
sup2,00B2,SUPERSCRIPT TWO,iso-num.ent
sup3,00B3,SUPERSCRIPT THREE,iso-num.ent
supe,2287, ,iso-tech.ent
szlig,00DF,LATIN SMALL LETTER SHARP S,iso-lat1.ent
target,2316,POSITION INDICATOR,iso-pub.ent
tcaron,0165,LATIN SMALL LETTER T WITH CARON,iso-lat2.ent
tcedil,0163,LATIN SMALL LETTER T WITH CEDILLA,iso-lat2.ent
tdot,20DB,COMBINING THREE DOTS ABOVE,iso-tech.ent
telrec,2315,TELEPHONE RECORDER,iso-pub.ent
tgr,03C4,GREEK SMALL LETTER TAU,iso-grk1.ent
there4,2234, ,iso-tech.ent
thgr,03B8, ,iso-grk1.ent
thinsp,2009,THIN SPACE,iso-pub.ent
thorn,00FE,LATIN SMALL LETTER THORN,iso-lat1.ent
times,00D7,MULTIPLICATION SIGN,iso-num.ent
tprime,2034,TRIPLE PRIME,iso-tech.ent
trade,2122,TRADE MARK SIGN,iso-num.ent
tstrok,0167,LATIN SMALL LETTER T WITH STROKE,iso-lat2.ent
uacgr,03CD,GREEK SMALL LETTER UPSILON WITH TONOS,iso-grk2.ent
uacute,00FA,LATIN SMALL LETTER U WITH ACUTE,iso-lat1.ent
uarr,2191,UPWARDS ARROW,iso-num.ent
ubreve,016D,LATIN SMALL LETTER U WITH BREVE,iso-lat2.ent
ucaron,01D4,LATIN SMALL LETTER U WITH CARON,uva-supp.ent
ucirc,00FB,LATIN SMALL LETTER U WITH CIRCUMFLEX,iso-lat1.ent
udagr,1F51,GREEK SMALL LETTER UPSILON WITH DASIA,uva-supp.ent
udblac,0171,LATIN SMALL LETTER U WITH DOUBLE ACUTE,iso-lat2.ent
udiagr,03B0,GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS,iso-grk2.ent
udigr,03CB,GREEK SMALL LETTER UPSILON WITH DIALYTIKA,iso-grk2.ent
ugr,03C5,GREEK SMALL LETTER UPSILON,iso-grk1.ent
ugrave,00F9,LATIN SMALL LETTER U WITH GRAVE,iso-lat1.ent
ugrgr,1F7A,GREEK SMALL LETTER UPSILON WITH VARIA,uva-supp.ent
uhblk,2580,UPPER HALF BLOCK,iso-pub.ent
ulcrop,230F,TOP LEFT CROP,iso-pub.ent
umacr,016B,LATIN SMALL LETTER U WITH MACRON,iso-lat2.ent
uogon,0173,LATIN SMALL LETTER U WITH OGONEK,iso-lat2.ent
upegr,1FE6,GREEK SMALL LETTER UPSILON WITH PERISPOMENI,uva-supp.ent
upsgr,1F50,GREEK SMALL LETTER UPSILON WITH PSILI,uva-supp.ent
upsoxgr,1F54,GREEK SMALL LETTER UPSILON WITH PSILI AND OXIA,uva-supp.ent
upspegr,1F56,GREEK SMALL LETTER UPSILON WITH PSILI AND PERISPOMENI,uva-supp.ent
urcrop,230E,TOP RIGHT CROP,iso-pub.ent
uring,016F,LATIN SMALL LETTER U WITH RING ABOVE,iso-lat2.ent
utilde,0169,LATIN SMALL LETTER U WITH TILDE,iso-lat2.ent
utri,25B5,WHITE UP-POINTING TRIANGLE,iso-pub.ent
utrif,25B4,BLACK UP-POINTING TRIANGLE,iso-pub.ent
uuml,00FC,LATIN SMALL LETTER U WITH DIAERESIS,iso-lat1.ent
vellip,22EE, ,iso-pub.ent
verbar,007C,VERTICAL LINE,iso-num.ent
vtilde,1E7D,LATIN SMALL LETTER V WITH TILDE,uva-supp.ent
wbull,25E6,WHITE BULLET,uva-supp.ent
wcirc,0175,LATIN SMALL LETTER W WITH CIRCUMFLEX,iso-lat2.ent
wedgeq,2259,ESTIMATES,iso-tech.ent
xgr,03BE,GREEK SMALL LETTER XI,iso-grk1.ent
yacute,00FD,LATIN SMALL LETTER Y WITH ACUTE,iso-lat1.ent
ycirc,0177,LATIN SMALL LETTER Y WITH CIRCUMFLEX,iso-lat2.ent
yen,00A5,YEN SIGN,iso-num.ent
ymacr,0233,LATIN SMALL LETTER Y WITH MACRON,uva-supp.ent
yogh,021D,LATIN SMALL LETTER YOGH,uva-supp.ent
ytilde,1EF9,LATIN SMALL LETTER Y WITH TILDE,uva-supp.ent
yuml,00FF,LATIN SMALL LETTER Y WITH DIAERESIS,iso-lat1.ent
zacute,017A,LATIN SMALL LETTER Z WITH ACUTE,iso-lat2.ent
zcaron,017E,LATIN SMALL LETTER Z WITH CARON,iso-lat2.ent
zdot,017C,LATIN SMALL LETTER Z WITH DOT ABOVE,iso-lat2.ent
zgr,03B6,GREEK SMALL LETTER ZETA,iso-grk1.ent
Acy,0410,CYRILLIC CAPITAL LETTER A,iso-cyr1.ent
Barwed,2306,PERSPECTIVE,iso-amsb.ent
Bcy,0411,CYRILLIC CAPITAL LETTER BE,iso-cyr1.ent
CHcy,0427,CYRILLIC CAPITAL LETTER CHE,iso-cyr1.ent
Cap,22D2,DOUBLE INTERSECTION,iso-amsb.ent
Cup,22D3,DOUBLE UNION,iso-amsb.ent
DJcy,0402,CYRILLIC CAPITAL LETTER DJE,iso-cyr2.ent
DScy,0405,CYRILLIC CAPITAL LETTER DZE,iso-cyr2.ent
DZcy,040F,CYRILLIC CAPITAL LETTER DZHE,iso-cyr2.ent
Dcy,0414,CYRILLIC CAPITAL LETTER DE,iso-cyr1.ent
Delta,0394,GREEK CAPITAL LETTER DELTA,iso-grk3.ent
Ecy,042D,CYRILLIC CAPITAL LETTER E,iso-cyr1.ent
Fcy,0424,CYRILLIC CAPITAL LETTER EF,iso-cyr1.ent
GJcy,0403,CYRILLIC CAPITAL LETTER GJE,iso-cyr2.ent
Gamma,0393,GREEK CAPITAL LETTER GAMMA,iso-grk3.ent
Gcy,0413,CYRILLIC CAPITAL LETTER GHE,iso-cyr1.ent
Gg,22D9,VERY MUCH GREATER-THAN,iso-amsr.ent
Gt,226B,MUCH GREATER-THAN,iso-amsr.ent
HARDcy,042A,CYRILLIC CAPITAL LETTER HARD SIGN,iso-cyr1.ent
IEcy,0415,CYRILLIC CAPITAL LETTER IE,iso-cyr1.ent
IOcy,0401,CYRILLIC CAPITAL LETTER IO,iso-cyr1.ent
Icy,0418,CYRILLIC CAPITAL LETTER I,iso-cyr1.ent
Iukcy,0406,CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I,iso-cyr2.ent
Jcy,0419,CYRILLIC CAPITAL LETTER SHORT I,iso-cyr1.ent
Jsercy,0408,CYRILLIC CAPITAL LETTER JE,iso-cyr2.ent
Jukcy,0404,CYRILLIC CAPITAL LETTER UKRAINIAN IE,iso-cyr2.ent
KHcy,0425,CYRILLIC CAPITAL LETTER HA,iso-cyr1.ent
KJcy,040C,CYRILLIC CAPITAL LETTER KJE,iso-cyr2.ent
Kcy,041A,CYRILLIC CAPITAL LETTER KA,iso-cyr1.ent
LJcy,0409,CYRILLIC CAPITAL LETTER LJE,iso-cyr2.ent
Lambda,039B,GREEK CAPITAL LETTER LAMDA,iso-grk3.ent
Larr,219E,LEFTWARDS TWO HEADED ARROW,iso-amsa.ent
Lcy,041B,CYRILLIC CAPITAL LETTER EL,iso-cyr1.ent
Ll,22D8, ,iso-amsr.ent
Lt,226A,MUCH LESS-THAN,iso-amsr.ent
Mcy,041C,CYRILLIC CAPITAL LETTER EM,iso-cyr1.ent
NJcy,040A,CYRILLIC CAPITAL LETTER NJE,iso-cyr2.ent
Ncy,041D,CYRILLIC CAPITAL LETTER EN,iso-cyr1.ent
Ocy,041E,CYRILLIC CAPITAL LETTER O,iso-cyr1.ent
Omega,03A9,GREEK CAPITAL LETTER OMEGA,iso-grk3.ent
Pcy,041F,CYRILLIC CAPITAL LETTER PE,iso-cyr1.ent
Phi,03A6,GREEK CAPITAL LETTER PHI,iso-grk3.ent
Pi,03A0,GREEK CAPITAL LETTER PI,iso-grk3.ent
Psi,03A8,GREEK CAPITAL LETTER PSI,iso-grk3.ent
Rarr,21A0,RIGHTWARDS TWO HEADED ARROW,iso-amsa.ent
Rcy,0420,CYRILLIC CAPITAL LETTER ER,iso-cyr1.ent
SHCHcy,0429,CYRILLIC CAPITAL LETTER SHCHA,iso-cyr1.ent
SHcy,0428,CYRILLIC CAPITAL LETTER SHA,iso-cyr1.ent
SOFTcy,042C,CYRILLIC CAPITAL LETTER SOFT SIGN,iso-cyr1.ent
Scy,0421,CYRILLIC CAPITAL LETTER ES,iso-cyr1.ent
Sigma,03A3,GREEK CAPITAL LETTER SIGMA,iso-grk3.ent
Sub,22D0, ,iso-amsr.ent
Sup,22D1, ,iso-amsr.ent
TSHcy,040B,CYRILLIC CAPITAL LETTER TSHE,iso-cyr2.ent
TScy,0426,CYRILLIC CAPITAL LETTER TSE,iso-cyr1.ent
Tcy,0422,CYRILLIC CAPITAL LETTER TE,iso-cyr1.ent
Theta,0398,GREEK CAPITAL LETTER THETA,iso-grk3.ent
Ubrcy,040E,CYRILLIC CAPITAL LETTER SHORT U,iso-cyr2.ent
Ucy,0423,CYRILLIC CAPITAL LETTER U,iso-cyr1.ent
Upsi,03D2, ,iso-grk3.ent
Vcy,0412,CYRILLIC CAPITAL LETTER VE,iso-cyr1.ent
Vdash,22A9, ,iso-amsr.ent
Vvdash,22AA, ,iso-amsr.ent
Xi,039E,GREEK CAPITAL LETTER XI,iso-grk3.ent
YAcy,042F,CYRILLIC CAPITAL LETTER YA,iso-cyr1.ent
YIcy,0407,CYRILLIC CAPITAL LETTER YI,iso-cyr2.ent
YUcy,042E,CYRILLIC CAPITAL LETTER YU,iso-cyr1.ent
Ycy,042B,CYRILLIC CAPITAL LETTER YERU,iso-cyr1.ent
ZHcy,0416,CYRILLIC CAPITAL LETTER ZHE,iso-cyr1.ent
Zcy,0417,CYRILLIC CAPITAL LETTER ZE,iso-cyr1.ent
acute,00B4,ACUTE ACCENT,iso-dia.ent
acy,0430,CYRILLIC SMALL LETTER A,iso-cyr1.ent
alpha,03B1, ,iso-grk3.ent
amalg,2210,N-ARY COPRODUCT,iso-amsb.ent
ang,2220,ANGLE,iso-amso.ent
angmsd,2221,MEASURED ANGLE,iso-amso.ent
ape,224A, ,iso-amsr.ent
asymp,224D,EQUIVALENT TO,iso-amsr.ent
b.Delta,0394,GREEK CAPITAL LETTER DELTA,iso-grk4.ent
b.Gamma,0393,GREEK CAPITAL LETTER GAMMA,iso-grk4.ent
b.Lambda,039B,GREEK CAPITAL LETTER LAMDA,iso-grk4.ent
b.Omega,03A9,GREEK CAPITAL LETTER OMEGA,iso-grk4.ent
b.Phi,03A6,GREEK CAPITAL LETTER PHI,iso-grk4.ent
b.Pi,03A0,GREEK CAPITAL LETTER PI,iso-grk4.ent
b.Psi,03A8,GREEK CAPITAL LETTER PSI,iso-grk4.ent
b.Sigma,03A3,GREEK CAPITAL LETTER SIGMA,iso-grk4.ent
b.Theta,0398,GREEK CAPITAL LETTER THETA,iso-grk4.ent
b.Upsi,03D2, ,iso-grk4.ent
b.Xi,039E,GREEK CAPITAL LETTER XI,iso-grk4.ent
b.alpha,03B1, ,iso-grk4.ent
b.beta,03B2,GREEK SMALL LETTER BETA,iso-grk4.ent
b.chi,03C7,GREEK SMALL LETTER CHI,iso-grk4.ent
b.delta,03B4,GREEK SMALL LETTER DELTA,iso-grk4.ent
b.epsi,03B5, ,iso-grk4.ent
b.epsis,03B5, ,iso-grk4.ent
b.epsiv,03B5, ,iso-grk4.ent
b.eta,03B7,GREEK SMALL LETTER ETA,iso-grk4.ent
b.gamma,03B3,GREEK SMALL LETTER GAMMA,iso-grk4.ent
b.gammad,03DC,GREEK LETTER DIGAMMA,iso-grk4.ent
b.iota,03B9,GREEK SMALL LETTER IOTA,iso-grk4.ent
b.kappa,03BA,GREEK SMALL LETTER KAPPA,iso-grk4.ent
b.kappav,03F0,GREEK KAPPA SYMBOL,iso-grk4.ent
b.lambda,03BB,GREEK SMALL LETTER LAMDA,iso-grk4.ent
b.mu,03BC,GREEK SMALL LETTER MU,iso-grk4.ent
b.nu,03BD,GREEK SMALL LETTER NU,iso-grk4.ent
b.omega,03C9,GREEK SMALL LETTER OMEGA,iso-grk4.ent
b.phis,03C6,GREEK SMALL LETTER PHI,iso-grk4.ent
b.phiv,03D5,GREEK PHI SYMBOL,iso-grk4.ent
b.pi,03C0,GREEK SMALL LETTER PI,iso-grk4.ent
b.piv,03D6,GREEK PI SYMBOL,iso-grk4.ent
b.psi,03C8,GREEK SMALL LETTER PSI,iso-grk4.ent
b.rho,03C1,GREEK SMALL LETTER RHO,iso-grk4.ent
b.rhov,03F1,GREEK RHO SYMBOL,iso-grk4.ent
b.sigma,03C3,GREEK SMALL LETTER SIGMA,iso-grk4.ent
b.sigmav,03C2, ,iso-grk4.ent
b.tau,03C4,GREEK SMALL LETTER TAU,iso-grk4.ent
b.thetas,03B8, ,iso-grk4.ent
b.thetav,03D1, ,iso-grk4.ent
b.upsi,03C5,GREEK SMALL LETTER UPSILON,iso-grk4.ent
b.xi,03BE,GREEK SMALL LETTER XI,iso-grk4.ent
b.zeta,03B6,GREEK SMALL LETTER ZETA,iso-grk4.ent
barwed,22BC,NAND,iso-amsb.ent
bcong,224C,ALL EQUAL TO,iso-amsr.ent
bcy,0431,CYRILLIC SMALL LETTER BE,iso-cyr1.ent
bepsi,220D,SMALL CONTAINS AS MEMBER,iso-amsr.ent
beta,03B2,GREEK SMALL LETTER BETA,iso-grk3.ent
beth,2136,BET SYMBOL,iso-amso.ent
bowtie,22C8, ,iso-amsr.ent
boxDL,2555,BOX DRAWINGS DOWN SINGLE AND LEFT DOUBLE,iso-box.ent
boxDR,2552,BOX DRAWINGS DOWN SINGLE AND RIGHT DOUBLE,iso-box.ent
boxDl,2557,BOX DRAWINGS DOUBLE DOWN AND LEFT,iso-box.ent
boxDr,2553,BOX DRAWINGS DOWN DOUBLE AND RIGHT SINGLE,iso-box.ent
boxH,2550,BOX DRAWINGS DOUBLE HORIZONTAL,iso-box.ent
boxHD,2565,BOX DRAWINGS DOWN DOUBLE AND HORIZONTAL SINGLE,iso-box.ent
boxHU,2568,BOX DRAWINGS UP DOUBLE AND HORIZONTAL SINGLE,iso-box.ent
boxHd,2566,BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL,iso-box.ent
boxHu,2569,BOX DRAWINGS DOUBLE UP AND HORIZONTAL,iso-box.ent
boxUL,255B,BOX DRAWINGS UP SINGLE AND LEFT DOUBLE,iso-box.ent
boxUR,2558,BOX DRAWINGS UP SINGLE AND RIGHT DOUBLE,iso-box.ent
boxUl,255C,BOX DRAWINGS UP DOUBLE AND LEFT SINGLE,iso-box.ent
boxUr,255A,BOX DRAWINGS DOUBLE UP AND RIGHT,iso-box.ent
boxV,2551,BOX DRAWINGS DOUBLE VERTICAL,iso-box.ent
boxVH,256B,BOX DRAWINGS VERTICAL DOUBLE AND HORIZONTAL SINGLE,iso-box.ent
boxVL,2562,BOX DRAWINGS VERTICAL DOUBLE AND LEFT SINGLE,iso-box.ent
boxVR,255F,BOX DRAWINGS VERTICAL DOUBLE AND RIGHT SINGLE,iso-box.ent
boxVh,256C,BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL,iso-box.ent
boxVl,2563,BOX DRAWINGS DOUBLE VERTICAL AND LEFT,iso-box.ent
boxVr,2560,BOX DRAWINGS DOUBLE VERTICAL AND RIGHT,iso-box.ent
boxdL,2556,BOX DRAWINGS DOWN DOUBLE AND LEFT SINGLE,iso-box.ent
boxdR,2554,BOX DRAWINGS DOUBLE DOWN AND RIGHT,iso-box.ent
boxdl,2510,BOX DRAWINGS LIGHT DOWN AND LEFT,iso-box.ent
boxdr,250C,BOX DRAWINGS LIGHT DOWN AND RIGHT,iso-box.ent
boxh,2500,BOX DRAWINGS LIGHT HORIZONTAL,iso-box.ent
boxhD,2564,BOX DRAWINGS DOWN SINGLE AND HORIZONTAL DOUBLE,iso-box.ent
boxhU,2567,BOX DRAWINGS UP SINGLE AND HORIZONTAL DOUBLE,iso-box.ent
boxhd,252C,BOX DRAWINGS LIGHT DOWN AND HORIZONTAL,iso-box.ent
boxhu,2534,BOX DRAWINGS LIGHT UP AND HORIZONTAL,iso-box.ent
boxuL,255D,BOX DRAWINGS DOUBLE UP AND LEFT,iso-box.ent
boxuR,2559,BOX DRAWINGS UP DOUBLE AND RIGHT SINGLE,iso-box.ent
boxul,2518,BOX DRAWINGS LIGHT UP AND LEFT,iso-box.ent
boxur,2514,BOX DRAWINGS LIGHT UP AND RIGHT,iso-box.ent
boxv,2502,BOX DRAWINGS LIGHT VERTICAL,iso-box.ent
boxvH,256A,BOX DRAWINGS VERTICAL SINGLE AND HORIZONTAL DOUBLE,iso-box.ent
boxvL,2561,BOX DRAWINGS VERTICAL SINGLE AND LEFT DOUBLE,iso-box.ent
boxvR,255E,BOX DRAWINGS VERTICAL SINGLE AND RIGHT DOUBLE,iso-box.ent
boxvh,253C,BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL,iso-box.ent
boxvl,2524,BOX DRAWINGS LIGHT VERTICAL AND LEFT,iso-box.ent
boxvr,251C,BOX DRAWINGS LIGHT VERTICAL AND RIGHT,iso-box.ent
bprime,2035,REVERSED PRIME,iso-amso.ent
breve,02D8,BREVE,iso-dia.ent
bsim,223D, ,iso-amsr.ent
bsime,22CD, ,iso-amsr.ent
bump,224E, ,iso-amsr.ent
bumpe,224F, ,iso-amsr.ent
caron,02C7,CARON,iso-dia.ent
cedil,00B8,CEDILLA,iso-dia.ent
chcy,0447,CYRILLIC SMALL LETTER CHE,iso-cyr1.ent
chi,03C7,GREEK SMALL LETTER CHI,iso-grk3.ent
circ,005E,RING OPERATOR,iso-dia.ent
cire,2257, ,iso-amsr.ent
colone,2254, ,iso-amsr.ent
comp,2201,COMPLEMENT,iso-amso.ent
coprod,2210,N-ARY COPRODUCT,iso-amsb.ent
cuepr,22DE, ,iso-amsr.ent
cuesc,22DF, ,iso-amsr.ent
cularr,21B6,ANTICLOCKWISE TOP SEMICIRCLE ARROW,iso-amsa.ent
cupre,227C, ,iso-amsr.ent
curarr,21B7,CLOCKWISE TOP SEMICIRCLE ARROW,iso-amsa.ent
cuvee,22CE,CURLY LOGICAL OR,iso-amsb.ent
cuwed,22CF,CURLY LOGICAL AND,iso-amsb.ent
dArr,21D3,DOWNWARDS DOUBLE ARROW,iso-amsa.ent
daleth,2138,DALET SYMBOL,iso-amso.ent
darr2,21CA,DOWNWARDS PAIRED ARROWS,iso-amsa.ent
dashv,22A3, ,iso-amsr.ent
dblac,02DD,DOUBLE ACUTE ACCENT,iso-dia.ent
dcy,0434,CYRILLIC SMALL LETTER DE,iso-cyr1.ent
delta,03B4,GREEK SMALL LETTER DELTA,iso-grk3.ent
dharl,21C3,DOWNWARDS HARPOON WITH BARB LEFTWARDS,iso-amsa.ent
dharr,21C2,DOWNWARDS HARPOON WITH BARB RIGHTWARDS,iso-amsa.ent
diam,22C4,DIAMOND OPERATOR,iso-amsb.ent
die,00A8, ,iso-dia.ent
divonx,22C7,DIVISION TIMES,iso-amsb.ent
djcy,0452,CYRILLIC SMALL LETTER DJE,iso-cyr2.ent
dlarr,2199,SOUTH WEST ARROW,iso-amsa.ent
dlcorn,231E,BOTTOM LEFT CORNER,iso-amsc.ent
dot,02D9,DOT ABOVE,iso-dia.ent
drarr,2198,SOUTH EAST ARROW,iso-amsa.ent
drcorn,231F,BOTTOM RIGHT CORNER,iso-amsc.ent
dscy,0455,CYRILLIC SMALL LETTER DZE,iso-cyr2.ent
dzcy,045F,CYRILLIC SMALL LETTER DZHE,iso-cyr2.ent
eDot,2251, ,iso-amsr.ent
ecir,2256, ,iso-amsr.ent
ecolon,2255, ,iso-amsr.ent
ecy,044D,CYRILLIC SMALL LETTER E,iso-cyr1.ent
efDot,2252, ,iso-amsr.ent
egs,22DD, ,iso-amsr.ent
ell,2113,SCRIPT SMALL L,iso-amso.ent
els,22DC, ,iso-amsr.ent
empty,2205, ,iso-amso.ent
epsi,220A, ,iso-grk3.ent
epsis,220A, ,iso-grk3.ent
epsiv,03B5, ,iso-grk3.ent
erDot,2253, ,iso-amsr.ent
esdot,2250, ,iso-amsr.ent
eta,03B7,GREEK SMALL LETTER ETA,iso-grk3.ent
fcy,0444,CYRILLIC SMALL LETTER EF,iso-cyr1.ent
fork,22D4, ,iso-amsr.ent
frown,2322, ,iso-amsr.ent
gE,2267, ,iso-amsr.ent
gEl,22DB, ,iso-amsr.ent
gamma,03B3,GREEK SMALL LETTER GAMMA,iso-grk3.ent
gammad,03DC,GREEK LETTER DIGAMMA,iso-grk3.ent
gap,2273,GREATER-THAN OR EQUIVALENT TO,iso-amsr.ent
gcy,0433,CYRILLIC SMALL LETTER GHE,iso-cyr1.ent
gel,22DB, ,iso-amsr.ent
ges,2265,GREATER-THAN OR EQUAL TO,iso-amsr.ent
gimel,2137,GIMEL SYMBOL,iso-amso.ent
gjcy,0453,CYRILLIC SMALL LETTER GJE,iso-cyr2.ent
gl,2277, ,iso-amsr.ent
gnE,2269, ,iso-amsn.ent
gnap,E411, ,iso-amsn.ent
gne,2269, ,iso-amsn.ent
gnsim,22E7,GREATER-THAN BUT NOT EQUIVALENT TO,iso-amsn.ent
grave,0060,GRAVE ACCENT,iso-dia.ent
gsdot,22D7, ,iso-amsr.ent
gsim,2273,GREATER-THAN OR EQUIVALENT TO,iso-amsr.ent
gvnE,2269,GREATER-THAN BUT NOT EQUAL TO,iso-amsn.ent
hArr,21D4, ,iso-amsa.ent
hardcy,044A,CYRILLIC SMALL LETTER HARD SIGN,iso-cyr1.ent
harr,2194,LEFT RIGHT ARROW,iso-amsa.ent
harrw,21AD,LEFT RIGHT WAVE ARROW,iso-amsa.ent
icy,0438,CYRILLIC SMALL LETTER I,iso-cyr1.ent
iecy,0435,CYRILLIC SMALL LETTER IE,iso-cyr1.ent
image,2111,BLACK-LETTER CAPITAL I,iso-amso.ent
inodot,0131,LATIN SMALL LETTER DOTLESS I,iso-amso.ent
intcal,22BA,INTERCALATE,iso-amsb.ent
iocy,0451,CYRILLIC SMALL LETTER IO,iso-cyr1.ent
iota,03B9,GREEK SMALL LETTER IOTA,iso-grk3.ent
iukcy,0456,CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I,iso-cyr2.ent
jcy,0439,CYRILLIC SMALL LETTER SHORT I,iso-cyr1.ent
jsercy,0458,CYRILLIC SMALL LETTER JE,iso-cyr2.ent
jukcy,0454,CYRILLIC SMALL LETTER UKRAINIAN IE,iso-cyr2.ent
kappa,03BA,GREEK SMALL LETTER KAPPA,iso-grk3.ent
kappav,03F0,GREEK KAPPA SYMBOL,iso-grk3.ent
kcy,043A,CYRILLIC SMALL LETTER KA,iso-cyr1.ent
khcy,0445,CYRILLIC SMALL LETTER HA,iso-cyr1.ent
kjcy,045C,CYRILLIC SMALL LETTER KJE,iso-cyr2.ent
lAarr,21DA,LEFTWARDS TRIPLE ARROW,iso-amsa.ent
lE,2266, ,iso-amsr.ent
lEg,22DA, ,iso-amsr.ent
lambda,03BB,GREEK SMALL LETTER LAMDA,iso-grk3.ent
lap,2272,LESS-THAN OR EQUIVALENT TO,iso-amsr.ent
larr2,21C7,LEFTWARDS PAIRED ARROWS,iso-amsa.ent
larrhk,21A9,LEFTWARDS ARROW WITH HOOK,iso-amsa.ent
larrlp,21AB,LEFTWARDS ARROW WITH LOOP,iso-amsa.ent
larrtl,21A2,LEFTWARDS ARROW WITH TAIL,iso-amsa.ent
lceil,2308,LEFT CEILING,iso-amsc.ent
lcy,043B,CYRILLIC SMALL LETTER EL,iso-cyr1.ent
ldot,22D6, ,iso-amsr.ent
leg,22DA, ,iso-amsr.ent
les,2264,LESS-THAN OR EQUAL TO,iso-amsr.ent
lfloor,230A,LEFT FLOOR,iso-amsc.ent
lg,2276,LESS-THAN OR GREATER-THAN,iso-amsr.ent
lhard,21BD,LEFTWARDS HARPOON WITH BARB DOWNWARDS,iso-amsa.ent
lharu,21BC,LEFTWARDS HARPOON WITH BARB UPWARDS,iso-amsa.ent
ljcy,0459,CYRILLIC SMALL LETTER LJE,iso-cyr2.ent
lnE,2268, ,iso-amsn.ent
lnap,E2A2, ,iso-amsn.ent
lne,2268, ,iso-amsn.ent
lnsim,22E6, ,iso-amsn.ent
lrarr2,21C6,LEFTWARDS ARROW OVER RIGHTWARDS ARROW,iso-amsa.ent
lrhar2,21CB,LEFTWARDS HARPOON OVER RIGHTWARDS HARPOON,iso-amsa.ent
lsh,21B0,UPWARDS ARROW WITH TIP LEFTWARDS,iso-amsa.ent
lsim,2272,LESS-THAN OR EQUIVALENT TO,iso-amsr.ent
lthree,22CB,LEFT SEMIDIRECT PRODUCT,iso-amsb.ent
ltimes,22C9,LEFT NORMAL FACTOR SEMIDIRECT PRODUCT,iso-amsb.ent
ltrie,22B4, ,iso-amsr.ent
lvnE,2268,LESS-THAN BUT NOT EQUAL TO,iso-amsn.ent
macr,00AF,MACRON,iso-dia.ent
map,21A6,RIGHTWARDS ARROW FROM BAR,iso-amsa.ent
mcy,043C,CYRILLIC SMALL LETTER EM,iso-cyr1.ent
mid,2223, ,iso-amsr.ent
minusb,229F,SQUARED MINUS,iso-amsb.ent
models,22A7,MODELS,iso-amsr.ent
mu,03BC,GREEK SMALL LETTER MU,iso-grk3.ent
mumap,22B8,MULTIMAP,iso-amsa.ent
nVDash,22AF,NEGATED DOUBLE VERTICAL BAR DOUBLE RIGHT TURNSTILE,iso-amsn.ent
nVdash,22AE,DOES NOT FORCE,iso-amsn.ent
nap,2249,NOT ALMOST EQUAL TO,iso-amsn.ent
ncong,2247,NEITHER APPROXIMATELY NOR ACTUALLY EQUAL TO,iso-amsn.ent
ncy,043D,CYRILLIC SMALL LETTER EN,iso-cyr1.ent
nearr,2197,NORTH EAST ARROW,iso-amsa.ent
nequiv,2262,NOT IDENTICAL TO,iso-amsn.ent
nexist,2204,THERE DOES NOT EXIST,iso-amso.ent
ngE,2271, ,iso-amsn.ent
nge,2271,NEITHER GREATER-THAN NOR EQUAL TO,iso-amsn.ent
nges,2271, ,iso-amsn.ent
ngt,226F,NOT GREATER-THAN,iso-amsn.ent
nhArr,21CE,LEFT RIGHT DOUBLE ARROW WITH STROKE,iso-amsa.ent
nharr,21AE,LEFT RIGHT ARROW WITH STROKE,iso-amsa.ent
njcy,045A,CYRILLIC SMALL LETTER NJE,iso-cyr2.ent
nlArr,21CD,LEFTWARDS DOUBLE ARROW WITH STROKE,iso-amsa.ent
nlE,2270, ,iso-amsn.ent
nlarr,219A,LEFTWARDS ARROW WITH STROKE,iso-amsa.ent
nle,2270,NEITHER LESS-THAN NOR EQUAL TO,iso-amsn.ent
nles,2270, ,iso-amsn.ent
nlt,226E,NOT LESS-THAN,iso-amsn.ent
nltri,22EA,NOT NORMAL SUBGROUP OF,iso-amsn.ent
nltrie,22EC,NOT NORMAL SUBGROUP OF OR EQUAL TO,iso-amsn.ent
nmid,2224,DOES NOT DIVIDE,iso-amsn.ent
npar,2226,NOT PARALLEL TO,iso-amsn.ent
npr,2280,DOES NOT PRECEDE,iso-amsn.ent
npre,22E0,DOES NOT PRECEDE OR EQUAL,iso-amsn.ent
nrArr,21CF,RIGHTWARDS DOUBLE ARROW WITH STROKE,iso-amsa.ent
nrarr,219B,RIGHTWARDS ARROW WITH STROKE,iso-amsa.ent
nrtri,22EB,DOES NOT CONTAIN AS NORMAL SUBGROUP,iso-amsn.ent
nrtrie,22ED,DOES NOT CONTAIN AS NORMAL SUBGROUP OR EQUAL,iso-amsn.ent
nsc,2281,DOES NOT SUCCEED,iso-amsn.ent
nsce,22E1,DOES NOT SUCCEED OR EQUAL,iso-amsn.ent
nsim,2241, ,iso-amsn.ent
nsime,2244, ,iso-amsn.ent
nsmid,E2AA, ,iso-amsn.ent
nspar,2226,NOT PARALLEL TO,iso-amsn.ent
nsub,2284,NOT A SUBSET OF,iso-amsn.ent
nsubE,2288, ,iso-amsn.ent
nsube,2288, ,iso-amsn.ent
nsup,2285,NOT A SUPERSET OF,iso-amsn.ent
nsupE,2289, ,iso-amsn.ent
nsupe,2289, ,iso-amsn.ent
nu,03BD,GREEK SMALL LETTER NU,iso-grk3.ent
numero,2116,NUMERO SIGN,iso-cyr1.ent
nvDash,22AD,NOT TRUE,iso-amsn.ent
nvdash,22AC,DOES NOT PROVE,iso-amsn.ent
nwarr,2196,NORTH WEST ARROW,iso-amsa.ent
oS,24C8,CIRCLED LATIN CAPITAL LETTER S,iso-amso.ent
oast,229B,CIRCLED ASTERISK OPERATOR,iso-amsb.ent
ocir,229A,CIRCLED RING OPERATOR,iso-amsb.ent
ocy,043E,CYRILLIC SMALL LETTER O,iso-cyr1.ent
odash,229D,CIRCLED DASH,iso-amsb.ent
odot,2299,CIRCLED DOT OPERATOR,iso-amsb.ent
ogon,02DB,OGONEK,iso-dia.ent
olarr,21BA,ANTICLOCKWISE OPEN CIRCLE ARROW,iso-amsa.ent
omega,03C9,GREEK SMALL LETTER OMEGA,iso-grk3.ent
ominus,2296,CIRCLED MINUS,iso-amsb.ent
oplus,2295,CIRCLED PLUS,iso-amsb.ent
orarr,21BB,CLOCKWISE OPEN CIRCLE ARROW,iso-amsa.ent
osol,2298,CIRCLED DIVISION SLASH,iso-amsb.ent
otimes,2297,CIRCLED TIMES,iso-amsb.ent
pcy,043F,CYRILLIC SMALL LETTER PE,iso-cyr1.ent
phis,03C6,GREEK SMALL LETTER PHI,iso-grk3.ent
phiv,03D5,GREEK PHI SYMBOL,iso-grk3.ent
pi,03C0,GREEK SMALL LETTER PI,iso-grk3.ent
piv,03D6,GREEK PI SYMBOL,iso-grk3.ent
planck,210F,PLANCK CONSTANT OVER TWO PI,iso-amso.ent
plusb,229E,SQUARED PLUS,iso-amsb.ent
plusdo,2214,DOT PLUS,iso-amsb.ent
pr,227A, ,iso-amsr.ent
prap,227E, ,iso-amsr.ent
pre,227C, ,iso-amsr.ent
prnE,E2B3, ,iso-amsn.ent
prnap,22E8, ,iso-amsn.ent
prnsim,22E8, ,iso-amsn.ent
prod,220F,N-ARY PRODUCT,iso-amsb.ent
prsim,227E, ,iso-amsr.ent
psi,03C8,GREEK SMALL LETTER PSI,iso-grk3.ent
rAarr,21DB,RIGHTWARDS TRIPLE ARROW,iso-amsa.ent
rarr2,21C9,RIGHTWARDS PAIRED ARROWS,iso-amsa.ent
rarrhk,21AA,RIGHTWARDS ARROW WITH HOOK,iso-amsa.ent
rarrlp,21AC,RIGHTWARDS ARROW WITH LOOP,iso-amsa.ent
rarrtl,21A3,RIGHTWARDS ARROW WITH TAIL,iso-amsa.ent
rarrw,219D,RIGHTWARDS SQUIGGLE ARROW,iso-amsa.ent
rceil,2309,RIGHT CEILING,iso-amsc.ent
rcy,0440,CYRILLIC SMALL LETTER ER,iso-cyr1.ent
real,211C,BLACK-LETTER CAPITAL R,iso-amso.ent
rfloor,230B,RIGHT FLOOR,iso-amsc.ent
rhard,21C1,RIGHTWARDS HARPOON WITH BARB DOWNWARDS,iso-amsa.ent
rharu,21C0,RIGHTWARDS HARPOON WITH BARB UPWARDS,iso-amsa.ent
rho,03C1,GREEK SMALL LETTER RHO,iso-grk3.ent
rhov,03F1,GREEK RHO SYMBOL,iso-grk3.ent
ring,02DA,RING ABOVE,iso-dia.ent
rlarr2,21C4,RIGHTWARDS ARROW OVER LEFTWARDS ARROW,iso-amsa.ent
rlhar2,21CC,RIGHTWARDS HARPOON OVER LEFTWARDS HARPOON,iso-amsa.ent
rpargt,E291, ,iso-amsc.ent
rsh,21B1,UPWARDS ARROW WITH TIP RIGHTWARDS,iso-amsa.ent
rthree,22CC,RIGHT SEMIDIRECT PRODUCT,iso-amsb.ent
rtimes,22CA,RIGHT NORMAL FACTOR SEMIDIRECT PRODUCT,iso-amsb.ent
rtrie,22B5, ,iso-amsr.ent
samalg,2210, ,iso-amsr.ent
sbsol,FE68,SMALL REVERSE SOLIDUS,iso-amso.ent
sc,227B, ,iso-amsr.ent
scap,227F, ,iso-amsr.ent
sccue,227D, ,iso-amsr.ent
sce,227D, ,iso-amsr.ent
scnE,E2B5, ,iso-amsn.ent
scnap,22E9, ,iso-amsn.ent
scnsim,22E9, ,iso-amsn.ent
scsim,227F, ,iso-amsr.ent
scy,0441,CYRILLIC SMALL LETTER ES,iso-cyr1.ent
sdot,22C5,DOT OPERATOR,iso-amsb.ent
sdotb,22A1,SQUARED DOT OPERATOR,iso-amsb.ent
setmn,2216,SET MINUS,iso-amsb.ent
sfrown,2322,FROWN,iso-amsr.ent
shchcy,0449,CYRILLIC SMALL LETTER SHCHA,iso-cyr1.ent
shcy,0448,CYRILLIC SMALL LETTER SHA,iso-cyr1.ent
sigma,03C3,GREEK SMALL LETTER SIGMA,iso-grk3.ent
sigmav,03C2, ,iso-grk3.ent
smid,E301, ,iso-amsr.ent
smile,2323, ,iso-amsr.ent
softcy,044C,CYRILLIC SMALL LETTER SOFT SIGN,iso-cyr1.ent
spar,2225,PARALLEL TO,iso-amsr.ent
sqcap,2293,SQUARE CAP,iso-amsb.ent
sqcup,2294,SQUARE CUP,iso-amsb.ent
sqsub,228F, ,iso-amsr.ent
sqsube,2291, ,iso-amsr.ent
sqsup,2290, ,iso-amsr.ent
sqsupe,2292, ,iso-amsr.ent
ssetmn,2216,SET MINUS,iso-amsb.ent
ssmile,2323,SMILE,iso-amsr.ent
sstarf,22C6,STAR OPERATOR,iso-amsb.ent
subE,2286, ,iso-amsr.ent
subnE,228A,SUBSET OF WITH NOT EQUAL TO,iso-amsn.ent
subne,228A, ,iso-amsn.ent
sum,2211,N-ARY SUMMATION,iso-amsb.ent
supE,2287, ,iso-amsr.ent
supnE,228B, ,iso-amsn.ent
supne,228B, ,iso-amsn.ent
tau,03C4,GREEK SMALL LETTER TAU,iso-grk3.ent
tcy,0442,CYRILLIC SMALL LETTER TE,iso-cyr1.ent
thetas,03B8, ,iso-grk3.ent
thetav,03D1, ,iso-grk3.ent
thkap,2248,ALMOST EQUAL TO,iso-amsr.ent
thksim,223C,TILDE OPERATOR,iso-amsr.ent
tilde,02DC,TILDE,iso-dia.ent
timesb,22A0,SQUARED TIMES,iso-amsb.ent
top,22A4,DOWN TACK,iso-amsb.ent
trie,225C, ,iso-amsr.ent
tscy,0446,CYRILLIC SMALL LETTER TSE,iso-cyr1.ent
tshcy,045B,CYRILLIC SMALL LETTER TSHE,iso-cyr2.ent
twixt,226C,BETWEEN,iso-amsr.ent
uArr,21D1,UPWARDS DOUBLE ARROW,iso-amsa.ent
uarr2,21C8,UPWARDS PAIRED ARROWS,iso-amsa.ent
ubrcy,045E,CYRILLIC SMALL LETTER SHORT U,iso-cyr2.ent
ucy,0443,CYRILLIC SMALL LETTER U,iso-cyr1.ent
uharl,21BF,UPWARDS HARPOON WITH BARB LEFTWARDS,iso-amsa.ent
uharr,21BE,UPWARDS HARPOON WITH BARB RIGHTWARDS,iso-amsa.ent
ulcorn,231C,TOP LEFT CORNER,iso-amsc.ent
uml,00A8, ,iso-dia.ent
uplus,228E,MULTISET UNION,iso-amsb.ent
upsi,03C5,GREEK SMALL LETTER UPSILON,iso-grk3.ent
urcorn,231D,TOP RIGHT CORNER,iso-amsc.ent
vArr,21D5,UP DOWN DOUBLE ARROW,iso-amsa.ent
vDash,22A8, ,iso-amsr.ent
varr,2195,UP DOWN ARROW,iso-amsa.ent
vcy,0432,CYRILLIC SMALL LETTER VE,iso-cyr1.ent
vdash,22A2, ,iso-amsr.ent
veebar,22BB, ,iso-amsr.ent
vltri,22B2, ,iso-amsr.ent
vprime,2032,PRIME,iso-amso.ent
vprop,221D, ,iso-amsr.ent
vrtri,22B3, ,iso-amsr.ent
vsubnE,E2B8, ,iso-amsn.ent
vsubne,228A,SUBSET OF WITH NOT EQUAL TO,iso-amsn.ent
vsupnE,228B,SUPERSET OF WITH NOT EQUAL TO,iso-amsn.ent
vsupne,228B,SUPERSET OF WITH NOT EQUAL TO,iso-amsn.ent
weierp,2118,SCRIPT CAPITAL P,iso-amso.ent
wreath,2240,WREATH PRODUCT,iso-amsb.ent
xcirc,25CB,WHITE CIRCLE,iso-amsb.ent
xdtri,25BD,WHITE DOWN-POINTING TRIANGLE,iso-amsb.ent
xhArr,2194,LEFT RIGHT ARROW,iso-amsa.ent
xharr,2194,LEFT RIGHT ARROW,iso-amsa.ent
xi,03BE,GREEK SMALL LETTER XI,iso-grk3.ent
xlArr,21D0,LEFTWARDS DOUBLE ARROW,iso-amsa.ent
xrArr,21D2,RIGHTWARDS DOUBLE ARROW,iso-amsa.ent
xutri,25B3,WHITE UP-POINTING TRIANGLE,iso-amsb.ent
yacy,044F,CYRILLIC SMALL LETTER YA,iso-cyr1.ent
ycy,044B,CYRILLIC SMALL LETTER YERU,iso-cyr1.ent
yicy,0457,CYRILLIC SMALL LETTER YI,iso-cyr2.ent
yucy,044E,CYRILLIC SMALL LETTER YU,iso-cyr1.ent
zcy,0437,CYRILLIC SMALL LETTER ZE,iso-cyr1.ent
zeta,03B6,GREEK SMALL LETTER ZETA,iso-grk3.ent
zhcy,0436,CYRILLIC SMALL LETTER ZHE,iso-cyr1.ent

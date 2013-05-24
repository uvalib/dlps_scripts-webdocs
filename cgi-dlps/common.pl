package common;

# common.pl - common functions and global variables for DLPS web-based tools

# Greg Murray <gpm2a@virginia.edu>
# Written: 2002-07-03
# Last modified: 2006-03-01

use strict;

#======================================================================
# global variables
#======================================================================

our $bookscanningPath = '/shares/image1/01bookscanning';
our $postkbPath = '/shares/text/04postkb';
our $proofreaderImagesPath = '/www/doc/dlps/uva-only/proofreader/images';
our $workreportsPath = '/www/doc/dlps/dlps-only/workreports';
our $xmlPath = '/www/doc/dlps/xml';

our $proofreaderImagesUrl = '/dlps/uva-only/proofreader/images';
our $proofreaderHtmlUrl = '/dlps/uva-only/proofreader/html';
our $workreportsUrl = '/dlps/dlps-only/workreports';


#======================================================================
# functions
#======================================================================

BEGIN {}

#----------------------------------------------------------------------

sub check_id {
    my $id = shift;
    if (not -d "$proofreaderImagesPath/$id") {
        print_error("No directory exists for ID <b>$id</b>.");
    }
}

#----------------------------------------------------------------------

sub print_error {
    my $error = shift;
    if (not $error) { $error = "Unknown error."; }
    print <<EOD;
Content-type: text/html

<html>
<head>
<title>Error</title>
</head>
<body onLoad="document.frm.back.focus();">
<p><span style="color: #990000; font-weight: bold;">ERROR:</span> $error</p>
<form name="frm">
<input type="button" name="back" value="Back" onClick="history.back();">
</form>
</body>
</html>
EOD
    exit;
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

return 1;

END {}

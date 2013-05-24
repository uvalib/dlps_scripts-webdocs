#!/usr/bin/perl -w

# SaxonCGI.pl - Perl CGI script to run an XSLT transformation using
# Saxon and send the result to the browser

# Greg Murray <murray@virginia.edu>
# Written: 2006-01-02
# Last modified: 2006-01-02

use strict;
use CGI 'param';
require '/www/cgi-dlps/common.pl';

my $prm;

# convert CGI parameters to a hash for easier access
my @params = param();
my %params = ();
my $c = 0;
foreach $prm (@params) {
    $params{$prm} = param($prm);
    $c++;
}

# test parameters
if (not $params{'source'}) {
    common::print_error("Missing parameter: The URL for the source XML file is required.");
}
if (not $params{'style'}) {
    common::print_error("Missing parameter: The URL for the XSLT stylesheet is required.");
}

# get stylesheet parameters
my $params = '';
foreach $prm (keys(%params)) {
    unless ($prm eq 'source' or $prm eq 'style') {
	$params .= "$prm=$params{$prm} ";
    }
}

my $command =  "/usr/bin/java -cp '/www/cgi-dlps/saxon/saxon_6.5.4/saxon.jar:/www/cgi-dlps/saxon/saxon_6.5.4/saxon-xml-apis.jar' com.icl.saxon.StyleSheet -l $params{'source'} $params{'style'} $params";
#$command .= ' 2>&1';  # DEBUG

my $result = `$command`;

if ($result) {
    print "Content-type: text/html\n\n";
    print $result;
} else {
    common::print_error("No output");
}

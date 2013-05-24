#!/usr/local/bin/perl

# comments out <div[2-7] type="preliminaries"> element containing
# only <pb> and comment elements

$0 = `basename $0`; chop $0;

while (<>) {
   if (/<div([2-7]).*type="preliminar/) {
      # preliminar catches both type="preliminaries" and "preliminary"
      $buffer = "";
      until ((/<\/div$1>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      $div = $buffer;
      $div =~ s/\n//g;
      $div =~ s/([^-])-([^-])/$1&mdash;$2/g;
      $div =~ s/<!--[^-]*-->//g;
      $div =~ s/\s+//g;
      $div =~ s/>\s</></g;
      $div =~ s/<pb[^>]*>//g;

      $level = $div;  $level =~ s/<div([2-7]).*/$1/;

      if ($div =~ /^<div[^>]*><\/div[^>]*>$/) {
         $buffer =~ s/(<div$level.*type="preliminar[^>]*>)/<!-- CONVPROC $0 $1 -->/;
         $buffer =~ s/(<\/div$level>)/<!-- CONVPROC $0 $1 -->/;
         print "$buffer";
      }
   } else {
      print;
   }
}


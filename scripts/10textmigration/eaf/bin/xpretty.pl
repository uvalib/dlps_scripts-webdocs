#!/usr/local/bin/perl

# "pretty print" 
# adds lines breaks for legibility

while (<>) {

   if (/<TEI.2/) {
      $buffer = "";
      until ((/<\/TEI.2/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;
      $buffer =~ s/(<body[^>]*>\n)\n/$1/;
      $buffer =~ s/(<\/p>)\n(<p[ |>])/$1\n\n$2/g;
      $buffer =~ s/(<\/div1>)\n(<div)/$1\n\n$2/g;
      $buffer =~ s/\n<text /\n\n<text /;
      $buffer =~ s/<\/front>/<\/front>\n/;
      $buffer =~ s/\n<titlePage/\n\n<titlePage/g;
      $buffer =~ s/\n<q><text>/\n\n<q><text>/g;
      $buffer =~ s/<\/text><\/q>/<\/text><\/q>\n/g;
      $buffer =~ s/<\/q>\n\n<\/div/<\/q>\n<\/div/g;
      $buffer =~ s/\n\n\n/\n\n/g;

      $buffer =~ s/\s+(<lb\/>\n)/$1/g;
      $buffer =~ s/\s+(<\/p>\n)/$1/g;

      print "$buffer";

   } else {
      print;
   }

}

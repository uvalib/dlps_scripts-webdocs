#!/usr/local/bin/perl

#

while (<>) {

   if (/<orig.*<\/orig><lb\/>/) {
      $buffer = "";
      s/<orig reg="">/<orig>/;
      until ((/<orig>.*<\/orig>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;
      $buffer =~ s/\n/\[EOL\]/g;

      $buffer =~ s/<orig reg="([^"]*)">(.*)<\/orig><lb\/>(.*)<orig>(.*)<\/orig>([^ ]*) /<reg orig="$2|$4">$1<\/reg>$5<lb\/>$3/;

      $buffer =~ s/\[EOL\]/\n/g;
      print "$buffer";

   } else {
      print;
   }
}

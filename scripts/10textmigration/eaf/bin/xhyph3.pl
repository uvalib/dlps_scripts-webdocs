#!/usr/local/bin/perl

#

while (<>) {

   if (/<orig reg="[^-]*-/) {
      $buffer = "";

      until ((/<\/orig>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;
      $buffer =~ s/\n/\[EOL\]/g;

      $buffer =~ s/<orig reg="([^"]*)"([^>]*)>([^<]*)<lb\/>([^<]*)<\/orig>([^ ]*) /<reg orig="$3|$4"$2>$1<\/reg><lb\/>\n/;
      $buffer =~ s/\|\[EOL\]/\|/g;
      $buffer =~ s/\[EOL\]/\n/g;
      print "$buffer";

   } else {
      print;
   }
}

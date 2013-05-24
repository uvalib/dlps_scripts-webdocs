#!/usr/local/bin/perl

while (<>) {
   if (/<orig [^>]*>[^<]*-<lb\/>/) {
      $buffer = "";

      until ((/<\/orig/) || (eof)) {
         $buffer = $buffer.$_;
         $_ = <>;
      }

      $buffer = $buffer.$_;

      $buffer =~ s/\n/\[EOL\]/g;
      $buffer =~ s/<orig reg="([^"]*)">([^<]*)-<lb\/>([^<]*)<\/orig>([^ ]*) /<reg orig="$2-|$3">$1<\/reg>$4<lb\/>\n/;
      $buffer =~ s/<orig reg="([^"]*)">([^<]*)-<lb\/>\[EOL\](<pb[^>]*>)([^<]*)<\/orig>([^ ]*) /<reg orig="$2-|$4">$1<\/reg>$5<lb\/>\n$3\n/;
      $buffer =~ s/<orig reg="([^"]*)">([^<]*)-<lb\/>([^<]*)<\/orig>([^ ]*)<\/p>(.*)\[EOL\]/<reg orig="$2-|$3">$1<\/reg>$4<\/p>$5\[EOL\]/;

      #$buffer =~ s/<ref<lb\/>/<lb\/>\n<ref /;
      #$buffer =~ s/<reg<lb\/>/<lb\/>\n<reg /;
      #$buffer =~ s/<hi<lb\/>/<lb\/>\n<hi /;
      $buffer =~ s/<([^>]+)<lb\/>/<lb\/>\n<$1 /;

      $buffer =~ s/-\|\[EOL\]/-\|/;
      $buffer =~ s/\[EOL\]/\n/g;

      print "$buffer";
   } else  {

      print;

   }
}


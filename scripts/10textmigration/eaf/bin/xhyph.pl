#!/usr/local/bin/perl

# converts <orig> for end-of-line hyphenation to <reg>
# misses <orig>.*</orig><pb/><orig>.*</orig>
# these have to be hand-edited

while (<>) {

   if (/<orig/) {
      $buffer = "";
      until ((/<\/orig>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;
      $buffer =~ s/\n/\[EOL\]/g;

      $buffer =~ s/<orig reg="([^"]*)"([^>]*)>([^-]*)-(<[^>]*>)(.*)<\/orig>([^ ]*) /<reg orig="$3-|$5"$2>$1<\/reg>$6$4\n/g;
      $buffer =~ s/<orig reg="([^"]*)"([^>]*)>([^-]*)-(<[^>]*>)(.*)<\/orig>([^<]*)</<reg orig="$3-|$5"$2>$1<\/reg>$6$4\n</g;

      $buffer =~ s/(<\/reg>[^<]*)<lb\/>\n(<\/p>)/$1$2/g;

      $buffer =~ s/-\|\[EOL\]/-\|/g;
      $buffer =~ s/\[EOL\]/\n/g;

      print "$buffer";

   } else {
      print;
   }
}

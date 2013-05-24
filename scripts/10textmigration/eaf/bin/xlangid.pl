#!/usr/local/bin/perl

# replaces <language>English</language> with
# <language id="en">English</language>

while (<>) {
   if (/<language/) {
      $buffer = "";
      until ((/<\/language>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      # operation on buffer goes here
      $buffer =~ s/\n/\[EOL\]/g;
      $buffer =~ s/<language>\[EOL\]/<language>/;

      $buffer =~ s/<language>English/<language id="en">English/;

      $buffer =~ s/\[EOL\]/\n/g;
      print "$buffer";

   } else {
      print;
   }
}

#!/usr/local/bin/perl

# removes comments

while (<>) {
   if (/<!--/) {
      $buffer = "";
      until ((/-->/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      $buffer =~ s/\s*\n/\[EOL\]/g;

      $buffer =~ s/([^-])-([^-])/$1&mdash;$2/g;
      $buffer =~ s/<!--[^-]*-->//g;
      $buffer =~ s/\[EOL\]/\n/g;

      unless ($buffer =~ /^$/) {
         print "$buffer";
      }

   } else {
      print;
   }
}



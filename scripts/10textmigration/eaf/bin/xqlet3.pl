#!/usr/local/bin/perl

# processes quoted letters within <div3>

$0 = `basename $0`;

while (<>) {
   if (/<div3/) {
      $buffer = "";
      until ((/<\/div3>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }
      $buffer .= $_;
      $buffer =~ s/\n/\007/g;

      if ($buffer =~ /<div4[^>]*type="letter"/)  {
         if ($buffer =~ /<div4[^>]*type="section"/) {
            $buffer =~ s/<\/div4>\007*<div4[^>]*type="section"[^>]*>/<\/div1><\/body><\/text><\/q>\007/g;
            $buffer =~ s/<div4(.*type="letter"[^>]*)>/\007<q><text><body><div1$1>/g;
            $buffer =~ s/<\/div4>//g;
         }
      }

      $buffer =~ s/\007/\n/g;
      print "$buffer";

   } else {
      print;
   }
}

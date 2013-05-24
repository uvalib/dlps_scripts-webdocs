#!/usr/local/bin/perl

# processes quoted letters within <div1>

$0 = `basename $0`;

while (<>) {
   if (/<div1/) {
      $buffer = "";
      until ((/<\/div1>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }
      $buffer .= $_;
      $buffer =~ s/\n/\007/g;

      if ($buffer =~ /<div2[^>]*type="letter"/)  {
         if ($buffer =~ /<div2[^>]*type="section"/) {
            $buffer =~ s/<\/div2>\007*<div2[^>]*type="section"[^>]*>/<\/div1><\/body><\/text><\/q>\007/g;
            $buffer =~ s/<div2(.*type="letter"[^>]*)>/\007<q><text><body><div1$1>/g;
            $buffer =~ s/<\/div2>//g;
         }
      }

      $buffer =~ s/\007/\n/g;
      print "$buffer";

   } else {
      print;
   }
}

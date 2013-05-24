#!/usr/local/bin/perl

# processes quoted letters within <div2>

$0 = `basename $0`;

while (<>) {
   if (/<div2/) {
      $buffer = "";
      until ((/<\/div2>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }
      $buffer .= $_;
      $buffer =~ s/\n/\007/g;

      if ($buffer =~ /<div3[^>]*type="letter"/)  {
         if ($buffer =~ /<div3[^>]*type="section"/) {
            $buffer =~ s/<\/div3>\007*<div3[^>]*type="section"[^>]*>/<\/div1><\/body><\/text><\/q>\007/g;
            $buffer =~ s/<div3(.*type="letter"[^>]*)>/\007<q><text><body><div1$1>/g;
            $buffer =~ s/<\/div3>//g;
         }
      }

      $buffer =~ s/\007/\n/g;
      print "$buffer";

   } else {
      print;
   }
}

#!/usr/local/bin/perl

# moves 'milestone unit="collation"' to <fw> element
# within preceding <pb>
# removes <milestone> element so that it won't interfere with
# a later process which attempts to convert <pb><div> to
# <div><pb>

while (<>) {
   if (/<milestone unit="collation"/) {
      $buffer = "";
      until ((/<pb/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      $milestone = $buffer;
      $milestone =~ s/\n/ /g;
      $milestone =~ s/\s+/ /g;
      $milestone =~ s/<milestone unit="collation" n="([^"]*)"\s*\/>.*/$1/;
      
      $pb = $buffer;
      $pb =~ s/\n/\[EOL\]/g;
      $pb =~ s/(<pb[^\/]*)\/>/$1><fw type="sig">$milestone<\/fw><\/pb>/;
      $pb =~ s/ >/>/g;
      $pb =~ s/(<milestone[^>]*>)//;
      $pb =~ s/\[EOL\]/\n/g;

      print "$pb";

   } else {
      print;
   }
}

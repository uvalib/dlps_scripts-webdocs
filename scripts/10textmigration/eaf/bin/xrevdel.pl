#!/usr/local/bin/perl

# removes <revisionDesc> element with no content

while (<>) {
   if (/<revisionDesc/) {
      $buffer = "";
      until ((/<\/revisionDesc>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      $rev = $buffer;
      $rev =~ s/\n//g;
      $rev =~ s/\s+//g;

      $rev =~ s/<[^>]*>//g;
      unless ($rev =~/^$/) {
         print "$buffer";
      }
   } else {
      print;
   }
}

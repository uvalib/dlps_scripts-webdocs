#!/usr/local/bin/perl

# removes <respStmt> element with no content

while (<>) {
   if (/<respStmt/) {
      $buffer = "";
      until ((/<\/respStmt>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      $resp = $buffer;
      $resp =~ s/\n//g;
      $resp =~ s/\s+//g;

      $resp =~ s/<[^>]*>//g;
      unless ($resp =~/^$/) {
         print "$buffer";
      }
   } else {
      print;
   }
}

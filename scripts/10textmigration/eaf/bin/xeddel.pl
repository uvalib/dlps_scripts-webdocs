#!/usr/local/bin/perl

# removes <editionStmt> element with no content

while (<>) {
   if (/<editionStmt/) {
      $buffer = "";
      until ((/<\/editionStmt>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      $ed = $buffer;
      $ed =~ s/\n//g;
      $ed =~ s/\s+//g;

      $ed =~ s/<[^>]*>//g;
      unless ($ed =~/^$/) {
         print "$buffer";
      }
   } else {
      print;
   }
}

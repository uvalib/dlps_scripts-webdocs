#!/usr/local/bin/perl

# removes <title> element with no content

while (<>) {
   if (/<title[ |>]/) {
      $buffer = "";
      until ((/<\/title>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      $title = $buffer;
      $title =~ s/\n//g;
      $title =~ s/\s+//g;

      $title =~ s/<[^>]*>//g;
      unless ($title =~/^$/) {
         unless ($title =~ /\[electronicresource\]/) {
            print "$buffer";
         }
      }
   } else {
      print;
   }
}

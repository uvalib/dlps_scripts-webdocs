#!/usr/local/bin/perl

# 

while (<>) {
   if (/<pb.*n="[Tt]itle [Pp]age"[^>]*>/) {
      $_ =~ s/[Tt]itle [Pp]age/Title Page/;

      $buffer = "";
      until ((/<titlePage/) || eof()) {
         $buffer .= $_;
         $_ = <>;
      }
      $buffer .= $_;

      $buffer =~ s/\n/\007/g;
      $buffer =~ s/(<pb.*n="Title Page[^>]*>)(.*)(<titlePage[^>]*>)/$2$3\n$1/;
      $buffer =~ s/(<pb.*n="Title Page[^>]*>\007*)<pb\/>/$1/;
      $buffer =~ s/\007+/\007/;
      $buffer =~ s/\007/\n/g;
      print "$buffer";

   } else {
      print;
   }
}

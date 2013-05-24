#!/usr/local/bin/perl

# replaces <seg> elements inside <docImprint> with line breaks

while (<>) {
   if (/<docImprint/) {
      $buffer = "";
      until ((/<\/docImprint>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      $buffer =~ s/\s*\n/\[EOL\]/g;
      $buffer =~ s/<seg>//g;
      $buffer =~ s/<\/seg><\/docImprint>/<\/docImprint>/;
      $buffer =~ s/<\/seg>/<lb\/><lb\/>/g;

      $buffer =~ s/\[EOL\]/\n/g;

      print "$buffer";

   } else {
      print;
   }
}



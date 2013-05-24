#!/usr/local/bin/perl

# comments out <p> element containing only a single <figure>

$0 = `basename $0`; chop $0;

while (<>) {
   if (/<p[ |>]/) {
      $buffer = "";
      until ((/<\/p>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      $p = $buffer;
      $p =~ s/\n/ /g;
      $p =~ s/\s+/ /g;

      if ($p =~ /^<p[^>]*>\s*<!-- CONVPROC [^<]*<figure.*<\/figure> -->\s*<\/p> $/) {
         $p =~ s/<!-- CONVPROC [^<]*<figure/<figure/;
         $p =~ s/<\/figure> -->/<\/figure>/;
         $p = "<!-- CONVPROC $0 $p -->";
         $p =~ s/> </></g;
         print "$p\n";
      } else {
         print "$buffer";
      }

   } else {
      print;
   }
}

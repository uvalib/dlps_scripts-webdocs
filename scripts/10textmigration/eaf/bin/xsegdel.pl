#!/usr/local/bin/perl

# comments out <seg> element containing only a single <figure>

$0 = `basename $0`; chop $0;

while (<>) {
   if (/<seg[ |>]/) {
      $buffer = "";
      until ((/<\/seg>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      $seg = $buffer;
      $seg =~ s/\n/ /g;
      $seg =~ s/\s+/ /g;

      if ($seg =~ /^<seg[^>]*>\s*<!-- CONVPROC [^<]*<figure.*<\/figure> -->\s*<\/seg> $/) {
         $seg =~ s/<!-- CONVPROC [^<]*<figure/<figure/;
         $seg =~ s/<\/figure> -->/<\/figure>/;
         $seg = "<!-- CONVPROC $0 $seg -->";
         $seg =~ s/> </></g;
         print "$seg\n";
      } else {
         print "$buffer";
      }

   } else {
      print;
   }
}

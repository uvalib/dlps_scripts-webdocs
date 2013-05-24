#!/usr/local/bin/perl

# report rend attributes

$/ = "<";

while (<>) {
   chop;
   s/\n/ /;
   s/^/</;
   if (/rend=/) {
      s/>.*/>/;
      print "$_\n";
   }
}


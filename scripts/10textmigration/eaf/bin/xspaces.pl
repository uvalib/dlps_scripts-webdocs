#!/usr/local/bin/perl

# compresses multiple spaces into a single space
# removes blank lines

while (<>) {
   s/\s+/ /g;
   s/ $//g;
   s/^ //;

   unless (/^$/) {
      print "$_\n";
   }

}

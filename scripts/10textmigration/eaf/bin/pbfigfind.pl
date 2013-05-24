#!/usr/local/bin/perl

# reports location of <pb> and <figure> elements

while (<>) {
   $count = $count + 1;
   if (/<pb/) {
      print "\n<pb> found at $count\n";
   }
   if (/<figure/) {
      print "     <figure> found at $count ";
   }
}

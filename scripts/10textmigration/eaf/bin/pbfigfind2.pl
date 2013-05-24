#!/usr/local/bin/perl

$count = 1;

while (<>) {
   $line[$count] = $_;
   $count = $count + 1;
}

foreach $i (1 .. $#line) {
   $tag1 = $line[$i];
   $tag1 =~ s/([^ ]*) .*/$1/;
   $tag2 = $line[$i + 1];
   $tag2 =~ s/([^ ]*) .*/$1/;

   if ($tag1 eq $tag2) {
      print "PROBLEM FOUND!\n";
      print "$line[$i]";
      print "$line[$i + 1]\n";
   }
}

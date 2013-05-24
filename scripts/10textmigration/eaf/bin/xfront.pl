#!/usr/local/bin/perl

$0 = `basename $0`; chop $0;

while (<>) {
   chop;
   $lines[$i] = $_;
   if (/<div1.*"covers"/) {
      $startcovers = $i;
   }
   if ((/<div1.*"preliminaries"/) && ($startprelim lt 0)) {
      $startprelim = $i;
   }

   $i = $i + 1;
}

foreach $i ($startcovers .. $#lines) {
   # look for the end of the div
   if ($lines[$i] =~ /<\/div1>/) {
      $endcovers = $i;
      last;
   }
}

foreach $i ($startprelim .. $#lines) {
   # look for the end of the div
   if ($lines[$i] =~ /<\/div1>/) {
      $endprelim = $i;
      last;
   }
}

if ($startcovers gt 1) {
   # if there is a div with type="covers",
   # comment out the <div> and </div> lines
   $lines[$startcovers] = "<!-- CONVPROC $0 $lines[$startcovers] -->";
   $lines[$endcovers] = "<!-- CONVPROC $0 $lines[$endcovers] -->";
}

if ($startprelim gt 1) {
   # if there is a <div type="preliminaries">
   # concatenate preliminary matter
   foreach $i ($startprelim .. $endprelim) {
      $prelim = $prelim.$lines[$i];
   }

   $prelim =~ s/([^-])-([^-])/$1&mdash;$2/g;
   $prelim =~ s/<!--[^-]*-->//g;
   $prelim =~ s/\s+/ /g;
   $prelim =~ s/>\s</></g;
   $prelim =~ s/<pb[^>]*>//g;
   $prelim =~ s/^\s+//;
   $prelim =~ s/\s+$//;

   if ($prelim =~ /^<div1[^>]*><\/div1[^>]*>$/) {
      # if after the substitutions above nothing is
      # left within the <div>, comment out the enclosing
      # div tags
      $lines[$startprelim] = "<!-- CONVPROC $0 $lines[$startprelim] -->";
      $lines[$endprelim] = "<!-- CONVPROC $0 $lines[$endprelim] -->";
   }

   #while (($lines[$startprelim+1] =~ /^<pb/) || ($lines[$startprelim+1] =~ /^<!-- CONVPROC/)) {
   #   $temp = $lines[$startprelim];
   #   $lines[$startprelim] = $lines[$startprelim+1];
   #   $lines[$startprelim+1] = $temp;
   #   $startprelim = $startprelim + 1;
   #}
}

#print "$prelim\n";


foreach $i (0 .. $#lines) {
   # if any 'preliminar*' type divs remain, the following line
   # will cause the file to have a parsing error, which must be
   # hand-edited
   $lines[$i] =~ s/type="preliminar[^"]+"/type="book-plate?"/;
   print "$lines[$i]\n";
}

#print "STARTCOVERS $startcovers\n";
#print "ENDCOVERS $endcovers\n";
#print "STARTPRELIM $startprelim\n";
#print "ENDPRELIM $endprelim\n";


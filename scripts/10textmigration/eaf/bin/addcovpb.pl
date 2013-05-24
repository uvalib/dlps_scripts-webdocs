#!/usr/local/bin/perl

# adds <pb> tag following <figure entity=".*spin.*">

while (<>) {
   if (/<figure entity=".*spin[^>]*>/) {
      if (/<\/figure>/) {
         chop;
         s/<\/figure>/\n<head>Spine<\/head>\n<figDesc><\/figDesc>\n<\/figure>\n<\/p>\n<pb\/>\n<p>\n/;
         print;
      }
   } else {
      print "$_";
   }
}

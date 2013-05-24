#!/usr/local/bin/perl

# adds <pb> tag following <titlePage>

while (<>) {
   if (/<titlePage/) {
      print "$_";
      print "<pb/>\n";
   } else {
      print "$_";
   }
}

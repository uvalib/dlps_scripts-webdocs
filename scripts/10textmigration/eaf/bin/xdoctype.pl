#!/usr/local/bin/perl

# replaces DOCTYPE declaration with TEI-P4 and DLPS modifications
# replaces character entity declarations with ones in standard location

while (<>) {
   if (/<\? *[X|x][M|m][L|l]/) {
      $xmldecl = 'yes';
   }
   if (/<!DOCTYPE .*\[/) {
      unless ($xmldecl eq "yes") {
         print "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n";
      }
      print<<EOH;
<!DOCTYPE TEI.2 SYSTEM "http://text.lib.virginia.edu/dtd/tei/tei-p4/tei2.dtd" [
<!ENTITY % POSTKB "INCLUDE">
<!ENTITY % TEI.extensions.ent SYSTEM "http://text.lib.virginia.edu/dtd/tei/uva-dl-tei/uva-dl-tei.ent">
<!ENTITY % TEI.extensions.dtd SYSTEM "http://text.lib.virginia.edu/dtd/tei/uva-dl-tei/uva-dl-tei.dtd">
EOH
   } else {

      s/(<!ENTITY % ISOlat1 SYSTEM ).*/$1 "http:\/\/text.lib.virginia.edu\/charent\/iso-lat1.ent"> %ISOlat1;/;
      s/(<!ENTITY % ISOlat2 SYSTEM ).*/$1 "http:\/\/text.lib.virginia.edu\/charent\/iso-lat2.ent"> %ISOlat2;/;
      s/(<!ENTITY % ISOnum SYSTEM ).*/$1 "http:\/\/text.lib.virginia.edu\/charent\/iso-num.ent"> %ISOnum;/;
      s/(<!ENTITY % ISOpub SYSTEM ).*/$1 "http:\/\/text.lib.virginia.edu\/charent\/iso-pub.ent"> %ISOpub;/;
      s/(<!ENTITY % ISOtech SYSTEM ).*/$1 "http:\/\/text.lib.virginia.edu\/charent\/iso-tech.ent"> %ISOtech;/;

      if (/<!ENTITY longs/) {
         s/<!ENTITY longs.*/<!ENTITY % UVAsupp SYSTEM "http:\/\/text.lib.virginia.edu\/charent\/uva-supp.ent"> %UVAsupp;\n/;
         $uvasupp = "yes";
      }

      if ((/<!NOTATION jpg/) && ($uvasupp ne "yes")) {
         print "<!ENTITY % UVAsupp SYSTEM \"http:\/\/text.lib.virginia.edu\/charent\/uva-supp.ent\"> %UVAsupp;\n";
      }

      print;
   }

}

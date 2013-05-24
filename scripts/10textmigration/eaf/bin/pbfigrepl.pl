#!/usr/local/bin/perl

# supplies entity attribute for each <pb> element constructed from
# the following <figure> element.
# if the figure description is less than 80 characters, it indicates
# that the figure is probably being used for a page image and the
# figure is commented out.  Otherwise, the figure is probably a
# bookplate or illustration.

$0 = `basename $0`;

while (<>) {
   if ((/<pb/) && (!/entity=/)) {
      $buffer = "";
      until ((/<\/figure>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      # operation on buffer goes here

      # parse out entity, figure head and figure description
      $entity = $buffer;
      $entity =~ s/\n/ /g;
      $entity =~ s/.*<figure entity="([^"]*)".*/$1/;

      $fighead = $buffer;
      $fighead =~ s/\n/ /g;
      $figdesc = $fighead;
      
      if ($fighead =~ /<head/) {
         $fighead =~ s/.*<head[^>]*>(.*)<\/head>.*/$1/;
         if (length($fighead) > 20) {
             $fighead = "";
         }
         if ($fighead =~ /Spine and Front Edge/) {
            $fighead = "Front Edge";
         }
      } else {
         $fighead = "";
      }

      if ($figdesc =~ /<figDesc/) {
         $figdesc =~ s/.*<figDesc>([^<]*)<\/figDesc>.*/$1/;
         $figdesc =~ s/\d\d\dEAF\. ([^\.]*)/$1/;
         $figdesc =~ s/\.$//;
         if (length($figdesc) > 20) {
            $figdesc = "";
         }
         if ($figdesc =~ /Page \d\d\d/) {
            $figdesc = "";
         }
      } else {
         $figdesc = "";
      }

      # construct appropriate pb tag
      $pb = $buffer;
      $pb =~ s/\n/ /g;
      $pb =~ s/.*(<pb[^>]*)>.*/$1>/;
      unless ($pb =~ / n=/) {
         if ($fighead ne "") {
            $pb =~ s/<pb/<pb n="$fighead" /;
         } elsif ($figdesc ne "") {
            $pb =~ s/<pb/<pb n="$figdesc" /;
         }
      }
      $pb =~ s/<pb/<pb entity="$entity"/;

      # replace pb tag in buffer with new one
      $buffer =~ s/<pb[^>]*>/$pb/;

      # comment out figure element if figdesc is short
      $figdesc = $buffer;
      $figdesc =~ s/\n/ /g;
      $figdesc =~ s/.*<figDesc>([^<]*)<\/figDesc>.*/$1/;
      unless (length($figdesc) > 80) {
         $buffer =~ s/\n/\[EOL\]/g;
         $buffer =~ s/(<figure.*<\/figure>)/<!-- CONVPROC $0 $1 -->/m;
         $buffer =~ s/\[EOL\]/\n/g;
      }

      print "$buffer";

   } else {
      print;
   }
}

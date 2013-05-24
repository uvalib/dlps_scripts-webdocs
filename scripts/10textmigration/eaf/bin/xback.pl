#!/usr/local/bin/perl

$0 = `basename $0`;

while (<>) {

   # create an array of lines
   chop;
   $lines[$i] = $_;
   if (/<\/body>/) {
      # line number of </body>
      $bodyend = $i;
   }
   if (/<back/) {
      # line number of <back>
      $backstart = $i;
   }
   if (/<\/back>/) {
      # line number of </back>
      $backend = $i;
   }
   if ((/<div[^>]+backmatter/) && ($backdivstart < 1)) {
      $backdivstart = $i;
   }
   if (($backdivstart gt 1) && ($lines[$i] =~ /<\/div1>/)) {
      if ($backdivend lt 1) {
         $backdivend = $i;
      }
   }

   $i = $i + 1;
}

#print "BODYEND $bodyend\n";
#print "BACKSTART $backstart\n";
#print "BACKDIVSTART $backdivstart\n";
#print "BACKDIVEND $backdivend\n";
#print "BACKEND $backend\n";

#exit;

if ($backstart gt 1) {
   # if there is a <back> element
   # concatenate back into a variable
   foreach $i ($backstart+1 .. $backend-1) {
      $back = $back.$lines[$i];
   }

   #print "$back\n";
   #exit;

   # test whether back contains only comments and <pb> elements
   $back =~ s/\n/ /g;
   $back =~ s/([^-])-([^-])/$1&mdash;$2/g;
   $back =~ s/<!--[^-]*-->//g;
   $back =~ s/\s+/ /g;
   $back =~ s/>\s</></g;
   $back =~ s/<pb[^>]*>//g;
   $back =~ s/^\s+//;
   $back =~ s/\s+$//;

   #print "$back\n";
   #exit;

   # locate the end of the last </div> within <body>
   for ($i=$bodyend; $i>0; $i--) {
      if ($lines[$i] =~ /<\/div/) {
         $divend = $i;
         last;
      }
   }

   if ($back =~ /^<div[^>]*><\/div[^>]*>$/) {
      # if after the substitutions above nothing is
      # left within the <back> but a single <div>,
      # move the <pb>s and comments to the end of the
      # last <div> within the <body>

      foreach $i ($backstart .. $backend) {
         if (($lines[$i] =~ /<pb/) || ($lines[$i] =~ /<!-- CONVPROC/)) {
            push(@backpbs, $lines[$i]);
         }
      }

      # pre-append <pb> elements from <back> to end of last <div>
      # in <body>
      foreach $i (0 .. $#backpbs) {
         $lines[$divend] .= "$backpbs[$i]";
      }
      $lines[$divend] =~ s/(<\/div[^>]*>)(.*)/$2$1/;
      $lines[$divend] =~ s/(<pb[^>]*>)/$1\n/g;
      $lines[$divend] =~ s/-->/-->\n/g;

      # print all the lines except the <back>
      foreach $i (0 .. $backstart-1) {
         print "$lines[$i]\n";
      }
      foreach $i ($backend+1 .. $#lines) {
         print "$lines[$i]\n";
      }

   } else {
      # the <back> element contains more than just
      # comments and <pb>s
      # if the 1st div contains only <pb>s and comments,
      # move the <pb> elements to the last <div> in the <body>

      # make a copy of back
      $backcopy = $back;

      # lop off everything after the end of the 1st div
      $back =~ s/<\/div1>.*$/<\/div1>/;

      #print "BACKDIV1 $back BACKDIV1\n";
      #exit;

      if ($back =~ /^<div[^>]*><\/div[^>]*>$/) {
         # if nothing is left within the <back> but a single <div>,
         # the 1st <div> consists of only <pb>s and comments.
         # move these elements to the end of the
         # last <div> within the <body>

         foreach $i ($backdivstart .. $backdivend) {
            if (($lines[$i] =~ /<pb/) || ($lines[$i] =~ /<!-- CONVPROC/)) {
               push(@backpbs, $lines[$i]);
            }
         }

         # pre-append <pb> elements from <back> to end of last <div>
         # in <body>
         foreach $i (0 .. $#backpbs) {
            $lines[$divend] .= "$backpbs[$i]";
         }
         $lines[$divend] =~ s/(<\/div[^>]*>)(.*)/$2$1/;
         $lines[$divend] =~ s/(<pb[^>]*>)/$1\n/g;
         $lines[$divend] =~ s/-->/-->\n/g;

         # print all the lines except the <div> start and end tags
         foreach $i ($backdivstart .. $backdivend) {
            $lines[$i] = "";
         }

         # now test the last div within the back
         # lop off everything before the last <div>
         $backcopy =~ s/.*<div1/<div1/;

         if ($backcopy =~ /^<div[^>]*><\/div[^>]*>$/) {
            # last div consists of only pbs and comments

            # search for the start and end tags of the last div
            for ($j=$backend; $j>0; $j--) {
               if ($lines[$j] =~ /<\/div1/) {
                  $backdivend = $j;
               }
               if ($lines[$j] =~ /<div1/) {
                  $backdivstart = $j;
                  last;
               }
            }

            # we assume that the end of the previous div is at line
            # divstart - 1
            $divend = $backdivstart - 1;

            @backpbs = ();
            foreach $i ($backdivstart .. $backdivend) {
               if (($lines[$i] =~ /<pb/) || ($lines[$i] =~ /<!-- CONVPROC/)) {
                  push(@backpbs, $lines[$i]);
               }
               $lines[$i] = "";
            }

            # pre-append <pb> elements from <back> to end of last <div>
            # in <body>
            foreach $i (0 .. $#backpbs) {
               $lines[$divend] .= "$backpbs[$i]";
            }
            $lines[$divend] =~ s/(<\/div[^>]*>)(.*)/$2$1/;
            $lines[$divend] =~ s/(<pb[^>]*>)/$1\n/g;
            $lines[$divend] =~ s/-->/-->\n/g;
         }

         # print the lines of the file
         foreach $i (0 .. $#lines) {
            unless ($lines[$i] =~ /^$/) {
               print "$lines[$i]\n";
            }
         }

      } else {

         # lop off everything but the last div within backcopy
         $backcopy =~ s/.*<div1/<div1/;

         if ($backcopy =~ /^<div[^>]*><\/div[^>]*>$/) {
            # last div consists of only pbs and comments
            for ($j=$backend;$j>0;$j--) {
               if ($lines[$j] =~ /<div1/) {
                  $lines[$j] = "<!-- CONVPROC $0 $lines[$j] -->";
                  $lines[$j-1] = "<!-- CONVPROC $0 $lines[$j-1] -->";
                  last;
               }
            }

         } else {
            # comment out start tag of 1st <div>
            $lines[$backdivstart] = "<!-- CONVPROC $0 $lines[$backdivstart] -->";
         }

         # print the lines of the file
         foreach $i (0 .. $#lines) {
            print "$lines[$i]\n";
         }

      }
   }
} else {
   # there is no back element
   # print the lines of the file unchanged
   foreach $i (0 .. $#lines) {
      print "$lines[$i]\n";
   }
}


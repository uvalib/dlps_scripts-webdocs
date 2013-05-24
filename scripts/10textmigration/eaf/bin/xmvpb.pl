#!/usr/local/bin/perl

# reverses lines where consecutive lines match:
#
# <pb
# <div
#
# also where consecutive lines match:
#
# <pb
# </div
# <titlePage
#
# places <pb> after the <titlePage> element, i.e.
#
# </div
# <titlePage
# <pb
#
# also where consecutive lines match
#
# <pb
# <body
# <div
#
# places <pb after the <div> element, i.e.
#
# <body
# <div
# <pb

@lines = <>;
foreach $i (0 .. $#lines) {
   if ($lines[$i] =~ /<pb/) {
      if ($lines[$i+1] =~ /<body/) {
         if ($lines[$i+2] =~ /<div/) {
            $temp = $lines[$i];
            $lines[$i] = $lines[$i+1];
            $lines[$i+1] = $lines[$i+2];
            $lines[$i+2] = $temp;
            next;
         }
      }

      if ($lines[$i+1] =~ /<div/) {
         $temp = $lines[$i];
         $lines[$i] = $lines[$i+1];
         $lines[$i+1] = $temp;
      }

      if ($lines[$i+1] =~ /<\/div/) {
         if ($lines[$i+2] =~ /<titlePage/) {
            unless ($lines[$i+3] =~ /<pb/) {
               $temp = $lines[$i];
               $lines[$i] = $lines[$i+1];
               $lines[$i+1] = $lines[$i+2];
               $lines[$i+2] = $temp;
            }
         }
      }
   }
   
}

foreach $i (0.. $#lines) {
   print "$lines[$i]";
}

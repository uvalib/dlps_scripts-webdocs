#!/usr/local/bin/perl

# adds value attribute to <date> elements based on the element content
# only works on the first <date> element on each line
# can handle numeric dates, e.g., 1993 or 4/17/1993
# can handle text dates e.g. 15[th] Feb. 1833 or Feb. 15th, 1833

%months = ("jan","01", "feb","02", "mar","03", "apr","04",
           "may","05", "jun","06", "jul","07", "aug","08",
           "sep","09", "oct","10", "nov","11", "dec","12");

$0 = `basename $0`; chop $0;

while (<>) {
   if (/<date>/) {
      $buffer = "";
      until ((/<\/date>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;
      $buffer =~ s/\n/\007/g;

      # copy $buffer to $date and remove any markup
      $date = $buffer;
      $date =~ s/.*<date>/<date>/;
      $date =~ s/\s//g;
      $date =~ s/\007//g;
      $date =~ s/<[^>]*>//g;
      $date =~ s/(\d\d\d\d)\./$1/g;

      if ($date =~ /^\d\d\d\d[\/-]\d\d[\/-]\d\d/) {
         # an ISO date
         $date =~ s/\//-/g;
         $buffer =~ s/<date>/<date value="$date">/;
      } elsif ($date =~ /^\d\d\d\d$/) {
         # date matches 4-digit year
         $buffer =~ s/<date>/<date value="$date">/;
      } elsif ($date =~ /(\d+)[-\/](\d+)[-\/](\d\d\d\d)/) {
         # date matches 00/00/0000 or 00-00-0000
         # parse out the year, month, and day
         $year = $3; $month = $1; $day = $2;
         if (length($month) < 2) { $month = "0".$month; }
         if (length($day) < 2) { $day = "0".$day; }
         $date = "$year-$month-$day";

         if ($date =~ /\d\d\d\d-\d\d\-\d\d/) {
            # is a valid ISO date
            $buffer =~ s/<date>/<date value="$date">/;
         } #else {
            # not a valid ISO date
            # leave buffer unmodified
         #}

      } elsif ($date =~ /^(\d\d?)[a-z][^\d]*([A-Z][^\d]+)(\d\d\d\d)/) {
         # date in the form 15[th] Feb[.|uary] 1833
         # parse out the year, month, and day
         $day = $1; $month = $2; $year = $3;
         $day =~ s/[^\d]//g;
         if (length($day) < 2) { $day = "0".$day; }
         $month =~ s/\.//g;
         $month = substr($month, 0, 3);
         $month =~ tr/A-Z/a-z/;
         $month = $months{$month};
         $date = "$year-$month-$day";

         if ($date =~ /\d\d\d\d-\d\d-\d\d/) {
            # is a valid ISO date
            $buffer =~ s/<date>/<date value="$year-$month-$day">/;
         } #else {
            # not a valid ISO date
            # leave buffer unmodified
         #}

      } elsif (($date =~ /^$/) || ($date =~ /^Scanned:$/)) {
         # date element has no content
         # remove date element from buffer
         $buffer =~ s/<date>\007*<\/date>//;

      } elsif ($date =~ /^([^\d]+)(\d\d\d\d)/) {
         # date in the form 'monthnameyear', e.g. March2002
         # parse out year, month
         $month = $1; $year = $2;
         $month =~ s/\.//g;
         $month = substr($month, 0, 3);
         $month =~ tr/A-Z/a-z/;
         $month = $months{$month};
         $date = "$year-$month";
         if ($date =~ /\d\d\d\d-\d\d/) {
            # is a valid ISO date
            $buffer =~ s/<date>/<date value="$year-$month">/;
         } #else {
            # not a valid ISO date
            # leave buffer unmodified
         #}

      } elsif ($date =~ /^([^\d]+)(\d+)[^\d]+(\d\d\d\d)/){
         # date in the form 'monthnameday,year', e.g.
         # Oct.2,1832 or October2,1832

         # parse out the year, month, and day
         $month = $1; $day = $2; $year = $3;
         $month =~ s/\.//g;
         $month = substr($month, 0, 3);
         $month =~ tr/A-Z/a-z/;
         $month = $months{$month};
         $day =~ s/[^\d]//g;
         if (length($day) < 2) { $day = "0".$day; }
         $date = "$year-$month-$day";

         if ($date =~ /\d\d\d\d-\d\d-\d\d/) {
            # is a valid ISO date
            $buffer =~ s/<date>/<date value="$year-$month-$day">/;
         } #else {
            # not a valid ISO date
            # leave buffer unmodified
         #}

      #} else {
         # cannnot discern a valid ISO date
         # leave buffer unmodified
      }

      $buffer =~ s/\007"/"/g;
      $buffer =~ s/\007/\n/g;
      unless ($buffer =~ /^$/) {
         print "$buffer";
      }

   } else {
      print;
   }
}



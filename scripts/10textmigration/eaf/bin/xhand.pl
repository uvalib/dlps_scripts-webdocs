#!/usr/local/bin/perl

while (<>) {
   s/(<!ENTITY % POSTKB "INCLUDE">)/$1\n<!ENTITY % MANUSCRIPT "INCLUDE">/;
   s/(<\/langUsage>)/$1\n<handList>\n<hand id="author"\/>\n<\/handList>/;

   if (/<add[ |>]/) {
      unless (/<add[^>]*hand=/) {
         s/<add/<add hand="author"/g;
      }
   }

   if (/<del/) {
      unless (/<del[^>]*hand=/) {
         s/<del/<del hand="author"/g;
      }
   }

   s/(<del[^>]*) (rend="[^"]*")([^>]*>)/$1$3<hi $2>/g;

   print;

}

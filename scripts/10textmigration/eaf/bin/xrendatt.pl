#!/usr/local/bin/perl

# regularizes rend attributes

while (<>) {
   chop;
   if (/rend="/) {
      # make sure attribute value is lower-case
      $rend = $_;
      $rend =~ s/.*rend="([^"]*)".*/$1/;
      $rend =~ tr/A-Z/a-z/;
      $_ =~ s/rend="[^"]*"/rend="$rend"/;
   }

   # change these values
   s/rend="suppress"/rend="none"/g;
   s/rend="italics"/rend="italic"/g;
   s/rend="smallcaps"/rend="small-caps"/g;
   s/rend="strikethrough"/rend="line-through"/g;
   s/rend="overstrike"/rend="line-through"/g;
   s/rend="sup"/rend="super"/g;
   s/rend="supralinear"/rend="super"/g;

   # remove these values
   s/ rend="typeset"//g;
   s/ rend="advert"//g;
   s/ rend="es"//g;
   s/ rend="Doctor"//g;
   s/(<p[^>]*) rend="italic"([^>]*><hi rend="italic")/$1$2/;
   s/(<p[^>]*) rend="small-caps"([^>]*><hi rend="small-caps")/$1$2/;

   print "$_\n";
}

#!/usr/local/bin/perl

# regularizes type attribute on <divN>

while (<>) {
   chop;
   if (/<div.*type="/) {
      # make sure the attribute value is lower-case
      $type = $_;
      $type =~ s/.*type="([^"]*)".*/$1/;
      $type =~ tr/A-Z/a-z/;
      $_ =~ s/type="[^"]*"/type="$type"/;
   }

   # change these values
   s/(<div.*)type="advert"/$1type="advertisement"/g;
   s/(<div.*)type="short story"/$1type="story"/g;
   s/(<div.*)type="ack"/$1type="acknowledgements"/g;
   s/(<div.*)type="content"/$1type="contents"/g;
   s/(<div.*)type="dedicat"/$1type="dedication"/g;
   s/(<div.*)type="erratum"/$1type="errata"/g;
   s/(<div.*)type="footnotes"/$1type="notes"/g;
   s/(<div.*)type="halftitle"/$1type="half-title"/g;
   s/(<div.*)type="intro"/$1type="introduction"/g;
   s/(<div.*)type="preliminariess"/$1type="preliminaries"/g;
   s/(<div.*)type="preliminary"/$1type="preliminaries"/g;
   s/(<div.*)type="cast"/$1type="castlist"/g;

   print "$_\n";
}

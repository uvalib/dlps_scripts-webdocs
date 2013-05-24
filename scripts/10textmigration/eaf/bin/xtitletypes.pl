#!/usr/local/bin/perl

# regularizes type attribute on <title>

while (<>) {
   chop;

   # change these values
   s/(<title[^>]*)type="245"([^>]*>)/$1type="main"$2/g;

   print "$_\n";
}

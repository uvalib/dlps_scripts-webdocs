#!/usr/local/bin/perl

# insures that <p>, <div>, and <list> elements begin on a new line

while (<>) {
   s/(<\/p>) *(<p[ |>])/$1\n$2/g;
   s/(<\/div[^>]*>) *(<div)/$1\n$2/g;
   s/(<\/list>) *(<list)/$1\n$2/g;
   s/(<\/p>) *(<div)/$1\n$2/g;

   print;
}

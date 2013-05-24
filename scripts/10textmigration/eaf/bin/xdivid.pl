#!/usr/local/bin/perl

# add id attribute to <divN>

$count = 1;

while (<>) {
   if (/<div[1-7]/) {
      $divtag = $_;
      $divtag =~ s/(<div[^>]*>).*/$1/;
      unless ($divtag =~ /id=/) {
         $_ =~ s/(<div[1-7])/$1 id="d$count"/;
         $count = $count + 1;
      }
      print;
   } else {
      print;
   }
}

#!/usr/local/bin/perl

# convert <milestone unit="column"/> to <cb />

while (<>) {
   s/<milestone unit="column"/<cb/;
   print;
}

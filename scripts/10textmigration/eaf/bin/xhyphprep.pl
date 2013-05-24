#!/usr/local/bin/perl

while (<>) {
   s/<orig reg="">/<orig>/g;
   print;
}

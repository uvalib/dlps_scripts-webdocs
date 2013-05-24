#!/usr/local/bin/perl

# transform ptr into ref

while (<>) {
   s/<ptr([^>]*)\/>([^<]*)</<ref$1>$2<\/ref></g;
   s/<ptr([^>]*)\/>([^\n]*)\n/<ref$1>$2<\/ref>\n/g;
   print;
}

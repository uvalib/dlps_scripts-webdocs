#!/usr/local/bin/perl

while (<>) {
   s/<orig reg="([^"]*)">([^<]*)<\/orig>/<reg orig="$2">$1<\/reg>/g;
   print;
}

   

#!/usr/local/bin/perl

# removes <head>\s*</head>

while (<>) {

   s/<head[^>]*>\s*<\/head>//g;
   unless (/^$/) {
      print;
   }
}

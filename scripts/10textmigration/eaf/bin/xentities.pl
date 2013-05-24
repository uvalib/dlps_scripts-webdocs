#!/usr/local/bin/perl

# removes entities that duplicate entities available in uva-supp.ent

while (<>) {
   s/<!ENTITY hand "&#x261E;">/<!-- ENTITY REMOVED -->/;
   s/<!ENTITY hand "-->">/<!-- ENTITY REMOVED -->/;

   unless (/<!-- ENTITY REMOVED -->/) {
      print;
   }
}

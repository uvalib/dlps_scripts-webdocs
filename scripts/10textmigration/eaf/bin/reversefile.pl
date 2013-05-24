#!/usr/local/bin/perl

# reverses file line-by-line

while (<>) {
   push(@lines, $_);
}

print reverse(@lines);

#!/usr/local/bin/perl

# reports tag and type attribute

while (<>) {
   chop;
   ($tag, $content) = split/>/;
   ($tag, $attrs) = (split/ /, $tag);
   $attrs =~ s/.*(type="[^"]*").*/$1/;
   print "$tag $attrs>\n";
}

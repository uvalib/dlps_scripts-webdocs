#!/usr/local/bin/perl

# adds rend attribute to <hi> if not present.
# places rend attribute value in a child <hi> element unless
# it is a globally-allowed value.  for example, <p rend="italic">
# becomes <p><hi rend="italic">...</hi></p>.
# will produce unexpected results with elements that are recursive.

while (<>) {
   # 'hide' rend attributes on <hi> elements and globally allowed
   # rend attribute values
   s/<hi rend=/<hi\*rend=/g;
   s/ (rend="block")/\*$1/g;
   s/ (rend="inline")/\*$1/g;
   s/ (rend="none")/\*$1/g;
   s/ (rend="indent\d*")/\*$1/g;
   s/ (rend="hang")/\*$1/g;
   s/ (rend="no-indent")/\*$1/g;
   s/ (rend="center")/\*$1/g;
   s/ (rend="left")/\*$1/g;
   s/ (rend="right")/\*$1/g;

   # add rend attribute to <hi> if not present
   s/<hi>/<hi\*rend="other" other="unspecified">/g;

   if (/ rend=/) {
      # found a 'non-global' rend attribute
      $buffer = "";

      $tag = $_;  chop $tag;
      $tag =~ s/.*(<[^>]* rend=[^>]*>).*/$1/;

      # construct the end tag to look for
      $endtag = $tag;
      ($endtag, $junk) = split(/>/, $endtag);
      ($endtag, $junk) = split(/ /, $endtag);
      $endtag =~ s/</<\//;
      $endtag = "$endtag>";

      $rendvalue = $tag;
      $rendvalue =~ s/.*rend="([^"]*)".*/$1/;

      ($tag, $junk) = split(/ /, $tag);
      #print "TAG $tag ENDTAG $endtag\n";
      #print "RENDVALUE $rendvalue\n";

      # then look for it
      until ((/$endtag/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      # operation on buffer goes here
      chop $buffer;

      $buffer =~ s/\n/\[EOL\]/g;

      # replace <$tag rend="$rendvalue">...</$endtag> with 
      # <$tag><hi rend="$rendvalue">...</hi></$endtag>
      $buffer =~ s/($tag[^>]*)rend="$rendvalue"([^>]*>)(.*)($endtag)/$1$2<hi\*rend="$rendvalue">$3<\/hi>$4/g;

      # restore previously 'hidden' rend values
      $buffer =~ s/\*rend/ rend/g;
      $buffer =~ s/\s+>/>/g;
      $buffer =~ s/\[EOL\]/\n/g;

      print "$buffer\n";

   } else {
      # restore previously 'hidden' rend values
      s/\*rend/ rend/g;
      print;
   }
}


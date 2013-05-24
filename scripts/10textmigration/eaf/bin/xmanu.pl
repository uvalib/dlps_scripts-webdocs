#!/usr/local/bin/perl

# to be run on those files which represent a manuscript and
# use <front> for meta-data

while (<>) {
   if (/<sourceDesc/) {
      $buffer = '';
      until ((/<\/front>/) || eof()) {
         $buffer .= $_;
         $_ = <>;
      }
      $buffer .= $_;

      # process buffer
      $buffer =~ s/\n/\007/g;

      unless ($buffer =~ /<title.*level="u"/) {
         $buffer =~ s/<title /<title level="u">/;
         $buffer =~ s/<title>/<title level="u">/;
      }

      $buffer =~ s/<publisher>/<publisher>unpublished/;
      $buffer =~ s/<pubPlace>\007*<\/pubPlace>\007*//;
      $buffer =~ s/<date>\007*<\/date>\007*//;
      $buffer =~ s/<notesStmt>/<notesStmt>\007<note n="520|a"><\/note>/;
      $buffer =~ s/<note>\007*<p>\007*<\/p>\007*<\/note>\007*//;
      $buffer =~ s/<\/taxonomy>/<\/taxonomy>\007<taxonomy id="uva-form">\007<bibl>\007<title>UVa Library Form Categories<\/title>\007<\/bibl>\007<\/taxonomy>/;
      $buffer =~ s/<\/textClass>/<keywords scheme="uva-form">\007<term>manuscript<\/term>\007<\/keywords>\007<\/textClass>/;
      $buffer =~ s/<refsDecl>\007*<p>\007*<\/p>\007*<\/refsDecl>\007*//;
      $n520 = $buffer;
      $n520 =~ s/.*(<p>.*<\/p>)\007*<\/div1>\007*<\/front>\007*/$1/;
      $buffer =~ s/(<note n="520\|a">)/$1\007$n520\007/;
      $buffer =~ s/<front/<!-- <front/;
      $buffer =~ s/<\/front>/<\/front> -->/;

      $buffer =~ s/\007/\n/g;
      print "$buffer";

   } else {
      chop;
      s/<note><p><\/p><\/note>//;
      s/<!ENTITY filename SYSTEM "filename.jpg" NDATA jpg>//;

      unless ($_ =~ /^$/) {
         print "$_\n";
      }
   }
}

#!/usr/local/bin/perl

# transforms <note target=> to <ref>

while (<>) {
   if (/<note[ |>]/) {
      $buffer = "";
      until ((/<\/note>/) || (eof)) {
         $buffer .= $_;
         $_ = <>;
      }

      $buffer .= $_;

      # operation on buffer goes here
      $buffer =~ s/\n/\007/g;

      # transform <note target=> to <ref>
      $buffer =~ s/<note(.*target=[^>]*>.*)<\/note>/<ref$1<\/ref>/;

      # collapse space inside a note containing nothing but space
      $buffer =~ s/(<note[^>]*>)\s+(<\/note>)/$1$2/;

      # remove space preceding <\/note>
      $buffer =~ s/ <\/note>/<\/note>/;

      # note must contain a <p> element
      # if already present, remove <p> and </p>
      $buffer =~ s/(<note [^>]*>)<p>/$1/;
      $buffer =~ s/<note><p>/<note>/;
      $buffer =~ s/<\/p>(<\/note>)/$1/;

      # add <p> and </p>
      $buffer =~ s/(<note [^>]*>)/$1<p>/;
      $buffer =~ s/<note>/<note><p>/;
      $buffer =~ s/<\/note>/<\/p><\/note>/;

      # note with an id attribute
      # insert a delimiting string
      $buffer =~ s/(<note.*id=[^>]*>)/$1seg type="note-symbol" REQUIRED HERE!/;
      # place the string following the <p> tag inside the <seg>
      $buffer =~ s/(seg type="note-symbol") REQUIRED HERE!(<p>)([^ \007]*)[ \007]/<$1>$3<\/seg> $2/;
      if ($buffer =~ /<seg type="note-symbol"><\/seg>/) {
         # if the only thing following the <p> tag was a space or linebreak
         # create a parsing error
         $buffer =~ s/(<seg type="note-symbol">)(<\/seg>)/$1<ERROR>NOTE-SYMBOL REQUIRED HERE!<\/ERROR> $2/;
      }

      # clean up
      $buffer =~ s/ <note/<note/g;
      $buffer =~ s/\007/\n/g;
      $buffer =~ s/(<notesStmt[^>]*>)\n*/$1\n/;
      $buffer =~ s/\s*<\/notesStmt>\n*/\n<\/notesStmt>\n/;

      print "$buffer";

   } else {
      print;
   }
}

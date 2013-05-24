#!/usr/local/bin/perl

# moves <xref>Kodak.*</ref> to <note> within <notesStmt>

while (<>) {
   chop;
   $lines[$i] = $_;

   if (($lines[$i] =~ /<\/notesStmt>/) && ($notesStmtend lt 1)) {
      # record the location of the first </notesStmt> tag
      # this is presumed to be within the <filedesc>
      $notesStmtend = $i;
   }

   if ($lines[$i] =~ /<xref>Kodak.*<\/xref>/) {
      # record the xref markup and remove the xref tag
      $xref = $xref.$lines[$i];
      $xref =~ s/<xref>//;
      $xref =~ s/<\/xref>//;

      # remove the <xref> line
      $lines[$i] = "";
   }

   $i = $i + 1;
}

# put the xref stuff just before the end of the notesStmt element
$lines[$notesStmtend] = "<note><p>$xref</p></note>\n".$lines[$notesStmtend];

foreach $i (0 .. $#lines) {
   unless ($lines[$i] =~ /^$/) {
      print "$lines[$i]\n";
   }
}

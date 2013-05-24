# modeng.sh - updates the <teiHeader> in Modern English TEI XML files
# Usage: modeng.sh <filenames>

binpath=/shares/admin/bin/text/migration/etext/teiHeader

for filename in "$@"
do
  echo "$filename..."

  # get filename for new TEI header file
  headerfile=${filename%.xml}_header.xml

  # generate new TEI header
  $binpath/modeng_teiHeader.sh $filename >>xslt_out.txt 2>&1

  # clean up new TEI header
  $binpath/strip_blank_lines headers/$headerfile
  rm headers/*.bak

  # validate new header
  parse headers/$headerfile >> parse_headers_err.txt

  # run QA on new header
  qa_super -hde -DE headers/$headerfile >> qa_headers_err.txt 2>&1

  # replace TEI header
  $binpath/clobber_teiHeader -d headers/ $filename >> clobber_out.txt

  # clean up internal subset
  replace 's/\s*<!ENTITY filename SYSTEM "filename.jpg" NDATA jpg>\s*//' $filename
  replace 's/\s*<!ENTITY % ([\w\-]+?) [^;]+ %\1;\s*//' $filename
  declare_charents $filename

  # add or normalize XML declaration
  replace_xml_decl $filename

  # refresh file size
  refresh_filesize -q $filename
  rm *.bak

  # validate
  parse $filename >> parse_final_err.txt
done

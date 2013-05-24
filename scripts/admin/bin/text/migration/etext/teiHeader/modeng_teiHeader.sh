# For each input file, run Saxon for XSLT 2.0 (-2 option).

# XSLT stylesheet creates new document with different filename, so no
# need to redirect Saxon output.

for filename in "$@"
do
  saxon -2 /shares/admin/bin/text/migration/etext/teiHeader/modeng_teiHeader.xsl filename=$filename $filename
done

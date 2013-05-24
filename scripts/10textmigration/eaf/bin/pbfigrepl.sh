#!/bin/sh

# for all .xml files construct/add entity attribute for each <pb>
# element.
# it is assumed there is a one-to-one correspondence between <pb>
# and <figure> elements before running this script.

files=`ls *.xml`

for file in $files
do
   cat $file | /dlps_work/10textmigration/eaf/pbfigrepl.pl > $file.new
   if [ "$1" = overwrite ]
   then
      /bin/mv $file.new $file
   fi
done

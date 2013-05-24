#!/bin/sh

# for files having 2 more <figure> elements than <pb> elements
# add <pb> element following the <titlePage> element

files=`/dlps_work/10textmigration/eaf/pbfigcount.sh *.xml|grep "2 more figs"|cut -f1`

for file in $files
do
   cat $file | /dlps_work/10textmigration/eaf/addtppb.pl > $file.new
   if [ "$1" = overwrite ]
   then
      mv $file.new $file
   fi
done

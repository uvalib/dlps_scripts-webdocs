#!/bin/sh

# for files having 1 more <figure> element than <pb> elements 
# add <pb> element following the <figure> element which represents
# the spine image

files=`/dlps_work/10textmigration/eaf/pbfigcount.sh *.xml|grep "1 more figs"|cut -f1`

for file in $files
do
   cat $file | /dlps_work/10textmigration/eaf/addcovpb.pl > $file.new
   if [ "$1" = overwrite ]
   then
      mv $file.new $file
   fi
done

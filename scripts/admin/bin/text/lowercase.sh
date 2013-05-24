#!/bin/bash

# a quick command line script to normalize all xml filenames to lowercase
# ms3uf Dec 09 2008 
# Replace xml with *

for file in `find . -type f -iname "*.*"`
 do echo -n "$file    "
 dir=`dirname $file`
 shorty=`basename $file .*`
 fully=`basename $file`
 lcasey=`echo $fully | tr A-Z a-z`
 if [ "$lcasey" != "$fully" ] 
  then
#  echo "$shorty $lcasey     $dir/$lcasey" 
  mv -vb "$file" "$dir/$lcasey"
#sleep 1
  else
  echo " is already lowercase."
  fi
done

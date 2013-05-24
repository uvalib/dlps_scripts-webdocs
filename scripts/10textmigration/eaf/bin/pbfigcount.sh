#!/bin/sh

# reports number of <pb> and <figure> elements and the difference

for file in $*
do
   pb=`cat $file|grep "<pb" | wc -l`
   # fig=`cat $file|grep "<figDesc>[0-9][0-9][0-9]EAF\."| wc -l`
   fig=`cat $file|grep "<figure"| wc -l`
   diff=`expr $pb - $fig`
   if [ "$diff" -eq 0 ]
   then
      echo "$file\t$pb pbs\t$fig figs\tpbs equal figs!"
   fi
   if [ "$diff" -gt 0 ]
   then
      echo "$file\t$pb pbs\t$fig figs\t$diff more pbs than figs!"
   fi
   if [ "$diff" -lt 0 ]
   then
      diff=`expr $fig - $pb`
      echo "$file\t$pb pbs\t$fig figs\t$diff more figs than pbs!"
   fi
done

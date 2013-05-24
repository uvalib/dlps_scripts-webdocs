#!/bin/bash

# utility script to take a file, a DSSR project folder, and create
# ENTITY declarations in the file for each .tif file in that folder

# for use in Modern English Migration (Digital Collections group, 2009)
# created by ms3uf Feb 19 2009
me=`basename $0`
# change the ProjectDir variable to wherever your dssr project folder is.
# ProjectDir="/shares/image3/incoming_modEng/"
ProjectDir="/shares/image1/01bookscanning/52_CCITTCOMPRESS_OUT/"
# change file ending variable to the type of files you need to search.
# FileEnding="jpg"                                              
FileEnding="tif"                                              
MakeBackups=0;
usage="\n
\n
usage: $me [xmlfile] [dssr_project_folder]\n
\n
$me inserts DSSR filenames \n
	from a project folder [project] into the \n
	ENTITY declarations of a TEI XML file [file]\n
\n
The project folder simply needs to be specified, $me will search\n
$ProjectDir for the folder.\n
Note: XML file will be edited in-place, but a .bak file will be made alongside it.\n
"
if [[ "$#" -eq 0 ]] ; then echo -e $usage; exit 1; fi; 
while getopts ":h" options; do
  case $options in
    h ) echo -e $usage
         exit 1;;
    \? ) echo -e $usage
         exit 1;;
     b ) let MakeBackups=1;
  esac
done

excl='!' # my way of escaping this character...

file=${1:-"ZerAero.xml"} # this default value is only for testing
ProjectNum=${2:-"000002074"} # this default value is only for testing
echo "Working on file $file "

# ensure file requested exists and is writeable
if [[ ! -e "$file" ]]
then
echo "$file not found."
exit 1
elif [[ ! -w "$file" ]]
then
echo "$file is not writable"
exit 1
fi


# build temporary file for writing
EntityFragments=`basename $file ".xml"`.frag
: >$EntityFragments  # clear this file
if [[ -s $EntityFragments ]] 
then
echo "error clearing $EntityFragments "
exit 1
else
echo "Clearing $EntityFragments"
fi
sleep 2


# locate project folder and confirm existence of .${FileEnding} files
lsTest=`ls $ProjectDir/$ProjectNum/*.$FileEnding`
lsTest=$?

if [[ ! -d "$ProjectDir/$ProjectNum"  ]]
then
echo "No Directory called $ProjectNum was found in $ProjectDir"
exit 1
elif [[ $lsTest -ne 0  ]]
then
echo "No .${FileEnding} files found in $ProjectDir/$ProjectNum"
exit 1
fi

# construct ENTITY declarations and write them to .frag file
echo "Writing to temp file $EntityFragments (creating list of ENTITY entries)"

for tifFile in `ls $ProjectDir/$ProjectNum/*.${FileEnding}`
 do bname=`basename $tifFile ".$FileEnding"`
# echo "adding ENTITY declaration for $bname"
 echo "<"$excl"ENTITY DSSR_$bname SYSTEM \"$bname\" NDATA uvaHighRes>" >>$EntityFragments
done

# if it looks like we're going to overwite a backup file, warn the user
backupFile=`basename $file`.bak
if [[ -e $backupFile && $MakeBackups -eq 1 ]]
then
echo "WARNING: there is a backup file $backupFile that will be overwritten!"
echo "Do you wish to proceed? (y/N)"
read -t 5
  if [[ $REPLY == 'y' ]]
  then
    # delete file
    rm $backupFile
    echo "$backupFile deleted."; sleep 1;
  else
    # exit gracefully
    echo "Please review $file and $backupFile before running $0 again."
    exit 0
  fi
fi

# use grep to test file and see if sed will latch on to it    |
mytest=`grep -E "^]>" $file`                                  
if [[ $mytest == '' ]]                                        
then                                                          
	echo "ERROR.  Please verify the close bracket CDATA section" 
	exit 1                                                        
fi

# call sed to insert the frag file into the xml file at the end of the DTD CDATA section
sed -i".bak" -c -e "/^]>/ {
x
r $EntityFragments
a\
]>
}" $file

# remove the temporary file
echo "Removing temp file $EntityFragments"
rm -i $EntityFragments

# if not called with -b flag, delete the backup file 
if [[ $MakeBackups -eq 0 || -e "$backupFile" ]]
then 
	rm $backupFile 
fi
exit 0

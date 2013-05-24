#!/bin/bash

maillist=robd@Virginia.edu

# set script-wide variables
sn_home=/lib_archive

# read source directory from command-line argument
case $1 in
	
	0)	echo
		echo "Syntax error: no source directory specified."
		echo "Type 'sndrop help' for a list of valid options."
		echo " "
		exit 1
		;;
		
	1)	local_home_list="/lv00/Stornext1"   # /lv00/Stornext1 /lv01/Stornext2 /lv04/Stornext4
		;;
		
	2)	local_home_list="/lv01/Stornext2"   # /lv00/Stornext1 /lv01/Stornext2 /lv04/Stornext4
		;;
		
	3)	local_home_list="/lv03/Stornext3"   # /lv00/Stornext1 /lv01/Stornext2 /lv04/Stornext4
		;;
		
	4)	local_home_list="/lv04/Stornext4"   # /lv00/Stornext1 /lv01/Stornext2 /lv04/Stornext4
		;;
		
	help)	echo
			echo "Specify one of the following source directories for manual archival to StorNext:"
			echo "1.  image1 (/lv00/Stornext1/Dropoff/Manual)"
			echo "2.  image2 (/lv01/Stornext2/Dropoff/Manual)"
			echo "3.  image3 (/lv03/Stornext3/Dropoff/Manual)"
			echo "4.  text (/lv04/Stornext4/Dropoff/Manual)"
			echo
			echo "example:  sndrop 2"
			echo "This will run a manual archive of files in /shares/image2/Stornext2/Dropoff/Manual"
			echo " "
		;;
		
	*)	echo
		echo "Syntax error: invalid source directory specified."
		echo "Type 'sndrop help' for a list of valid options."
		echo " "
		exit 1
		;;
esac


# using this standard, script must run the _same day_ that files are dropped off, i.e., not after midnight
# NOTE: since this is a manually activated script, change "weekday" to point to "Manual" subdirectory
weekday=Manual

# set umask to allow proper Confirmed/Failed directory creation
umask 0007

# Mail function
function f-mail {
	case "$1" in
	
		0)	echo >> $local_home/Logs/sn_copylog-$logdate
			echo `date` >> $local_home/Logs/sn_copylog-$logdate
			echo "Stornext upload completed successfully." >> $local_home/Logs/sn_checklog-$logdate
			mail -s "StorNext job for $local_home completed successfully." $maillist
			# If upload successful, create file to indicate the obvious...
			touch $dropoff_dir/upload_complete
			;;
		
		1)	echo >> $local_home/Logs/sn_copylog-$logdate
			echo `date` >> $local_home/Logs/sn_copylog-$logdate
			echo "Checksum mismatch or file copy failure." >> $local_home/Logs/sn_checklog-$logdate
			cat $local_home/Logs/sn_checklog-$logdate | mail -s "StorNext job for $local_home encountered errors; please check logs." $maillist
			;;

		2)	echo >> $local_home/Logs/sn_copylog-$logdate
			echo `date` >> $local_home/Logs/sn_copylog-$logdate
			echo "Minor errors found. Please check logs" >> $local_home/Logs/sn_checklog-$logdate
			cat $local_home/Logs/sn_checklog-$logdate | mail -s "StorNext job for $local_home encountered errors; please check logs." $maillist
			;;

		3)	echo >> $local_home/Logs/sn_checklog-$logdate
			echo "One or more required directories do not exist in $local_home. Exiting script." >> $local_home/Logs/sn_checklog-$logdate
			cat $local_home/Logs/sn_checklog-$logdate | mail -s "StorNext job for $local_home halted; please check logs." $maillist
			;;
	
	esac
}


# begin Main loop
for local_home in $local_home_list
	do

	# set loop-specific vars
	logdate=`date +%C%y%m%d`

	dropoff_dir=$local_home/Dropoff/$weekday

	jobstatus=
	shadowfile=
	sumlocalfile=
	sumremotefile=
	cpfile=
	checkfile=		# full (local) file path including file name
	checkfilename=	# file name only
	relcheckfile=  # relative file path including file name
	relcheckfiledir=	# relative file path without file name


	# Mark beginning of job run
	echo >> $local_home/Logs/sn_checklog-$logdate
	echo " +++ Begin StorNext archive transfer job +++ " >> $local_home/Logs/sn_checklog-$logdate
	echo `date` >> $local_home/Logs/sn_checklog-$logdate
	echo >> $local_home/Logs/sn_checklog-$logdate

	# remove previous job completion indicator
	if [ -e $dropoff_dir/upload_complete ]
		then rm -v $dropoff_dir/upload_complete >> $local_home/Logs/sn_checklog-$logdate
	fi


	# verify local dropoff, Logging, and file hold directories exists; if not, exit with error
	if [ ! -d "$dropoff_dir" -o ! -d "$local_home/Logs" -o ! -d "$local_home/Confirmed" -o ! -d "$local_home/Failed" ]
		then
		
		f-mail 3
		continue
	fi


	### Mac OS specific routine ###
	# Search for Mac OS X shadow (AppleDouble) files; if found, move to directory which will not be synced
	# for shadowfile in `find $dropoff_dir -type f -name "._*"`
	#	do
	#	mv -vf $shadowfile $local_home/ResForks >> $local_home/Logs/sn_checklog-$logdate
	# done


	# copy local dropoff directory up to StorNext system
	# options: [r]ecursive, preserve [t]imes, copy [W]hole files, [I]gnore mod time checks
	# do not transfer files from local system which match files already on StorNext
	# log transfers
	echo >> $local_home/Logs/sn_copylog-$logdate
	echo " --- Begin file transfer --- " >> $local_home/Logs/sn_copylog-$logdate
	echo `date` >> $local_home/Logs/sn_copylog-$logdate
	echo >> $local_home/Logs/sn_copylog-$logdate

	rsync -rtWI --ignore-existing --log-format="%o %f %l %b %t" $dropoff_dir/ $sn_home >> $local_home/Logs/sn_copylog-$logdate 2>&1

	echo "copy complete." >> $local_home/Logs/sn_copylog-$logdate
	echo `date` >> $local_home/Logs/sn_copylog-$logdate
	echo >> $local_home/Logs/sn_copylog-$logdate
	echo >> $local_home/Logs/sn_copylog-$logdate


	#  run loop to compare checksums all files in local dropoff dir; ignore any .DS_Store files found

	for checkfile in `find $dropoff_dir -type f \! -name ".DS_Store"`
		do 
		# create relative file path by removing path up through dropoff dir
		# statement requires trailing "/"
		# then assign relative file path without filename to "relcheckfiledir"
		relcheckfile=`ls $checkfile | sed "s:$dropoff_dir/::"`
		checkfilename=`ls $checkfile | awk -F/ '{ print $NF }'`
		relcheckfiledir=`echo $relcheckfile | sed "s:/$checkfilename::"`

		# check if file exists on StorNext; compare remote checksum to local checksum
		if [ -e $sn_home/$relcheckfile ]
			then 
			sumremotefile=`/usr/bin/md5sum $sn_home/$relcheckfile | awk '{ print $1 }'`
			sumlocalfile=`/usr/bin/md5sum $checkfile | awk '{ print $1 }'`

			if [ $sumremotefile != $sumlocalfile ]
				then
				echo "**Warning**: File $sn_home/$relcheckfile failed checksum test! " >> $local_home/Logs/sn_checklog-$logdate
				jobstatus=1

				# check for subdirectory under Failed; create if it does not exist
				if [ ! -e $local_home/Failed/$relcheckfiledir ]
					then
					mkdir -pv $local_home/Failed/$relcheckfiledir
			
				fi

				# move failed file to temporary location under "Failed" directory
				mv -v $checkfile $local_home/Failed/$relcheckfiledir
				
			fi

			if [ $sumremotefile == $sumlocalfile ]
				then
				echo "File $sn_home/$relcheckfile passed checksum test " >> $local_home/Logs/sn_checklog-$logdate

				# check for subdirectory under "Confirmed" directory; create if it does not exist
				if [ ! -e $local_home/Confirmed/$relcheckfiledir ]
					then
					mkdir -pv $local_home/Confirmed/$relcheckfiledir
				fi

				# move confirmed file to temporary location under "Confirmed" 
				mv -v $checkfile $local_home/Confirmed/$relcheckfiledir

			fi

			else 
			# file does not exist on StorNext; report error and move to Failed local dir
			echo "**Warning**: File $relcheckfile does not exist on StorNext system. " >> $local_home/Logs/sn_checklog-$logdate
			jobstatus=1

			# check for subdirectory under Failed; create if it does not exist
			if [ ! -e "$local_home/Failed/$relcheckfiledir" ]
				then
				mkdir -pv $local_home/Failed/$relcheckfiledir
			fi

			# move failed file to temporary location under "Failed" directory
			mv -v $checkfile $local_home/Failed/$relcheckfiledir

		fi

		# remove current directory if empty - rmdir will not remove non-empty dirs
		rmdir $dropoff_dir/$relcheckfiledir >> $local_home/Logs/sn_checklog-$logdate

	done
	
	# call mail function to send jobstatus
	f-mail "$jobstatus"

done

exit 0

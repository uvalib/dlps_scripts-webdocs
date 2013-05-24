
DOCUMENTATION FOR THE dirman.pl AND deldir.pl TOOLS:
----------------------------------------------------

dirman.pl

URL: http://pogo.lib.virginia.edu/cgi-dlps/dlps-only/cleanup/dirman.pl
Script location: pogo: /www/cgi-dlps/dlps-only/cleanup/dirman.pl

Description: This script creates a file on pogo.lib
(/usr/tmp/dirman_delete.txt) that lists subdirectories and files
on pogo that DLPS staff have determined should be deleted.  The
utility allows the user to find selected files/subdirectories under
"/shares/image1/01bookscanning" or "/shares/text/04postkb".  The user
can select one or both of these directory locations from which to
begin the search.  If the user specifies one or more IDs in the "DLPS
ID" field, the utility searches for those subdirectories or files that
start with that ID.

Within the "/shares/image1/01bookscanning" directory the utility looks
for *subdirectories* that start with the designated pattern.  It is
important for the user to remember that everything under the
subdirectory selected will be deleted.  In the case of the
"/shares/text/04postkb" directory, the tool looks for *files* that
start with the pattern.

After selecting from the list displayed on the screen and clicking
"Continue", the script will display a window with the selected files
and subdirectories for verification.  If the selection is correct, the
user clicks "DELETE" and if not, clicks "Cancel"

The script is intended to work in conjunction with the deldir.pl
script, which is run by a root cron job to actually perform the
deletions.

______________________________________________________________________

deldir.pl

Script location: pogo: /shares/admin/bin/cron/deldir.pl

Description: This script reads the "/usr/tmp/dirman_delete.txt" file
created by the dirman.pl script and deletes the files and directories
listed.  As a precaution, the script will only make deletions under
the two hardcoded directories ("/shares/image1/01bookscanning" and
"/shares/text/04postkb").  Additionally, an email is sent to
'ul-dlpsscripts@virginia.edu' listing the files and directories that
have been deleted.

The deldir.pl script is executed by a root cron job on pogo.lib.

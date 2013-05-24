<?php 
/* 
 * @(#)applescriptStatus.php		1.00	2006/06/13
 *
 * Copyright (c) 2006 Digital Library Production Services, University of Virginia Library
 * All rights reserved.
 *
 * This script displays a selection list of projects to choose from for which you can check
 * the status of submitted AppleScripts.
 *
 * @version		1.00 2006/06/13
 * @author		Jack Kelly
 *
 * 2006/06/20 - (jlk4p) Updated to use timestamps instead of booleans for each step. Plus
 *				added additional detail information on the displayed page.
 * 2006/06/20 - (jlk4p) Updated to add step0 data, which refers to the status of the iview2iris
 *				AppleScript that currently runs in DLPS as a cron job.
 * 2006/07/18 - (jlk4p) Added ability to store notes for each script step to document error 
 *				resolution/issues.
 */
//error_reporting(E_ALL);
require_once("database.php");
require_once("functions.php");
	
/* Identify the project selected from the index form page. */
?>
<?php if (isset($_POST['project']) and ($_POST['project'] != "")) : 
	$project = trim(urldecode($_POST['project'])); ?>
	<?php
	/* If someone updated a note on this page then make sure to save it to the database. */
	if (isset($_POST['updateNote0']) and ($_POST['updateNote0'] == "Update")) {
		$step0Note = escapeField(trim($_POST['step0Note']));
		$query = "update projects set step0Note='$step0Note' where projectName='$project'";
		$result = executeSQL($database,$query,'update');
	} else if (isset($_POST['updateNote1']) and ($_POST['updateNote1'] == "Update")) {
		$step1Note = escapeField(trim($_POST['step1Note']));
		$query = "update projects set step1Note='$step1Note' where projectName='$project'";
		$result = executeSQL($database,$query,'update');
	} else if (isset($_POST['updateNote2']) and ($_POST['updateNote2'] == "Update")) {
		$step2Note = escapeField(trim($_POST['step2Note']));
		$query = "update projects set step2Note='$step2Note' where projectName='$project'";
		$result = executeSQL($database,$query,'update');
	} else if (isset($_POST['updateNote3']) and ($_POST['updateNote3'] == "Update")) {
		$step3Note = escapeField(trim($_POST['step3Note']));
		$query = "update projects set step3Note='$step3Note' where projectName='$project'";
		$result = executeSQL($database,$query,'update');
	}
	?>
<html>
<head>
<title>AppleScript Status for project <?php echo $project; ?></title>
<link rel="stylesheet" type="text/css" href="../tracksys/inc/tracksys.css">
<script type="text/javascript">
var step0='hidden';
var step1='hidden';
var step2='hidden';
var step3='hidden';
var note0='hidden';
var note1='hidden';
var note2='hidden';
var note3='hidden';
function showAndHide(elementId) {
	if (elementId == 'step0') {
		if (step0 == 'hidden') {
			document.getElementById('step0').style.display = 'block';
			step0 = 'visible';
			document.getElementById('step0sign').innerHTML = 'Less info...';
		} else {
			document.getElementById('step0').style.display = 'none';
			step0 = 'hidden';
			document.getElementById('step0sign').innerHTML = 'More info...';
		}
	}
	if (elementId == 'step1') {
		if (step1 == 'hidden') {
			document.getElementById('step1').style.display = 'block';
			step1 = 'visible';
			document.getElementById('step1sign').innerHTML = 'Less info...';
		} else {
			document.getElementById('step1').style.display = 'none';
			step1 = 'hidden';
			document.getElementById('step1sign').innerHTML = 'More info...';
		}
	}
	if (elementId == 'step2') {
		if (step2 == 'hidden') {
			document.getElementById('step2').style.display = 'block';
			step2 = 'visible';
			document.getElementById('step2sign').innerHTML = 'Less info...';
		} else {
			document.getElementById('step2').style.display = 'none';
			step2 = 'hidden';
			document.getElementById('step2sign').innerHTML = 'More info...';
		}
	}
	if (elementId == 'step3') {
		if (step3 == 'hidden') {
			document.getElementById('step3').style.display = 'block';
			step3 = 'visible';
			document.getElementById('step3sign').innerHTML = 'Less info...';
		} else {
			document.getElementById('step3').style.display = 'none';
			step3 = 'hidden';
			document.getElementById('step3sign').innerHTML = 'More info...';
		}
	}
	if (elementId == 'note0') {
		if (note0 == 'hidden') {
			document.getElementById('note0').style.display = 'block';
			note0 = 'visible';
		} else {
			document.getElementById('note0').style.display = 'none';
			note0 = 'hidden';
		}
	}
	if (elementId == 'note1') {
		if (note0 == 'hidden') {
			document.getElementById('note1').style.display = 'block';
			note0 = 'visible';
		} else {
			document.getElementById('note1').style.display = 'none';
			note0 = 'hidden';
		}
	}
	if (elementId == 'note2') {
		if (note0 == 'hidden') {
			document.getElementById('note2').style.display = 'block';
			note0 = 'visible';
		} else {
			document.getElementById('note2').style.display = 'none';
			note0 = 'hidden';
		}
	}
	if (elementId == 'note3') {
		if (note0 == 'hidden') {
			document.getElementById('note3').style.display = 'block';
			note0 = 'visible';
		} else {
			document.getElementById('note3').style.display = 'none';
			note0 = 'hidden';
		}
	}
}
</script>
</head>
<body>
<h2>AppleScript Status for project <?php echo $project; ?></h2>

<?php
	/* Get AppleScript status information regarding the chosen project. */
	$query = "select step0Started, step0Finished, step0ErrorCount, step0Note,
		if(isnull(step0started),0,if(isnull(step0finished),(unix_timestamp()-unix_timestamp(step0started)),(unix_timestamp(step0finished)-unix_timestamp(step0started)))) as step0runtime, 
		step1Started, step1Finished, step1ErrorCount, step1Note,
		if(isnull(step1started),0,if(isnull(step1finished),(unix_timestamp()-unix_timestamp(step1started)),(unix_timestamp(step1finished)-unix_timestamp(step1started)))) as step1runtime, 
		step2Started, step2Finished, step2ErrorCount, step2Note,
		if(isnull(step2started),0,if(isnull(step2finished),(unix_timestamp()-unix_timestamp(step2started)),(unix_timestamp(step2finished)-unix_timestamp(step2started)))) as step2runtime,
		step3Started, step3Finished, step3ErrorCount, step3Note,
		if(isnull(step3started),0,if(isnull(step3finished),(unix_timestamp()-unix_timestamp(step3started)),(unix_timestamp(step3finished)-unix_timestamp(step3started)))) as step3runtime
		from projects where projectName='$project'";
	$result = executeSQL($database,$query,'select');
	$record = mysql_fetch_assoc($result[0]);
	
	/* Display the status of the iview2iris script to put image info from iview into IRIS... */
	if ($record['step0Started'] != "") {
		print("<h3>Iview2iris ");
		if ($record['step0Finished'] != "") {
			print(" is finished running.");
			if ($record['step2Started'] == "") {
				print(" There ");
				if ($record['step0ErrorCount'] == 0) {
					print("were no errors.");
				} elseif ($record['step0ErrorCount'] == 1) {
					print("was one error.");
				} elseif ($record['step0ErrorCount'] > 1) {
					print("were $record[step0ErrorCount] errors.");
				}
			}
			print("</h3>");
		} else {
			print(" has not finished running.</h3>");
		}
		print("<blockquote>");
		print("<a href=\"javascript:showAndHide('step0')\"><div id=\"step0sign\">More info...</div></a>");
		print("<div id=\"step0\" style=\"display: none;\">");
		print("<p>This script runs as a cron job in the DLPS facility on Zoe. It searchs for 
			Iview exported text project files on the Udon.lib server in the Iris_dropoff 
			volume. Any text files found there are read and the PID and project name
			are updated in IRIS for each image. When the script is completed an email is 
			sent to Liz, Ray, and Kristy.</p>");
		print("</div>");
		print("</blockquote>");	
		
		if ($record['step0Finished'] != "") {
			if ($record['step0ErrorCount'] == 0) {
				print("<p><b>Status:</b> Image PIDs and project names successfully imported to IRIS.</p>");
			} else {
				if ($record['step1Started'] == "") {
					print("<p>Please check the automated email sent by the script for 
						information regarding the error(s) in order to resolve them.</p>");
				} else {
					print("<p>");
					print("<b>Status:</b> Image PIDs and project names added to IRIS. (There ");
					if ($record['step0ErrorCount'] == 1) {
						print("was one error");
					} else {
						print("were $record[step0ErrorCount] errors");
					}
					print(" that did not necessarily impact the import of all the data.)");
					print("</p>");
				}
			}
			print("<p>");
			$startTime = date("h:i a  M j, Y",strtotime($record['step0Started']));
			print("<b>Started:</b> $startTime<br/>");
			$finishTime = date("h:i a  M j, Y",strtotime($record['step0Finished']));
			print("<b>Finished:</b> $finishTime<br/>");
			print("<b>Run-time:</b> " . convertSecondsToString($record['step0runtime']) . "<br/>");
			$step0Note = htmlspecialchars(stripslashes($record['step0Note']));
			print("<a href=\"javascript:showAndHide('note0')\"><b>Note:</b></div></a>");
			print("<div id=\"note0\" style=\"display: none;\">");
			print("<form action=\"$_SERVER[PHP_SELF]\" method=\"post\"><table><tr valign=\"top\">
				<input type=\"hidden\" name=\"project\" value=\"$project\">
				<td><textarea name=\"step0Note\" rows=\"3\" cols=\"50\">$step0Note</textarea></td>
				<td><input type=\"submit\" name=\"updateNote0\" value=\"Update\"></td>
				</table></form>");
			print("</div>");
			print("</p>");
		} else {
			$startTime = date("h:i a  M j, Y",strtotime($record['step0Started']));
			print("<p><b>Started:</b> $startTime ");
			print("(running for " . convertSecondsToString($record['step0runtime']) . ")</p>");
		}
		
		/* Display the status of the first iris2tabbed script to export work data... */
		if ($record['step1Started'] != "") {
			print("<h3>Iris2tabbed13step1 ");
			if ($record['step1Finished'] != "") {
				print(" is finished running.");
				if ($record['step2Started'] == "") {
					print(" There ");
					if ($record['step1ErrorCount'] == 0) {
						print("were no errors.");
					} elseif ($record['step1ErrorCount'] == 1) {
						print("was one error.");
					} elseif ($record['step1ErrorCount'] > 1) {
						print("were $record[step1ErrorCount] errors.");
					}
				}
				print("</h3>");
			} else {
				print(" has not finished running.</h3>");
			}
			print("<blockquote>");	
			print("<a href=\"javascript:showAndHide('step1')\"><div id=\"step1sign\">More info...</div></a>");
			print("<div id=\"step1\" style=\"display: none;\">");
			print("<p>Fine Arts initiates this script after cataloging is completed (at the 
				end of step 4 of the image workflow). This scripts prompts the user for the
				project name and exports the work metadata from IRIS into a tab delimited text 
				file on pogo.lib's dropbox volume. No email is sent after the execution of this
				script finishes.</p>");
			print("</div>");
			print("</blockquote>");	
			
			if ($record['step1Finished'] != "") {
				if ($record['step1ErrorCount'] == 0) {
					print("<p><b>Status:</b> IRIS work data successfully exported.</p>");
				} else {
					if ($record['step2Started'] == "") {
						print("<p>Please look in the iris_exports folder on Pogo's dropbox volume and
							examine both the 'iris2tabbed.out' and 'IrisWorksExport.err' files for 
							information on the $record[step1ErrorCount] error(s). NOTE: Warnings
							are counted as errors, but some may not actually affect the process. 
							You will need to determine the severity.</p>");
						print("<p>If  resolving the problem requires making any data changes to IRIS
							work record data, then you will need to re-run this AppleScript after making 
							the corrections.<p>");
					} else {
						print("<p>");
						print("<b>Status:</b> IRIS work data exported. (There ");
						if ($record['step1ErrorCount'] == 1) {
							print("was one error");
						} else {
							print("were $record[step1ErrorCount] errors");
						}
						print(" that did not impact the exported data.)");
						print("</p>");
					}
				}
				print("<p>");
				$startTime = date("h:i a  M j, Y",strtotime($record['step1Started']));
				print("<b>Started:</b> $startTime<br/>");
				$finishTime = date("h:i a  M j, Y",strtotime($record['step1Finished']));
				print("<b>Finished:</b> $finishTime<br/>");
				print("<b>Run-time:</b> " . convertSecondsToString($record['step1runtime']) . "<br/>");
				$step1Note = htmlspecialchars(stripslashes($record['step1Note']));
				print("<a href=\"javascript:showAndHide('note1')\"><b>Note:</b></div></a>");
				print("<div id=\"note1\" style=\"display: none;\">");
				print("<form action=\"$_SERVER[PHP_SELF]\" method=\"post\"><table><tr valign=\"top\">
					<input type=\"hidden\" name=\"project\" value=\"$project\">
					<td><textarea name=\"step1Note\" rows=\"3\" cols=\"50\">$step1Note</textarea></td>
					<td><input type=\"submit\" name=\"updateNote1\" value=\"Update\"></td>
					</table></form>");
				print("</div>");
				print("</p>");
			} else {
				$startTime = date("h:i a  M j, Y",strtotime($record['step1Started']));
				print("<p><b>Started:</b> $startTime ");
				print("(running for " . convertSecondsToString($record['step1runtime']) . ")</p>");
			}
			
			/* Only display the status of the second iris2tabbed script if the first is finished... */
			if ($record['step2Started'] != "") {
				print("<h3>Iris2tabbed13step2 ");
				if ($record['step2Finished'] != "") {
					print(" is finished running.");
					if ($record['step3Started'] == "") {
						print(" There ");
						if ($record['step2ErrorCount'] == 0) {
							print("were no errors.");
						} elseif ($record['step2ErrorCount'] == 1) {
							print("was one error.");
						} elseif ($record['step2ErrorCount'] > 1) {
							print("were $record[step2ErrorCount] errors.");
						}
					}
					print("</h3>");
				} else {
					print(" has not finished running.</h3>");
				}
	
				print("<blockquote>");	
				print("<a href=\"javascript:showAndHide('step2')\"><div id=\"step2sign\">More info...</div></a>");
				print("<div id=\"step2\" style=\"display: none;\">");
				print("<p>Fine Arts initiates this script after Iris2tabbed13step1 is completed 
					(at the end of step 4 of the image workflow). This scripts exports the image 
					and source metadata from IRIS into a tab delimited text file on pogo.lib's 
					dropbox volume. This script cannot run unless step1 has, since it relies on
					a file created in step1 in order to determine the project, etc. An email 
					regarding the status of this script is sent to ul-dlpsscripts and Liz. (After 
					this text file and the one from the previous step are created, then tabbed2gdms
					cron job will find them when it runs and generate the work GDMS and image
					DESC files.)</p>");
				print("</div>");
				print("</blockquote>");	
	
				if ($record['step2Finished'] != "") {
					if ($record['step2ErrorCount'] == 0) {
						print("<p><b>Status:</b> IRIS image and source data successfully exported.</p>");
					} else {
						print("<p>You should receive an email indicating the errors that occurred
							during this script step (and the previous one). NOTE: Warnings
							are counted as errors, but some may not actually affect the process. 
							You will need to determine the severity.</p>");
						print("<p>If  resolving the problem requires making any data changes to IRIS
							image record data, then you will need to re-run this AppleScript after 
							making the corrections.<p>");
					}
					print("<p>");
					$startTime = date("h:i a  M j, Y",strtotime($record['step2Started']));
					print("<b>Started:</b> $startTime<br/>");
					$finishTime = date("h:i a  M j, Y",strtotime($record['step2Finished']));
					print("<b>Finished:</b> $finishTime<br/>");
					print("<b>Run-time:</b> " . convertSecondsToString($record['step2runtime']) . "<br/>");
					$step2Note = htmlspecialchars(stripslashes($record['step2Note']));
					print("<a href=\"javascript:showAndHide('note2')\"><b>Note:</b></div></a>");
					print("<div id=\"note2\" style=\"display: none;\">");
					print("<form action=\"$_SERVER[PHP_SELF]\" method=\"post\"><table><tr valign=\"top\">
						<input type=\"hidden\" name=\"project\" value=\"$project\">
						<td><textarea name=\"step2Note\" rows=\"3\" cols=\"50\">$step2Note</textarea></td>
						<td><input type=\"submit\" name=\"updateNote2\" value=\"Update\"></td>
						</table></form>");
					print("</div>");
					print("</p>");
				} else {
					$startTime = date("h:i a  M j, Y",strtotime($record['step2Started']));
					print("<p><b>Started:</b> $startTime ");
					print("(running for " . convertSecondsToString($record['step2runtime']) . ")</p>");
				}
				
				/* Only display the status of the third iris2tabbed script if the second is finished... */
				if ($record['step3Started'] != "") {
					print("<h3>Iris2tabbed13step3 ");
					if ($record['step3Finished'] != "") {
						print(" is finished running. There ");
						if ($record['step3ErrorCount'] == 0) {
							print("were no errors.</h3>");
						} elseif ($record['step3ErrorCount'] == 1) {
							print("was one error.</h3>");
						} elseif ($record['step3ErrorCount'] > 1) {
							print("were $record[step3ErrorCount] errors.</h3>");
						}
					} else {
						print(" has not finished running.</h3>");
					}
		
					print("<blockquote>");	
					print("<a href=\"javascript:showAndHide('step3')\"><div id=\"step3sign\">More info...</div></a>");
					print("<div id=\"step3\" style=\"display: none;\">");
					print("<p>Fine Arts initiates this script after receiving the \"GDMS and Image DESC file status\"
						email and approving step 4 in the Image Tracking system. This script will read the archived 
						work and image project files. Then it will update the IRIS work and image records' export date 
						fields to indicate that the work and image metadata were successfully exported into GDMS and 
						Image DESC files.</p>");
					print("</div>");
					print("</blockquote>");	
		
					if ($record['step3Finished'] != "") {
						if ($record['step3ErrorCount'] == 0) {
							print("<p><b>Status:</b> IRIS work and image export dates successfully updated.</p>");
						} else {
							print("<p>You should receive an email indicating the errors that occurred
								during this script step.</p>");
						}
						print("<p>");
						$startTime = date("h:i a  M j, Y",strtotime($record['step3Started']));
						print("<b>Started:</b> $startTime<br/>");
						$finishTime = date("h:i a  M j, Y",strtotime($record['step3Finished']));
						print("<b>Finished:</b> $finishTime<br/>");
						print("<b>Run-time:</b> " . convertSecondsToString($record['step3runtime']) . "<br/>");
						$step3Note = htmlspecialchars(stripslashes($record['step3Note']));
						print("<a href=\"javascript:showAndHide('note3')\"><b>Note:</b></div></a>");
						print("<div id=\"note3\" style=\"display: none;\">");
						print("<form action=\"$_SERVER[PHP_SELF]\" method=\"post\"><table><tr valign=\"top\">
							<input type=\"hidden\" name=\"project\" value=\"$project\">
							<td><textarea name=\"step3Note\" rows=\"3\" cols=\"50\">$step3Note</textarea></td>
							<td><input type=\"submit\" name=\"updateNote3\" value=\"Update\"></td>
							</table></form>");
						print("</div>");
						print("</p>");
					} else {
						$startTime = date("h:i a  M j, Y",strtotime($record['step3Started']));
						print("<p><b>Started:</b> $startTime ");
						print("(running for " . convertSecondsToString($record['step3runtime']) . ")</p>");
					}
				}

			}
		}
	} else {
		print("<p>No AppleScripts currently running against IRIS for this project.</p>");
	}
?>
<p><a href="index.php">Check</a> another project's AppleScript status.</p>
<p><a href="/dlps">Return</a> to the DLPS Resources page.</p>
</body>
</html>
<?php else : ?>
	<?php header("location: index.php"); ?>
<?php endif; ?>

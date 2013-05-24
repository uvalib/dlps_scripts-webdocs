<?php
/* 
 * @(#)updateImageProjectExportStatus.php		1.00	2006/06/08
 *
 * Copyright (c) 2006 Digital Library Production Services, University of Virginia Library
 * All rights reserved.
 *
 * This script updates the AppleScript(s) status of an image project to let Fine Arts
 * be able to check via the web if the script finished successfully or not when run over 
 * night. Since the script's final dialog box displayed may time out and no longer be
 * showing on their local computer screen.
 *
 * @version		1.00 2006/06/08
 * @author		Jack Kelly
 *
 * 2006/06/13 - (jlk4p) Incorporated checking and creating project if not already defined.
 * 2006/06/20 - (jlk4p) Updated to use timestamps instead of boolean flags for each step.
 * 2006/06/26 - (jlk4p) Fixed so that when rerunning step 0 or 1, later steps get cleared out.
 * 2006/06/27 - (jlk4p) Added step 3 AppleScript and needed to update this to reset step 3
 *			if step 2 re-run.
 */

require_once("database.php");
require_once("functions.php");

/* Only execute this script if the project was passed on the URL and is not empty. */
if (isset($_GET['project']) && ($_GET['project'] <> "")) {
	$projName = trim(urldecode($_GET['project']));
	
	/* Check to see if the project already exists. If not then create a record for it. */
	$query = "select projectName from projects where projectName='$projName'";
	$checkProject = executeSQL($database,$query,'select');
	if ($checkProject[1] == 0) {
		$query = "insert into projects(projectName) values('$projName')";
		$success = executeSQL($database,$query,'insert');
	}
	
	/* Check on the parameters passed for the project status. */
	if (isset($_GET['step'])) {	//if the step parameter is not passed then set it to 1.
		$step = (int) trim(urldecode($_GET['step']));
	} else {
		$step = 1;
	}
	if (isset($_GET['started'])) {	//if the finished parameter is not passed then set to no
		$started = trim(urldecode($_GET['started']));
	} else {
		$started = "";
	}
	if (isset($_GET['finished'])) {	//if the finished parameter is not passed then set to no
		$finished = trim(urldecode($_GET['finished']));
	} else {
		$finished = "";
	}
	if (isset($_GET['errorCount'])) {	///if the error count is not passed then set to 0
		$errorCount = (int) trim(urldecode($_GET['errorCount']));
	} else {
		$errorCount = 0;
	}

	/* Update the project status. */
	$query = "update projects set ";
	if ($started != "") {
		$query .= "step" . $step . "Started='$started', ";
		$query .= "step" . $step . "Finished=NULL, ";
		switch ($step) {
			case 0: $query .= "step1Started=NULL, step1Finished=NULL, step1ErrorCount=0, ";
			case 1: $query .= "step2Started=NULL, step2Finished=NULL, step2ErrorCount=0, ";
			case 2: $query .= "step3Started=NULL, step3Finished=NULL, step3ErrorCount=0, ";
		}
	}
	if ($finished != "") {
		$query .= "step" . $step . "Finished='$finished', ";
	}
	$query .= " step" . $step . "ErrorCount=$errorCount where projectName='$projName'";
	$success = executeSQL($database,$query,'update');
} else {
	print("ERROR: project parameter missing from URL");
}
?>
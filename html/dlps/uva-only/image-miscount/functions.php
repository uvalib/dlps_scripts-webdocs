<?php
/* 
 * @(#)functions.php		1.00	2006/06/08
 *
 * Copyright (c) 2002 Digital Library Production Services, University of Virginia Library
 * All rights reserved.
 *
 * This module contains functions used by this web application/directory:
 *
 *		convertSecondsToString(seconds)
 *		escapeField(data)
 *		executeSQL(database,query,statement type)
 *
 * @version		1.00 2006/06/08
 * @author		Jack Kelly
 *
 * 2006/06/20 - (jlk4p) Added convertSecondsToString for displaying hours, minutes, seconds
 *				duration that the script has run/been running.
 * 2006/07/18 - (jlk4p) Added escapeField function for testing if data has already been escaped.
 */

/*
 * convertSecondsToString - takes the seconds passed to it and returns a string indicating
 *			the number of hours, minutes and seconds that it represents.
 *
 * parameters:
 *		$seconds - the number of seconds to be converted into a string.
 */
function convertSecondsToString($seconds) {
	/* Calculate the hours and minutes, adjusting the seconds as needed. */
	$secperhr = 3600;
	$secpermin = 60;
	if ($seconds >= $secperhr) {
		$hours = (int) ($seconds / $secperhr);
		$seconds -= $hours * $secperhr;
	} else {
		$hours = 0;
	}
	if ($seconds >= $secpermin) {
		$minutes = (int) ($seconds / $secpermin);
		$seconds -= $minutes * $secpermin;
	} else {
		$minutes = 0;
	}
	/* Create a string based on the number of hours, minutes and seconds are. */
	$time = "";
	if ($hours > 0) {
		$time .= $hours . " hour";
		if ($hours > 1) {
			$time .= "s";
		}
		$time .= " ";
	}
	if ($minutes > 0) {
		$time .= $minutes . " minute";
		if ($minutes > 1) {
			$time .= "s";
		}
		$time .= " ";
	}
	if ($seconds > 0) {
		if ($time != "") {
			$time .= "and ";
		}
		$time .= $seconds . " second";
		if ($seconds > 1) {
			$time .= "s";
		}
	}
	return $time;	
}

/*
 * escapeField - Escapes the data passed via form if needed before trying to store it in
 *			a database field.
 *
 * parameters:
 *		$data - data to be escaped.

 */
function escapeField($data) {
	if (get_magic_quotes_gpc() == 1) {
		return $data;
	} else {
		return addslashes($data);
	}
}

/*
 * executeSQL - Sends the SQL string to the database server for execution.
 * 			If the request causes an error for MySQL, execution stops and 
 *			the appropriate error message is returned. If the SQL successfully
 * 			is executed then an array is returned that contains the following
 * 			information:
 *				array[0] - the pointer to the result set
 *				array[1] - the number of rows in the result set, or the number
 *					of rows affected by an insert, update or delete.
 *				array[2] - if an insert was performed then the auto_increment 
 *					value for that table if it exists; otherwise 0.
 *
 * parameters:
 *		$dbName - the name of the MySQL databse to be queried.
 *		$sqlString - the SQL string to be executed on the MySQL server.
 *		$commandType - identifies the type of query: select, insert, update, delete
 */
function executeSQL($dbName,$sqlString,$commandType="select") {
	//$dbHost = "localhost";
	$dbHost = "mysql.lib.virginia.edu";
	$dbUser = "jlk4p";
	$dbPwd = "jlk4p912";
	$results = array();		// empty array to contain the results of the query
	
	/* Establish connection to mySQL server; if unsuccessful then terminate. */
	$link= mysql_connect($dbHost,$dbUser,$dbPwd) or 
		die("Unable to connect to the MySQL $dbHost server.<br>/n");
	mysql_select_db($dbName,$link) or die(mysql_error($link));
	
	/* Return a pointer to the result set; or if an error occurs then terminate. */
	$results[0] = mysql_query($sqlString,$link) or die(mysql_error($link) . 
			"<p>Query: $sqlString</p>");

	/*
	 * If a select was performed then return the number of records in the result
	 * set as the second element. Otherwise return the number of record that were
	 * affected by the insert, update, or delete. NOTE: If a delete was performed
	 * that did not contain a where clause, then 0 is returned.
	 */
	if ($commandType == "select") {
		$results[1] = mysql_num_rows($results[0]);
	} else {
		$results[1] = mysql_affected_rows($link);
	}
	
	/*
	 * If an insert was performed and the table has an auto_increment field,
	 * then the value of that auto_increment field is returned. Otherwise
	 * zero is returned.
	 */
	$results[2] = mysql_insert_id($link);
	
	mysql_close($link);
	return $results;
}

?>

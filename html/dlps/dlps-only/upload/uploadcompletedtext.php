<?php
/*
 * uploadcompletedtext.php
 *
 * This script will allow someone to upload a tab delimited file for replacing
 * the contents of the dlsp_tracker MySQL database books table.
 *
 * Author: Jack Kelly
 * Created: 2004/02/12
 *
 * 2004/03/03 - (jlk4p) Hatbox is running PHP 4.1 which does not support the
 *				error check when uploading a file. The error check must be
 *				dropped. In addition, it is necessary to store the date of the
 *				file upload for use on the display of the tracked texts.
 * 2004/03/03 - (jlk4p) Modified the process that writes the book records so that
 *				each field value has extraneous whitespace removed from the front
 *				or back.
 * 2005/05/02 - (jlk4p) The use of "select" to identify the query type is not good
 *				since that text may exist in the actual data for a record. Instead
 *				define a new parameter in submitQuery to identify the command type.
 */

$dbHost = "datastore.lib.virginia.edu";
$dbUser = "jlk4p";
$dbPassword = "jlk4p912";
$dbName = "jlk4p_dlps_tracker";
$booksFieldCount = 8;	// Note: this could be found by querying MySQL?

/*
 * submitQuery - Sends the SQL string to the database server for execution.
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
 *		$sqlQuery - the SQL string to be executed on the MySQL server.
 *		$commandType - the type of query being executed: select, insert, update
 */
function submitQuery($sqlString,$commandType) {
	global $dbHost;	// database server name
	global $dbUser;	// account name for logging into the db server
	global $dbPassword;			// password for the account name provided
	global $dbName;	// database name
	$results = array();		// empty array to contain the results of the query
	
	/* Establish connection to mySQL server; if unsuccessful then terminate. */
	$link= mysql_connect($dbHost,$dbUser,$dbPassword) or 
		die("Unable to connect to the MySQL $dbHost server.<br>/n");
	mysql_select_db($dbName,$link) or die(mysql_error($link));
	
	/* Return a pointer to the result set; or if an error occurs then terminate. */
	$results[0] = mysql_query($sqlString,$link) or die(mysql_error($link) . "<p>Query: $sqlString</p>");
	
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
	
	//mysql_close($link);
	return $results;
}

/* If the function file_get_contents does not exist in PHP then define it. */
if (!function_exists("file_get_contents")) {
	/*
	 * file_get_contents - Reads the contents of a file into a string.
	 *
	 * parameters:
	 *		$filename - the name of the file (can be a URL).
	 *		$use_include_path - 
	 */
	function file_get_contents($filename, $use_include_path = 0) {
		$data = ""; // just to be safe. Dunno, if this is really needed
		$file = fopen($filename, "rb", $use_include_path);
		if ($file) {
			$data = "";
			while (!feof($file)) {
				$data .= fread($file, 1024);
			}
			fclose($file);
		}
		return $data;
	}
}
?>

<html>
<head>
<title>Digital Library Production Services - Completed Texts</title>
</head>
<body>
<h3 align="center">Digital Library Production Services</h3>
<h3 align="center">Completed Texts</h3>
<h3 align="center">Upload Replacement File</h3>

<?php if (!isset($_POST['upload'])) : ?>

	<p>This upload process will allow you to replace the data records used for
	displaying the completed texts web page. It will delete the current data
	records and replace them with those records in the file you upload.</p>
	<p>Please make sure that you are uploading a tab delimited file (with Macintosh line breaks) that 
	contains the following fields in the order shown:
	<ol>
	<li>process status
	<li>call number
	<li>volume
	<li>selector
	<li>book id
	<li>author
	<li>title
	<li>page count
	</ol>
	</p>
	<form action="uploadcompletedtext.php" method="post" enctype="multipart/form-data">
	File to upload:<br>
	<input type="file" name="books" size="40"><br>
	<input type="submit" name="upload" value="Upload it!">
	</form>
	
<?php else : ?>
<?php
	/* This is what happens after the form above is submitted. */
	print("<p>Status of the file upload...</p>");
	/* Identify the temporary file location of the data that was uploaded. */
	$fileMimeType = $_FILES['books']['type'];
	$fileSize = $_FILES['books']['size'];
	$uploadedTempFileName = $_FILES['books']['tmp_name'];
	$fileUploadErrorCode = $_FILES['books']['error'];
	
	$fileContents = file_get_contents("$uploadedTempFileName");
		
	/* If the file contents were successfully read then proceed to process it. */
	if ($fileContents === false) {
		/* Error reading the file. Let the user know. */
		print("<p>Error! There was a problem reading the uploaded file. 
				Please try again. (Nothing was deleted from the existing
				database.)</p>");
	} else {
		/* The file is ready to parse and be put into the database. */
		
		/* Take the file and put each line into a separate array element. */
		$uploadedRecordArray = split("\r",$fileContents);
		$numberUploadedRecords = count($uploadedRecordArray);
		
		/* Check to see if the last line in the file is empty. */
		if (trim($uploadedRecordArray[$numberUploadedRecords - 1]) == "") {
			$numberUploadedRecords--;
		}
		
		if ($numberUploadedRecords > 0) {
			print("<p>Number of records found in uploaded file = $numberUploadedRecords</p>");
			/*
			 * Identify how many fields exist in a record. And make sure that
			 * it jives with what we are expecting.
			 */
			$fieldsArray = split("\t",$uploadedRecordArray[0]);
			$numberOfFields = count($fieldsArray);
			if ($numberOfFields == $booksFieldCount) {
				/* Begin by deleting the existing records from the db. */
				$sqlQuery = "select callNumber from books";
				$books = submitQuery($sqlQuery,"select");
				$sqlQuery = "delete from books";
				$delete = submitQuery($sqlQuery,"delete");
				print("<p>Deleted $books[1] existing records found in the database.<p>");
				
				/* Now go through the uploaded data and insert new records. */
				$insertedRecords = 0;
				for ($i=0; $i < $numberUploadedRecords; $i++) {
					/* Get each field value for the record being imported. */
					$fieldValuesArray = split("\t",$uploadedRecordArray[$i]);
					
					/* Create the query string to insert the new record. */
					$sqlQuery = "insert into books (processStatus,callNumber,volume,selector,bookID,author,title,pageCount) values(";
					foreach ($fieldValuesArray as $value) {
						$sqlQuery .= "'" . addslashes(trim($value)) . "',";
					}
					$sqlQuery = rtrim($sqlQuery,",");
					$sqlQuery .= ")";
				
					/* Add the record to the database. */
					$insert = submitQuery($sqlQuery,"insert");
					
					/*
					 * If an error occurred when inserting the record then
					 * generate a warning message.
					 */
					if ($insert[1] != 1) {
						printf("<p>Warning! Record %s contains invalid data.
								<br>Query: %s<p>",($i + 1),$sqlQuery);
					} else {
						$insertedRecords++;
					}
				}
				print("<p>Inserted $insertedRecords new records into the database.</p>");
			
				/*
				 * Now that the records were updated, store the current
				 * date/time of the upload.
				 */
				$nowDateTime = date("Y-m-d H:i:s",time());
				$sqlQuery = "update fileupload set booksUpdate='$nowDateTime'";
				$update = submitQuery($sqlQuery,"update");
				
				/* Indicate the upload was completed successfully. */
				if ($update[1] == 1) {
					print("<p>The book information was successfully updated 
							as of $nowDateTime.</p>");
				} else {
					print("<p>Warning! Unable to modify the upload date and time.</p>");
				}
			} else {
				print("<p>Error! Your file contains $numberOfFields fields. 
						The database is expecting $booksFieldCount.</p>");
			}
		} else {
			print("<p>Empty file! Nothing done.</p>");
		}
	}

?>
<?php endif; ?>

</body>
</html>
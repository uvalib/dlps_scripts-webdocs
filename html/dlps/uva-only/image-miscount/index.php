<?php 
/* 
 * @(#)index.php		1.00	2007/01/11
 *
 * Copyright (c) 2006 Digital Library Production Services, University of Virginia Library
 * All rights reserved.
 *
 * This script displays a selection list of projects to choose from for which you can check
 * the image miscount between the Iview data created in DLPS and the IRIS data exported by 
 * Fine Arts.
 *
 * @version		1.00 2007/01/11
 * @author		Jack Kelly
 *
 * 2007/11/05 - (jlk4p) Change selection criteria only to display projects that are not
 *				finished in the list.
 */
 
require_once("database.php");
require_once("functions.php");

if (isset($_POST['project']) and ($_POST['project'] != "")) {
	$project = $_POST['project'];
} else {
	$project = '';
}
?>

<html>
<head>
<title>Image Project Miscount - Analysis Report</title>
<link rel="stylesheet" type="text/css" href="../tracksys/inc/tracksys.css">
</head>

<body>
<h2>Image Project Miscount - Analysis Report</h2>
<form name="projectForm" method="POST" action="index.php">

<table cellpadding="4">
<tr>
<td></td>
</tr>
<tr>
<td class="label">Image Project:</td>
<td>
<select name="project" size="1" onChange="projectForm.submit()">
	<option value="">choose...</option>
	<?php
	/* Create selection list of existing projects. */
	$query = "select projectName from projects where step3Started is null or step3Finished is null order by projectName";
	$result = executeSQL($database,$query,'select');
	while ($record = mysql_fetch_assoc($result[0])) {
		print("<option value=\"$record[projectName]\"");
		if ($record['projectName'] == $project) {
			print(" selected");
		}
		print(">$record[projectName]</option>\n");
	}
	?>
</select>
</td>
</tr>
</table>

</form>

<p><a href="/dlps">Return</a> to the DLPS Resources page.</p>

<hr>

<?php
/* If the form has been submitted, display the results of the projectImageMiscount script. */
if ($project != '') {
	print("<pre>\n");
	system("/Users/jlk4p/Sites/dlps/image-miscount/cgi-dlps/projectImageMiscount.pl $project");
	print("</pre>\n");
}
?>
</body>
</html>

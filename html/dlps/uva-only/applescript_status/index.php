<?php 
/* 
 * @(#)index.php		1.00	2006/06/13
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
 * 2006/06/20 - (jlk4p) Testing of timestamp change required pinting to another test table,
 *				but this was switched back to the production database table.
 * 2007/11/05 - (jlk4p) Change selection criteria so only unfinished projects show up in the
 *				list and add link to return to main tracking page.
 */
 
require_once("database.php");
require_once("functions.php");
?>

<html>
<head>
<title>AppleScript Status</title>
<link rel="stylesheet" type="text/css" href="../tracksys/inc/tracksys.css">
</head>

<body>
<h2>AppleScript Status</h2>
<form name="projectForm" method="POST" action="applescriptStatus.php">

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
		print("<option value=\"$record[projectName]\">$record[projectName]</option>\n");
	}
	?>
</select>
</td>
</tr>
</table>

</form>

<p><a href="/dlps">Return</a> to the DLPS Resources page.</p>

</body>
</html>

' marc2tei.vbs - a script to facilitate converting a MARC binary file to a TEI XML file in a
'   Windows environment
' Greg Murray <gpm2a@virginia.edu> (Digital Library Production Services, Univ. of Virginia Library)
' Written: 2006-10-26
' Last modified: 2006-11-30
' Version: 1.1

' This script is written in VBScript, the Windows scripting language. For more information, see
' _VBScript in a Nutshell_ published by O'Reilly. This title is available on the Safari Books
' Online service, to which UVA Library has a subscription:
'   http://proquest.safaribooksonline.com/0596004885

' This script performs several steps:
'   - gather parameters needed for the conversion
'   - run Java program from Library of Congress to convert MARC binary to MARC XML
'   - run a Perl script to alter the MARC XML slightly so that Saxon can process it
'   - run XSLT processor (Saxon) using DLPS stylesheet (marc2tei.xsl) to convert MARC XML to TEI
'     header XML
'   - run Perl scripts to normalize special characters, fix date values, etc. in the TEI XML

' This script runs in a Windows environment. It can be started in three ways:
'   * by double-clicking the script file (marc2tei.vbs)
'   * by dragging a MARC binary file and dropping it on the script file (in this case the script
'     will not ask for the MARC file to convert; the dropped file will be converted)
'   * by integrating the script into the Oxygen XML editor:
'       - Open Oxygen; go to Tools --> External Tools --> Preferences
'       - Click New to set up a new external tool
'       - Under "Name", enter "MARC to TEI"
'       - Under "Command line" enter "WScript.exe" followed by the full path to this script file.
'         For example: WScript.exe C:\DLPS\marc2tei.vbs
'       - Click OK; click OK again to dismiss the Preferences window
'       - To run the script, go to Tools --> External Tools --> MARC to TEI, or just click
'         "MARC to TEI" in the main Oxygen tool bar.

' Requirements for this script to work:
'   - Java runtime engine must be installed
'   - Perl must be installed
'   - The DLPS workspace \\pogo.lib.virginia.edu\text must be mapped as a network drive
'   - Files required on pogo.lib:
'       [DRIVE]:\05teiHeader\bin\marcxml\marcxml.jar  (from http://www.loc.gov/standards/marcxml/ )
'       [DRIVE]:\05teiHeader\bin\marcxml\marc4j.jar   (from http://www.loc.gov/standards/marcxml/ )
'       [DRIVE]:\05teiHeader\bin\saxon\saxon8.jar     (from http://saxon.sourceforge.net/ )
'       [DRIVE]:\05teiHeader\bin\marc2tei\marc2tei.xsl
'       [DRIVE]:\05teiHeader\bin\marc2tei\strings.xsl
'       [DRIVE]:\05teiHeader\bin\marc2tei\tweakMarcXml.pl
'       [DRIVE]:\05teiHeader\bin\marc2tei\flipent.pl
'       [DRIVE]:\05teiHeader\bin\marc2tei\diacritic2composite.pl
'       [DRIVE]:\05teiHeader\bin\marc2tei\header_date_values.pl
'       [DRIVE]:\05teiHeader\bin\marc2tei\clean_teiHeader.pl
'   - Local directories required:
'       C:\temp  (for writing temp files)

' Note: If the Perl interpreter gives unexpected syntax-error messages, try switching the
' Perl (.pl) files to DOS line endings (rather than Unix line endings) or vice versa.

'==================================================================================================
' MAIN LOGIC
'==================================================================================================

'--------------------------------------------------------------------------------------------------
' Set up
'--------------------------------------------------------------------------------------------------

' Require explicit declaration of variables
Option Explicit

' Declare constants for reading/writing text files
Const ForReading = 1
Const ForWriting = 2

' Declare global variables
Dim answer              'integer (MsgBox) or string (InputBox); user's response to a dialog box
Dim baseInfileName      'string; base name of input file (used for default name of output file)
Dim binDir              'string; path (not including the drive) to bin directory on DLPS workspace
Dim binPath             'string; full path (including drive) to bin directory on DLPS workspace
Dim command             'string; a command-line command
Dim configFile          'string; full path to config file
Dim defaultBinDir       'string; default value for path to bin directory on DLPS workspace
Dim defaultDrive        'string; default value for mapped drive for DLPS workspace
Dim defaultEditorExe    'string; default path for preferred XML editor
Dim defaultOutputFile   'string; default name of output file (which user can change as desired)
Dim defaultTempDir      'string; default value for temporary directory
Dim dialogOpenFile      'object; CommonDialog object, for displaying an "Open" file-selection dialog
Dim dlpsId              'string; DLPS ID of item being converted
Dim doDeleteMarcXmlFile 'boolean; indicates whether to delete temporary MARC XML file when finished
Dim doIndHeader         'boolean; indicates whether to create an independent TEI header
Dim drive               'string; mapped drive for DLPS workspace, as in "E:"
Dim editorExe           'string; full path to the .exe file for the user's preferred XML editor
Dim inputFile           'string; full path to input (MARC) file
Dim lastDlpsId          'string; DLPS ID from last conversion
Dim lastInputDir        'string; path to input directory from last conversion
Dim lastOutputDir       'string; path to output directory from last conversion
Dim lastTitleControl    'string; title control number from last conversion
Dim lastVirgoId         'string; Virgo ID from last conversion
Dim marcXmlFile         'string; full path to temporary MARC XML file
Dim msg                 'string; message to user
Dim outputDir           'string; full path to directory where output (TEI XML) file will be written
Dim outputFile          'string; full path to output (TEI XML) file
Dim process             'object; WshScriptExec object representing an external command-line process
Dim tempDir             'string; full path to temporary directory
Dim titleControl        'string; title control number of item being converted
Dim virgoId             'string; Virgo ID of item being converted

' Set default values, used in absence of a config file
defaultDrive = "X:"
defaultBinDir = "\05teiHeader\bin"
defaultTempDir = "C:\temp"
defaultEditorExe = "C:\Program Files\Oxygen XML Editor 7.2\oxygen7.2.exe"
doDeleteMarcXmlFile = True

' Set up label to use in title bar of message boxes
Dim msgBoxTitle
msgBoxTitle = "DLPS MARC to TEI Converter"

' This script requires Windows Scripting Host (WSH) version 5.6 or higher
If WScript.Version < 5.6 Then
	msg = "This script requires Windows Scripting Host version 5.6 or higher. Your version is: "
	msg = msg & WScript.Version
	MsgBox msg, vbExclamation, msgBoxTitle
	WScript.Quit  'terminate script execution
End If

' Set up FileSystemObject, for accessing the Windows file system
Dim fs
Set fs = CreateObject("Scripting.FileSystemObject")

' Set up Shell object, for executing command-line commands
Dim shell
Set shell = WScript.CreateObject("WScript.Shell")

' Set up RegExp object, for testing strings using regular expressions
Dim regex
Set regex = New RegExp

' Get current year
Dim thisYear
thisYear = Year( Date() )

Dim newline  'string containing one newline indicator (carriage return + line feed)
newline = vbCrLf

' Config file lives in same directory as script file and is named marc2tei.ini
configFile = fs.BuildPath(fs.GetParentFolderName(WScript.ScriptFullName), "marc2tei.ini")

' Get settings from config file
Call getConfigSettings(configFile)

If editorExe = "" Then
	editorExe = defaultEditorExe
End If

' Get drive letter mapped to DLPS workspace (if not already found in config file)
If drive = "" Then
	msg = "Enter the letter (A-Z) of the mapped drive for the DLPS workspace:"
	drive = InputBox(msg, msgBoxTitle, defaultDrive)
	If drive = "" Then
		'user clicked Cancel
		WScript.Quit  'terminate script execution
	End If
End If

' Validate input; drive must be one letter followed by colon
drive = UCase( Trim(drive) )  'convert to upper case; trim leading/trailing whitespace
regex.Pattern = "[\\/]$"
drive = regex.Replace(drive, "")  'remove final backslash or slash, if any
regex.Pattern = ":$"
If Not regex.Test(drive) Then
	drive = drive & ":"  'append colon
End If
regex.Pattern = "^[A-Z]:$"
If Not regex.Test(drive) Then
	msg = "Bad value: " & drive & newline & "The drive for the DLPS workspace must be specified as 'X:' where X is any letter from A to Z. Cannot continue."
	MsgBox msg, vbExclamation, msgBoxTitle
	WScript.Quit  'terminate script execution
End If

' Make sure drive exists
If Not fs.DriveExists(drive) Then
	msg = "Drive " & drive & " does not exist or is not connected. Cannot continue."
	MsgBox msg, vbExclamation, msgBoxTitle
	WScript.Quit  'terminate script execution
End If

' Make sure bin directory exists (where the required Java programs live)
If binDir = "" Then
	binDir = defaultBinDir
End If
binPath = fs.BuildPath(drive, binDir)
If Not fs.FolderExists(binPath) Then
	msg = "Directory " & binPath & " (directory for program files) does not exist or is not accessible. Cannot continue."
	MsgBox msg, vbExclamation, msgBoxTitle
	WScript.Quit  'terminate script execution
End If

' Make sure temp directory exists
If tempDir = "" Then
	tempDir = defaultTempDir
End If
If Not fs.FolderExists(tempDir) Then
	msg = "Directory " & tempDir & " (directory for temporary files) does not exist or is not accessible. Cannot continue."
	MsgBox msg, vbExclamation, msgBoxTitle
	WScript.Quit  'terminate script execution
End If

' Get path of MARC binary input file
' If user drag-and-dropped a file onto the script file, that file will be the first argument
If WScript.Arguments.Count > 0 Then
	inputFile = WScript.Arguments.Item(0)
Else
	msg = "In the file-selection window that follows, please select the MARC file to convert..."
	MsgBox msg, vbInformation, msgBoxTitle

	' Display a standard "Open" file-selection dialog, for selecting the MARC input file
	Set dialogOpenFile = CreateObject("UserAccounts.CommonDialog")
	dialogOpenFile.Filter = "MARC files (*.marc)|*.marc|All files|*.*"
	If lastInputDir <> "" Then
		dialogOpenFile.InitialDir = lastInputDir
	End If
	answer = dialogOpenFile.ShowOpen
	If answer = 0 Then
		'user clicked Cancel
		WScript.Quit  'terminate script execution
	End If
	inputFile = dialogOpenFile.FileName
	Set dialogOpenFile = Nothing
End If

' Make sure input file exists
If Not fs.FileExists(inputFile) Then
	msg = "MARC input file " & inputFile & " does not exist or is not accessible. Cannot continue."
	MsgBox msg, vbExclamation, msgBoxTitle
	WScript.Quit  'terminate script execution
End If

' Get DLPS ID/Virgo ID/title control
msg = "Enter the DLPS ID:"
msg = msg & newline & newline & "If you leave this blank, the <idno type='DLPS ID'>"
msg = msg & " field will be empty in the resulting TEI header."
dlpsId = InputBox(msg, msgBoxTitle, lastDlpsId)

msg = "Enter the Virgo ID:"
msg = msg & newline & newline & "If you leave this blank, the <idno type='UVa Virgo ID'>"
msg = msg & " field will be empty in the resulting TEI header."
virgoId = InputBox(msg, msgBoxTitle, lastVirgoId)

' Title control number is optional if the MARC file contains only one record.
' If TCN is supplied, the MARC record corresponding to that TCN will be converted to TEI.
' If TCN is missing, the first MARC record in the MARC XML file will be converted to TEI.
msg = "Enter the title control number:"
msg = msg & newline & newline & "To specify which MARC record to convert to TEI, enter the title "
msg = msg & "control number here. If the MARC file contains only one record, you can leave this blank."
titleControl = InputBox(msg, msgBoxTitle, lastTitleControl)

' Determine TEI header type (regular or independent)
msg = "Create an independent TEI header?" & newline
msg = msg & "(Click Yes for independent header, No for regular header, or Cancel to quit)"
answer = MsgBox(msg, vbQuestion + vbYesNoCancel + vbDefaultButton2, msgBoxTitle)
Select Case answer
	Case vbYes
		doIndHeader = True
	Case vbCancel
		WScript.Quit  'terminate script execution
	Case Else
		doIndHeader = False
End Select

' Determine default output file
' If doing an independent header, use title control number as default base filename
' If doing a regular header, use DLPS ID as default base filename
' If title control or DLPS ID is not available, use base filename of input file
baseInfileName = fs.GetBaseName(inputFile)
If doIndHeader Then
	' independent header; use title control number, if available
	If titleControl = "" Then
		defaultOutputFile = baseInfileName
	Else
		defaultOutputFile = titleControl
	End If
Else
	' regular header; use DLPS ID, if available
	If dlpsId = "" Then
		defaultOutputFile = baseInfileName
	Else
		defaultOutputFile = dlpsId
	End If
End If
defaultOutputFile = defaultOutputFile & "_header.xml"

If lastOutputDir = "" Then
	' output directory preference unknown; use same directory as input file
	lastOutputDir = fs.GetParentFolderName(inputFile)
End If

defaultOutputFile = fs.BuildPath(lastOutputDir, defaultOutputFile)

' Get path of TEI XML output file
msg = "Enter the full path to the TEI XML output file:"
outputFile = InputBox(msg, msgBoxTitle, defaultOutputFile)
If outputFile = "" Then
	'user clicked Cancel
	WScript.Quit  'terminate script execution
End If

' Make sure output directory exists
outputDir = fs.GetParentFolderName(outputFile)
If Not fs.FolderExists(outputDir) Then
	msg = "Output directory " & outputDir & " does not exist or is not accessible. Cannot continue."
	MsgBox msg, vbExclamation, msgBoxTitle
	WScript.Quit  'terminate script execution
End If

' Test whether output file already exists; if so, ask whether to overwrite
If fs.FileExists(outputFile) Then
	msg = "Output file " & outputFile & " already exists. Do you want to replace it?"
	answer = MsgBox(msg, vbQuestion + vbOKCancel, msgBoxTitle)
	If answer = vbCancel Then
		WScript.Quit  'terminate script execution
	End If
End If

' Save settings to config file
lastInputDir = fs.GetParentFolderName(inputFile)
lastOutputDir = outputDir
lastDlpsId = dlpsId
lastVirgoId = virgoId
lastTitleControl = titleControl
Call saveConfigSettings(configFile)


'--------------------------------------------------------------------------------------------------
' Convert MARC binary to MARC XML using Java program from Library of Congress
'--------------------------------------------------------------------------------------------------

' Set file to be used for MARC XML output; this file is temporary and is the intermediary between
' MARC binary and TEI header XML
marcXmlFile = fs.BuildPath(tempDir, "dlps_temp_marc.xml")

command = "java -classpath " & binPath & "\marcxml\marcxml.jar;" & binPath & "\marcxml\marc4j.jar"
command = command & " gov.loc.marcxml.MARC2MARC21slim " & inputFile & " " & marcXmlFile

' Run Java MARC-to-MARCXML converter
Call runShellCommand(command, "MARC binary to MARC XML conversion")

' Make sure MARC XML file exists and is not empty
If fs.FileExists(marcXmlFile) Then
	Dim f  'File object
	Set f = fs.GetFile(marcXmlFile)
	If f.Size = 0 Then
		msg = "An error occurred while converting MARC binary to MARC XML."
		msg = msg & " The MARC XML file " & marcXmlFile & " is empty (contains zero bytes)."
		MsgBox msg, vbExclamation, msgBoxTitle
		WScript.Quit  'terminate script execution
	End If
Else
	msg = "An error occurred while converting MARC binary to MARC XML."
	msg = msg & " The MARC XML file " & marcXmlFile & " does not exist."
	MsgBox msg, vbExclamation, msgBoxTitle
	WScript.Quit  'terminate script execution
End If


'--------------------------------------------------------------------------------------------------
' Run Perl script to adjust MARC XML
'--------------------------------------------------------------------------------------------------

' Run Perl script (tweakMarcXml.pl) to remove attributes from <collection> element of MARC XML
' file, because the attributes prevent Saxon from processing the file
command = "perl " & binPath & "\marc2tei\tweakMarcXml.pl " & marcXmlFile
Call runShellCommand(command, "Perl script tweakMarcXml.pl")


'--------------------------------------------------------------------------------------------------
' Convert MARC XML to TEI header XML using DLPS marc2tei.xsl stylesheet and Saxon XSLT processor
'--------------------------------------------------------------------------------------------------

Dim headerTypeParam
If doIndHeader Then
	headerTypeParam = " standaloneHeader=true"
Else
	headerTypeParam = ""
End If

Dim dlpsIdParam
If dlpsId = "" Then
	dlpsIdParam = ""
Else
	dlpsIdParam = " dlpsID=" & dlpsId
End If

Dim virgoIdParam
If virgoId = "" Then
	virgoIdParam = ""
Else
	virgoIdParam = " virgoID=" & virgoId
End If

Dim titleControlParam
If titleControl = "" Then
	titleControlParam = ""
Else
	titleControlParam = " titleControl=" & titleControl
End If

command = "java -classpath " & binPath & "\saxon\saxon8.jar"    'set Java classpath
command = command & " net.sf.saxon.Transform -o " & outputFile  'run Saxon; specify output file (rather than printing to standard out)
command = command & " " & marcXmlFile                           'specify input file
command = command & " " & binPath & "\marc2tei\marc2tei.xsl"    'specify XSLT stylesheet
command = command & " quiet=true year=" & thisYear              'pass stylesheet parameters
command = command & headerTypeParam & dlpsIdParam               'pass stylesheet parameters
command = command & virgoIdParam & titleControlParam            'pass stylesheet parameters

' Run Saxon to transform MARC XML to TEI XML
Call runShellCommand(command, "MARC XML to TEI XML conversion")

' Make sure TEI XML file exists
If Not fs.FileExists(marcXmlFile) Then
	msg = "An error occurred while converting MARC XML to TEI XML."
	msg = msg & " The TEI XML output file " & outputFile & " does not exist."
	MsgBox msg, vbExclamation, msgBoxTitle
	WScript.Quit  'terminate script execution
End If


'--------------------------------------------------------------------------------------------------
' Run Perl scripts to normalize special characters, fix date values, etc. in TEI XML
'--------------------------------------------------------------------------------------------------

' Run flipent.pl to "flip" character entity references from hex to mnemonic/named entity references
command = "perl " & binPath & "\marc2tei\flipent.pl " & outputFile
Call runShellCommand(command, "Perl script flipent.pl")

' Run diacritic2composite.pl to convert use of combining diacritics (like e&comacute;) to a
' composite character (like &eacute;) when possible
command = "perl " & binPath & "\marc2tei\diacritic2composite.pl " & outputFile
Call runShellCommand(command, "Perl script diacritic2composite.pl")

' Run header_date_values.pl to fix common problems with date values in TEI header
command = "perl " & binPath & "\marc2tei\header_date_values.pl -C " & outputFile
Call runShellCommand(command, "Perl script header_date_values.pl")

' Run clean_teiHeader.pl to fix specific validation errors in TEI header
command = "perl " & binPath & "\marc2tei\clean_teiHeader.pl " & outputFile
Call runShellCommand(command, "Perl script clean_teiHeader.pl")


'--------------------------------------------------------------------------------------------------
' Finish
'--------------------------------------------------------------------------------------------------

MsgBox "Conversion completed", vbInformation, msgBoxTitle

' Delete temporary MARC XML file
If fs.FileExists(marcXmlFile) And doDeleteMarcXmlFile Then
	fs.DeleteFile(marcXmlFile)
End If

' Delete TEI backup file
If fs.FileExists(outputFile & ".bak") Then
	fs.DeleteFile(outputFile & ".bak")
End If

' Test whether XML editor exists; if not, provide file-selection dialog for finding preferred editor
If Not fs.FileExists(editorExe) Then
	msg = "The XML editor " & editorExe & " does not exist."
	msg = msg & " Do you want to locate your preferred XML editor now?"
	answer = MsgBox(msg, vbQuestion + vbOKCancel, msgBoxTitle)
	If answer = vbOK Then
		' Display a standard "Open" file-selection dialog
		Set dialogOpenFile = CreateObject("UserAccounts.CommonDialog")
		dialogOpenFile.Filter = "Programs (*.exe)|*.exe|All files|*.*"
		dialogOpenFile.InitialDir = "C:\Program Files"
		answer = dialogOpenFile.ShowOpen
		If answer = 0 Then
			'user clicked Cancel
			WScript.Quit  'terminate script execution
		End If
		editorExe = dialogOpenFile.FileName
		Call saveConfigSettings(configFile)
	End If
End If

' Open TEI XML file in user's preferred XML editor
If fs.FileExists(editorExe) Then
	command = editorExe & " " & outputFile
	Set process = shell.Exec(command)
End If


'==================================================================================================
' FUNCTIONS
'==================================================================================================

Sub getConfigSettings(path)

	' Reads text file containing script configuration settings

	' Parameters:
	'   path   string; full path to config file

	' For format of config file, see saveConfigSettings() below

	Dim handle         'TextStream object (file handle), for reading content of config file
	Dim line           'string; one line of config file
	Dim regexComment   'RegExp object for skipping comment lines (starting with ;)
	Dim regexNameValue 'RegExp object for finding name=value pairs in config file
	Dim oMatches       'Matches collection containing Match objects from evaluating a regular expression
	Dim nameValue      'Match object containing name=value pair
	Dim name           'string; name part of a name=value pair
	Dim value          'string; value part of a name=value pair

	Set regexComment = New RegExp
	regexComment.Pattern = "^;"

	Set regexNameValue = New RegExp
	regexNameValue.Pattern = "([^=]+)=([^=]+)"

	' Make sure config file exists
	If Not fs.FileExists(path) Then
		Exit Sub
	End If

	' Open config file and read it line by line; grab values from name=value pairs
	Set handle = fs.OpenTextFile(path, ForReading)
	Do While Not handle.AtEndOfStream
		line = handle.ReadLine
		If regexComment.Test(line) Then
			'this is a comment line; skip
		Else
			If regexNameValue.Test(line) Then
				'this line contains a (non-commented) name=value pair
				Set oMatches = regexNameValue.Execute(line)
				Set nameValue = oMatches.Item(0)
				name = Trim( nameValue.Submatches.Item(0) )
				value = Trim ( nameValue.Submatches.Item(1) )

				If name = "drive" Then drive = value
				If name = "binDir" Then binDir = value
				If name = "tempDir" Then tempDir = value
				If name = "lastInputDir" Then lastInputDir = value
				If name = "lastDlpsId" Then lastDlpsId = value
				If name = "lastVirgoId" Then lastVirgoId = value
				If name = "lastTitleControl" Then lastTitleControl = value
				If name = "lastOutputDir" Then lastOutputDir = value
				If name = "deleteMarcXmlFile" Then
					If value = "True" or value = "true" Then
						doDeleteMarcXmlFile = True
					Else
						doDeleteMarcXmlFile = False
					End If
				End If
				If name = "editorExe" Then editorExe = value
			End If
		End If
	Loop
	handle.Close

End Sub

'--------------------------------------------------------------------------------------------------

Sub runShellCommand(command, description)

	' Runs a shell command, waits for the process to finish, gets errors from standard error;
	' if errors, displays errors and terminates script execution

	' Parameters:
	'   command       string; command to run
	'   description   string; brief description of command (used in display of error messages)

	Dim errors   'string; messages sent by a command-line process to standard error

	Set process = shell.Exec(command)

	' Wait for process to finish
	Do While process.Status = 0  'zero (WshRunning) indicates process is running
		WScript.Sleep 100
	Loop

	' Get messages sent to standard error, if any
	errors = process.StdErr.ReadAll()

	' Test for errors
	If errors <> "" Then
		If description = "" Then
			msg = "An error occurred:"
		Else
			msg = "An error occurred while running " & description & ":"
		End If
		msg = msg & newline & newline & errors
		MsgBox msg, vbExclamation, msgBoxTitle
		WScript.Quit  'terminate script execution
	End If

End Sub

'--------------------------------------------------------------------------------------------------

Sub saveConfigSettings(path)

	' Writes a text file containing script configuration settings

	' Parameters:
	'   path   string; full path to config file

	' Format of config file is typical .ini format: comments start with ; (semicolon) and entries
	' are name/value pairs separated by = (equals sign). Typical entry:
	'	; Temporary directory
	'	tempDir=C:\temp

	Dim handle  'TextStream object (file handle), for writing to config file

	' Open config file for writing
	Set handle = fs.OpenTextFile(path, ForWriting, True)

	handle.WriteLine("; marc2tei.ini - Config file for marc2tei.vbs")
	handle.WriteBlankLines(1)

	handle.WriteLine("; Drive mapped to DLPS workspace")
	handle.WriteLine("drive=" & drive)
	handle.WriteBlankLines(1)

	handle.WriteLine("; 'bin' directory containing required programs and files")
	handle.WriteLine("binDir=" & binDir)
	handle.WriteBlankLines(1)

	handle.WriteLine("; Temporary directory")
	handle.WriteLine("tempDir=" & tempDir)
	handle.WriteBlankLines(1)

	handle.WriteLine("; Input directory from the last conversion")
	handle.WriteLine("lastInputDir=" & lastInputDir)
	handle.WriteBlankLines(1)

	handle.WriteLine("; DLPS ID from the last conversion")
	handle.WriteLine("lastDlpsId=" & lastDlpsId)
	handle.WriteBlankLines(1)

	handle.WriteLine("; Virgo ID from the last conversion")
	handle.WriteLine("lastVirgoId=" & lastVirgoId)
	handle.WriteBlankLines(1)

	handle.WriteLine("; Title control number from the last conversion")
	handle.WriteLine("lastTitleControl=" & lastTitleControl)
	handle.WriteBlankLines(1)

	handle.WriteLine("; Output directory from the last conversion")
	handle.WriteLine("lastOutputDir=" & lastOutputDir)
	handle.WriteBlankLines(1)

	handle.WriteLine("; Delete temporary MARC XML file after conversion?")
	handle.WriteLine("deleteMarcXmlFile=" & doDeleteMarcXmlFile)
	handle.WriteBlankLines(1)

	handle.WriteLine("; Location of preferred XML editor")
	handle.WriteLine("editorExe=" & editorExe)

	handle.Close

End Sub

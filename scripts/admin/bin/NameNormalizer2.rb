#!/usr/bin/ruby
BEGIN {
	puts 
	puts "UVA Library script #$0 running on #{RUBY_PLATFORM} using ruby version #{RUBY_VERSION}"
	puts 
}
# a simple object for holding info about manipulated TEI elements
class Element
  def initialize(qName, value, line_number)
    qName=@qName
    value=@value
    lineNumber=@lineNumber
  end
  def to_s
    @qName
  end
  def qName
    @qName
  end
  def qName=(new_qName)
    @qName=new_qName
  end
  def value
    @value
  end
  def value=(new_value)
    @value=new_value
  end
  def lineNumber
    @lineNumber
  end
  def lineNumber=(new_lineNumber)
    @lineNumber=new_lineNumber
  end
end

# this is a testing area for a few ruby basics
# these requires are not used by this script

require 'rexml/document' # for using xpath
require 'yaml' # for reading/writing text files 
require 'optparse'

# initialize our options

interact = false; renameAuthorize = false; # second flag is for interactive filename normalization
verbose = false
backup = false 
debug = false 
usage = false 
check = false

if check : puts "check-values=" + check.to_s.upcase end

filename=Array.new

opts = OptionParser.new
opts.on( "-i", "--interactive" )  { interact = true}
opts.on( "-v", "--verbose" ) 	  { verbose = true }
opts.on( "-b", "--backup-files" ) { backup = true }
opts.on( "-d", "--debug" ) 		  { debug = true }
opts.on( "-c", "--check" ) 		  { check = true }
opts.on( "-?", "-h", "--help" )   { usage = true }

leftOver = opts.parse($*)

if usage then
	puts " "
	puts $0.gsub(/.*\//, '') + " is a ruby command-line script to normalize certain names in TEI XML files."
	puts " "
	puts "usage: #{$0} [-ivbd] *.xml"
	puts "examples: #{$0} -ib myfile.xml   --> search and replace interactively on myfile.xml, making backup myfile.bkp before starting"
	puts "          #{$0} -v ../*.xml   --> search and replace on all .xml files in directory above this one, printing lots of info along the way"
	puts " "
	exit
end


if debug || verbose then 
	puts 
	puts "YOUR OPTIONS:"
	puts "=========================="
	puts "interactive mode: " + interact.to_s.upcase
	puts "verbose mode:     " + verbose.to_s.upcase
	puts "with-backups:     " + backup.to_s.upcase
	puts "debug:            " + debug.to_s.upcase
  puts "check-values:     " + check.to_s.upcase
	puts "=========================="
	puts 
	sleep 2
end

if debug then
	puts "Remainder = #{leftOver.join(', ')}"
	puts "leftOver is type #{leftOver.class}"
	puts leftOver.inspect 
end

# treat opts remainder as an array, to permit file globbing

filenames = leftOver.to_a
if filenames.empty? then
	if verbose || interact 
	then 
		puts "No files specified.  Should I work on xml files in current directory? (Y/n)"
		myConsent = $stdin.gets.chomp
		if myConsent =~ /n/i 
		then
			puts "Goodbye!" 
			exit 0 
		end
	end
	filenames=Dir.glob("*.xml")
end

puts "object 'filenames': "+ filenames.inspect
if filenames[0] === filenames[-1]
  then # see if we were passed a bare directory, if so, append "*.xml"
  if File.stat(filenames[0]).directory? : filenames=Dir.glob(filenames[0].to_s + "*.xml"); end
end

unless filenames.empty? 
then

	puts "processing the following files: "
	filenames.each do |f|
	  next unless File.stat(f).file?
	  puts "#{f}"
  end
  puts
  if verbose || debug : puts "Starting Search/Replace" end

myFiletally=0
    
	filenames.each do |f| 
	  next unless File.stat(f).file?
		myFtest = "file not found"
		myFtest = "file exists" if File.exist?(f)
		if debug || ! debug then puts "\n#{f.to_s} " + myFtest end

	myResponse = String.new
	if interact
	  myQuery = String.new
		myQuery = "Do you want me to open #{f}? (Y[es]/n[o]/q[uit]/a[ll]) "
		if ! backup : myQuery = myQuery + " (there will be no backup!) " end
		print(myQuery) 
		myResponse = $stdin.gets
		myResponse = myResponse.chomp
	end
	next if myResponse =~ /n/i 
	break if myResponse =~ /q/i 
	interact=FALSE if myResponse =~ /a/i

#
# for each file: open (opt: make backup) and proceed to line-by-line processing
#

		File.open(f, "r+") do |file|
			if backup || ! backup 
			then 
				backupName = File.basename(f, ".*") + ".bkp"
				newFileName= File.basename(f, ".*") + ".new"
				myNewFile = File.open(newFileName, 'w+') 
				if debug && backup 
				then
					print "will open backup file -->#{backupName}<--  " 
					`cp -p "#{f}" "#{backupName}"`;
					unless $?.exitstatus == 0 : puts "Unable to make backup for #{f} .... exiting #{$0}." ; exit;
					else
						puts "\tbackup saved."
					end
 				end
		sleep 1
end
#			myDlps = false; myTei2 = false ; myIdno = false;
			myDlps = Element.new('myDlps', '', '-1'); myTei2 = Element.new('myTei2', '', '-1') ; myIdno = Element.new('myIdno', '', '-1');
			
			puts
#
# go through file line-by-line
#
	  		while line = file.gets
	    		# print out any line that has a field likely to contain filename (e.g. <?dlps id="VerUnde"?>)
				# We're using \S+ (one or more non-space chars) to grab any possible id attribute value
	    		if line =~ /^<\?(dlps) id="(\S+)"\?>/ || line =~ /^<(TEI\.2) id="(\S+)">/ || line =~ /^<(idno) type="etc">(.+)<\/idno>/i 
				then
					elementName = $1 ; attrContent = $2; newLine = String.new
#					puts "#{elementName} and #{attrContent} were found by regexp."
					if elementName == 'dlps'
					  myDlps.qName = elementName; myDlps.value=attrContent.downcase; myDlps.lineNumber = $. ; 
						newLine = "<?#{elementName} id=\"" + attrContent.downcase + "\"?>\n"
					elsif  elementName == 'TEI.2' 
					  myTei2.qName = elementName; myTei2.value=attrContent.downcase; myTei2.lineNumber = $. ; 
						newLine = "<#{elementName} id=\"" + attrContent.downcase + "\">\n"
					elsif elementName == 'idno' 
					  myIdno.qName = elementName; myIdno.value=attrContent.downcase; myIdno.lineNumber = $. ; 
						newLine = "<#{elementName} type=\"ETC\">" + attrContent.downcase + "</idno>\n"
					end
	 				if debug || verbose then puts line; puts newLine; end
					myNewFile.write newLine
				else
					myNewFile.write line
				end
	  		end
			
# two optional tests (see flag '-c'): consistency of data and filenames; filename is lowercase
			if check or ! check
			  then
			  print("Checking...")
# check three values against each other and their filename
			  unless ( (myDlps.value == myTei2.value) && (myDlps.value == myIdno.value) && (myIdno.value == File.basename(f, ".*" )) ) then 
			    puts; warn "WARNING: TeiHeader info looks incorrect!!\n\n";
			    print("Filename: \t", File.basename(f), "\n")
			    print "myDlps: \t#{myDlps.value}" ; if myDlps.value != File.basename(f, ".*" ).downcase then print(" <------- see line ", myDlps.lineNumber ,"\n"); else print "\n" end
			    print "myTei2: \t#{myTei2.value}" ; if myTei2.value != File.basename(f, ".*" ).downcase then print(" <------- see line ", myTei2.lineNumber ,"\n"); else print "\n" end
			    print "myIdno: \t#{myIdno.value}" ; if myIdno.value != File.basename(f, ".*" ).downcase then print(" <------- see line ", myIdno.lineNumber ,"\n"); else print "\n" end
			    puts
			    			    sleep 2
		    else
		      print "done.\n"
		    end
# check filename against lowercase version of itself
        if File.basename(f) != File.basename(f).downcase
		      then
		      print "Looks like #{File.basename(f)} needs to be renamed if you want an exact match with internal identifiers.\n"
          if renameAuthorize==true then puts "normalizing filename: changing to #{File.basename(f)}";
		      elsif renameAuthorize==false then
		      print "Do you want to change this filename to lowercase? (/N[o]/y[es]/q[uit]/a[ll]) "
		      myResponse = $stdin.gets
      		myResponse = myResponse.chomp
      		  if myResponse =~ /q/i : print("#{$0} quitting execution. #{myFiletally} of #{filenames.length} files read"); exit end
      		  if myResponse =~ /a/i : myResponse="y"; renameAuthorize=true; end
    		    if myResponse =~ /y/i 
      		  then
      		  puts "Ok. attempting to rename #{f} to #{f.downcase}."
      		  File.rename(f, f.downcase) unless File.exist?(f.downcase)
      		  if File.exist?(f.downcase) then puts "File rename successful."; sleep 2; end
    		  else puts "Skipping rename."; sleep 1
      		  end
    		  end
		    end
      else
        puts "Skipping consistency checks.  This is now YOUR problem..."
        sleep 2
		  end
#
# move temporary file into sourcefile's location
#				
`mv #{newFileName} #{f}`
if $?.exitstatus != 0 : puts "Error moving #{newFileName} to #{f}" ; sleep 2; puts ; end
		end
	myFiletally +=1	
	end
end
puts
myPercentage = (myFiletally.to_f / filenames.length.to_f)*100
print("#{$0} finished execution. #{myFiletally} of #{filenames.length} files read (", myPercentage,"%) ")
if backup : print "\t backups have extension .bkp" end
puts
exit

SAXON_PATH='/shares/admin/bin/text/jars'
CP="$SAXON_PATH/saxon_6.5.4/saxon.jar:$SAXON_PATH/saxon_6.5.4/saxon-xml-apis.jar"

java -cp $CP com.icl.saxon.StyleSheet -l -o dlpsTextScripts_NEW.html dlpsTextScripts.xml scripts.xsl source=dlpsTextScripts.xml

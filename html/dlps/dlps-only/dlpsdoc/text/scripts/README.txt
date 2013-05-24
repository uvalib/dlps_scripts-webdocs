To update the HTML file in this directory:

  * Edit dlpsTextScripts.xml
  * Validate dlpsTextScripts.xml against scripts.dtd
  * Process dlpsTextScripts.xml using the scripts.xsl XSLT stylesheet
    - If working in Oxygen, run the transformation there and overwrite
      dlpsTextScripts.html
    - If working at the command line, run make_html.sh (which runs
      Saxon and overwrites dlpsTextScripts.html)

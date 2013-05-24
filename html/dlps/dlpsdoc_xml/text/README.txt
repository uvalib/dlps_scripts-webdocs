To update the online documentation in this directory:

  * Edit the XML file that requires updating

    - The files are in "teitech" format, a slightly modified form of
      TEI useful for technical documentation

    - The filenames should make it obvious which XML files correspond
      to which pages of online documentation. The XML files contain
      documentation for:

      ~ Workflows for books, TEI headers, newspapers, and
        non-transcription resources

      ~ QA procedures for books and newspapers

  * There is no need to generate an HTML file for display. The XML is
    converted to HTML dynamically by a Saxon servlet, using URLs such
    as this (parameters broken down for readability):

http://pogo.lib.virginia.edu/cgi-dlps/saxon/SaxonCGI.pl?
  source=http://pogo.lib.virginia.edu/dlps/dlpsdoc_xml/text/postkb_books.xml
  &style=http://pogo.lib.virginia.edu/dlps/xsl/teitech.xsl
  &filename=postkb_books.xml

    But if the Saxon servlet ever gets decommissioned, just manually
    run the XSLT stylesheet from the URL above against the XML file to
    generate a corresponding HTML file for web display.

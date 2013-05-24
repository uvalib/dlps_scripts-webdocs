# $Id: xmlxpath_05attrib.t,v 1.6 2004/03/26 16:30:40 mrodrigu Exp $

BEGIN 
  { if( eval( 'require XML::XPath'))
      { import XML::XPath; require Test; import Test; plan( tests => 6); }
    else
      { print "1..1\nok 1\n"; warn "skipping: XML::XPath not available\n"; exit; }
  }
 

use XML::Twig::XPath;
ok(1);

my $t= XML::Twig::XPath->new->parse( \*DATA);

ok( $t);

my @ids = $t->findnodes( '//BBB[@id]');
ok(@ids, 2);

my @names = $t->findnodes( '//BBB[@name]');
ok(@names, 1);

my @attribs = $t->findnodes( '//BBB[@*]');
ok(@attribs, 3);

my @noattribs = $t->findnodes( '//BBB[not(@*)]');
ok(@noattribs, 1);

exit 0;

__DATA__
<AAA>
<BBB id='b1'/>
<BBB id='b2'/>
<BBB name='bbb'/>
<BBB/>
</AAA>

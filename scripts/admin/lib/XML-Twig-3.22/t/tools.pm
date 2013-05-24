# $Id: tools.pm,v 1.3 2005/10/10 13:47:34 mrodrigu Exp $

use strict;

my $DEBUG=0;

{ my $test_nb;
  BEGIN { $test_nb=0; }
  sub is
    { my( $got, $expected, $message) = @_;
      $test_nb++; 

      if( ( !defined( $expected) && !defined( $got) ) || ($expected eq $got) ) 
        { print "ok $test_nb\n";
          warn "ok $test_nb $message\n" if( $DEBUG); 
          return 1;
        }
      else 
        { print "not ok $test_nb\n"; 
          if( length( $expected) > 20)
            { warn "$message:\nexpected: '$expected'\ngot     : '$got'\n"; }
          else
            { warn "$message: expected '$expected', got '$got'\n"; }
          return 0;
        }
    }

  sub isnt
    { my( $got, $expected, $message) = @_;
      $test_nb++; 

      if( $expected ne $got) 
        { print "ok $test_nb\n";
          warn "ok $test_nb $message\n" if( $DEBUG); 
          return 1;
        }
      else 
        { print "not ok $test_nb\n"; 
          if( length( $expected) > 20)
            { warn "$message:\ngot     : '$got'\n"; }
          else
            { warn "$message: got '$got'\n"; }
          return 0;
        }
    }



  sub matches
    { my $got     = shift; my $expected_regexp= shift; my $message = shift;
      $test_nb++; 

      if( $got=~ /$expected_regexp/) 
        { print "ok $test_nb\n"; 
          warn "ok $test_nb $message\n" if( $DEBUG); 
          return 1;
        }
      else { print "not ok $test_nb\n"; 
             warn "$message: expected to match /$expected_regexp/, got '$got'\n";
             return 0;
           }
    }

  sub ok
    { my $cond   = shift; my $message=shift;
      $test_nb++; 

      if( $cond)
        { print "ok $test_nb\n"; 
          warn "ok $test_nb $message\n" if( $DEBUG); 
          return 1;
        }
      else 
        { print "not ok $test_nb\n"; 
          warn "$message: false\n"; 
          return 0;
        }
    }

  sub nok
    { my $cond   = shift; my $message=shift;
      $test_nb++; 

      if( !$cond)
        { print "ok $test_nb\n"; 
          warn "ok $test_nb $message\n" if( $DEBUG); 
          return 1;
        }
      else 
        { print "not ok $test_nb\n"; 
          warn "$message: true (should be false): '$cond'\n"; 
          return 0;
        }
    }

  sub is_undef
    { my $cond   = shift; my $message=shift;
      $test_nb++; 

      if( ! defined( $cond)) 
        { print "ok $test_nb\n"; 
          warn "ok $test_nb $message\n" if( $DEBUG); 
          return 1;
        }
      else 
        { print "not ok $test_nb\n";
          warn "$message is defined: '$cond'\n"; 
          return 0;
        }
    }

  sub sys_ok
    { my $message=pop;
      $test_nb++; 
      my $status= system join " ", @_, "2>/dev/null";
      if( !$status)
        { print "ok $test_nb\n"; 
          warn "ok $test_nb $message\n" if( $DEBUG); 
        }
      else { print "not ok $test_nb\n"; warn "$message: $!\n"; }

    }



  sub is_like
    { my( $got, $expected, $message) = @_;
      $test_nb++; 

      if( clean_sp( $expected) eq clean_sp( $got)) 
        { print "ok $test_nb\n";
          warn "ok $test_nb $message\n" if( $DEBUG); 
          return 1;
        }
      else 
        { print "not ok $test_nb\n"; 
          if( length( $expected) > 20)
            { warn "$message:\nexpected: '$expected'\ngot     : '$got'\n"; }
          else
            { warn "$message: expected '$expected', got '$got'\n"; }
          warn "compact expected: ", clean_sp( $expected), "\n",
               "compact got:      ", clean_sp( $got), "\n";  
          return 0;
        }
    }

  sub etest
    { my ($elt, $gi, $id, $message)= @_;
      $test_nb++;
      unless( $elt)
        { print "not ok $test_nb\n    -- $message\n";
          warn "         -- no element returned";
          return;
        }
      if( ($elt->tag eq $gi) && ($elt->att( 'id') eq $id))
        { print "ok $test_nb\n"; 
          return $elt;
        }
      print "not ok $test_nb\n    -- $message\n";
      warn "         -- expecting ", $gi, " ", $id, "\n";
      warn "         -- found     ", $elt->tag, " ", $elt->id, "\n";
      return $elt;
    }
  


# element text test
sub ttest
  { my ($elt, $text, $message)= @_;
    $test_nb++;
    unless( $elt)
      { print "not ok $test_nb\n    -- $message\n";
        warn "         -- no element returned ";
        return;
      }
    if( $elt->text eq $text)
      { print "ok $test_nb\n"; 
        return $elt;
      }
    print "not ok $test_nb\n    -- $message\n";
    warn "          expecting ", $text, "\n";
    warn "          found     ", $elt->text, "\n";
    return $elt;
  }

# testing if the result is a  strings
sub stest
  { my ($result, $expected, $message)= @_;
   $result ||='';
   $expected ||='';
    $test_nb++;
    if( $result eq $expected)
      { print "ok $test_nb\n"; }
    else
      { print "not ok $test_nb\n    -- $message\n";  
        warn "          expecting ", $expected, "\n";
         warn"          found     ", $result, "\n";
      }
  }


# element sprint test
sub sttest
  { my ($elt, $text, $message)= @_;
    $test_nb++;
    unless( $elt)
      { print "not ok $test_nb\n    -- $message\n";
        warn "         -- no element returned ";
        return;
      }
    if( $elt->sprint eq $text)
      { print "ok $test_nb\n"; 
        return $elt;
      }
    print "not ok $test_nb\n    -- $message\n";
    warn "          expecting ", $text, "\n";
    warn "          found     ", $elt->sprint, "\n";
    return $elt;
  }

# testing if the result matches a pattern
sub mtest
  { my ($result, $expected, $message)= @_;
    $test_nb++;
    if( $result=~ /$expected/)
      { print "ok $test_nb\n"; }
    else
      { print "not ok $test_nb\n    -- $message\n";  
        warn "          expecting ", $expected, "\n";
        warn"          found     ", $result, "\n";
      }
  }

# test 2 files
sub ftest
  { my ($result_file, $expected_file, $message)= @_;
    my $result_string= clean_sp( slurp( $result_file));
    my $expected_string= clean_sp( slurp( $expected_file));
    $test_nb++;
    if( $result_string eq $expected_string)
      { print "ok $test_nb\n"; }
    else
      { print "not ok $test_nb\n    -- $message\n";  
        warn "          expecting ", $expected_string, "\n";
        warn "          found     ", $result_string, "\n";
      }
    
  }

sub slurp
  { my( $file)= @_;
    local undef $/;
    open( FH, "<$file") or die "cannot slurp '$file': $!\n";
    my $content=<FH>;
    close FH;
    return $content;
  }

sub spit
  { my( $file, $content)= @_;
    open( FH, ">$file") or die "cannot spit '$file': $!\n";
    print FH $content;
    close FH;
  }      


sub stringifyh
  { my %h= @_;
    return '' unless @_; 
    return join ':', map { "$_:$h{$_}"} sort keys %h; 
  }

sub stringify
  { return '' unless @_; 
    return join ":", @_; 
  }

my %seen_message;
  sub skip
    { my( $nb_skip, $message)= @_;
      $message ||='';
      unless( $seen_message{$message})
        { warn "\n$message: skipping $nb_skip tests\n";
          $seen_message{$message}++;
        }
      for my $test ( ($test_nb + 1) .. ($test_nb + $nb_skip))
        { print "ok $test\n";
          warn "skipping $test ($message)\n" if( $DEBUG); 
        }
      $test_nb= $test_nb + $nb_skip;
      return 1;
    }
}

sub tags { return join ':', map { $_->gi } @_ }
sub ids  { return join ':', map { $_->att( 'id') || '<' . $_->gi . ':no_id>' } @_ }
sub id_list { my $list= join( "-", sort keys %{$_[0]->{twig_id_list}});
              if( !defined $list) { $list= ''; }
							return $list;
            } 
sub id { my $elt= $_[0]->elt_id( $_[1]) or return "unknown";
         return $elt->att( $_[0]->{twig_id});
		   }

sub clean_sp
  { my $str= shift; $str=~ s{\s+}{}g; return $str; }

sub normalize_xml
  { my $xml= shift;
    $xml=~ s{\n}{}g;
    $xml=~ s{'}{"}g; #'
    $xml=~ s{ />}{/>}g;
    return $xml;
  }


sub xml_escape
  { my $string= shift;
    #$string=~ s{&}{&amp;}g;
    $string=~ s{<}{&lt;}g;
    $string=~ s{>}{&gt;}g;
    $string=~ s{"}{&quot;}g; #"
    $string=~ s{'}{&apos;}g; #'
    return $string;
  }


sub hash_ent_text
  { my %ents= @_;
    return map { $_ => "<!ENTITY $_ $ents{$_}>" } keys %ents;
  }
sub string_ent_text
  { my %ents= @_;
    my %hash_ent_text= hash_ent_text( %ents);
    return join( '', map { $hash_ent_text{$_} } sort keys %hash_ent_text);
  }
  1;

sub _use
  { my( $module)= @_;
    if( eval "require $module") { import $module; return 1; }
    else                        { return;                }
  }

__END__

=head1 SYNOPSYS

use FindBin qw($Bin);
BEGIN { unshift @INC, $Bin; }
use tools;


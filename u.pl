#!perl
#!perl -w

require 5.8.1 ;

use strict ;

use Language::Unlambda ;

sub nl
{
  print "\n" ;
}

sub we
{
  <STDIN> ;
}

$| = 1 ;

my $u = new Language::Unlambda::Parser ;

my $file ;

{
  undef local $/ ;
  $file = <> ;
}

my $x = $u -> do ( $file ) ;

print "\nUnlambda1-alpha intepreter v0.740\n" ;
print "Copyright (c) Pavel Lepin 2005, 2006\n\n" ;

print "Input : \n" ;
print "{\n" . $file . "\n}" ;
nl ;
we ;

print "Parsed : \n" ;
print "{\n" . $x -> id ( ) . "\n}" ;
nl ;
we ;

print "\n".('='x64)."\n" ;

$x = $x -> start ( ) ;

print "\n".('='x64)."\n" ;

print "Returned : \n" ;
print "{\n" . ( $x -> id ( ) ) . "\n}" ;
nl ;
we ;

1 ;

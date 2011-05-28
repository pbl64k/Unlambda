
package     Language::Unlambda::Parser ;



require     5.8.1 ;

use         strict ;

use         Language::Unlambda::Global ;

use         Language::Unlambda::Hash ;

use         Language::Unlambda::Core ;



our $PACKAGE = 'Language::Unlambda::Parser' ;
our $VERSION = $Language::Unlambda::Global::VERSION ;



our $func    = qr/[ivkdsr]/ ;
our $cont    = qr/c/ ;
our $dot     = qr/\./ ;
our $tick    = qr/`/ ;
our $rem     = qr/#/ ;
our $nl      = qr/\n/ ;

#our $cr      = "\r" ;



our @ISA     = ( 'Language::Unlambda::Hash' ) ;



sub new
{

  my $method     = 'new' ;

  my $this       = shift ;

  my $self       = ( $this -> SUPER::new ( ) ) ;

  $self -> { _ } = new Language::Unlambda::Core ;

  return ( $self ) ;

}



sub do
{

  my $method = 'do' ;

  my $self   = shift ;

  my $code   = shift ;

  return ( $self -> prc ( \$code ) ) ;

}



sub prc
{

  my $method = 'prc' ;

  my $self   = shift ;

  my $r      = shift ;

  my $char   = $self -> onec ( $r ) ;
  
  my $result ;

  if    ( $char =~ $func )
  {

    $result   = $self -> { _ } -> { $char } ;

  }
  elsif ( $char =~ $cont )
  {

    $result   = $self -> { _ } -> { $char } -> ( ) ;

  }
  elsif ( $char =~ $dot )
  {

    my $schar = $self -> onechar ( $r ) ;

    $result   = $self -> { _ } -> { '.' } { $schar } ;

  }
  elsif ( $char =~ $tick )
  {

    my $farg  = $self -> prc ( $r ) ;
    my $sarg  = $self -> prc ( $r ) ;

    $result   = $self -> { _ } -> { '`' } ( $farg , $sarg ) ;

  }

  return ( $result ) ;

}



sub onec
{

  my $method = 'onec' ;

  my $self   = shift ;

  my $r      = shift ;

  my $char ;

  do
  {

    $char = $self -> onechar ( $r ) ;

    if ( $char =~ $rem )
    {

      while ( $char !~ $nl )
      {

        $char = $self -> onechar ( $r ) ;

      }

    }

  } while ( ( $char !~ $func ) && ( $char !~ $dot ) &&
            ( $char !~ $tick ) && ( $char !~ $cont ) ) ;

  return $char ;

}

sub onechar
{

  my $method = 'onechar' ;

  my $self   = shift ;

  my $r      = shift ;

  my ( $char , $rest ) = split ( // , $$r , 2 ) ;

  $$r = $rest ;

  return ( $char ) ;

}

1 ;

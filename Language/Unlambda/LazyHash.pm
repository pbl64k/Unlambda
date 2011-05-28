
package     Language::Unlambda::LazyHash ;



require     5.8.1 ;

use         strict ;

use         Language::Unlambda::Global ;

use         Language::Unlambda::Hash ;



our $PACKAGE = 'Language::Unlambda::LazyHash' ;
our $VERSION = $Language::Unlambda::Global::VERSION ;



our @ISA     = ( 'Language::Unlambda::Hash' ) ;



sub TIEHASH
{

  my $method             = 'TIEHASH' ;

  my $this               = shift ;
  my $construct          = shift ;
  my $islegal            = shift ;

  my $self               = ( $this -> SUPER::new ( ) ) ;

  $self -> { construct } = $construct ;
  $self -> { islegal }   = $islegal ;

  $self -> { tied }      = ( ) ;

  return ( $self ) ;

}



sub FETCH
{

  my $method = 'FETCH' ;

  my $self   = shift ;
  my $key    = shift ;

  if ( ! $self -> { islegal } -> ( $key ) )
  {

    return ;

  }

  if ( ! defined ( $self -> { tied } -> { $key } ) )
  {

    $self -> { tied } -> { $key } = $self -> { construct } -> ( $key ) ;
  
  }

  return ( $self -> { tied } -> { $key } ) ;

}



sub STORE
{

  my $method = 'STORE' ;

  return ;

}



sub DELETE
{

  my $method = 'DELETE' ;

  my $self   = shift ;
  my $key    = shift ;

  delete ( $self -> { tied } -> { $key } ) ;

  return ;

}



sub CLEAR
{

  my $method        = 'CLEAR' ;

  my $self          = shift ;

  $self -> { tied } = { } ;

  return ;

}



sub EXISTS
{

  my $method = 'EXISTS' ;

  my $self   = shift ;
  my $key    = shift ;

  return ( $self -> { islegal } -> ( $key ) ) ;

}



sub SCALAR
{

  my $method = 'SCALAR' ;

  my $self   = shift ;

  return scalar ( %{ $self -> { tied } } ) ;

}



sub FIRSTKEY
{

  my $method = 'FIRSTKEY' ;

  my $self   = shift ;

  my $keys   = keys ( %{ $self -> { tied } } ) ;

  return each ( %{ $self -> { tied } } ) ;

}



sub NEXTKEY
{

  my $method = 'NEXTKEY' ;

  my $self   = shift ;

  return each ( %{ $self -> { tied } } ) ;

}



1 ;


package     Language::Unlambda::F ;



require     5.8.1 ;

use         strict ;

use         Language::Unlambda::Global ;



our $PACKAGE  = 'Language::Unlambda::F' ;
our $VERSION  = $Language::Unlambda::Global::VERSION ;



my  $_code    = 'CODE' ;

our $ev       = 'ev' ;
our $ap       = 'ap' ;
our $id       = 'id' ;
our $cp       = 'cp' ;

our $caller   = -1 ;
our $freeze   = 0 ;
our %unfreeze = ( ) ;
our %contres  = ( ) ;
our %taint    = ( ) ;



our @ISA      = ( ) ;



sub new
{

  my $method = 'new' ;

  my $this   = shift ;
  my $init   = shift ;

  my $class  = ref ( $this ) || $this ;

  my $self   =
    ( ! UNIVERSAL::isa ( $init , $_code ) ) ?
      ( ( ( ref ( $this ) ) && UNIVERSAL::isa ( $this , __PACKAGE__ ) ) ?
          $this :
          sub { } ) :
      ( $init ) ;

  bless  ( $self , $class ) ;

  return ( $self ) ;

}



sub start
{

  my $method = 'start' ;

  my $self   = shift ;

  $caller    = -1 ;

  my $flag   = 0 ;

  my $result ;

  %unfreeze  = ( ) ;

  while ( ! $flag )
  {

    if ( $caller > 0 )
    {

      $self = $unfreeze { $caller } -> cp ( ) ;

    }

    %taint   = ( ) ;

    $freeze  = $self ;

    $flag    =
    eval
    {

      $result = &$self ( $ev ) ;

    } ;

  }

  return ( $result ) ;

}



sub ev
{

  my $method = $ev ;

  my $self   = shift ;

  return ( &$self ( $method ) ) ;

}



sub ap
{

  my $method = $ap ;

  my $self   = shift ;
  my $ref    = shift ;

  if ( ( ref ( $ref ) ) &&
         UNIVERSAL::isa ( $ref , __PACKAGE__ ) )
  {

    return ( &$self ( $method , $ref ) ) ;

  }

}



sub id
{

  my $method = $id ;

  my $self   = shift ;

  return ( &$self ( $method ) ) ;

}



sub cp
{

  my $method = $cp ;

  my $self   = shift ;

  return ( &$self ( $method , shift ) ) ;

}



1 ;

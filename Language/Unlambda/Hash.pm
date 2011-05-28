
package     Language::Unlambda::Hash ;



require     5.8.1 ;

use         strict ;

use         Language::Unlambda::Global ;



our $PACKAGE = 'Language::Unlambda::Hash' ;
our $VERSION = $Language::Unlambda::Global::VERSION ;



our @ISA     = ( ) ;



sub new
{

  my $method   = 'new' ;

  my $this     = shift ;
  my ( %init ) = ( @_ ) ;

  my $class    = ref ( $this ) || $this ;

  my $self     = ( %init ) ? ( \%init ) : { } ;

  bless  ( $self , $class ) ;

  return ( $self ) ;

}



1 ;

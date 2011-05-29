
package     Language::Unlambda::Core ;



require     5.8.1 ;

use         strict ;

use         Language::Unlambda::Global ;

use         Language::Unlambda::F ;
use         Language::Unlambda::Hash ;
use         Language::Unlambda::LazyHash ;



our $PACKAGE  = 'Language::Unlambda::Core' ;
our $VERSION  = $Language::Unlambda::Global::VERSION ;



our $contnum = 1 ;

our $cr      = 'cr' ;



our @ISA     = ( 'Language::Unlambda::Hash' ) ;



sub new
{

  my $method = 'new' ;

  my $this   = shift ;
  my $doth   = shift ;

  my %f      = %{ ( $this -> SUPER::new ( ) ) } ;

  $f { '`' } =
  sub
  {
    my $X = shift ;
    my $Y = shift ;
    my $tick ;
    return
    (
      $tick = new Language::Unlambda::F
      (
        sub
        {
          my $method = shift ;
          if    ( $method eq $Language::Unlambda::F::id )
          {
            return ( '`' . ( $X -> id ( ) ) . ( $Y -> id ( ) ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ev )
          {
            return ( $X -> ev ( ) -> ap ( $Y ) -> ev ( ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::cp )
          {
            return ( $f { '`' } ( $X -> cp ( ) , $Y -> cp ( ) ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ap )
          {
            my $Z = shift ;
            return ( ( $X -> ev ( ) -> ap ( $Y ) ) -> ev ( ) ->
                     ap ( $Z ) -> ev ( ) ) ;
          }
        }
      )
    ) ;
  } ;

  $f { i } =
  new Language::Unlambda::F
  (
    sub
    {
      my $method = shift ;
      if    ( $method eq $Language::Unlambda::F::id )
      {
        return ( 'i' ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ev )
      {
        return ( $f { i } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::cp )
      {
        return ( $f { i } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ap )
      {
        my $X = shift ;
        return ( $X -> ev ( ) ) ;
      }
    }
  ) ;

  $f { v } =
  new Language::Unlambda::F
  (
    sub
    {
      my $method = shift ;
      if    ( $method eq $Language::Unlambda::F::id )
      {
        return ( 'v' ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ev )
      {
        return ( $f { v } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::cp )
      {
        return ( $f { v } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ap )
      {
        # ignored but MUST be evaluated!
        my $X = shift -> ev ( ) ;
        return ( $f { v } ) ;
      }
    }
  ) ;

  $f { k } =
  new Language::Unlambda::F
  (
    sub
    {
      my $method = shift ;
      if    ( $method eq $Language::Unlambda::F::id )
      {
        return ( 'k' ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ev )
      {
        return ( $f { k } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::cp )
      {
        return ( $f { k } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ap )
      {
        my $X = shift ;
        return ( $f { k1 } ( $X -> ev ( ) ) ) ;
      }
    }
  ) ;

  $f { k1 } =
  sub
  {
    my $X = shift ;
    my $k1 ;
    return
    (
      $k1 = new Language::Unlambda::F
      (
        sub
        {
          my $method = shift ;
          if    ( $method eq $Language::Unlambda::F::id )
          {
            return ( '`k(1)' . ( $X -> id ( ) ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ev )
          {
            return ( $k1 ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::cp )
          {
            return ( $f { k1 } ( $X -> cp ( ) ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ap )
          {
            # ignored but MUST be evaluated!
            my $Y = shift -> ev ( ) ;
            return ( $X -> ev ( ) ) ;
          }
        }
      )
    ) ;
  } ;

  $f { d } =
  new Language::Unlambda::F
  (
    sub
    {
      my $method = shift ;
      if    ( $method eq $Language::Unlambda::F::id )
      {
        return ( 'd' ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ev )
      {
        return ( $f { d } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::cp )
      {
        return ( $f { d } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ap )
      {
        # does NOT evaluate! bundles it into a promise instead
        my $X = shift ;
        return ( $f { d1 } ( $X ) ) ;
      }
    }
  ) ;

  $f { d1 } =
  sub
  {
    my $X = shift ;
    my $d1 ;
    return
    (
      $d1 = new Language::Unlambda::F
      (
        sub
        {
          my $method = shift ;
          if    ( $method eq $Language::Unlambda::F::id )
          {
            return ( '`d' . ( $X -> id ( ) ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ev )
          {
            return ( $d1 ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::cp )
          {
            return ( $f { d1 } ( $X -> cp ( ) ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ap )
          {
            # this DOES evaluate - it's a promise, NOT a delay!
            my $Y = shift ;
            return ( $X -> ev ( ) -> ap ( $Y -> ev ( ) ) ) ;
          }
        }
      )
    ) ;
  } ;

  $f { c } =
  sub
  {
    my $cn   = shift ;
    my $cont = shift ;
    my $c ;
    return
    (
      $c = new Language::Unlambda::F
      (
        sub
        {
          my $method = shift ;
          if    ( UNIVERSAL::isa ( $method ,
                                   $Language::Unlambda::F::PACKAGE ) )
          {
            $cont = $method ;
            return ;
          }
          elsif ( $method eq $Language::Unlambda::F::id )
          {
            return ( 'c('. $cn . ')(' .$cont.')('.
                           ($cont?&$cont:'no cont').')' ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ev )
          {
            return ( $c ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::cp )
          {
            if ( $cont )
            {
              my $clone = $f { c } ( $cn ) ;
              my $clonecont = $cont -> cp ( $clone ) ;
              &$clone ( $clonecont ) ;
              return ( $clone ) ;
            }
            else
            {
              return ( $f { c } ( $cn ) ) ;
            }
          }
          elsif ( $method eq $Language::Unlambda::F::ap )
          {
            # I'm not sure whether this should evaluate in any case
            # (it seems it shouldn't)
            my $X = shift ;
            if ( $Language::Unlambda::F::caller == $cn )
            {
              $Language::Unlambda::F::caller = -1 ;
              &$cont ( $cr , $Language::Unlambda::F::contres { $cn } ) ;
            }
            if ( $cont && ( ! $Language::Unlambda::F::taint { $cn } ) )
            {
#print"returning c($cn)...";
#              if ( ! &$cont ( ) )
#              {
#print" [abnormally]";
#                &$cont ( $cr , $Language::Unlambda::F::contres { $cn } ) ;
#              }
#              $Language::Unlambda::F::taint { $cn } = 1 ;
#print" {".(&$cont->id)."}\n";
#<STDIN>;
              return ( &$cont ( ) ) ;
            }
            else
            {
              $cn   =  $Language::Unlambda::Core::contnum ;
              $cont =  $f { c1 } ( $c , $Language::Unlambda::F::freeze ) ;
              &$cont ( $Language::Unlambda::F::freeze ) ;
              return (  $cont -> ap ( $X -> ev ( ) ) ) ;
            }
          }
        }
      )
    ) ;
  } ;

  $f { c1 } =
  sub
  {
    my $c       = shift ;
    my $freeze  = shift ;
    my $contres = shift ;
    my $cn      = shift ;
    my $virgin  = shift ;

    my $c1 ;

    $cn         = $cn ? $cn : $contnum++ ;

    $c1 = new Language::Unlambda::F
    (
      sub
      {
        my $method = shift ;

        if    ( UNIVERSAL::isa ( $method , $Language::Unlambda::F::PACKAGE ) )
        {
          $freeze = $method ;
          if ( ! exists ( $Language::Unlambda::F::unfreeze { $cn } ) )
          {
            my $oldcall                              =
               $Language::Unlambda::F::caller ;
            $Language::Unlambda::F::caller           = $cn ;
            $Language::Unlambda::F::unfreeze { $cn } = 1 ;
            $Language::Unlambda::F::unfreeze { $cn } = $freeze -> cp ( ) ;
            $Language::Unlambda::F::caller           = $oldcall ;
          }
          return ;
        }
        elsif ( $method eq $cr )
        {
          $contres = shift -> cp ( ) ;
          return ;
        }
        elsif ( $method eq $Language::Unlambda::F::id )
        {
          return ( '<CONT:' . $cn . ':' . $virgin . ':' . $c . '>' ) ;
        }
        elsif ( $method eq $Language::Unlambda::F::ev )
        {
          return ( $c1 ) ;
        }
        elsif ( $method eq $Language::Unlambda::F::cp )
        {
          my $clonecont = $f { c1 }
                             (  $c , $freeze , $contres , $cn , $virgin ) ;
          return ( $clonecont ) ;
        }
        elsif ( $method eq $Language::Unlambda::F::ap )
        {

          my $X                          = shift ;

          if ( ! $virgin )
          {

            $virgin = 1 ;

            return ( $X -> ev ( ) -> ap ( $c1 ) ) ;

          }
          else
          {

            $contres                       = $X -> ev ( ) ;

            $Language::Unlambda::F::caller           = $cn ;
            $Language::Unlambda::F::contres { $cn }  = $contres -> cp ( ) ;

            die ;

          }

        }
        else
        {
          if ( ( ! $contres ) && ( ! $Language::Unlambda::F::taint { $cn } ) )
          {
            $contres                              =
            $Language::Unlambda::F::contres { $cn } -> cp ( ) ;
          }
          $Language::Unlambda::F::taint { $cn } = 1 ;
          return ( $contres ) ;
        }
       }
    ) ;

    if ( ! $contres )
    {
      $contres = $c1 ;
    }

    return ( $c1 ) ;

  } ;

  $f { s } =
  new Language::Unlambda::F
  (
    sub
    {
      my $method = shift ;
      if    ( $method eq $Language::Unlambda::F::id )
      {
        return ( 's' ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ev )
      {
        return ( $f { s } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::cp )
      {
        return ( $f { s } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ap )
      {
        my $X = shift ;
        return ( $f { s1 } ( $X -> ev ( ) ) ) ;
      }
    }
  ) ;

  $f { s1 } =
  sub
  {
    my $X = shift ;
    my $s1 ;
    return
    (
      $s1 = new Language::Unlambda::F
      (
        sub
        {
          my $method = shift ;
          if    ( $method eq $Language::Unlambda::F::id )
          {
            return ( '`s(1)' . ( $X -> id ( ) ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ev )
          {
            return ( $s1 ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::cp )
          {
            return ( $f { s1 } ( $X -> cp ( ) ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ap )
          {
            my $Y = shift ;
            return ( $f { s2 } ( $X -> ev ( ) , $Y -> ev ( ) ) ) ;
          }
        }
      )
    ) ;
  } ;

  $f { s2 } =
  sub
  {
    my $X = shift ;
    my $Y = shift ;
    my $s2 ;
    return
    (
      $s2 = new Language::Unlambda::F
      (
        sub
        {
          my $method = shift ;
          if    ( $method eq $Language::Unlambda::F::id )
          {
            return ( '``s(2)' . ( $X -> id ( ) ) . ( $Y -> id ( ) ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ev )
          {
            return ( $s2 ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::cp )
          {
            return ( $f { s2 } ( $X -> cp ( ) , $Y -> cp ( ) ) ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ap )
          {
            my $Z    = shift -> ev ( ) ;
# I have no idea what is all of this about.
my $Z0 = $Z -> cp ( ) ;
#print"evaluating s2 ";
#print"X: [".$X->id."] ";
#print"Y: [".$Y->id."] ";
#print"Z: [".$Z->id."] ";
#print"Z0: [".$Z0->id."]\n";
my $farg = $f { '`' } ( $X , $Z ) ;
my $sarg = $f { '`' } ( $Y , $Z0 ) ;
my $resss = $f { '`' } (  $farg , $sarg ) ;
#print"resss: [".$resss->id."]\n";
$resss = $resss -> ev ( ) ;
#print"resssev: [".$resss->id."]\n";
#<STDIN>;
return ( $resss ) ;

# works (sort of)
#            my $farg = $f { '`' } ( $X , $Z ) -> ev ( ) ;
#            my $sarg = $f { '`' } ( $Y , $Z ) -> ev ( ) ;
#            return ( $f { '`' } (  $farg , $sarg ) -> ev ( ) ) ;
          }
        }
      )
    ) ;
  } ;

  $f { DOT_handler_default } =
  sub
  {

    select STDOUT ;

    local $| = 1 ;

    my $char = shift ;

    print STDOUT ( $char ) ;

    return ;

  } ;

  $f { DOT_handler } = $doth ? $doth : $f { DOT_handler_default } ;

  $f { DOT } =
  sub
  {
    my $handler = shift ;
    my $char    = shift ;
    my $dot ;
    return
    (
      $dot = new Language::Unlambda::F
      (
        sub
        {
          my $method = shift ;
          if    ( $method eq $Language::Unlambda::F::id )
          {
            return ( '.' . $char ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ev )
          {
            return ( $dot ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::cp )
          {
            return ( $dot ) ;
          }
          elsif ( $method eq $Language::Unlambda::F::ap )
          {
            my $X = shift ;
            $X    = $X -> ev ( ) ;
            if ( $Language::Unlambda::F::caller == -1 )
            {
              &$handler ( $char ) ;
            }
            return ( $X ) ;
          }
        }
      )
    ) ;
  } ;

  $f { '.' } = { } ;

  tie %{ $f { '.' } } , 'Language::Unlambda::LazyHash' ,
  (
    sub
    {
      my $char = shift ;
      return ( $f { DOT } ( $f { DOT_handler } , $char ) ) ;
    } ,
    sub
    {
      my $char = shift ;
      return ( $char =~ /[\x00-\xff]/s ) ;
    }
  ) ;

  $f { r } =
  new Language::Unlambda::F
  (
    sub
    {
      my $method = shift ;
      if    ( $method eq $Language::Unlambda::F::id )
      {
        return ( 'r' ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ev )
      {
        return ( $f { r } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::cp )
      {
        return ( $f { r } ) ;
      }
      elsif ( $method eq $Language::Unlambda::F::ap )
      {
        my $X = shift ;
        $X    = $X -> ev ( ) ;
        if ( $Language::Unlambda::F::caller == -1 )
        {
          $f { DOT_handler } -> ( "\n" ) ;
        }
        return ( $X ) ;
      }
    }
  ) ;

  return ( \%f ) ;

}



1 ;

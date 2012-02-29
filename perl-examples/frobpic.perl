#!/usr/bin/perl -w
# $RCSfile: frobpic.perl,v $$Revision: 19980513.122223 $

use POSIX qw( strftime );
$date = strftime( "%Y\\-%m\\-%d", localtime );

sub fmt_num_label{
   my( $number ) = @_;
   return "\@ 0 \@" if $number == 0;
   $number = sprintf( "%.3g", $number );
   my( $exponent ) = 0;
   $exponent++, $number /= 10 while abs( $number ) >= 10;
   $exponent--, $number *= 10 while abs( $number ) < 1;
   $exponent--, $number *= 10 if $exponent == 1;
   return "\@ $number \@" if $exponent == 0;
   return "\@ 10 sup $exponent \@" if $number == 1;
   return "\@ $number \\[mu] 10 sup $exponent \@";
};

print <<__END__PROLOG__;
.ds T1 CMPS-012B 
.ds T2 Linear plot of Big-O values of various functions
.ds T3 $date
.PH "'\\f[HB]\\*[T1]'\\*[T2]'\\*[T3]\\f[P]'''"
.nr \@ll 6.5i
.ll \\n[\@ll]u
.lt \\n[\@ll]u
.EQ
delim \@\@
.EN
This plot illustrates the complexity of some
characterized by their running times.
__END__PROLOG__

while( <> ){
   s/(line)  (.*reset.*)/$1 thickness 1 $2/;
   s/thickness [\d.]+/thickness 0.1/;
   s/(line (dotted|dashed [\d.]+|)) (.*\\)/line thickness 3 $3/;
   print;
};

print "\\f[CB]$ENV{'PWD'}/*\\f[P]\n";

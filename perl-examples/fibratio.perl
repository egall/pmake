#!/usr/local/bin/perl -w
# $Id: fibratio.perl,v 351.4 2005-02-16 16:00:04-08 - - $
sub F($){
   my( $j ) = @_;
   my $phi = (5 ** .5 + 1) / 2;
   my $psi = 1 - $phi;
   ($phi ** $j - $psi ** $j) / 5 ** .5
};
$a=0;
$b=1;
for( $i = 0;; ++$i ){
   $r = $a / $b;
   last if $s && $r == $s;
   $f = F $i;
   printf "F(%3d) = %10.0f || %10.0f / %10.0f = %19.16f\n",
          $i, $f, $a, $b, $r;
   $n = $a + $b;
   $a = $b;
   $b = $n;
   $s = $r;
};

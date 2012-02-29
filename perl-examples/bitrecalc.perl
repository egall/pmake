#!/usr/bin/perl -w
# $RCSfile: asg4-bitreecalc.perl,v $$Revision: 19981113.192658 $
#
# Synopsis:  asgt4-treecalc.perl [file...]
#
# Reads from STDIN or from a list of files any input conformable
# to the specifications for asgt4.  Sample input is used instead
# if the special filename DATA is used.
#

$DATA = @ARGV && $ARGV[0] eq "DATA";
$numpat = '[+-]?(\.\d+|\d+\.?\d*)([Ee][+-]?\d+)?';
$varpat = '[a-z]';
$NAN = 1000**1000 / 1000**1000;
for $var( 'a' .. 'z' ){
   $value{ $var } = $NAN;
   $expr{ $var } = "NULL";
};

for( $input = ''; $input .= $DATA ? <DATA> : <>; ){
   $input =~ s/\s*//g;
   for(;;){
      if( $input =~ s/^($varpat)\?// ){
         $var = $1;
      }elsif( $input =~ s/^($varpat)\:($numpat)\;// ){
         $var = $1;
         $value{ $var } = $2;
         $expr{ $var } = "NULL";
      }elsif( $input =~ s/^($varpat)\=(.*)\;// ){
         ( $var, $rpn ) = ( $1, $2 );
         my( @stack ) = ();
         for $token( split( '', $rpn )){
            $token = "(" . join( $token, splice( @stack, -2 )) . ")"
                  unless $token =~ /$varpat/;
            push( @stack, $token );
         };
         $expr{ $var } = pop( @stack );
      }else{
         last;
      };
      if(( $expr = $expr{ $var } ) ne "NULL" ){
         $expr =~ s/$varpat/\$value{'$&'}/g;
         $value = eval( "0+($expr)" );
         $value{ $var } = defined( $value ) ? $value : $NAN;
      };
      printf "%s: %.15g\n   %s\n", $var, $value{ $var }, $expr{ $var };
   };
   if( $input =~ /[;?]/ ){
      print "Invalid input, quitting:\n$input\n";
      exit 1;
   };
};

__END__

a: 1.7;
b= ac+ ac+*;
c:3;
b ?
z :0;
y= a z/;
h: 1e300;
i=hh*;
k=ii-;
k=ii/;
p : 3.141592653589793238462643383279502884197169399;
e : 2.718281828459045235360287471352662497757247093;
l : 0.301029995663981195213738894724493026768189881;
t : 1.414213562373095048801688724209698078569671875;
m = pe*;
n = ep*;
o = pe* ep*-;
s = pelt***;
s = pe+l+t-;
f = pe+l+t-pe+l+t-pe+l+t-pe+l+t-///;
o:1;t:.00000000000000000000033333333333333333333333333333;u=ot/;
z:0;
n=zi-;

#!/usr/bin/perl

print<<__END_OF_NOTE__;
NOTE:  This perl script approximates the output expected, but
there will be some differences, most notably in the choice of
pointer values when printed under %p format and also the output
from the mallocmap() function.
__END_OF_NOTE__

&mallocmap;
while( $line = <> ){
   for $word( split( ' ', $line )){
      if( $word =~ /<FLUSH>/ ){
         &flush;
      }elsif( $word =~ /<DUMP>/ ){
         &dump;
      }else{
         push( @words, $word );
      };
   };
};
&flush;

sub dump{
   local( @fakeaddr );
   for $index( 0 .. $#words ){
      push( @fakeaddr, 32000 + 0x58 * $index );
   };
   print "\n";
   printf "Queue dump:  (head=[%x], tail=[%x])\n",
      @fakeaddr[ 0, $#fakeaddr ];
   for $word( @words ){
      printf "   node [%x]-> ", shift @fakeaddr;
      printf "element=[%s]; ", $word;
      printf "link=[%x];\n", $fakeaddr[0];
   };
   print "End of queue dump.\n";
};

sub flush{
   print "\n";
   while( $word = shift( @words )){
      print "<FLUSH> $word\n";
   };
   &mallocmap;
};

sub mallocmap{
print<<__END_MALLOCMAP__;

<MALLOCMAP> begin
4570: 8200 bytes: busy
6578: 24 bytes: busy
6590: 8208 bytes: busy
85a0: 8152 bytes: free
<MALLOCMAP> end
__END_MALLOCMAP__
};

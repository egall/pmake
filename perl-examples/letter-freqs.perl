#!/usr/bin/perl
#
# Run through input files and compute relative letter frequencies.
#

$total = 0;
while( <> ){
   tr/A-Z/a-z/;
   tr/a-z//cd;
   for $char( split( //, $_ )){
      $char{ $char } += 1;
      $total += 1;
   };
};
print sort { $b <=> $a }
      map( sprintf( "%.6f %s\n", $char{ $_ } / $total, $_ ),
           keys %char );

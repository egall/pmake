#!/usr/bin/perl
# $RCSfile: asg4-xref-words.perl,v $$Revision: 19980515.212431 $

while( <> ){
   $hash{ $& } .= " $." while s/\w+//;
};

for $word( sort keys %hash ){
   print $word, $hash{ $word }, "\n";
};


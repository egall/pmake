#!/bin/perl
use POSIX qw( isgraph );

for $i( 0..256 ){
   $c = chr $i;
   print " $i" unless isgraph( $c);
};

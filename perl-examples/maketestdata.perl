#!/usr/bin/perl

@courses = qw(
   Compsci
   Geometry
   Math
   Physics
   Rocks
   Smells
   Sparks
   Stars
   Stat
   Zoo
);

@students = qw(
   Ada
   Alphard
   Algol
   Amber
   Argus
   Cecil
   Edison
   Linda
   Euclid
   Goedel
   Io
   Leda
   Lucinda
   Miranda
   Millie
   Occam
   Perl
   Russel
   Sal
   Val
);

sub choose{
   my( @array ) = @_;
   return $array[ int( rand() * @array )];
};

for $student( @students ){
   for( 1..3 ){
      print "$student ", &choose( @courses ), "\n";
   };
};


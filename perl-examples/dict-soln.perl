#!/usr/bin/perl -w
# $RCSfile: asgt3-dict-soln.perl,v $$Revision: 970211.183537 $
#
# Solution to asgt3.  This is Perl, not C, so don't worry
# if you can't read it.  Just use it as an example of what
# your C program should do.
#

if( @ARGV > 0 && $ARGV[0] eq "-E" ){
   shift;
   %table = %ENV;
};

while( <> ){
   chomp;
   print "Input: [$_]\n";
   if( m/^\*$/ ){
      print sort map "$_=$table{$_}\n", keys %table;
   }elsif( m/^([^=]+)=(.+)$/ ){
      $table{ $1 } = $2;
   }elsif( m/^([^=]+)(=)?$/ ){
      unless( defined $table{ $1 } ){
         print "Error: [$1] not in table.\n";
      }elsif( defined $2 ){
         delete $table{ $1 };
      }else{
         print "$1=$table{ $1 }\n";
      };
   }else{
      print "Error: bad input [$_]\n";
   };
   print ".\n";
};

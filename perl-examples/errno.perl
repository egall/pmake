#!/usr/local/bin/perl -w
use strict;
use warnings;
my $RCSID = '$Id: errno.perl,v 358.1 2005-10-28 18:36:19-07 - - $';
#
# NAME
#    errno.perl - print out system error codes
#
# SYNOPSIS
#    errno.perl [errno...]
#
# DESCRIPTION
#    Prints out the system error codes given on the command line.
#    Prints all of them if none.

if (@ARGV) {
   for my $errno (@ARGV) {
      if ($errno !~ m/^\d+$/) {
         print STDERR "$0: $errno: not a number\n";
      }else {
         $! = $errno;
         print "error($errno) = $!\n";
      };
   };
}else {
   for (my $errno = 0; ; ++$errno) {
      $! = $errno;
      my $strerror = "$!";
      last if $strerror eq $errno;
      print "error($errno) = $!\n";
   };
};

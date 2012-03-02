#!/usr/local/bin/perl -w
use strict;
use warnings;
# $Id: env.perl,v 358.1 2005-11-14 18:44:54-08 - - $
#
# NAME
#    env.perl - print out process environment variables
#

for my $var (sort keys %ENV) {
   print "$var => $ENV{$var}\n";
};

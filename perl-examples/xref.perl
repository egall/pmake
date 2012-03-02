#!/usr/bin/perl
# $Id: xref.perl,v 358.1 2005-10-28 18:51:06-07 - - $

map { $hash{lc $_} .= " $." } m/(\w+)/g while <>;
map { print "$_$hash{$_}\n" } sort keys %hash;


#!/bin/perl
# $Id: degree.perl,v 353.1 2005-05-18 12:12:51-07 - - $
map { printf "degree=($_)\n", ord '°' } qw( %c %d 0x%X 0%o );

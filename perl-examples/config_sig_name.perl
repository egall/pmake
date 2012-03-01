#!/usr/bin/perl
# $Id$

use strict;
use warnings;
use Config;
defined $Config{sig_name} or die "No Config{sig_name}!\n";

my @sig_names = map {"SIG$_"} split ' ', $Config{sig_name};

print "SIG[$_]=$sig_names[$_]\n" for 0..$#sig_names;

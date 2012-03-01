#!/usr/local/bin/perl
# $Id: yes.perl,v 351.4 2005-02-24 15:38:26-08 - - $
#
# NAME
#    yes - be repetitively affirmative
#
# SYNOPSIS
#    yes [expletive]
#
# DESCRIPTION
#    yes repeatedly outputs y, or if expletive is given, that is
#    output repeatedly.  Termination is by typing an interrupt
#    character or breaking the pipe.
#

my $expletive = "@ARGV" || "y";
print "$expletive\n" while 1;

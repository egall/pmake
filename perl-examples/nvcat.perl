#!/usr/bin/perl
# $Id: nvcat.perl,v 1.5 2012-01-13 20:18:20-08 - - $
#
# NAME
#    nvcat - cat files with filenames and line numbers
#
# SYNOPSIS
#    nvcat [filename...]
#
# DESCRIPTION
#    Display all files given by the list of filenames, or STDIN,
#    if none.  Display filenames and line numbers.
#    

use strict;
use warnings;

$0 =~ s|^(.*/)?([^/]+)/*$|$2|;
my $EXIT_STATUS = 0;
END {exit $EXIT_STATUS}
sub note(@) {print STDERR "$0: @_"}
$SIG{'__WARN__'} = sub {note @_; $EXIT_STATUS = 1};
$SIG{'__DIE__'} = sub {warn @_; exit};

my $eqline = ":" x 32 . "\n";
push @ARGV, "-" unless @ARGV;
for my $filename (@ARGV) {
   open my $infile, "<$filename" or warn "<$filename: $!\n" and next;
   print "\n$eqline$filename\n$eqline";
   while (defined (my $line = <$infile>)) {
      chomp $line;
      printf "%6d  %s\n", $., $line;
   }
   close $infile;
}


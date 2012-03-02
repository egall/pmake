#!/usr/local/bin/perl -w
use strict;
use warnings;
my $RCSID = '$Id: wordfreq.perl,v 358.2 2005-11-14 18:44:54-08 - - $';

$0 =~ s|^(.*/)?([^/]+)/*$|$2|;
my $EXITCODE = 0;
END{ exit $EXITCODE; }
sub note(@){ print STDERR "$0: @_"; };
$SIG{'__WARN__'} = sub{ note @_; $EXITCODE = 1; };
$SIG{'__DIE__'} = sub{ warn @_; exit; };

my $MAN_PAGE = <<__END_MAN_PAGE__;
#
# NAME
#    $0 - count the frequencies of words in a file
#
# SYNOPSIS
#    $0 [-Dh] [file...]
#
# DESCRIPTION
#    Reads words from the files given as arguments and prints them
#    out along with their frequencies.  If no arguments are given
#    reads STDIN.
#
# OPTIONS
#    -D  produces a debug dump (not implemented in Perl)
#    -h  prints this help message.
#
# $RCSID
__END_MAN_PAGE__

use Getopt::Std;
my %OPTIONS;
getopts ("Dh", \%OPTIONS);
print $MAN_PAGE and exit if $OPTIONS{'h'};

push @ARGV, "-" unless @ARGV;

my %WORDFREQ;
while (defined (my $line = <>)) {
   map{ ++$WORDFREQ{$_} } $line =~ m/([[:alnum:]]+)/g;
};

map { printf "%7d %s\n", $WORDFREQ{$_}, $_ } sort keys %WORDFREQ;


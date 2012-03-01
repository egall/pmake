#!/usr/local/bin/perl
use strict;
use warnings;
my $RCSID = '$Id: ncat.perl,v 358.1 2005-10-28 18:45:34-07 - - $';

$0 =~ s|^(.*/)?([^/]+)/*$|$2|;
my $exit_status = 0;
END { exit $exit_status; }
sub note (@) { print STDERR "$0: @_"; };
$SIG{'__WARN__'} = sub { note @_; $exit_status = 1; };
$SIG{'__DIE__'} = sub { warn @_; exit; };


while (<>) {
   next if m/^\s*#/;
   print "$ARGV:$.:$_";
}continue {
   close ARGV if eof;
};


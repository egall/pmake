#!/usr/local/bin/perl -w
use strict;
use warnings;
my $RCSID = '$Id: loaddict.perl,v 358.2 2005-11-14 18:46:52-08 - - $';
#
# Load a dictionary into a hash and then print the hash.
#

$0 =~ s|^(.*/)?([^/]+)/*$|$2|;
my $EXITCODE = 0;
END{ exit $EXITCODE; }
sub note(@){ print STDERR "$0: @_"; };
$SIG{'__WARN__'} = sub{ note @_; $EXITCODE = 1; };
$SIG{'__DIE__'} = sub{ warn @_; exit; };

sub loaddict (\%$) {
   my ($hashref, $filename) = @_;
   open my $dict, $filename or warn "$filename: $!\n" and return;
   for my $word (<$dict>) {
      chomp $word;
      $hashref->{$word} = 1;
   };
   close $dict;
};

push @ARGV, "/usr/dict/words" unless @ARGV;

for my $filename (@ARGV) {
   my %hash;
   loaddict %hash, $filename;
   for my $word (sort keys %hash) {
      print "$filename: $word\n";
   };
};


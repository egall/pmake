#!/usr/bin/perl
# $Id: pgrep.perl,v 1.1 2007-09-28 13:05:41-07 - - $
use strict;
use warnings;
use Getopt::Std;

$0 =~ s|^.*?/?([^/]+)/*$|$1|;
my $exit_status = 0;
sub note(@) {print STDERR "$0: @_"}
$SIG{'__WARN__'} = sub {note @_; $exit_status = 2};
$SIG{'__DIE__'} = sub {warn @_; exit};

sub usage_exit {
   print STDERR "Usage: $0 [-ilnv] regex [filename...]\n";
   $exit_status = 2;
   exit;
}

my %opts;
getopts ("ilnv", \%opts);
my $regex = shift or usage_exit;
my $anymatch = 0;
$regex = eval ('$opts{"i"} ? qr($regex)i : qr($regex)');
die $@ if $@;
print "regex=$regex;\n";
push @ARGV, "-" unless @ARGV;

for my $filename (@ARGV) {
   open my $file, "<$filename" or warn "$filename: $!\n" and next;
   my $filematch = 0;
   while (defined (my $line = <$file>)) {
      if (my $match = $opts{"v"} ? $line !~ $regex : $line =~ $regex) {
         $anymatch = $filematch = 1;
         unless ($opts{"l"}) {
            printf "%s:", $filename if @ARGV > 1;
            printf "%s:", $. if $opts{"n"};
            print $line;
         }
      }
   }
   print "$filename\n" if $filematch and $opts{"l"};
   close $file;
}

$exit_status ||= ! $anymatch;
exit $exit_status;


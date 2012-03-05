#!/usr/local/bin/perl -w
use strict;
use warnings;

$0 =~ s|^(.*/)?([^/]+)/*$|$2|;
my $EXITCODE = 0;
END{ exit $EXITCODE; }
sub note(@) { print STDERR "$0: @_"; };
$SIG{'__WARN__'} = sub { note @_; $EXITCODE = 1; };
$SIG{'__DIE__'} = sub { warn @_; exit; };

(my $USAGE = <<__END_USAGE__) =~ s/^#[ ]?//gm;
#
# NAME
#    $0 - pmake
#
# SYNOPSIS
#    $0 [-abcopq] [file...]
#
# DESCRIPTION
#    Performs make on given directory
#
# OPTIONS
#    -h    print help and exit
#    -abc  flags not requiring options
#    -opq  flags requiring arguments
#
__END_USAGE__

use Getopt::Std;
my %OPTS;
getopts ("abcho:p:q:", \%OPTS);
print $USAGE and exit if $OPTS{'h'};

print "$0: -$_ = $OPTS{$_}\n" for sort keys %OPTS;
print "$0: ARGV[$_]=$ARGV[$_]\n" for 0 .. $#ARGV;

$0 =~ s|.*/||;
my $readfile = "Makefile";

open FILE, "<$readfile" or die "$0: $readfile: $!";
my @readfile = <FILE>;
my $ID;


while( <@readfile> ){
   for(;;){
      m/^$/ && last;
      s/^\n// && do{
            print "\t\tNewline\n";
            next;
         };
      s/^(?!\n)\s+// && do{
            # Ignore white space |$&|
            next;
         };
      s/^#.*// && do{
            # Ignore comments too |$&|
            next;
         };
      s/^([`"'])(((?!\1).)*)\1?// && do{
            print "\t\tString:\t|$2|\n";
            next;
         };
      s/^(?!\d)\w+// && do{
            ( $ID = $& ) =~ s/.*/\L$&/;
            print "\t\tIdent:\t|$ID|\n";
            print "\t\tWhole line \t|$&|\n";
            next;
         };
      s/^(\d+\.?\d*|\.\d+)([Ee][+-]?\d+)?// && do{
            print "\t\tNumber:\t|$&|\n";
            next;
         };
      s/^(<=?|>=?|\/?=|[-+*%^])// && do{
            print "\t\tOper:\t|$&|\n";
            next;
         };
#      s/^[,:\[\]()]// && do{
#            print "\t\tPunct:\t|$&|\n";
#            next;
#         };
      s/^.// && do{
            print "\t\tError:\t|$&|\n";
            next;
         };
      print "\t\tThis can't happen |$_|\n";
   };
   close ARGV if eof;
}

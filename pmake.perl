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

my %macro_hash = ();
my %target_hash = ();
my @has_pre = ();
my %cmd_hash = ();
my $previous_target = "";


print "$0: -$_ = $OPTS{$_}\n" for sort keys %OPTS;
print "$0: ARGV[$_]=$ARGV[$_]\n" for 0 .. $#ARGV;

$0 =~ s|.*/||;
my $readfile = "Makefile";

open my $file, $readfile or die "$0: $readfile: $!";
my $ID;


while( defined(my $line = <$file>) ){
   if($line !~ /^#.+/){
      if($line =~ /\s*(\S+)\s*=\s+(.+)/){
            my $macro = $1;
            my $value = $2;
            my @value_split = ();
            @value_split = split(" ", $value);
            $macro_hash{$macro} = [@value_split];
            print "macro = $macro\nvalue = $value\n";
      }
      elsif($line =~ /\s*(\S+)\s*:.*/ and $line !~ /\t\s*.+/){
            my $target = $1;
            $previous_target = $target;
            if($line =~ /.+:\s+(.+)/){
                my @value_split = ();
                @value_split = split(" ", $1);
                $target_hash{$target} = [@value_split];
                push(@has_pre, $target);
            }
            else{
                $target_hash{$target} = "";
            }
            print "Target =  $target\n";
      }   
      elsif($line =~ /\t\s*(.+)/){
            print "Command:\n";
            my $cmd = $1;
            my @value_split = ();
            if( exists $cmd_hash{$previous_target}){
                @value_split = split(" ", $cmd);
                push(@{$cmd_hash{$previous_target}}, @value_split);
                push(@{$cmd_hash{$previous_target}}, "\n");
            }
            else{
                $cmd_hash{$previous_target} = ();
                @value_split = split(" ", $cmd);
                push(@{$cmd_hash{$previous_target}}, @value_split);
                push(@{$cmd_hash{$previous_target}}, "\n");
            }
            print $line;
      }
   }else{
      print "Comment:\n";
      print $line;
   }
     
   close ARGV if eof;
}
print "############# Macro Hash ###########\n";
for my $macros (keys %macro_hash){
    print "$macros: @{ $macro_hash{$macros} }\n";
}
print "############# target hash ########\n";

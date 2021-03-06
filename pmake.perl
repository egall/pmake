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
#    $0 [-h]   - for help 
#    $0        - to make
#    $0 clean  - to clean
#    $0 submit - to submit
#
# DESCRIPTION
#    Performs make on given directory
#
# OPTIONS
#    -h    print help and exit
#
__END_USAGE__

use Getopt::Std;
my %OPTS;
getopts ("abcho:p:q:", \%OPTS);
print $USAGE and exit if $OPTS{'h'};

my $action = "";
$action = $ARGV[0] if $ARGV[0];



print "$0: -$_ = $OPTS{$_}\n" for sort keys %OPTS;
print "$0: ARGV[$_]=$ARGV[$_]\n" for 0 .. $#ARGV;

$0 =~ s|.*/||;
my $readfile = "Makefile";

open my $file, $readfile or die "$0: $readfile: $!";
my $ID;

my %macro_hash = ();
my %target_hash = ();
my %cmd_hash = ();
my @has_pre = ();
my $previous_target = "";

while( defined(my $line = <$file>) ){
   if($line !~ /^#.+/){
      if($line =~ /\s*(\S+)\s*=\s+(.+)/){
            my $macro = $1;
            my $value = $2;
            my @value_split = ();
            @value_split = split(" ", $value);
            $macro_hash{$macro} = [@value_split];
#            print "macro = $macro\nvalue = $value\n";
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
#            print "Target =  $target\n";
      }   
      elsif($line =~ /\t\s*(.+)/){
#            print "Command:\n";
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
#            print $line;
      }
   }else{
#      print "Comment:\n";
#      print $line;
   }
     
   close ARGV if eof;
}
for my $macros (keys %macro_hash){
    my @check_list = @{$macro_hash{$macros}};
    @check_list = &replace_macro(\@check_list, \%macro_hash);
    $macro_hash{$macros} = [@check_list];
}


foreach my $tar (@has_pre){
    if($tar =~ /\$\{([^\}]+)\}/){
        my @replace_target = @{$macro_hash{$1}};
        my $replace = "";
        foreach my $str (@replace_target){
            $replace = $str;
        }
        my @replace_list = @{$target_hash{$tar}};
        delete $target_hash{$tar};
        @{$target_hash{$replace}} = @replace_list;
        $tar = $replace;
    }
    my @check_list = @{$target_hash{$tar}};
    if(@check_list > 0){
        @check_list = &replace_macro(\@check_list,\%macro_hash);
        $target_hash{$tar} = [@check_list];
    }
}

foreach my $tar (keys %cmd_hash){
    if($tar =~ /\$\{([^\}]+)\}/){
        my @replace_target = @{$macro_hash{$1}};
        my $replace = "";
        foreach my $str (@replace_target){
            $replace = $str;
        }
        my @replace_list = @{$cmd_hash{$tar}}; 
        delete $cmd_hash{$tar};
        @{$cmd_hash{$replace}} = @replace_list;
        $tar = $replace;
    }
    my @check_list = @{$cmd_hash{$tar}};
    @check_list = &replace_macro(\@check_list,\%macro_hash);
    $cmd_hash{$tar} = [@check_list];
}


foreach my $targ (keys %cmd_hash){
    if($action eq ''){
        if($targ ne "clean"){
            print "$targ: @{$cmd_hash{$targ}}\n";
            my @exec_cmd = @{$cmd_hash{$targ}};
            print "Executing:\n @exec_cmd\n";
            pop @exec_cmd;
            system(@exec_cmd);
            if($? > 0){
               $EXITCODE = $?;
               die "$0:@{$cmd_hash{$targ}} returned exit code $EXITCODE:$!\n";
            }
        }
    }
    else{
      if($action eq $targ){
          my @exec_cmd = @{$cmd_hash{$targ}};
          pop @exec_cmd;
          system(@exec_cmd);
      }
    }
}


sub replace_macro {
    my @line = @{$_[0]};
    my $macro_hash = $_[1];
    for(my $count = 0; $count < @line; $count++){
       my $value = $line[$count];
       if ($value =~ /(\S+)?\$\{([^\}]+)\}(\S+)?/){
	  my $pre = $1;
	  my $post = $3;
          my @replace_list = @{$macro_hash->{$2}};
	  $replace_list[0] = $pre . $replace_list[0] if $pre;
	  $replace_list[-1] = $replace_list[-1] . $post if $post;
          splice @line, $count, 1, @replace_list;
		 }
       elsif ($value =~ /\$\{([^\}]+)\}/){
          my @replace_list = @{$macro_hash->{$1}};
          splice @line, $count, 1, @replace_list;
       }
    }
    return @line;
}


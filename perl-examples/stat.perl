#!/usr/local/bin/perl -w
use strict;
use warnings;
my $RCSID = '$Id: stat.perl,v 360.1 2006-01-12 16:35:07-08 - - $';

$0 =~ s|^(.*/)?([^/]+)/*$|$2|;
my $EXITCODE = 0;
END { exit $EXITCODE; }
sub note(@) { print STDERR "$0: @_"; };
$SIG{'__WARN__'} = sub { note @_; $EXITCODE = 1; };
$SIG{'__DIE__'} = sub { warn @_; exit; };

(my $USAGE = <<__END_USAGE__) =~ s/^#[ ]?//gm;
#
# NAME
#    $0 - $0 display file status
#
# SYNOPSIS
#    $0 [-l] filename...
#
# DESCRIPTION
#    Displays the status of each file specified in the arg list.
#
# OPTIONS
#    -l  Use lstat(2) instead of stat(2) to display information
#        about the symbolic link instead of the file itself.
#
# SEE ALSO
#    stat(2), lstat(2)
#
# $RCSID
__END_USAGE__

use POSIX qw(locale_h strftime);
setlocale LC_CTYPE, "iso_8859_1";

use Getopt::Std;
my %OPTIONS;
getopts ("l", \%OPTIONS);
print $USAGE and exit unless @ARGV;
my $statlink = $OPTIONS{'l'} ? " -l" : "";

sub print_dev($$) {
   my ($dev, $label) = @_;
   printf "%6d,%4d = %s\n", $dev >> 8, $dev & 0xFF, $label;
};

sub print_time($$) {
   my ($time, $label) = @_;
   printf "%11d = %s = %s\n", $time, $label,
          strftime "%C", localtime $time;
};

for my $filename (@ARGV) {
   my @status = $statlink ? lstat $filename : stat $filename;
   warn "stat $filename: $!" and next unless @status;
   my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size,
       $atime, $mtime, $ctime, $blksize, $blocks) = @status;
   print "$0 $statlink \"$filename\":\n";
   print_dev $dev, "dev: device inode resides on";
   printf "%11d = ino: file's inode number\n", $ino;
   print "###$mode\n";
   printf "%11d = nlink: number of hard links to file\n", $nlink;
   printf "%11d = uid: file's user id = %s\n", $uid, getpwuid $uid;
   printf "%11d = gid: file's group id = %s\n", $gid, getgrgid $gid;
   print_dev $rdev, "rdev: device if a special file";
   printf "%11d = size: file size in bytes\n", $size;
   print_time $atime, "atime: file last access";
   print_time $mtime, "mtime: file last modify";
   print_time $ctime, "ctime: file last change";
   printf "%11d = blksize: preferred I/O block size\n", $blksize;
   printf "%11d = blocks: number 512 byte blocks allocated\n", $blocks;
};


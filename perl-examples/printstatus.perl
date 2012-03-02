#!/usr/bin/perl
# $Id: printstatus.perl,v 1.1 2009-01-05 19:41:33-08 - - $
#
# Copy code from this file in order to print an exit status.
#
use strict;
use warnings;

my %status_strings = (
    1=> "Hangup",
    2=> "Interrupt",
    3=> "Quit",
    4=> "Illegal Instruction",
    5=> "Trace/Breakpoint Trap",
    6=> "Abort",
    7=> "Emulation Trap",
    8=> "Arithmetic Exception",
    9=> "Killed",
   10=> "Bus Error",
   11=> "Segmentation Fault",
   12=> "Bad System Call",
   13=> "Broken Pipe",
   14=> "Alarm Clock",
   15=> "Terminated",
   16=> "User Signal 1",
   17=> "User Signal 2",
   18=> "Child Status Changed",
   19=> "Power-Fail/Restart",
   20=> "Window Size Change",
   21=> "Urgent Socket Condition",
   22=> "Pollable Event",
   23=> "Stopped (signal)",
   24=> "Stopped (user)",
   25=> "Continued",
   26=> "Stopped (tty input)",
   27=> "Stopped (tty output)",
   28=> "Virtual Timer Expired",
   29=> "Profiling Timer Expired",
   30=> "Cpu Limit Exceeded",
   31=> "File Size Limit Exceeded",
   32=> "No runnable lwp",
   33=> "Inter-lwp signal",
   34=> "Checkpoint Freeze",
   35=> "Checkpoint Thaw",
   36=> "Thread Cancellation",
   37=> "Resource Lost",
   38=> "First Realtime Signal",
   39=> "Second Realtime Signal",
   40=> "Third Realtime Signal",
   41=> "Fourth Realtime Signal",
   42=> "Fourth Last Realtime Signal",
   43=> "Third Last Realtime Signal",
   44=> "Second Last Realtime Signal",
   45=> "Last Realtime Signal",
);

#
# See man -s 2 wait for an explanation.
#
sub status_string ($) {
   my ($status) = @_;
   return undef unless $status;
   printf "0x%08X\n", $status;
   print $status & 0xFF, "\n";
   return sprintf "Error %d", $status >> 8 if ($status & 0xFF) == 0;
   my $message = $status_strings{$status & 0x7F}
                 || "Invalid Signal Number";
   $message .= " (core dumped)" if $status & 0x80;
   return $message;
}

#
# What you need is the hash and the function.
# The following is just a dummy main function for testing.
#

for my $code (@ARGV) {
   my $string = status_string $code;
   next unless $string;
   printf "status 0x%04X = %s\n", $code, $string;
}

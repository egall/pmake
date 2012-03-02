#!/usr/bin/perl
# $Id: isatty.perl,v 1.1 2009-10-09 18:22:06-07 - - $

use POSIX qw (isatty);

sub printty ($$) {
   my ($handle, $bool) = @_;
   print "$handle is", ($bool ? "" : " not"), " a tty\n";
}

printty "STDIN", -t STDIN;
printty "STDOUT", -t STDOUT;
printty "STDERR", -t STDERR;

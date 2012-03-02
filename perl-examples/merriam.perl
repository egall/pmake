#!/usr/local/bin/perl -w
use strict;
use warnings;
my $RCSID = '$Id: merriam.perl,v 358.1 2005-10-28 18:44:40-07 - - $';

$0 =~ s|^(.*/)?([^/]+)/*$|$2|;
my $EXITCODE = 0;
END{ exit $EXITCODE; }
sub note(@){ print STDERR "$0: @_"; };
$SIG{'__WARN__'} = sub{ note @_; $EXITCODE = 1; };
$SIG{'__DIE__'} = sub{ warn @_; exit; };

(my $USAGE = <<__END_USAGE__) =~ s/^#[ ]?//mg;
#
# NAME
#    $0 - look up words in the Merriam-Webster online dictionary.
#
# SYNOPSIS
#    $0 words...
#
# DESCRIPTION
#    Each word specified in @ARGV is looked up in Merriam-Webster's
#    online dictionary, with the results displayed to STDOUT.
#
# BUGS
#    This is a hack into HTML, so if the format of the pages served
#    changes, this script will no longer work.
#
# RCSID
#    $RCSID
#
__END_USAGE__

print STDERR $USAGE and exit unless @ARGV;

my $MWURL = "http://www.m-w.com/cgi-bin/dictionary?book=Dictionary&va=";
my $fmtpipe = "| fmt -s";
open FMTPIPE, $fmtpipe or die "$fmtpipe: $!";

for my $word( @ARGV ){
   my $codeword = $word;
   $codeword =~ s/\s+/+/g;
   my $cmd = "lynx -source '$MWURL'$codeword\n";
   my $page = `$cmd`;
   $page =~ s|\r||sig;
   $page =~ s|.*<!-- begin content -->(.*)<!-- end content -->.*|$1|si;
   $page =~ s|((.*?</table>){2}).*|$1|si;
   $page =~ s|&nbsp;| |sig;
   $page =~ s|<br>\s*|\n|sig;
   $page =~ s|<[^>]*>||sig;
   $page =~ s|^\s*|\n|si;
   $page =~ s|\s*$|\n|si;
   $page =~ s|\s*\n\s*\n+|\n\n|sig;
   $page =~ s|&lt;|<|sig;
   $page =~ s|&gt;|>|sig;
   $page =~ s|&amp;|&|sig;

   print FMTPIPE $page;
};

close FMTPIPE;

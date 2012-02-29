#!/usr/local/bin/perl -w
# $Id: xy.perl,v 311.2 2001-03-02 13:15:29-08 - - $
#
# NAME
#    x - start a new command in an xterm, man and perldoc special.
#
# SYNOPSIS
#    x [man|perldoc|command] [operands...]]
#
# DESCRIPTION
#    The command given is started in a new xterm with the title
#    set to the command.  If no command is given, just starts an
#    xterm.
#
#    If the command is either man or perldoc, the program is run
#    with STDOUT and STDERR redirected to a temporary file, which
#    is then edited to remove backspace graphics, after which the
#    file is brought up in an xterm with view.
#

use POSIX;
$0 =~ s{.*/}{};

sub view_command(@){

   $tmpname = '/var/tmp';
   $tmpdir = $ENV{ TMPDIR } || '/var/tmp';
   mkdir $tmpdir, 0755 or die "$0: $tmpdir: $!" unless -d $tmpdir;
   $tmpdir = $tmpname unless -d $tmpdir;

   $file = join ':', $0, $<, $argv = join ' ', @ARGV;
   $file =~ s/\s/:/g;
   $file =~ s{[\s!"#$&'()*/;<=>?[\\\]^`{|}]}
               {sprintf "=%02X", ord $&}egimx;
   $file = "$tmpdir/$file";

   unless( -r $file ){
      select( STDERR ); $| = 1;
      select( STDOUT ); $| = 1;
      $pid = open PIPE, '-|';
      defined $pid or die "$0: open( PIPE, '-|' ): $!";
      if( $pid == 0 ){
         close STDIN or die "$0: close STDIN: $!";
         exec @ARGV;
         die "$0: exec @ARGV: $!";
      };
      open FILE, ">$file" or die "$0: $file: $!";
      $old_RS = $/;
      $/ = ''; # Paragraph mode.
      while( $line = <PIPE> ){
         0 while $line =~ s/(.)[\b]\1/$1/g;
         0 while $line =~ s/_[\b]|[\b]_//g;
         0 while $line =~ s/o[\b]\+|\+[\b]o/\+/g;
         print FILE $line;
      };
      $/ = $old_RS;
      close FILE;
      close PIPE;
      print "$0: $argv: pid $pid, status $?\n" if $?;
   };
   @ARGV = ( 'view', $file );
};

%special = (
   'man'     => \&view_command,
   'perldoc' => \&view_command,
);

sub main(){

   @uname{ qw( -s -n -r -v -m ) } = uname;
   $hostname = $uname{ '-n' };
   $username = scalar getpwuid $<;

   if( @ARGV ){
      $title = join ' ', $0, @ARGV;
      $special = $special{ $ARGV[0] } and &$special;;
      unshift @ARGV, '-e';
   }else{
      $title = "$hostname!$username";
   };

   @title = ( '-n', $title, '-T', $title );
   @command = ( qw( xterm -ut -ls ), @title, @ARGV );
   print STDERR join( ' ', @command ), "\n";
   exec @command;
   die "$0: exec @command: $!";

};

main;


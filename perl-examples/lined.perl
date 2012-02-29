#!/usr/bin/perl
# $RCSfile: lined.perl,v $$Revision: 19980205.115128 $

%switch = (
   ' ' => sub{ &printline( "+1" ); },
   "\t"=> sub{ &printline( "+1" ); },
   "\n"=> sub{ &printline( "+1" ); },
   '+' => sub{ &printline( "+1" ); },
   '-' => sub{ &printline( "-1" ); },
   '^' => sub{ &printline( "-1" ); },
   '.' => sub{ &printline( "+0" ); },
   '*' => sub{ print @file; $curr = @file; },
   '$' => sub{ &printline( scalar( @file )); },
   'D' => sub{ print STDERR "\$0=$0; \@ARGV=@ARGV; \$curr=$curr; ",
                     "\$prevcmd=$prevcmd; \$changed=$changed;\n"; },
   'a' => sub{ while( defined( $line = <STDIN> )){
                  print $line unless -t STDIN && -t STDOUT;
                  last if $changed = $line =~ m/^\.\n$/;
                  splice( @file, $curr++, 0, $line );
               }; },
   'd' => sub{ splice( @file, $curr - 1, $changed = 1 );
               &printline( "+0" ); },
   'q' => sub{ exit unless $prevcmd !~ m/^q/ && $changed;
               print "Are you sure?\n"; },
   'w' => sub{ &writefile; },
);

die "Usage: $0 filename\n" if @ARGV != 1;
if( open( INPUT, "<$ARGV[0]" )){
   print $curr = @file = <INPUT>, " lines.\n";
   close( INPUT );
}else{
   print STDERR "$0: $ARGV[0]: $!\n";
};

while( $prevcmd = $cmd, print( "ed: " ), $cmd = <STDIN> ){
   print $cmd unless -t STDIN && -t STDOUT;
   if( $cmd =~ m/^[+-]?\d+/ ){
      &printline( "$&" );
   }else{
      $cmd =~ m/./s && defined( $case = $switch{ $& } )
      ? &${case}
      : print "Bad command: $cmd";
   };
};
&writefile;

sub writefile{
   open( OUTPUT, ">$ARGV[0]" ) || die "$0: $ARGV[0]: $!\n";
   print OUTPUT @file;
   close( OUTPUT );       
   print $curr = @file, " lines.\n";
   $changed = 0;
};

sub printline{
   $curr = $_[0] =~ m/^[+-]/ ? $curr + $_[0] : $_[0];
   $curr = $curr < 0 ? 0 : $curr > @file ? @file : $curr;
   print $file[ $curr - 1 ] if $curr;
};


#!/usr/bin/perl
# $RCSfile: runtest.perl,v $$Revision: 19980205.120023 $
#
# Note to grader:  To run this script, you need to copy all
# of the files matching the pattern *.in and *.dat from the
# course locker into the directory to which the student did
# the submission.  Then run this script in that directory.
# You probably want to delete the lines which run the lis and
# enscript commands.
#
# Before doing so, check to see that there are no files matching
# *.in, *.out, *.new, or *.dat, which will be crapped on.  Take
# off some points if the student submitted any files with these
# names.
#
# Change the filename in quotes below to the name of the
# student's executable.

$editor = "lined.perl";

#
# Note to students:  since the grader will be compiling your
# code from sources, you have no control over what this name
# will be.  Hence the required use of argv[0] in your error
# messages.
#

#
# Beginning of the program.
#

unlink <test*.new>, <test*.out>, <test*.err>;

for $infile( <testi*.in> ){
   ( $base = $infile ) =~ s/\.in$//;
   &execute( "cp $base.dat $base.new 2>&1" ) if -r "$base.dat";
   &execute( "$editor $base.new <$base.in >$base.out 2>$base.err" );
};

&execute( "$editor           </dev/null >testx1.out 2>testx1.err" );
&execute( "$editor /dev/null <testx2.in >testx2.out 2>testx2.err" );
&execute( "$editor /no/file  <testx2.in >testx4.out 2>testx4.err" );

&execute( "lis [a-z]*.* >Listing.lis" );
&execute( "enscript -G2r -g -p- `pwd`/Listing.lis >Listing.ps" );

sub execute{
   my( $command ) = @_;
   print "% $command\n";
   print `$command`;
};

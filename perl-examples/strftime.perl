#!/usr/bin/perl
# $RCSfile: strftime.perl,v $$Revision: 970403.153410 $

# Illustrate use of POSIX::strftime called from Perl.
# strftime should be used to format dates in various ways.

use POSIX qw( strftime );
@time_now = localtime( $^T );

sub strf{
   my( $key ) = @_;
   $key = "%$key";
   my( $val ) = strftime( "$key", @time_now );
   return '' if $key eq $val;
   $val =~ s/\n/\\n/g;
   $val =~ s/\t/\\t/g;
   return "$key=$val;";
};

print "$0\n";
print 72 x '=', "\n";
for $key( 'a'..'z' ){
   printf "%-30s%-30s\n", &strf( $key ), &strf( uc( $key ));
};
print 72 x '=', "\n";

for $key( "%Y/%m/%d (%a)" ){
   printf "%s=%s;\n", $key, strftime( $key, @time_now );
};
print "Perl version=$]\n";
print '`date`:   ', `date`;
print 'strftime: ', strftime( "%a %b %e %T %Z %Y\n", localtime() );

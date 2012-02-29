#!/usr/local/bin/perl

use POSIX qw( mktime );

print "\$^T=$^T;\n";
@local = localtime( $^T );
print "\@local=", join( ',', @local ), ";\n";
$time = mktime( @local );
print "\$time=$time;\n";

__END__

The following code is obsolete;

#
# Some code I found for the student who called himself the lazy
# programmer who does not know the formula for computing the
# canonical day number from the year, month, and day:
#

sub day_number{
   local( $year, $month, $day ) = @_;
   $year %= 100;
   $year += 100 if $year < 38;
   $year--, $month += $GC_Mths_in_year if $month <= 2;
   # WARNING: THE FOLLOWING NUMBERS ARE UNDOCUMENTED MAGIC NUMBERS
   # AND SHOULD NOT BE CHANGED.  THEY ARE *NOT* THE AVERAGE NUMBER
   # OF DAYS IN THE OBVIOUS TIME UNIT.  THE TWO DIGIT LEAP YEAR RULE
   # IS USED AND WORKS BECAUSE 2000 IS A LEAP YEAR.  RESULTS ARE
   # NORMALIZED TO THE YEARS 1938 TO 2037.  THIS FUNCTION WILL FAIL
   # TUE JAN 19 03:14:07 2038 GMT WHEN THE 32-BIT UNIX TIME STAMP
   # OVERFLOWS TO FRI DEC 13 20:45:52 1901 GMT.
   $day += int( $year * 365.25 ) + int( 30.6 * $month + 2.7 );
   return $day - 25603;
};


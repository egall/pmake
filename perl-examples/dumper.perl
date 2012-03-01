#!/usr/bin/perl
# $Id: dumper.perl,v 1.5 2009-05-29 13:01:01-07 - - $
# Example of using Data::Dumper;

use Data::Dumper;

$a = [1,2,3,4,5];
$b = {qw (A B C D)};
@c = (1,2,3);
$t = {LEAF=> 'a'};
$u = {LEAF=> 'b'};
$v = {OPER=> '+', LEFT=> $t, RIGHT=> $u};
$w = {OPER=> '*', LEFT=> 'x', RIGHT=> $v};
@p = (\$a, \$b, \@c, \$w);
print Dumper @p;
print "$t, $u, $v\n";

#!/usr/bin/perl
print sort map "$_=$ENV{$_}\n", keys %ENV

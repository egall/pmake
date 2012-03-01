#!/usr/local/bin/perl -w
# $Id: fixreadme.perl,v 347.12 2004-10-07 14:32:41-07 - - $
#
# SYNOPSIS
#    fixreadme.perl
#
# DESCRIPTION
#    Edits the given file, looking for strings matching /http:lab\d+/
#    and replacing them with actual directory names beginning with
#    /lab*/.  In addition, creates a file called `editreadme.ed'
#    which can be used to edit the other README file.
#

$0 =~ s|.*/||;
$readfile = "README-all-cmps012m.text";
$edfile = "editreadme.ed";

open FILE, "<$readfile" or die "$0: $readfile: $!";
@readfile = <FILE>;
close $readfile;
print `cid + $readfile`;

@labs = glob "lab[0-9]*";
for $lab( @labs ){
   @base = $lab =~ m/^(lab\d+)/;
   map{ s|http:$base[0]\S*|http:$lab| } @readfile;
};

open FILE, ">$readfile" or die "$0: $readfile: $!";
print FILE @readfile;
close $readfile;
print `cid + $readfile`;

$pattern = "^\..*cmps012m.* --- http:";
@greplines = grep{ m|$pattern| } @readfile;
($pwdlast = $ENV{PWD}) =~ s|.*/||;
map{ s|http:|$&$pwdlast/| } @greplines;

open ED, ">$edfile" or die "$0: $edfile: $!";
print ED "g/$pattern/d\n",
         "a\n",
         @greplines,
         ".\n",
         "w\n",
         "q\n";
close ED;
        

#!/usr/local/bin/perl -00p
#
# NAME
#    squeeze - squeeze out multiple empty lines
#
# SYNOPSIS
#    squeeze [filename...]
#
# DESCRIPTION
#    Read either from the list of filenames given, or stdin.
#    Copy input to output, and eliminate blank lines.  Note
#    that this program consists entirely of comments and all
#    of the program logic is in the #! line.
#
#    -00     put perl into paragraph mode for input.
#    -p      echo input to output
#
# To make this into a csh alias, put the following line in
# (without the hash on the front) into your .cshrc:
# alias squeeze perl -00pe0
#
# Or run the following from the command line:
# % perl -00pe0 foo bar baz
#
# This latter will cat the three files specified.  Note that
# from the command line you need the option -e0 which is an inline
# perl program.  0 is just a place keeper which does nothing.

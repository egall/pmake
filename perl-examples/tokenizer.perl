#!/usr/local/bin/perl
#
# Tokenizer example code.
# Input:  any program in some suitable language.
# Output: debug dump of the tokens in the program.
#

while( <> ){
   printf "%s %4d:\t%s", $ARGV, $., $_;
   for(;;){
      m/^$/ && last;
      s/^\n// && do{
            print "\t\tNewline\n";
            next;
         };
      s/^(?!\n)\s+// && do{
            # Ignore white space |$&|
            next;
         };
      s/^#.*// && do{
            # Ignore comments too |$&|
            next;
         };
      s/^([`"'])(((?!\1).)*)\1?// && do{
            print "\t\tString:\t|$2|\n";
            next;
         };
      s/^(?!\d)\w+// && do{
            ( $ID = $& ) =~ s/.*/\L$&/;
            print "\t\tIdent:\t|$ID|\n";
            next;
         };
      s/^(\d+\.?\d*|\.\d+)([Ee][+-]?\d+)?// && do{
            print "\t\tNumber:\t|$&|\n";
            next;
         };
      s/^(<=?|>=?|\/?=|[-+*%^])// && do{
            print "\t\tOper:\t|$&|\n";
            next;
         };
      s/^[,:\[\]()]// && do{
            print "\t\tPunct:\t|$&|\n";
            next;
         };
      s/^.// && do{
            print "\t\tError:\t|$&|\n";
            next;
         };
      print "\t\tThis can't happen |$_|\n";
   };
   close ARGV if eof;
}

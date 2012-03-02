// $Id: sigtoperl.c,v 1.9 2011-03-24 17:54:12-07 - - $

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>

int main (void) {
   int sig;
   system ("echo '#' `uname -srp`");
   printf ("my @strsignals;\n");
   for (sig = 0; sig <= 0xFF; ++sig) {
      char *strsig = strsignal (sig);
      if (strsig == NULL) continue;
      if (strstr (strsig, "Unknown signal") == strsig) continue;
      printf ("$strsignals[%d] = \"%s\";\n", sig, strsig);
   }
   return EXIT_SUCCESS;
}


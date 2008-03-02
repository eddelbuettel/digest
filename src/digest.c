
// hey emacs this is -*- c++ -*-
// $Id$

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>
#include "sha1.h"		
#include "md5.h"

SEXP digest(SEXP Txt, SEXP Algo) {

  char *txt = STRING_VALUE(Txt);
  int algo = INTEGER_VALUE(Algo);
  SEXP result = NULL;
  char output[41];		/* 33 for md5, 41 for sha1 */

  switch (algo) {
    case 1: {			/* md5 case */
      md5_context ctx;
      unsigned char md5sum[16];
      int j;

      //printf("In digest() txt is %s\n", txt);
      md5_starts( &ctx );
      md5_update( &ctx, (uint8 *) txt, strlen(txt));
      md5_finish( &ctx, md5sum );

      for(j = 0; j < 16; j++) {
	sprintf(output + j * 2, "%02x", md5sum[j]);
      }
      //printf("In digest, output is %s\n", output);
      break;
    }
    case 2: {			/* sha1 case */
      int i, j;
      sha1_context ctx;
      unsigned char sha1sum[20];

      sha1_starts( &ctx );
      sha1_update( &ctx, (uint8 *) txt, strlen(txt));
      sha1_finish( &ctx, sha1sum );

      for( j = 0; j < 20; j++ ) {
	sprintf( output + j * 2, "%02x", sha1sum[j] );
      }
      break;
    }
    default: {
      error("Unsupported algorithm code");
      return(NULL);
    }  
  }
    
  PROTECT(result=allocVector(STRSXP, 1));
  SET_STRING_ELT(result, 0, mkChar(output));
  UNPROTECT(1);			

  return result;
}

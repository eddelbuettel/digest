/*
  hey emacs this is -*- c++ -*-

  digest -- hash digest functions for R

  Copyright 2003, 2004, 2005  Dirk Eddelbuettel <edd@debian.org>

  $Id: digest.c,v 1.4 2005/03/23 03:55:15 edd Exp $

  This file is part of the digest packages for GNU R.
  It is made available under the terms of the GNU General Public
  License, version 2, or at your option, any later version,
  incorporated herein by reference.

  This program is distributed in the hope that it will be
  useful, but WITHOUT ANY WARRANTY; without even the implied
  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.  See the GNU General Public License for more
  details.

  You should have received a copy of the GNU General Public
  License along with this program; if not, write to the Free
  Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>
#include "sha1.h"		
#include "md5.h"
#include "zlib.h"
unsigned long ZEXPORT digest_crc32(unsigned long crc,
				   const unsigned char FAR *buf,
				   unsigned len);

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

      md5_starts( &ctx );
      md5_update( &ctx, (uint8 *) txt, strlen(txt));
      md5_finish( &ctx, md5sum );

      for(j = 0; j < 16; j++) {
	sprintf(output + j * 2, "%02x", md5sum[j]);
      }
      break;
    }
    case 2: {			/* sha1 case */
      int j;
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
    case 3: {			/* crc32 case */
      unsigned long val, l;
      l = strlen(txt);

      val  = digest_crc32(0L, 0, 0);
      val  =  digest_crc32(val , txt,(unsigned) l);
      
      sprintf(output, "%2.2x", (unsigned int) val);

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

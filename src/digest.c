/* -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-

  digest -- hash digest functions for R

  Copyright (C) 2003 - 2016  Dirk Eddelbuettel <edd@debian.org>

  This file is part of digest.

  digest is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.

  digest is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with digest.  If not, see <http://www.gnu.org/licenses/>.

*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>
#include <Rversion.h>
#include <inttypes.h>
#include "sha1.h"
#include "sha2.h"
#include "sha256.h"
#include "md5.h"
#include "zlib.h"
#include "xxhash.h"
#include "pmurhash.h"

unsigned long ZEXPORT digest_crc32(unsigned long crc,
                                   const unsigned char FAR *buf,
                                   unsigned len);

static const char *sha2_hex_digits = "0123456789abcdef";


SEXP digest(SEXP Txt, SEXP Algo, SEXP Length, SEXP Skip, SEXP Leave_raw, SEXP Seed) {
    size_t BUF_SIZE = 1024;
    FILE *fp=0;
    char *txt;
    int algo = INTEGER_VALUE(Algo);
    int  length = INTEGER_VALUE(Length);
    int skip = INTEGER_VALUE(Skip);
    int seed = INTEGER_VALUE(Seed);
    int leaveRaw = INTEGER_VALUE(Leave_raw);
    SEXP result = R_NilValue;
    char output[128+1], *outputp = output;    /* 33 for md5, 41 for sha1, 65 for sha256, 128 for sha512; plus trailing NULL */
    R_xlen_t nChar;
    int output_length = -1;
    if (IS_RAW(Txt)) { /* Txt is either RAW */
        txt = (char*) RAW(Txt);
#if defined(R_VERSION) && R_VERSION >= R_Version(3,0,0)
        nChar = XLENGTH(Txt);
#else
        nChar = LENGTH(Txt);
#endif
    } else { /* or a string */
        txt = (char*) STRING_VALUE(Txt);
        nChar = strlen(txt);
    }
    if (skip > 0 && algo < 100) {
        if (skip>=nChar) {
            nChar=0;                                                            /* #nocov */
        } else {
            nChar -= skip;
            txt += skip;
        }
    }
    if (length>=0 && length<nChar) nChar = length;

    switch (algo) {
    case 1: {     /* md5 case */
        md5_context ctx;
        output_length = 16;
        unsigned char md5sum[16];
        int j;
        md5_starts( &ctx );
        md5_update( &ctx, (uint8 *) txt, nChar);
        md5_finish( &ctx, md5sum );
        memcpy(output, md5sum, 16);

        if (!leaveRaw)
            for (j = 0; j < 16; j++)
                sprintf(output + j * 2, "%02x", md5sum[j]);

        break;
    }
    case 2: {     /* sha1 case */
        int j;
        sha1_context ctx;
        output_length = 20;
        unsigned char sha1sum[20];

        sha1_starts( &ctx );
        sha1_update( &ctx, (uint8 *) txt, nChar);
        sha1_finish( &ctx, sha1sum );
        memcpy(output, sha1sum, 20);

        if (!leaveRaw)
            for ( j = 0; j < 20; j++ )
                sprintf( output + j * 2, "%02x", sha1sum[j] );

        break;
    }
    case 3: {     /* crc32 case */
        unsigned long val, l;
        l = nChar;

        val  = digest_crc32(0L, 0, 0);
        val  = digest_crc32(val, (unsigned char*) txt, (unsigned) l);

        sprintf(output, "%08x", (unsigned int) val);
        break;
    }
    case 4: {     /* sha256 case */
        int j;
        sha256_context ctx;
        output_length = 32;
        unsigned char sha256sum[32];

        sha256_starts( &ctx );
        sha256_update( &ctx, (uint8 *) txt, nChar);
        sha256_finish( &ctx, sha256sum );
        memcpy(output, sha256sum, 32);

        if (!leaveRaw)
            for ( j = 0; j < 32; j++ )
                sprintf( output + j * 2, "%02x", sha256sum[j] );

        break;
    }
    case 5: {     /* sha2-512 case */
        int j;
        SHA512_CTX ctx;
        output_length = SHA512_DIGEST_LENGTH;
        uint8_t sha512sum[output_length], *d = sha512sum;

        SHA512_Init(&ctx);
        SHA512_Update(&ctx, (uint8 *) txt, nChar);
        /* Calling SHA512_Final, because SHA512_End will already
           convert the hash to a string, and we also want RAW */
        SHA512_Final(sha512sum, &ctx);
        memcpy(output, sha512sum, output_length);

        /* adapted from SHA512_End */
        if (!leaveRaw) {
            for (j = 0; j < output_length; j++) {
                *outputp++ = sha2_hex_digits[(*d & 0xf0) >> 4];
                *outputp++ = sha2_hex_digits[*d & 0x0f];
                d++;
            }
            *outputp = (char)0;
        }
        break;
    }
    case 6: {     /* xxhash32 case */
        unsigned int val =  XXH32(txt, nChar, seed);
        sprintf(output, "%08x", val);
        break;
    }
    case 7: {     /* xxhash64 case */
        unsigned long long val =  XXH64(txt, nChar, seed);
#ifdef WIN32
        sprintf(output, "%016" PRIx64, val);
#else
        sprintf(output, "%016llx", val);
#endif
        break;
    }
    case 8: {     /* MurmurHash3 32 */
        unsigned int val = PMurHash32(seed, txt, nChar);
        sprintf(output, "%08x", val);
        break;
    }
    case 101: {     /* md5 file case */
        int j;
        md5_context ctx;
        output_length = 16;
        unsigned char buf[BUF_SIZE];
        unsigned char md5sum[16];

        if (!(fp = fopen(txt,"rb"))) {
            error("Cannot open input file: %s", txt); /* already covered at R level too */ /* #nocov */
        }
        if (skip > 0) fseek(fp, skip, SEEK_SET);
        md5_starts( &ctx );
        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0
                   && length>0) {
                if (nChar>length) nChar=length;
                md5_update( &ctx, buf, nChar );
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0)
                md5_update( &ctx, buf, nChar );
        }
        fclose(fp);
        md5_finish( &ctx, md5sum );
        memcpy(output, md5sum, 16);
        if (!leaveRaw)
            for (j = 0; j < 16; j++)
                sprintf(output + j * 2, "%02x", md5sum[j]);
        break;
    }
    case 102: {     /* sha1 file case */
        int j;
        sha1_context ctx;
        output_length = 20;
        unsigned char buf[BUF_SIZE];
        unsigned char sha1sum[20];

        if (!(fp = fopen(txt,"rb"))) {
            error("Cannot open input file: %s", txt); /* already covered at R level too */ /* #nocov */
        }
        if (skip > 0) fseek(fp, skip, SEEK_SET);
        sha1_starts ( &ctx );
        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length>0) {
                if (nChar>length) nChar=length;
                sha1_update( &ctx, buf, nChar );
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0)
                sha1_update( &ctx, buf, nChar );
        }
        fclose(fp);
        sha1_finish ( &ctx, sha1sum );
        memcpy(output, sha1sum, 20);
        if (!leaveRaw)
            for ( j = 0; j < 20; j++ )
                sprintf( output + j * 2, "%02x", sha1sum[j] );
        break;
    }
    case 103: {     /* crc32 file case */
        unsigned char buf[BUF_SIZE];
        unsigned long val;

        if (!(fp = fopen(txt,"rb"))) {
            error("Cannot open input file: %s", txt); /* already covered at R level too */ /* #nocov */
        }
        if (skip > 0) fseek(fp, skip, SEEK_SET);
        val  = digest_crc32(0L, 0, 0);
        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length>0) {
                if (nChar>length) nChar=length;
                val  = digest_crc32(val , buf, (unsigned) nChar);
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0)
                val  = digest_crc32(val , buf, (unsigned) nChar);
        }
        fclose(fp);
        sprintf(output, "%08x", (unsigned int) val);
        break;
    }
    case 104: {     /* sha256 file case */
        int j;
        sha256_context ctx;
        output_length = 32;
        unsigned char buf[BUF_SIZE];
        unsigned char sha256sum[32];

        if (!(fp = fopen(txt,"rb"))) {
            error("Cannot open input file: %s", txt); /* already covered at R level too */ /* #nocov */
        }
        if (skip > 0) fseek(fp, skip, SEEK_SET);
        sha256_starts ( &ctx );
        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length>0) {
                if (nChar>length) nChar=length;
                sha256_update( &ctx, buf, nChar );
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0)
                sha256_update( &ctx, buf, nChar );
        }
        fclose(fp);
        sha256_finish ( &ctx, sha256sum );
        memcpy(output, sha256sum, 32);
        if (!leaveRaw)
            for ( j = 0; j < 32; j++ )
                sprintf( output + j * 2, "%02x", sha256sum[j] );
        break;
    }
    case 105: {     /* sha2-512 file case */
        int j;
        SHA512_CTX ctx;
        output_length = SHA512_DIGEST_LENGTH;
        uint8_t sha512sum[output_length], *d = sha512sum;

        unsigned char buf[BUF_SIZE];

        if (!(fp = fopen(txt,"rb"))) {
            error("Cannot open input file: %s", txt); /* already covered at R level too */ /* #nocov */
        }
        if (skip > 0) fseek(fp, skip, SEEK_SET);
        SHA512_Init(&ctx);
        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length>0) {
                if (nChar>length) nChar=length;
                SHA512_Update( &ctx, buf, nChar );
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0)
                SHA512_Update( &ctx, buf, nChar );
        }
        fclose(fp);

		/* Calling SHA512_Final, because SHA512_End will already
		   convert the hash to a string, and we also want RAW */
		SHA512_Final(sha512sum, &ctx);
		memcpy(output, sha512sum, output_length);

		/* adapted from SHA512_End */
		if (!leaveRaw) {
            for (j = 0; j < output_length; j++) {
                *outputp++ = sha2_hex_digits[(*d & 0xf0) >> 4];
                *outputp++ = sha2_hex_digits[*d & 0x0f];
                d++;
            }
            *outputp = (char)0;

		}
        break;
    }
    case 106: {     /* xxhash32 */
        unsigned char buf[BUF_SIZE];
        XXH32_state_t* const state = XXH32_createState();

        if (!(fp = fopen(txt,"rb"))) {
            error("Cannot open input file: %s", txt); /* already covered at R level too */ /* #nocov */
        }
        if (skip > 0) fseek(fp, skip, SEEK_SET);
        XXH_errorcode const resetResult = XXH32_reset(state, seed);
        if (resetResult == XXH_ERROR) {
          error("Error in `XXH32_reset()`"); 				/* #nocov */
        }
        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length>0) {
                if (nChar>length) nChar=length;
                XXH_errorcode const updateResult = XXH32_update(state, buf, nChar);
                if (updateResult == XXH_ERROR) {
                  error("Error in `XXH32_update()`"); 		/* #nocov */
                }
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0) {
              XXH_errorcode const updateResult = XXH32_update(state, buf, nChar);
              if (updateResult == XXH_ERROR) {
                error("Error in `XXH32_update()`");	 		/* #nocov */
              }
            }
        }
        fclose(fp);
        unsigned int val =  XXH32_digest(state);
        XXH32_freeState(state);

        sprintf(output, "%08x", val);
        break;
    }
    case 107: {     /* xxhash64 */
        unsigned char buf[BUF_SIZE];
        XXH64_state_t* const state = XXH64_createState();

        if (!(fp = fopen(txt,"rb"))) {
            error("Cannot open input file: %s", txt); /* already covered at R level too */ /* #nocov */
        }
        if (skip > 0) fseek(fp, skip, SEEK_SET);
        XXH_errorcode const resetResult = XXH64_reset(state, seed);
        if (resetResult == XXH_ERROR) {
          error("Error in `XXH64_reset()`"); 				/* #nocov */
        }
        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length>0) {
                if (nChar>length) nChar=length;
                XXH_errorcode const updateResult = XXH64_update(state, buf, nChar);
                if (updateResult == XXH_ERROR) {
                  error("Error in `XXH64_update()`"); 		/* #nocov */
                }
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0) {
              XXH_errorcode const updateResult = XXH64_update(state, buf, nChar);
              if (updateResult == XXH_ERROR) {
                error("Error in `XXH64_update()`"); 		/* #nocov */
              }
            }
        }
        fclose(fp);
        unsigned long long val =  XXH64_digest(state);
        XXH64_freeState(state);

#ifdef WIN32
        sprintf(output, "%016" PRIx64, val);
#else
        sprintf(output, "%016llx", val);
#endif
        break;
    }
    case 108: {     /* murmur32 */
        unsigned int h1=seed, carry=0;
        unsigned char buf[BUF_SIZE];
        size_t total_length = 0;

        if (!(fp = fopen(txt,"rb"))) {
            error("Cannot open input file: %s", txt); /* already covered at R level too */ /* #nocov */
        }
        if (skip > 0) fseek(fp, skip, SEEK_SET);
        if (length>=0) {
            while( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0
                   && length>0) {
                if (nChar>length) nChar=length;
                PMurHash32_Process(&h1, &carry, buf, nChar);
                length -= nChar;
                total_length += nChar;
            }
        } else {
            while( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0) {
                PMurHash32_Process(&h1, &carry, buf, nChar);
                total_length += nChar;
            }
        }
        fclose(fp);
        unsigned int val = PMurHash32_Result(h1, carry, total_length);

        sprintf(output, "%08x", val);
        break;
    }
    default: {
        error("Unsupported algorithm code"); /* should not be reached due to test in R */ /* #nocov */
    }
    } /* end switch */

    if (leaveRaw && output_length > 0) {
        PROTECT(result=allocVector(RAWSXP, output_length));
        memcpy(RAW(result), output, output_length);
    } else {
        PROTECT(result=allocVector(STRSXP, 1));
        SET_STRING_ELT(result, 0, mkChar(output));
    }
    UNPROTECT(1);

  return result;
}

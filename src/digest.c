/*

  digest -- hash digest functions for R

  Copyright (C) 2003 - 2024  Dirk Eddelbuettel <edd@debian.org>

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

#include <stdint.h> // for uint32_t
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
#include "blake3.h"
#include "crc32c.h"

#ifdef _WIN32
#include <Windows.h>
#endif

unsigned long ZEXPORT digest_crc32(unsigned long crc,
                                   const unsigned char FAR *buf,
                                   unsigned len);

static const char *sha2_hex_digits = "0123456789abcdef";

FILE* open_with_widechar_on_windows(const char* txt) {
    FILE* out;
#ifdef _WIN32
    wchar_t* buf;
    size_t len = MultiByteToWideChar(CP_UTF8, 0, txt, -1, NULL, 0);
    if (len <= 0) {
        error("Cannot convert file to Unicode: %s", txt);
    }
    buf = (wchar_t*) R_alloc(len, sizeof(wchar_t));
    if (buf == NULL) {
        error("Could not allocate buffer of size: %llu", len);
    }

    MultiByteToWideChar(CP_UTF8, 0, txt, -1, buf, len);
    out = _wfopen(buf, L"rb");
#else
    out = fopen(txt, "rb");
#endif

    return out;
}


// Also already used in sha2.h
//
// We can rely on WORDS_BIGENDIAN only be defined on big endian systems thanks to Rconfig.
//
// A number of other #define based tests are in other source files here for different hash
// algorithm implementations notably crc32c, pmurhash, sha2 and xxhash
//
// A small and elegant test is also in package qs based on https://stackoverflow.com/a/1001373

// edd 02 Dec 2013  use Rconfig.h to define BYTE_ORDER, unless already defined
#ifndef BYTE_ORDER
// see sha2.c comments, and on the internet at large
#define LITTLE_ENDIAN 1234
#define BIG_ENDIAN    4321
#ifdef WORDS_BIGENDIAN
#define BYTE_ORDER  BIG_ENDIAN
#else
#define BYTE_ORDER  LITTLE_ENDIAN
#endif
#endif

SEXP is_big_endian(void) {
    return Rf_ScalarLogical(BYTE_ORDER == BIG_ENDIAN);
}

SEXP is_little_endian(void) {
    return Rf_ScalarLogical(BYTE_ORDER == LITTLE_ENDIAN);
}

#ifndef USESHA512
#define USESHA512 0
#endif

// USESHA512 seems maybe faster? however, more complex, not obviously faster
SEXP _store_from_char_ptr(const unsigned char * hash,
                              const size_t output_length, const int leaveRaw) {
    SEXP result = R_NilValue;
    if (leaveRaw) {
        PROTECT(result = allocVector(RAWSXP, output_length));
        memcpy(RAW(result), hash, output_length);
    } else {
        unsigned char outputp[output_length * 2 + 1];
#if USESHA512
        unsigned const char *d = hash;
#endif
        for (int j = 0; j < output_length; j++) {
#if USESHA512
            *outputp++ = sha2_hex_digits[(*d & 0xf0) >> 4];
            *outputp++ = sha2_hex_digits[*d & 0x0f];
            d++;
#else
            // a char = 2 hex digits => to (0-9A-F)-charset = writing 2 spots
            snprintf(outputp + j * 2, 3, "%02x", hash[j]);
#endif
        }
#if USESHA512
        *outputp = (char)0;
#endif
        PROTECT(result = allocVector(STRSXP, 1));
        SET_STRING_ELT(result, 0, mkChar(outputp));
    }
    UNPROTECT(1);
    return result;
}

void rev_memcpy(char *dst, const void *src, int len) {
    for (int i = 0; i < len; i++) {
        dst[i] = ((char*)src)[len - i - 1];
    }
}

// n.b. ripe templating to e.g. _store_from_integral<> if switching to c++
SEXP _store_from_int32(const uint32_t hash, const int leaveRaw) {
    SEXP result = R_NilValue; int output_length = sizeof(uint32_t);
    if (leaveRaw) {
        PROTECT(result = allocVector(RAWSXP, output_length));
        rev_memcpy(RAW(result), &hash, output_length);
    } else {
        char output[output_length*2 + 1];
        snprintf(output, output_length*2 + 1, "%08x", hash);
        PROTECT(result = allocVector(STRSXP, 1));
        SET_STRING_ELT(result, 0, mkChar(output));
    }
    UNPROTECT(1);
    return result;
}

SEXP _store_from_int64(const uint64_t hash, const int leaveRaw) {
    SEXP result = R_NilValue; int output_length = sizeof(uint64_t);
    if (leaveRaw) {
        PROTECT(result = allocVector(RAWSXP, output_length));
        rev_memcpy(RAW(result), &hash, output_length);
    } else {
        char output[output_length*2 + 1];
        snprintf(output, output_length*2 + 1, "%016" PRIx64, hash);
        PROTECT(result = allocVector(STRSXP, 1));
        SET_STRING_ELT(result, 0, mkChar(output));
    }
    UNPROTECT(1);
    return result;
}

SEXP _store_from_2xint64(const uint64_t hashlo, const uint64_t hashhi, const int leaveRaw) {
    SEXP result = R_NilValue; int output_length = 2*sizeof(uint64_t);
    if (leaveRaw) {
        PROTECT(result = allocVector(RAWSXP, output_length));
        rev_memcpy(RAW(result), &hashhi, 8);
        rev_memcpy(RAW(result) + 8, &hashlo, 8);
    } else {
        char output[output_length*2 + 1];
        snprintf(output, output_length*2 + 1, "%016" PRIx64 "%016" PRIx64, hashhi, hashlo);
        PROTECT(result = allocVector(STRSXP, 1));
        SET_STRING_ELT(result, 0, mkChar(output));
    }
    UNPROTECT(1);
    return result;
}

#define FILEHASH(WHAT) if (length >= 0) { \
    while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length > 0) { \
        if (nChar > length) nChar = length; \
        WHAT; \
        length -= nChar; \
    } \
} else { \
    while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0) { \
        WHAT; \
    } \
} \
fclose(fp);

SEXP digest(SEXP Txt, SEXP Algo, SEXP Length, SEXP Skip, SEXP Leave_raw, SEXP Seed) {
    size_t BUF_SIZE = 1024;
    FILE *fp=0;
    char *txt;
    int algo = INTEGER_VALUE(Algo);
    int length = INTEGER_VALUE(Length);
    int skip = INTEGER_VALUE(Skip);
    int seed = INTEGER_VALUE(Seed);
    int leaveRaw = INTEGER_VALUE(Leave_raw);
    
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

        if (algo >= 100) {
            fp = open_with_widechar_on_windows(txt);
            if (!fp)  {
              error("Cannot open input file: %s", txt);  /* #nocov */
            }
        }
    }
    if (skip > 0) { 
        if (algo < 100) {
            if (skip >= nChar) {
                nChar = 0;                              /* #nocov */
            } else {
                nChar -= skip;
                txt += skip;
            }
        } else {
            fseek(fp, skip, SEEK_SET);
        }
    }
    if (length>=0 && length<nChar) nChar = length;

    switch (algo) {
    case 1: {     /* md5 case */
        md5_context ctx;
        output_length = 16; // produces 16*8 = 128 bits
        unsigned char md5sum[output_length];

        md5_starts( &ctx );
        md5_update( &ctx, txt, nChar);
        md5_finish( &ctx, md5sum );

        return _store_from_char_ptr(md5sum, output_length, leaveRaw);
    }
    case 2: {     /* sha1 case */
        sha1_context ctx;
        output_length = 20;
        unsigned char sha1sum[output_length];

        sha1_starts( &ctx );
        sha1_update( &ctx, txt, nChar);
        sha1_finish( &ctx, sha1sum );

        return _store_from_char_ptr(sha1sum, output_length, leaveRaw);
    }
    case 3: {     /* crc32 case */
        unsigned long val;
        unsigned l = nChar;
        output_length = sizeof(unsigned int);

        val  = digest_crc32(0L, 0, 0);
        val  = digest_crc32(val, txt, l);

        return _store_from_int32(val, leaveRaw);
    }
    case 4: {     /* sha256 case */
        sha256_context ctx;
        output_length = 32;
        unsigned char sha256sum[output_length];

        sha256_starts( &ctx );
        sha256_update( &ctx, txt, nChar);
        sha256_finish( &ctx, sha256sum );

        return _store_from_char_ptr(sha256sum, output_length, leaveRaw);
    }
    case 5: {     /* sha2-512 case */
        SHA512_CTX ctx;
        output_length = SHA512_DIGEST_LENGTH;
        unsigned char sha512sum[output_length];

        SHA512_Init(&ctx);
        SHA512_Update(&ctx, txt, nChar);
        /* Calling SHA512_Final, because SHA512_End will already
           convert the hash to a string, and we also want RAW */
        SHA512_Final(sha512sum, &ctx);

        return _store_from_char_ptr(sha512sum, output_length, leaveRaw);
    }
    case 6: {     /* xxhash32 case */

        XXH32_hash_t val = XXH32(txt, nChar, seed);

        return _store_from_int32(val, leaveRaw);
    }
    case 7: {     /* xxhash64 case */

        XXH64_hash_t val = XXH64(txt, nChar, seed);
        
        return _store_from_int64(val, leaveRaw);
    }
    case 8: {     /* MurmurHash3 32 */

        unsigned int val = PMurHash32(seed, txt, nChar);

        return _store_from_int32(val, leaveRaw);
    }
    case 10: {     /* blake3 */
        output_length = BLAKE3_OUT_LEN;
        uint8_t val[output_length];
        blake3_hasher hasher;

        blake3_hasher_init(&hasher);
        blake3_hasher_update(&hasher, txt, nChar);
        blake3_hasher_finalize(&hasher, val, output_length);

        return _store_from_char_ptr(val, output_length, leaveRaw);
    }
    case 11: {		/* crc32c */

        uint32_t crc = 0;       /* initial value, can be zero */
        crc = crc32c_extend(crc, (const uint8_t*) txt, (size_t) nChar);

        return _store_from_int32(crc, leaveRaw);
    }
    case 12: {		/* xxh3_64bits */

        XXH64_hash_t val = XXH3_64bits_withSeed(txt, nChar, seed);

        return _store_from_int64(val, leaveRaw);
    }
    case 13: {		/* xxh3_128bits */

        XXH128_hash_t val =  XXH3_128bits_withSeed(txt, nChar, seed);

        return _store_from_2xint64(val.low64, val.high64, leaveRaw);
    }
    case 101: {     /* md5 file case */
        md5_context ctx;
        output_length = 16;
        unsigned char buf[BUF_SIZE];
        unsigned char md5sum[output_length];

        md5_starts( &ctx );
        FILEHASH(md5_update( &ctx, buf, nChar ));
        md5_finish( &ctx, md5sum );

        return _store_from_char_ptr(md5sum, output_length, leaveRaw);
    }
    case 102: {     /* sha1 file case */
        sha1_context ctx;
        output_length = 20;
        unsigned char buf[BUF_SIZE];
        unsigned char sha1sum[output_length];

        sha1_starts ( &ctx );
        FILEHASH(sha1_update( &ctx, buf, nChar ));
        sha1_finish ( &ctx, sha1sum );

        return _store_from_char_ptr(sha1sum, output_length, leaveRaw);
    }
    case 103: {     /* crc32 file case */
        unsigned char buf[BUF_SIZE];
        unsigned long val;

        val  = digest_crc32(0L, 0, 0);
        FILEHASH(val = digest_crc32(val, buf, nChar));

        return _store_from_int32(val, leaveRaw);
    }
    case 104: {     /* sha256 file case */
        sha256_context ctx;
        output_length = 32;
        unsigned char buf[BUF_SIZE];
        unsigned char sha256sum[output_length];

        sha256_starts ( &ctx );
        FILEHASH(sha256_update( &ctx, buf, nChar));
        sha256_finish ( &ctx, sha256sum );

        return _store_from_char_ptr(sha256sum, output_length, leaveRaw);
    }
    case 105: {     /* sha2-512 file case */
        SHA512_CTX ctx;
        output_length = SHA512_DIGEST_LENGTH;
        uint8_t sha512sum[output_length];
        unsigned char buf[BUF_SIZE];

        SHA512_Init(&ctx);
        FILEHASH(SHA512_Update(&ctx, buf, nChar));
		/* Calling SHA512_Final, because SHA512_End will already
		   convert the hash to a string, and we also want RAW */
		SHA512_Final(sha512sum, &ctx);
    
        return _store_from_char_ptr(sha512sum, output_length, leaveRaw);
    }
    case 106: {     /* xxhash32 */
        unsigned char buf[BUF_SIZE];
        XXH32_state_t* const state = XXH32_createState();

        if (XXH32_reset(state, seed) == XXH_ERROR) error("Error in `XXH32_reset()`"); /* #nocov */
        FILEHASH(if (XXH32_update(state, buf, nChar)) error("Error in `XXH32_update()`"));
        XXH32_hash_t val =  XXH32_digest(state);
        XXH32_freeState(state);

        return _store_from_int32(val, leaveRaw);
    }
    case 107: {     /* xxhash64 */
        unsigned char buf[BUF_SIZE];
        XXH64_state_t* const state = XXH64_createState();

        if (XXH64_reset(state, seed) == XXH_ERROR) error("Error in `XXH64_reset()`"); 				/* #nocov */
        FILEHASH(if (XXH64_update(state, buf, nChar)) error("Error in `XXH64_update()`"));
        XXH64_hash_t val =  XXH64_digest(state);
        XXH64_freeState(state);
        
        return _store_from_int64(val, leaveRaw);
    }
    case 108: {     /* murmur32 */
        unsigned int h1 = seed, carry = 0;
        unsigned char buf[BUF_SIZE];
        size_t total_length = 0;

        FILEHASH(PMurHash32_Process(&h1, &carry, buf, nChar); total_length += nChar);
        unsigned int val = PMurHash32_Result(h1, carry, total_length);

        return _store_from_int32(val, leaveRaw);
    }
    case 110: {     /* blake3 file case */
        output_length = BLAKE3_OUT_LEN;
        unsigned char buf[BUF_SIZE];
        uint8_t val[BLAKE3_OUT_LEN];
        blake3_hasher hasher;

        blake3_hasher_init(&hasher);
        FILEHASH(blake3_hasher_update(&hasher, buf, nChar));
        blake3_hasher_finalize(&hasher, val, BLAKE3_OUT_LEN);
        
        return _store_from_char_ptr(val, output_length, leaveRaw);
    }
    case 111: {		/* crc32c */
        unsigned char buf[BUF_SIZE];
        uint32_t crc = 0;

        FILEHASH(crc = crc32c_extend(crc, (const uint8_t*) buf, (size_t) nChar));

        return _store_from_int32(crc, leaveRaw);
    }
    case 112: {     /* xxh3_64 */
        unsigned char buf[BUF_SIZE];
        XXH3_state_t* const state = XXH3_createState();

        if (XXH3_64bits_reset(state) == XXH_ERROR) error("Error in `XXH3_reset()`"); /* #nocov */
        FILEHASH(if (XXH3_64bits_update(state, buf, nChar)) error("Error in `XXH3_64bits_update()`"));
        XXH64_hash_t val =  XXH3_64bits_digest(state);
        XXH3_freeState(state);

        return _store_from_int64(val, leaveRaw);
    }
    case 113: {     /* xxh3_128 */
        unsigned char buf[BUF_SIZE];
        XXH3_state_t* const state = XXH3_createState();

        if (XXH3_128bits_reset(state) == XXH_ERROR) error("Error in `XXH3_reset()`"); /* #nocov */
        FILEHASH(if (XXH3_128bits_update(state, buf, nChar)) error("Error in `XXH3_128bits_update()`"));
        XXH128_hash_t val =  XXH3_128bits_digest(state);
        XXH3_freeState(state);

        return _store_from_2xint64(val.low64, val.high64, leaveRaw);
    }

    default: {
        error("Unsupported algorithm code"); /* should not be reached due to test in R */ /* #nocov */
    }
    } /* end switch */

}


SEXP vdigest(SEXP Txt, SEXP Algo, SEXP Length, SEXP Skip, SEXP Leave_raw, SEXP Seed){
    R_xlen_t n = length(Txt);
    if (TYPEOF(Txt) == RAWSXP || n == 0)
        return(digest(Txt, Algo, Length, Skip, Leave_raw, Seed));
    SEXP ans = PROTECT(allocVector(STRSXP, n));
    SEXP d = R_NilValue;
    if (TYPEOF(Txt) == VECSXP){
        for (R_xlen_t i = 0; i < n; i++){
            d = digest(VECTOR_ELT(Txt, i), Algo, Length, Skip, Leave_raw, Seed);
            SET_STRING_ELT(ans, i, STRING_ELT(d, 0));
        }
    } else {
        for (R_xlen_t i = 0; i < n; i++){
            d = digest(STRING_ELT(Txt, i), Algo, Length, Skip, Leave_raw, Seed);
            SET_STRING_ELT(ans, i, STRING_ELT(d, 0));
        }
    }
    UNPROTECT(1);
    return ans;
}

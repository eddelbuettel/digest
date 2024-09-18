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

#include "digest.h"
#include "sha1.h"
#include "sha2.h"
#include "sha256.h"
#include "md5.h"
#include "zlib.h"
#include "xxhash.h"
#include "pmurhash.h"
#include "blake3.h"
#include "crc32c.h"

unsigned long ZEXPORT digest_crc32(unsigned long crc,
                                   const unsigned char FAR *buf,
                                   unsigned len);

FILE* open_with_widechar_on_windows(const unsigned char* txt) {
    FILE* out;
#ifdef _WIN32
    wchar_t* buf;
    size_t len = MultiByteToWideChar(CP_UTF8, 0, (char *)txt, -1, NULL, 0);
    if (len <= 0) {
        error("Cannot convert file to Unicode: %s", txt);
    }
    buf = (wchar_t*) R_alloc(len, sizeof(wchar_t));
    if (buf == NULL) {
        error("Could not allocate buffer of size: %llu", len);
    }

    MultiByteToWideChar(CP_UTF8, 0, (char *)txt, -1, buf, len);
    out = _wfopen(buf, L"rb");
#else
    out = fopen((char *)txt, "rb");
#endif

    return out;
}

SEXP is_big_endian(void) {
    return Rf_ScalarLogical(BYTE_ORDER == BIG_ENDIAN);
}

SEXP is_little_endian(void) {
    return Rf_ScalarLogical(BYTE_ORDER == LITTLE_ENDIAN);
}

// rawoutput is a RAWSXP
SEXP _to_STRINGELT(const SEXP rawoutput) {
    const size_t output_length = RVLENGTH(rawoutput);
    char output[output_length*2];
    const unsigned char * hash = RAW(rawoutput);
#if USESHA512
    char *outputp = output;
    unsigned const char *d = hash;
#endif
    for (int j = 0; j < output_length; j++) {
#if USESHA512
        *outputp++ = sha2_hex_digits[(*d & 0xf0) >> 4];
        *outputp++ = sha2_hex_digits[*d & 0x0f];
        d++;
#else
        // a char = 2 hex digits => to (0-9A-F)-charset = writing 2 spots
        snprintf(output + j * 2, 3, "%02x", hash[j]);
#endif
    }
    SEXP result = PROTECT(allocVector(STRSXP, 1));
    SET_STRING_ELT(result, 0, mkChar(output));
    UNPROTECT(1);
    return result;
}

// USESHA512 seems maybe faster? however, more complex, not obviously faster
void _store_from_char_ptr(const unsigned char * hash, char * const output,
                          const size_t output_length, const int leaveRaw) {
    if (leaveRaw) {
        memcpy(output, hash, output_length);
    } else {
#if USESHA512
        char *outputp = output;
        unsigned const char *d = hash;
#endif
        for (int j = 0; j < output_length; j++) {
#if USESHA512
            *outputp++ = sha2_hex_digits[(*d & 0xf0) >> 4];
            *outputp++ = sha2_hex_digits[*d & 0x0f];
            d++;
#else
            // a char = 2 hex digits => to (0-9A-F)-charset = writing 2 spots
            snprintf(output + j * 2, 3, "%02x", hash[j]);
#endif
        }
#if USESHA512
        *outputp = (char)0;
#endif
    }
}

void rev_memcpy(char *dst, const void *src, int len) {
    for (int i = 0; i < len; i++) {
        dst[i] = ((char*)src)[len - i - 1];
    }
}

// n.b. ripe templating to e.g. _store_from_integral<> if switching to c++
void _store_from_int32(const uint32_t hash, char *output, const int leaveRaw) {
    if (leaveRaw) {
        rev_memcpy(output, &hash, sizeof(uint32_t));
    } else snprintf(output, sizeof(uint32_t)*2 + 1, "%08x", hash);
}

void _store_from_int64(const uint64_t hash, char *output, const int leaveRaw) {
    if (leaveRaw) {
        rev_memcpy(output, &hash, sizeof(uint64_t));
    } else snprintf(output, sizeof(uint64_t)*2 + 1, "%016" PRIx64, hash);
}

// approach:
//  - for each algorithm, define the core block in terms of char* inputs, char* outputs
//  - for each input type, define the transformation from input type to char*
//  - for each algorithm, provide a wrapper which dispatches by input type,
//    deals with streaming, and handles conversion to string if requested
//  - export each wrapper (alt: each direct type translator / algo combination?)
//  - continue

// interfaces:
// direct_ALGO(SEXP input, SEXP inputtype, SEXP leaveRaw)
//  - deals with converting input from inputtype to char*,
//  - ... including extracting input length
//  - ... invoking one_ALGO on it
//  - ... handling return (based on leaveRaw TRUE vs FALSE)
// stream_ALGO()
//  - ibid, but for file inputs + invoking rep_ALGO
// one_ALGO(char* input, size_t length_of_input, char* output)
//  - allocates output to the appropriate size
//  - invokes update call once
// rep_ALGO(char* buffer, size_t length)
//  - ibid, except invokes update call repeatedly

// core_ALGO a macro to encapsulate hashing algorithms
//
// @param ALGO: the name of the hashing algorithm
// @param LEN: the length of the hash from that algorithm
// @param BLOCK: the block of code to hash the input
//
// creates a function taking arguments
// @param input: the input to hash
// @param len: the length of the input
// @param output: pointer to the output buffer to store the hash, unallocated
# define core_ALGO(ALGO, LEN, BLOCK) SEXP core_ ## ALGO\
(const unsigned char* input, const size_t len) {\
    const size_t output_length = LEN; \
    SEXP result = PROTECT(allocVector(RAWSXP, output_length)); \
    unsigned char *output = RAW(result); \
    BLOCK \
    UNPROTECT(1); \
    return result; \
};

core_ALGO(SHA1, 20,
    sha1_context ctx;
    sha1_starts( &ctx );
    sha1_update( &ctx, input, len);
    sha1_finish( &ctx, output);
);

core_ALGO(MD5, 16,
    md5_context ctx;
    md5_starts( &ctx );
    md5_update( &ctx, input, len);
    md5_finish( &ctx, output);
)

// direct_ALGO
// @param ALGO which algorithm 
//
// creates a function taking arguments:
// @param inputtype: the type of the input, must be one of the enumerated types
// @param input: the input to hash
// @param leaveRaw: whether to return the hash as a raw vector or a character string
#define direct_ALGO(ALGO) direct_ALGO_SIG(ALGO) {\
    const SEXPTYPE inputtype = TYPEOF(input); \
    int len = RVLENGTH(input); \
    unsigned char* algoinput = NULL; \
    switch (inputtype) { \
        case RAWSXP: \
            algoinput = (unsigned char*) RAW(input); \
            break; \
        case INTSXP: \
            algoinput = (unsigned char*) INTEGER(input); \
            len *= sizeof(int); \
            break; \
        /* TODO: handle other input types */ \
        default: \
            exit(-1); \
            break; \
    } \
    if (LOGICAL(leaveRaw)) { \
        return core_ ## ALGO(algoinput, len); \
    } else { \
        return _to_STRINGELT(core_ ## ALGO(algoinput, len)); \
    } \
};

direct_ALGO(SHA1);
direct_ALGO(MD5);

SEXP digest(SEXP Txt, SEXP Algo, SEXP Length, SEXP Skip, SEXP Leave_raw, SEXP Seed) {
    size_t BUF_SIZE = 1024;
    FILE *fp=0;
    unsigned char *txt;
    int algo = INTEGER_VALUE(Algo);
    int length = INTEGER_VALUE(Length);
    int skip = INTEGER_VALUE(Skip);
    int seed = INTEGER_VALUE(Seed);
    int leaveRaw = LOGICAL_VALUE(Leave_raw);

    /* use char[] for either raw or character output */
    /* for raw output, get 8 bits / 1 byte out of each entry */
    /* for character output, get 4 bits out of each entry */
    char output[128+1];    /* 33 for md5, 41 for sha1, 65 for sha256, 128 for sha512; plus trailing NULL */
    R_xlen_t nChar;
    int output_length = -1;
    if (IS_RAW(Txt)) { /* Txt is either RAW */
        txt = (unsigned char*) RAW(Txt);
        nChar = RVLENGTH(Txt);
    } else { /* or a string */
        txt = (unsigned char*) STRING_VALUE(Txt);
        nChar = strlen((char *)txt);

        if (algo >= 100) {
            fp = open_with_widechar_on_windows(txt);
            if (!fp)  {
              error("Cannot open input file: %s", txt);  /* #nocov */
            }
        }
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
        if (leaveRaw) {
            return core_MD5(txt, nChar);
        } else {
            return _to_STRINGELT(core_MD5(txt, nChar));
        }
    }
    case 2: {     /* sha1 case */
        if (leaveRaw) {
            return core_SHA1(txt, nChar);
        } else {
            return _to_STRINGELT(core_SHA1(txt, nChar));
        }
    }
    case 3: {     /* crc32 case */
        unsigned long val;
        unsigned l = nChar;
        output_length = sizeof(unsigned int);

        val  = digest_crc32(0L, 0, 0);
        val  = digest_crc32(val, txt, l);

        _store_from_int32(val, output, leaveRaw);
        break;
    }
    case 4: {     /* sha256 case */
        sha256_context ctx;
        output_length = 32;
        unsigned char sha256sum[output_length];

        sha256_starts( &ctx );
        sha256_update( &ctx, txt, nChar);
        sha256_finish( &ctx, sha256sum );

        _store_from_char_ptr(sha256sum, output, output_length, leaveRaw);
        break;
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

        _store_from_char_ptr(sha512sum, output, output_length, leaveRaw);
        break;
    }
    case 6: {     /* xxhash32 case */
        output_length = 4;

        XXH32_hash_t val = XXH32(txt, nChar, seed);

        _store_from_int32(val, output, leaveRaw);
        break;
    }
    case 7: {     /* xxhash64 case */
        output_length = 8;

        XXH64_hash_t val = XXH64(txt, nChar, seed);

        _store_from_int64(val, output, leaveRaw);
        break;
    }
    case 8: {     /* MurmurHash3 32 */
        output_length = 4;

        unsigned int val = PMurHash32(seed, txt, nChar);

        _store_from_int32(val, output, leaveRaw);
        break;
    }
    case 10: {     /* blake3 */
        output_length = BLAKE3_OUT_LEN;
        uint8_t val[output_length];
        blake3_hasher hasher;

        blake3_hasher_init(&hasher);
        blake3_hasher_update(&hasher, txt, nChar);
        blake3_hasher_finalize(&hasher, val, output_length);

        _store_from_char_ptr(val, output, output_length, leaveRaw);
        break;
    }
    case 11: {		/* crc32c */
        output_length = 4;

        uint32_t crc = 0;       /* initial value, can be zero */
        crc = crc32c_extend(crc, (const uint8_t*) txt, (size_t) nChar);

        _store_from_int32(crc, output, leaveRaw);
        break;
    }
    case 12: {		/* xxh3_64bits */
        output_length = 8;

        XXH64_hash_t val = XXH3_64bits_withSeed(txt, nChar, seed);

        _store_from_int64(val, output, leaveRaw);
        break;
    }
    case 13: {		/* xxh3_128bits */
        output_length = 16;

        XXH128_hash_t val =  XXH3_128bits_withSeed(txt, nChar, seed);

        // need something a bit fancier here
        if (leaveRaw) {
          rev_memcpy(output, &val.high64, 8);
          rev_memcpy(output + 8, &val.low64, 8);
        } else {
          snprintf(output, 128, "%016" PRIx64 "%016" PRIx64, val.high64, val.low64);
        }
        break;
    }
    case 101: {     /* md5 file case */
        md5_context ctx;
        output_length = 16;
        unsigned char buf[BUF_SIZE];
        unsigned char md5sum[output_length];
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
        md5_finish( &ctx, md5sum );

        _store_from_char_ptr(md5sum, output, output_length, leaveRaw);
        break;
    }
    case 102: {     /* sha1 file case */
        sha1_context ctx;
        output_length = 20;
        unsigned char buf[BUF_SIZE];
        unsigned char sha1sum[output_length];
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
        sha1_finish ( &ctx, sha1sum );

        _store_from_char_ptr(sha1sum, output, output_length, leaveRaw);
        break;
    }
    case 103: {     /* crc32 file case */
        unsigned char buf[BUF_SIZE];
        unsigned long val;
        output_length = 4;
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

        _store_from_int32(val, output, leaveRaw);
        break;
    }
    case 104: {     /* sha256 file case */
        sha256_context ctx;
        output_length = 32;
        unsigned char buf[BUF_SIZE];
        unsigned char sha256sum[output_length];
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
        sha256_finish ( &ctx, sha256sum );

        _store_from_char_ptr(sha256sum, output, output_length, leaveRaw);
        break;
    }
    case 105: {     /* sha2-512 file case */
        SHA512_CTX ctx;
        output_length = SHA512_DIGEST_LENGTH;
        uint8_t sha512sum[output_length];
        unsigned char buf[BUF_SIZE];
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
		/* Calling SHA512_Final, because SHA512_End will already
		   convert the hash to a string, and we also want RAW */
		SHA512_Final(sha512sum, &ctx);

        _store_from_char_ptr(sha512sum, output, output_length, leaveRaw);
        break;
    }
    case 106: {     /* xxhash32 */
        unsigned char buf[BUF_SIZE];
        XXH32_state_t* const state = XXH32_createState();
        output_length = 4;
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
        XXH32_hash_t val =  XXH32_digest(state);
        XXH32_freeState(state);

        _store_from_int32(val, output, leaveRaw);
        break;
    }
    case 107: {     /* xxhash64 */
        unsigned char buf[BUF_SIZE];
        XXH64_state_t* const state = XXH64_createState();
        output_length = 8;
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
        XXH64_hash_t val =  XXH64_digest(state);
        XXH64_freeState(state);

        _store_from_int64(val, output, leaveRaw);
        break;
    }
    case 108: {     /* murmur32 */
        unsigned int h1=seed, carry=0;
        unsigned char buf[BUF_SIZE];
        size_t total_length = 0;
        output_length = 4;
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
        unsigned int val = PMurHash32_Result(h1, carry, total_length);

        _store_from_int32(val, output, leaveRaw);
        break;
    }
    case 110: {     /* blake3 file case */
        output_length = BLAKE3_OUT_LEN;
        unsigned char buf[BUF_SIZE];
        uint8_t val[BLAKE3_OUT_LEN];
        blake3_hasher hasher;
        if (skip > 0) fseek(fp, skip, SEEK_SET);

        blake3_hasher_init(&hasher);
        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length>0) {
                if (nChar>length) nChar=length;
                blake3_hasher_update( &hasher, buf, nChar );
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0)
                blake3_hasher_update( &hasher, buf, nChar );
        }
        blake3_hasher_finalize(&hasher, val, BLAKE3_OUT_LEN);

        _store_from_char_ptr(val, output, output_length, leaveRaw);
        break;
    }
    case 111: {		/* crc32c */
        unsigned char buf[BUF_SIZE];
        output_length = 4;
        uint32_t crc = 0;
        if (skip > 0) fseek(fp, skip, SEEK_SET);

        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length>0) {
                if (nChar>length) nChar=length;
                crc = crc32c_extend(crc, (const uint8_t*) buf, (size_t) nChar);
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0)
                crc = crc32c_extend(crc, (const uint8_t*) buf, (size_t) nChar);
        }

        _store_from_int32(crc, output, leaveRaw);
        break;
    }
    case 112: {     /* xxh3_64 */
        unsigned char buf[BUF_SIZE];
        output_length = 8;
        XXH3_state_t* const state = XXH3_createState();
        if (skip > 0) fseek(fp, skip, SEEK_SET);

        XXH_errorcode const resetResult = XXH3_64bits_reset(state);
        if (resetResult == XXH_ERROR) {
            error("Error in `XXH3_reset()`"); 				/* #nocov */
        }
        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length>0) {
                if (nChar>length) nChar=length;
                XXH_errorcode const updateResult = XXH3_64bits_update(state, buf, nChar);
                if (updateResult == XXH_ERROR) {
                    error("Error in `XXH3_64bits_update()`"); 		/* #nocov */
                }
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0) {
                XXH_errorcode const updateResult = XXH3_64bits_update(state, buf, nChar);
                if (updateResult == XXH_ERROR) {
                    error("Error in `XXH3_64bit_update()`"); 		/* #nocov */
                }
            }
        }
        XXH64_hash_t val =  XXH3_64bits_digest(state);
        XXH3_freeState(state);

        _store_from_int64(val, output, leaveRaw);
        break;
    }
    case 113: {     /* xxh3_128 */
        unsigned char buf[BUF_SIZE];
        XXH3_state_t* const state = XXH3_createState();
        output_length = 16;
        if (skip > 0) fseek(fp, skip, SEEK_SET);

        XXH_errorcode const resetResult = XXH3_128bits_reset(state);
        if (resetResult == XXH_ERROR) {
            error("Error in `XXH3_reset()`"); 				/* #nocov */
        }
        if (length>=0) {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0 && length>0) {
                if (nChar>length) nChar=length;
                XXH_errorcode const updateResult = XXH3_128bits_update(state, buf, nChar);
                if (updateResult == XXH_ERROR) {
                    error("Error in `XXH3_128bits_update()`"); 		/* #nocov */
                }
                length -= nChar;
            }
        } else {
            while ( ( nChar = fread( buf, 1, sizeof( buf ), fp ) ) > 0) {
                XXH_errorcode const updateResult = XXH3_128bits_update(state, buf, nChar);
                if (updateResult == XXH_ERROR) {
                    error("Error in `XXH3_128bit_update()`"); 		/* #nocov */
                }
            }
        }
        XXH128_hash_t val =  XXH3_128bits_digest(state);
        XXH3_freeState(state);

        // need something a bit fancier here
        if (leaveRaw) {
            rev_memcpy(output, &val.high64, 8);
            rev_memcpy(output + 8, &val.low64, 8);
        } else {
            snprintf(output, 128, "%016" PRIx64 "%016" PRIx64, val.high64, val.low64);
        }
        break;
    }

    default: {
        error("Unsupported algorithm code"); /* should not be reached due to test in R */ /* #nocov */
    }
    } /* end switch */

    if (algo >= 100 && fp) {
        fclose(fp);
    }

    SEXP result = R_NilValue;

    if (leaveRaw) {
        PROTECT(result=allocVector(RAWSXP, output_length));
        memcpy(RAW(result), output, output_length);
    } else {
        PROTECT(result=allocVector(STRSXP, 1));
        SET_STRING_ELT(result, 0, mkChar(output));
    }
    UNPROTECT(1);

    return result;
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

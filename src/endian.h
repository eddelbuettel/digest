
#include <R.h>
#include <Rdefines.h>

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

SEXP is_big_endian();

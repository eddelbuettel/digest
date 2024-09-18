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

#ifdef _WIN32
#include <Windows.h>
#endif

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

SEXP is_big_endian(void);
SEXP is_little_endian(void);

#if defined(R_VERSION) && R_VERSION >= R_Version(3,0,0)
#define RVLENGTH(ROBJ) XLENGTH(ROBJ)
#else
#define RVLENGTH(ROBJ) LENGTH(ROBJ)
#endif

#ifndef USESHA512
#define USESHA512 0
#endif

#if USESHA512
static const char *sha2_hex_digits = "0123456789abcdef";
#endif

// direct_ALGO
// @param ALGO which algorithm 
//
// creates a function taking arguments:
// @param inputtype: the type of the input, must be one of the enumerated types
// @param input: the input to hash
// @param leaveRaw: whether to return the hash as a raw vector or a character string
#define direct_ALGO_SIG(ALGO) SEXP direct_ ## ALGO\
(const SEXP input, const SEXP leaveRaw)

direct_ALGO_SIG(SHA1);
direct_ALGO_SIG(MD5);

SEXP digest(SEXP Txt, SEXP Algo, SEXP Length, SEXP Skip, SEXP Leave_raw, SEXP Seed);
SEXP vdigest(SEXP Txt, SEXP Algo, SEXP Length, SEXP Skip, SEXP Leave_raw, SEXP Seed);
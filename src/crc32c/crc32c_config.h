// Copyright 2017 The CRC32C Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file. See the AUTHORS file for names of contributors.

#ifndef CRC32C_CRC32C_CONFIG_H_
#define CRC32C_CRC32C_CONFIG_H_

// Define to 1 if building for a big-endian platform and conditions met ... else 0 for little endian
#if defined(__BYTE_ORDER__) && defined(__ORDER_BIG_ENDIAN__) && (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__)
#define BYTE_ORDER_BIG_ENDIAN 1
#else
#define BYTE_ORDER_BIG_ENDIAN 0
#endif

// Define to 1 if the compiler has the __builtin_prefetch intrinsic.
// edd 2023-06-26  Set to 0 for maximum portability
#define HAVE_BUILTIN_PREFETCH 0

// Define to 1 if targeting X86 and the compiler has the _mm_prefetch intrinsic.
// edd 2023-06-26  Set to 0 for maximum portability
#define HAVE_MM_PREFETCH 0

// Define to 1 if targeting X86 and the compiler has the _mm_crc32_u{8,32,64}
// intrinsics.
#define HAVE_SSE42 0

// Define to 1 if targeting ARM and the compiler has the __crc32c{b,h,w,d} and
// the vmull_p64 intrinsics.
#define HAVE_ARM64_CRC32C 0

// Define to 1 if the system libraries have the getauxval function in the
// <sys/auxv.h> header. Should be true on Linux and Android API level 20+.
#define HAVE_STRONG_GETAUXVAL 0

// Define to 1 if the compiler supports defining getauxval as a weak symbol.
// Should be true for any compiler that supports __attribute__((weak)).
#define HAVE_WEAK_GETAUXVAL 1

// Define to 1 if CRC32C tests have been built with Google Logging.
#define CRC32C_TESTS_BUILT_WITH_GLOG 0

#endif  // CRC32C_CRC32C_CONFIG_H_

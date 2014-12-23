/* -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-

  init -- registering the c hash digest functions

  Copyright (C) 2014  Wush Wu <wush978@gmail.com>

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

#include <R_ext/Rdynload.h>
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

static const R_CallMethodDef callMethods [] = {
    { "md5_starts", (DL_FUNC) &md5_starts, 1 },
    { "md5_update", (DL_FUNC) &md5_update, 3 },
    { "md5_finish", (DL_FUNC) &md5_finish, 2 },
    { "sha1_starts", (DL_FUNC) &sha1_starts, 1 },
    { "sha1_update", (DL_FUNC) &sha1_update, 3 },
    { "sha1_finish", (DL_FUNC) &sha1_finish, 2 },
    { "digest_crc32", (DL_FUNC) &digest_crc32, 3 },
    { "sha256_starts", (DL_FUNC) &sha256_starts, 1 },
    { "sha256_update", (DL_FUNC) &sha256_update, 3 },
    { "sha256_finish", (DL_FUNC) &sha256_finish, 2 },
    { "SHA512_Init", (DL_FUNC) &SHA512_Init, 1 },
    { "SHA512_Update", (DL_FUNC) &SHA512_Update, 3 },
    { "SHA512_Final", (DL_FUNC) &SHA512_Final, 2 },
    { "XXH32_reset", (DL_FUNC) &XXH32_reset, 2 },
    { "XXH32_update", (DL_FUNC) &XXH32_update, 3 },
    { "XXH32_digest", (DL_FUNC) &XXH32_digest, 1 },
    { "XXH64_reset", (DL_FUNC) &XXH64_reset, 2 },
    { "XXH64_update", (DL_FUNC) &XXH64_update, 3 },
    { "XXH64_digest", (DL_FUNC) &XXH64_digest, 1 },
    { "PMurHash32", (DL_FUNC) &PMurHash32, 3 },
    { NULL, NULL, 0 }
};

void R_init_digest(DllInfo *info) {
    R_RegisterCCallable("digest", "md5_starts", (DL_FUNC) &md5_starts);
    R_RegisterCCallable("digest", "md5_update", (DL_FUNC) &md5_update);
    R_RegisterCCallable("digest", "md5_finish", (DL_FUNC) &md5_finish);
    R_RegisterCCallable("digest", "sha1_starts", (DL_FUNC) &sha1_starts);
    R_RegisterCCallable("digest", "sha1_update", (DL_FUNC) &sha1_update);
    R_RegisterCCallable("digest", "sha1_finish", (DL_FUNC) &sha1_finish);
    R_RegisterCCallable("digest", "digest_crc32", (DL_FUNC) &digest_crc32);
    R_RegisterCCallable("digest", "sha256_starts", (DL_FUNC) &sha256_starts);
    R_RegisterCCallable("digest", "sha256_update", (DL_FUNC) &sha256_update);
    R_RegisterCCallable("digest", "sha256_finish", (DL_FUNC) &sha256_finish);
    R_RegisterCCallable("digest", "SHA512_Init", (DL_FUNC) &SHA512_Init);
    R_RegisterCCallable("digest", "SHA512_Update", (DL_FUNC) &SHA512_Update);
    R_RegisterCCallable("digest", "SHA512_Final", (DL_FUNC) &SHA512_Final);
    R_RegisterCCallable("digest", "XXH32_reset", (DL_FUNC) &XXH32_reset);
    R_RegisterCCallable("digest", "XXH32_update", (DL_FUNC) &XXH32_update);
    R_RegisterCCallable("digest", "XXH32_digest", (DL_FUNC) &XXH32_digest);
    R_RegisterCCallable("digest", "XXH64_reset", (DL_FUNC) &XXH64_reset);
    R_RegisterCCallable("digest", "XXH64_update", (DL_FUNC) &XXH64_update);
    R_RegisterCCallable("digest", "XXH64_digest", (DL_FUNC) &XXH64_digest);
    R_RegisterCCallable("digest", "PMurHash32", (DL_FUNC) &PMurHash32);

    R_registerRoutines(info,
                       NULL,    /* slot for .C */
                       callMethods,   /* slot for .Call */
                       NULL,            /* slot for .Fortran */
                       NULL);     /* slot for .External */

    R_useDynamicSymbols(info, TRUE);    /* controls visibility */
}

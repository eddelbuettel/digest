/* -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-

  init -- registering the c hash digest functions

  Copyright (C) 2014  Wush Wu and Dirk Eddelbuettel

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
#include "xxhash.h"
#include "pmurhash.h"

static const R_CallMethodDef callMethods [] = {
    { "PMurHash32", (DL_FUNC) &PMurHash32, 3 },
    { NULL, NULL, 0 }
};

void R_init_digest(DllInfo *info) {
    R_RegisterCCallable("digest", "PMurHash32", (DL_FUNC) &PMurHash32);

    R_registerRoutines(info,
                       NULL,            /* slot for .C */
                       callMethods,     /* slot for .Call */
                       NULL,            /* slot for .Fortran */
                       NULL);           /* slot for .External */

    R_useDynamicSymbols(info, TRUE);    /* controls visibility */
}

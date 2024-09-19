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

#ifndef DIGEST_H
#define DIGEST_H

#include <Rinternals.h>

SEXP is_big_endian(void);
SEXP is_little_endian(void);

SEXP digest(SEXP Txt, SEXP Algo, SEXP Length, SEXP Skip, SEXP Leave_raw, SEXP Seed);
SEXP vdigest(SEXP Txt, SEXP Algo, SEXP Length, SEXP Skip, SEXP Leave_raw, SEXP Seed);

#endif // DIGEST_H
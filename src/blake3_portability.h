/*

  digest -- hash digest functions for R

  Copyright (C) 2025 - current  Dirk Eddelbuettel <edd@debian.org>

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

/* blake3 supports hardware acceleration in the full (upstream)
   version, but we carry only the 'portable' version so we need to
   explicitly un-select hardware acceleration on amd64 (SSE*, AVX*)
   and (recent) arm64 (NEON */

#if !defined(BLAKE3_NO_SSE2)
#define BLAKE3_NO_SSE2
#endif

#if !defined(BLAKE3_NO_SSE41)
#define BLAKE3_NO_SSE41
#endif

#if !defined(BLAKE3_NO_AVX2)
#define BLAKE3_NO_AVX2
#endif

#if !defined(BLAKE3_NO_AVX512)
#define BLAKE3_NO_AVX512
#endif

#if !defined(BLAKE3_USE_NEON)
#define BLAKE3_USE_NEON 0
#endif

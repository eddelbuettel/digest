//  Copyright (C) 2024         Dirk Eddelbuettel
//  Copyright (C) 2019         Kendon Bell
//  Copyright (C) 2014         Gabe Becker
//
//  This file is part of digest and is modified from the original source in
//  the R package fastdigest under the Artistic License 2.0.
//
//  digest is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 2 of the License, or
//  (at your option) any later version.
//
//  digest is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with digest.  If not, see <http://www.gnu.org/licenses/>.

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#define R_NO_REMAP
#define USE_RINTERNALS
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <Rdefines.h>

#include "SpookyV2.h"

static void OutCharSpooky(R_outpstream_t stream, int c)	{	// #nocov start
    SpookyHash *spooky = (SpookyHash *)stream->data;
    spooky->Update(&c, 1);
}								// #nocov end

static void OutBytesSpooky(R_outpstream_t stream, void *buf, int length) {
    SpookyHash *spooky = (SpookyHash *)stream->data;
    uint8 skipped = 0;
    uint8 to_skip = 0;
    spooky->GetSkipCounter(&skipped);
    spooky->GetToSkip(&to_skip);
    if (skipped < to_skip){
        if ((skipped + length) > to_skip){
            Rf_error("Serialization header has an unexpected length. Please file an issue at https://github.com/eddelbuettel/digest/issues."); // #nocov
        }
        spooky->UpdateSkipCounter(length);
    } else {
        spooky->Update(buf, length);
    }
}


static void InitSpookyPStream(R_outpstream_t stream, SpookyHash *spooky,
                              R_pstream_format_t type, int version,
                              SEXP (*phook)(SEXP, SEXP), SEXP pdata) {
     R_InitOutPStream(stream, (R_pstream_data_t) spooky, type, version,
                      OutCharSpooky, OutBytesSpooky, phook, pdata);
}


//From serialize.c in R sources
/* ought to quote the argument, but it should only be an ENVSXP or STRSXP */
static SEXP CallHook(SEXP x, SEXP fun) {			// #nocov start
    SEXP val, call;
    PROTECT(call = Rf_lcons(fun, Rf_lcons(x, R_NilValue)));
    val = Rf_eval(call, R_GlobalEnv);
    UNPROTECT(1);
    return val;
}								// #nocov end


extern "C" SEXP spookydigest_impl(SEXP s, SEXP to_skip_r, SEXP seed1_r, SEXP seed2_r, SEXP version_r, SEXP fun) {
    SpookyHash spooky;
    double seed1_d = Rf_asReal(seed1_r);
    double seed2_d = Rf_asReal(seed2_r);
    uint64_t seed1 = static_cast<uint64_t>(seed1_d);
    uint64_t seed2 = static_cast<uint64_t>(seed2_d);

    uint8_t to_skip = static_cast<uint8_t>(Rf_asInteger(to_skip_r));
    spooky.Init(seed1, seed2, to_skip);
    R_outpstream_st spooky_stream;
    R_pstream_format_t type = R_pstream_binary_format;
    SEXP (*hook)(SEXP, SEXP);
    int version = Rf_asInteger(version_r);
    hook = fun != R_NilValue ? CallHook : NULL;
    InitSpookyPStream(&spooky_stream, &spooky, type, version, hook, fun);
    R_Serialize(s, &spooky_stream);

    //There are two because they are 64 bit ints and the hash is 128 bits!!!
    uint64 h1, h2;
    spooky.Final(&h1, &h2);
    SEXP ans;
    PROTECT(ans = Rf_allocVector(RAWSXP, 16));
    unsigned char *tmp;
    tmp  = (unsigned char *) &h1;
    for (int i = 0; i < 8; i++)
        RAW(ans)[i] = tmp[i];
    tmp = (unsigned char *) &h2;
    for (int j = 0; j < 8; j++)
	RAW(ans)[j + 8] = tmp[j];
    UNPROTECT(1);
    return ans;
}

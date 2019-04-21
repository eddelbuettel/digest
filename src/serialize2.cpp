#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#define USE_RINTERNALS
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

#include "SpookyV2.h"


static void OutCharSpooky(R_outpstream_t stream, int c)
{
    SpookyHash *spooky = (SpookyHash *)stream->data;
    spooky->Update(&c, 1);
}

static void OutBytesSpooky(R_outpstream_t stream, void *buf, int length)
{
    SpookyHash *spooky = (SpookyHash *)stream->data;
    spooky->Update(buf, length);
}


static void InitSpookyPStream(R_outpstream_t stream, SpookyHash *spooky,
			      R_pstream_format_t type, int version,
			      SEXP (*phook)(SEXP, SEXP), SEXP pdata)
{
     R_InitOutPStream(stream, (R_pstream_data_t) spooky, type, version,
		     OutCharSpooky, OutBytesSpooky, phook, pdata);
}


//From serialize.c in R sources
/* ought to quote the argument, but it should only be an ENVSXP or STRSXP */
static SEXP CallHook(SEXP x, SEXP fun)
{
    SEXP val, call;
    PROTECT(call = LCONS(fun, LCONS(x, R_NilValue)));
    val = eval(call, R_GlobalEnv);
    UNPROTECT(1);
    return val;
}


static SEXP R_spookydigest(SEXP s, SEXP fun)
{
    SpookyHash spooky;
    uint64 seed1 = 100000, seed2 = 9872143234;
    spooky.Init(seed1, seed2);
    int dummy;
    R_outpstream_st spooky_stream;
    R_pstream_format_t type = R_pstream_binary_format;
    SEXP (*hook)(SEXP, SEXP);
    int version = 0; //R_DefaultSerializeVersion?;
    hook = fun != R_NilValue ? CallHook : NULL;
    InitSpookyPStream(&spooky_stream, &spooky, type, version, hook, fun);
    R_Serialize(s, &spooky_stream);

//There are two because they are 64 bit ints and the hash is 128 bits!!!
    uint64 h1, h2;
    spooky.Final(&h1, &h2);
    SEXP ans;
    PROTECT(ans = allocVector(RAWSXP, 16));
    unsigned char *tmp;
    tmp  = (unsigned char *) &h1;
    for(int i = 0; i < 8; i++)
	RAW(ans)[i] = tmp[i];
    tmp = (unsigned char *) &h2;
    for(int j = 0; j < 8; j++)
	RAW(ans)[j + 8] = tmp[j];
    UNPROTECT(1);
    return ans;
}

static R_CallMethodDef callMethods[]  = {
  {"R_fastdigest", (DL_FUNC) &R_spookydigest, 2},
  {NULL, NULL, 0}
};

extern "C" {
void R_init_fastdigest(DllInfo *info)
{
    R_registerRoutines(info, NULL, callMethods, NULL, NULL);
}
}

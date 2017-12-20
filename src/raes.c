
/* This is a simple R interface to Christophe Devine's AES implementation */


#include "aes.h"
#include <R.h>
#include <Rinternals.h>

static aes_context ctx;

void encrypt(unsigned char *key, int *len, unsigned char *text) { /* #nocov start */ 
  aes_set_key(&ctx, key, 8*(*len));
  aes_encrypt(&ctx, text, text);
}

void decrypt(unsigned char *key, int *len, unsigned char *code) {
  aes_set_key(&ctx, key, 8*(*len));
  aes_decrypt(&ctx, code, code);
}

static void AESFinalizer(SEXP ptr)
{
  void *ctx = R_ExternalPtrAddr(ptr);
  if (!ctx) return;
  Free(ctx);
  R_ClearExternalPtr(ptr);
} /* #nocov end */

SEXP AESinit(SEXP key) {
  int nbits = 8*length(key);
  int status;
  SEXP result;
  
  aes_context *ctx;
  
  if (TYPEOF(key) != RAWSXP)
    error("key must be a raw vector"); 				/* #nocov */
  
  if (nbits != 128 && nbits != 192 && nbits != 256)
    error("AES only supports 16, 24 and 32 byte keys"); 	/* #nocov */
    
  ctx = (aes_context*)Calloc(sizeof(*ctx), char);
  
  status = aes_set_key(ctx, (uint8 *) RAW(key), nbits);
  if (status)
    error("AES initialization failed");				/* #nocov */
  
  result = R_MakeExternalPtr(ctx, install("AES_context"), R_NilValue);
  PROTECT(result);
  R_RegisterCFinalizerEx(result, AESFinalizer, FALSE);
  UNPROTECT(1);
  return result;
}

SEXP AESencryptECB(SEXP context, SEXP text) {
  aes_context *ctx = R_ExternalPtrAddr(context);
  int len = length(text);
  unsigned char *block;
  
  if (!ctx) 
    error("AES context not initialized"); 			/* #nocov */
  if (TYPEOF(text) != RAWSXP)
    error("Text must be a raw vector");				/* #nocov */
  if (len % 16)
    error("Text length must be a multiple of 16 bytes");	/* #nocov */
  
  if (MAYBE_REFERENCED(text)) text = duplicate(text);
  
  block = RAW(text);
  while (len > 0) {
    aes_encrypt(ctx, block, block);
    block += 16;
    len -= 16;
  }
  return(text);
}

SEXP AESdecryptECB(SEXP context, SEXP ciphertext) {
  aes_context *ctx = R_ExternalPtrAddr(context);
  int len = length(ciphertext);
  unsigned char *block;
  
  if (!ctx) 
    error("AES context not initialized");			/* #nocov */
  if (TYPEOF(ciphertext) != RAWSXP)
    error("Ciphertext must be a raw vector");			/* #nocov */
  if (len % 16)
    error("Ciphertext length must be a multiple of 16 bytes");	/* #nocov */
  
  if (MAYBE_REFERENCED(ciphertext)) ciphertext = duplicate(ciphertext);
  
  block = RAW(ciphertext);
  
  while (len > 0) {
    aes_decrypt(ctx, block, block);
    block += 16;
    len -= 16;
  }
  return(ciphertext);
}

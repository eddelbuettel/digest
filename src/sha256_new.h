#ifndef _SHA256_new_H
#define _SHA256_new_H

#ifndef uint8
#define uint8  unsigned char
#endif

#ifndef R_xlen_t
#define R_xlen_t unsigned long long int
#endif

typedef struct
{
    R_xlen_t total[2];
    R_xlen_t state[8];
    uint8 buffer[64];
}
sha256_new_context;

void sha256_new_starts( sha256_new_context *ctx );
void sha256_new_update( sha256_new_context *ctx, uint8 *input, R_xlen_t length );
void sha256_new_finish( sha256_new_context *ctx, uint8 digest[32] );

#endif /* sha256_new.h */

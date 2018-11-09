#include <R.h>
#include <Rdefines.h>
#include <stdint.h>

// https://en.wikipedia.org/wiki/Jenkins_hash_function#one_at_a_time
uint32_t jenkins_one_at_a_time_hash(const char *key, uint32_t seed) {

    uint32_t hash = seed;
    for(; *key; ++key) {
        hash += *key;
        hash += (hash << 10);
        hash ^= (hash >> 6);
    }

    hash += (hash << 3);
    hash ^= (hash >> 11);
    hash += (hash << 15);
    return hash;
}

SEXP digest2int(SEXP input, SEXP Seed) {
    uint32_t seed = INTEGER_VALUE(Seed);

    if (TYPEOF(input) != STRSXP)  error("invalid input - should be character vector");
    R_xlen_t n = xlength(input);

    SEXP result = PROTECT(allocVector(INTSXP, n ));
    memset(INTEGER(result), 0, n * sizeof(int));

    int *res_ptr = INTEGER(result);

    for(R_xlen_t i = 0; i < n; i++) {
        const char* element_ptr = CHAR(STRING_ELT(input, i));
        res_ptr[i] = jenkins_one_at_a_time_hash(element_ptr, seed);
    }
    UNPROTECT(1);

    return(result);
}

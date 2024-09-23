
#include <RApiSerializeAPI.h>   	// provides C API with serialization for R

extern "C" {

SEXP serialize_to_raw(SEXP inp) {
    return serializeToRaw(inp, Rf_ScalarInteger(2), Rf_ScalarLogical(1));
}

SEXP unserialize_from_raw(SEXP inp) {
    return unserializeFromRaw(inp);
}

}

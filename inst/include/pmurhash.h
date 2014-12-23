/* number of R header files (possibly listing too many) */
#include <stddef.h>
#include <R_ext/Rdynload.h>

#ifdef HAVE_VISIBILITY_ATTRIBUTE
    # define attribute_hidden __attribute__ ((visibility ("hidden")))
#else
    # define attribute_hidden
#endif

#ifdef __cplusplus
extern "C" {
#endif

/* First look for special cases */
#if defined(_MSC_VER)
  #define MH_UINT32 unsigned long
#endif

/* If the compiler says it's C99 then take its word for it */
#if !defined(MH_UINT32) && ( \
     defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L )
  #include <stdint.h>
  #define MH_UINT32 uint32_t
#endif

/* Otherwise try testing against max value macros from limit.h */
#if !defined(MH_UINT32)
  #include  <limits.h>
  #if   (USHRT_MAX == 0xffffffffUL)
    #define MH_UINT32 unsigned short
  #elif (UINT_MAX == 0xffffffffUL)
    #define MH_UINT32 unsigned int
  #elif (ULONG_MAX == 0xffffffffUL)
    #define MH_UINT32 unsigned long
  #endif
#endif

#if !defined(MH_UINT32)
  #error Unable to determine type name for unsigned 32-bit int
#endif

/* I'm yet to work on a platform where 'unsigned char' is not 8 bits */
#define MH_UINT8  unsigned char

MH_UINT32 attribute_hidden PMurHash32(MH_UINT32 seed, const void *key, int len) {
  static MH_UINT32(*fun)(MH_UINT32, const void*, int) = NULL;
  if (!fun) {
    fun = (MH_UINT32(*)(MH_UINT32, const void*, int)) R_GetCCallable("digest", "PMurHash32");
  }
  return fun(seed, key, len);
}

#ifdef __cplusplus
}
#endif

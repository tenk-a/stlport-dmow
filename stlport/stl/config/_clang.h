/* STLport configuration file
 * It is internal STLport header - DO NOT include it directly
 */

// this header for clang+mingw (windows)

#define _STLP_COMPILER "clang"

#define _STLP_HAS_INCLUDE_NEXT 1

#if !defined (_REENTRANT) && (defined (_THREAD_SAFE) || \
                             (defined (__OpenBSD__) && defined (_POSIX_THREADS)) || \
                             (defined (__MINGW32__) && defined (_MT)))
#  define _REENTRANT
#endif

#if 1 //defined (__MINGW32__) || defined(__MINGW64__)
/* Mingw32, egcs compiler using the Microsoft C runtime */
#  define _STLP_VENDOR_GLOBAL_CSTD
#  undef  _STLP_NO_DRAND48
#  define _STLP_NO_DRAND48
#  define _STLP_CALL
#  define _STLP_NEW_PLATFORM_SDK
#  define _STLP_KKKK_DMOW
#  undef  _PTHREADS
#endif /* __MINGW32__ */

#if 1 //defined (__CYGWIN__) || defined (__MINGW32__)
#  if !defined (_STLP_USE_STATIC_LIB)
#    define _STLP_USE_DECLSPEC 1
#    if !defined (_STLP_USE_DYNAMIC_LIB)
#      define _STLP_USE_DYNAMIC_LIB
#    endif
#    define _STLP_EXPORT_DECLSPEC __declspec(dllexport)
#    define _STLP_CLASS_EXPORT_DECLSPEC __declspec(dllexport)
#    define _STLP_CLASS_IMPORT_DECLSPEC __declspec(dllimport)
#  endif
/* The following is defined independently of _STLP_USE_STATIC_LIB because it is also
 * used to import symbols from PSDK under MinGW
 */
#  define _STLP_IMPORT_DECLSPEC __declspec(dllimport)
#endif

#if 1 //defined (__CYGWIN__) || defined (__MINGW32__) || !(defined (_STLP_USE_GLIBC) || defined (__sun) || defined(__APPLE__))
#  define _STLP_NO_NATIVE_WIDE_STREAMS   1
#endif

#define _STLP_NORETURN_FUNCTION __attribute__((noreturn))

/* g++ 2.7.x and above */
#define _STLP_LONG_LONG long long

#if 1 //(__GNUC__ >= 3)
#  ifndef _STLP_HAS_NO_NEW_C_HEADERS
/*
#    ifndef _STLP_USE_UCLIBC
*/
#    define _STLP_HAS_NATIVE_FLOAT_ABS
/*
#    endif
*/
#  else
#    ifdef _STLP_USE_GLIBC
#      define _STLP_VENDOR_LONG_DOUBLE_MATH  1
#    endif
#  endif
#endif

#undef _STLP_NO_UNCAUGHT_EXCEPT_SUPPORT
#undef _STLP_NO_UNEXPECTED_EXCEPT_SUPPORT

/* strict ANSI prohibits "long long" ( gcc) */
#if defined ( __STRICT_ANSI__ )
#  undef _STLP_LONG_LONG
#endif

#ifndef __EXCEPTIONS
#  undef  _STLP_DONT_USE_EXCEPTIONS
#  define _STLP_DONT_USE_EXCEPTIONS 1
#endif

#if 1 //(__GNUC__ >= 3)
/* Instantiation scheme that used (default) in gcc 3 made void of sense explicit
   instantiation within library: nothing except increased library size. - ptr
 */
#  define _STLP_NO_FORCE_INSTANTIATE
#endif

#if defined (_STLP_VERBOSE) && !defined (_STLP_VERBOSE_MODE_SUPPORTED)
#  undef _STLP_VERBOSE
#endif

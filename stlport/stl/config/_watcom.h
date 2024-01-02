// STLport configuration file
// It is internal STLport header - DO NOT include it directly

#define _STLP_COMPILER "Watcom"

#if (__WATCOMC__ < 1280)
#  error Not supported!
#endif

//#define _STLP_NO_LOCALE_SUPPORT
//#define _STLP_KKKK_USE_CINCOUTCERR_REF
//#define _STLP_DONT_USE_SHORT_STRING_OPTIM

#define _STLP_VERBOSE_MODE_SUPPORTED            1   // better
#define _STLP_HAS_SPECIFIC_PROLOG_EPILOG        1   // better ???
#define _STLP_DEF_CONST_PLCT_NEW_BUG            1   // better ?
#define _STLP_USE_NEWALLOC                      1   // need _STLP_USE_NEWALLOC or _STLP_USE_MALLOC
#define _STLP_NO_FUNCTION_TMPL_PARTIAL_ORDER    1   // need (=> undef _STLP_FUNCTION_TMPL_PARTIAL_ORDER, define _STLP_USE_PARTIAL_SPEC_WORKAROUND)
#define _STLP_DONT_SUP_DFLT_PARAM               1   // need
#define _STLP_NO_STATIC_CONST_DEFINITION        1   // need
#define _STLP_STATIC_CONST_INIT_BUG             1   // need
#define _STLP_NEW_PLATFORM_SDK                  1   // need
#define _STLP_USE_NEW_C_HEADERS                 1   // need
#define _STLP_KKKK_H_INCLUDE_NEW_C_HEADERS      1   // need
#define _STLP_KKKK_DMOW                         1   // need (for watcom c++ & digitalmars c++)

#ifndef _CPPRTTI
#  define _STLP_NO_RTTI 1
#endif

#if !defined(__IALIAS_H_INCLUDED)
// Dummy define.  If the header file of 8.3 forms is not used, it is necessary
// to specify -D__IALIAS_H_INCLUDED as the command line option of the compiler.
#define __IALIAS_H_INCLUDED
#endif

// for switches (-xs,  -xss,  -xst)
#if !(defined (__SW_XS) || defined (__SW_XSS) || defined(__SW_XST))
#  define _STLP_HAS_NO_EXCEPTIONS 1
#endif

//#define _STLP_NO_BAD_ALLOC
#if !defined(_STLP_HAS_NO_EXCEPTIONS) && !defined(_STLP_NO_EXCEPTIONS)
#define _STLP_NEW_DONT_THROW_BAD_ALLOC
#endif

#if defined (__SW_BD)
#  define _STLP_DLL 1
#endif
#if defined (__SW_BR)
#  define _STLP_RUNTIME_DLL 1
#endif

#if defined(__SW_BM) && !defined(_MT)
#  define _MT
#endif
#if defined (_MT) && !defined (_NOTHREADS)
#  define _STLP_THREADS
#endif
// select threads strategy
#if defined (__SW_BM) && !defined (_NOTHREADS)
#  define _REENTRANT
#else
#  define _NOTHREADS
#endif

#define _STLP_LONG_LONG long long


// On QNX, headers are supposed to be found in /usr/include,
// so default "../include" should work.
#if defined(__LINUX__)
#  define _STLP_NATIVE_INCLUDE_PATH ../lh
#elif !defined(__QNX__)
#  define _STLP_NATIVE_INCLUDE_PATH ../h
#else
// boris : is this true or just the header is not in /usr/include ?
#  define _STLP_NO_TYPEINFO 1
#endif

#define _STLP_EXPORT_DECLSPEC   __declspec(dllexport)
#define _STLP_IMPORT_DECLSPEC   __declspec(dllimport)

#define _STLP_CLASS_EXPORT_DECLSPEC __declspec(dllexport)
#define _STLP_CLASS_IMPORT_DECLSPEC __declspec(dllimport)

#define _STLP_IMPORT_TEMPLATE_KEYWORD   __declspec(dllimport)
#define _STLP_EXPORT_TEMPLATE_KEYWORD   __declspec(dllexport)

#include <stl/config/_detect_dll_or_lib.h>
#undef _STLP_RUNTIME_DLL
#undef _STLP_DLL

//#define _STLP_CALL __cdecl
//#define _STLP_IMPORT_DECLSPEC __declspec(dllimport)
#if defined (_STLP_USE_DYNAMIC_LIB)
#  define _STLP_USE_DECLSPEC 1
#  if defined (__BUILDING_STLPORT)
#    define _STLP_CALL __export __watcall
#  else
#    define _STLP_CALL __watcall
#  endif
#else
#  define _STLP_CALL __watcall
#endif

// Get rid of Watcom's min and max macros
#undef min
#undef max

// Inline replacements for locking calls under Watcom
// Define _STLP_NO_WATCOM_INLINE_INTERLOCK to keep using
// standard WIN32 calls
// Define _STL_MULTIPROCESSOR to enable lock
//#define _STLP_NO_WATCOM_INLINE_INTERLOCK
#if !defined(_STLP_NO_WATCOM_INLINE_INTERLOCK)

long    __stl_InterlockedIncrement( long *var );
long    __stl_InterlockedDecrement( long *var );

#ifdef _STL_MULTIPROCESSOR
// Multiple Processors, add lock prefix
#pragma aux __stl_InterlockedIncrement parm [ ecx ] = \
        ".586"                  \
        "mov eax, 1"            \
        "lock xadd [ecx], eax"  \
        "inc eax"               \
        value [eax];


#pragma aux __stl_InterlockedDecrement parm [ ecx ] = \
        ".586"                  \
        "mov eax, 0FFFFFFFFh"   \
        "lock xadd [ecx], eax"  \
        "dec eax"               \
        value [eax];
#else
// Single Processor, lock prefix not needed
#pragma aux __stl_InterlockedIncrement parm [ ecx ] = \
        ".586"                  \
        "mov eax, 1"            \
        "xadd [ecx], eax"       \
        "inc eax"               \
        value [eax];

#pragma aux __stl_InterlockedDecrement parm [ ecx ] = \
        ".586"                  \
        "mov eax, 0FFFFFFFFh"   \
        "xadd [ecx], eax"       \
        "dec eax"               \
        value [eax];
#endif // _STL_MULTIPROCESSOR

long    __stl_InterlockedExchange( long *Destination, long Value );

// xchg has auto-lock
#pragma aux __stl_InterlockedExchange parm [ecx] [eax] = \
        ".586"                  \
        "xchg eax, [ecx]"       \
        value [eax];

#  define _STLP_ATOMIC_INCREMENT(__x)           __stl_InterlockedIncrement((long*)__x)
#  define _STLP_ATOMIC_DECREMENT(__x)           __stl_InterlockedDecrement((long*)__x)
#  define _STLP_ATOMIC_EXCHANGE(__x, __y)       __stl_InterlockedExchange((long*)__x, (long)__y)
#  define _STLP_ATOMIC_EXCHANGE_PTR(__x, __y)   (void*)__stl_InterlockedExchange((long*)__x, (long)__y)
#endif /* INLINE INTERLOCK */

//#include <stl/config/_auto_link.h>

// STLport configuration file for Digital Mars C++

#define _STLP_COMPILER __DMC_VERSION_STRING__

#if (__DMC__ < 0x855)
#  error "Digital Mars C++ compilers before version 8.55 are not supported!"
#endif

//#define _STLP_NO_LOCALE_SUPPORT
//#define _STLP_KKKK_USE_CINCOUTCERR_REF

#define _STLP_KKKK_DMOW     // for dm & ow

#define _STLP_USE_NEWALLOC 1
//#define _STLP_DONT_USE_SHORT_STRING_OPTIM

/* DMC goes too far in template instanciation and tries to fully instanciate
 * slist<pair<const int, string> > for instance. The generation of assignment
 * operator fails of course so we are force to use mutable key for this compiler.
 */
#define _STLP_NO_CONST_IN_PAIR
#define _STLP_DONT_SUP_DFLT_PARAM

#define _STLP_VENDOR_GLOBAL_CSTD

#if !defined (_WIN32)
// it's not fully supported on non-Win32 platforms
#  define _STLP_NO_NATIVE_WIDE_FUNCTIONS
#endif

/* _STLP_NO_OWN_NAMESPACE is defined because Digital Mars' linker and libarian
   appear to have problems with STLport namespaces. Summary of the issues:

   STATIC: Digital Mars' librarian (lib.exe) may fail with "len <= IDMAX" error
   if _STLP_DEBUG is defined.  This is because Digital Mars' librarian uses
   Microsoft OMF format, which limits identifier length to about 512 bytes.
   With STLport namespaces, some identifiers such as Category_Map in
   src/locale_catalog.cpp may exceed the maximum OMF identifier length.

   DYNAMIC: Export issues with cin, cout, cerr, clog in src/iostream.cpp.
   Exports in Digital Mars 'def' file must match mangled names in iostream.cpp.
   With STLport namespaces, the mangled names in the intermediate files no
   longer match these pre-defined exports. To use STLport dynamic libraries
   and STLport namespaces with Digital Mars, the pre-defined exports in
   src/iostream.cpp and the related Digital Mars 'def' files would need to be
   revised. */
//#define _STLP_NO_OWN_NAMESPACE 1
#define _STLP_USE_ABBREVS

#define _STLP_DONT_USE_PRIV_NAMESPACE
#define _STLP_PRIV

// select threads strategy
#if defined (_MT) && !defined (_STLP_NO_THREADS)
#  define _STLP_THREADS
#endif

#ifndef _CPPRTTI
#  define _STLP_NO_RTTI 1
#endif
#ifndef _CPPUNWIND
#  define _STLP_NO_EXCEPTIONS
#endif
#ifndef _STLP_NO_EXCEPTIONS
#define _STLP_NEW_DONT_THROW_BAD_ALLOC
#endif
#if (__DMC__ < 0x849)
#  define _STLP_NO_BAD_ALLOC
#endif
#define _STLP_THROW_RETURN_BUG
#define _STLP_NO_UNCAUGHT_EXCEPT_SUPPORT    // dmc has bad 'uncaught_exception()'

#ifndef _BOOL_DEFINED
#  define _STLP_NO_BOOL
#else
#  define _STLP_DONT_USE_BOOL_TYPEDEF
#endif

#if _INTEGRAL_MAX_BITS >= 64
#  define _STLP_LONG_LONG long long
#endif

#if !defined (_DLL)
#  undef _STLP_NO_UNEXPECTED_EXCEPT_SUPPORT
#endif

#define _STLP_EXPORT_DECLSPEC __declspec(dllexport)
#define _STLP_IMPORT_DECLSPEC __declspec(dllimport)

#define _STLP_CLASS_EXPORT_DECLSPEC __declspec(dllexport)
#define _STLP_CLASS_IMPORT_DECLSPEC __declspec(dllimport)

//#define _STLP_IMPORT_TEMPLATE_KEYWORD __declspec(dllimport)
//#define _STLP_EXPORT_TEMPLATE_KEYWORD __declspec(dllexport)

#if defined (_WINDLL)
#  define _STLP_DLL
#endif
#if defined (_DLL)
#  define _STLP_RUNTIME_DLL
#endif
#include <stl/config/_detect_dll_or_lib.h>
#undef _STLP_RUNTIME_DLL
#undef _STLP_DLL

#if defined (_STLP_USE_DYNAMIC_LIB)
#  define _STLP_USE_DECLSPEC 1
#  if defined (__BUILDING_STLPORT)
#    define _STLP_CALL __export
#  else
#    define _STLP_CALL
#  endif
#else
#  define _STLP_CALL
#endif

#if !defined (_STLP_KKKK_NO_BUILD_LIB)
#include <stl/config/_auto_link.h>
#endif

#undef __SC__

#include <stl/config/_feedback.h>


//DMC prefer enum to real static const variable because it do not consider
//static const as const enough to be used in switch declaration...
// (for dll)
#define _STLP_STATIC_CONST_INIT_BUG

//#define _STLP_NO_FUNCTION_TMPL_PARTIAL_ORDER
//#define _STLP_USE_MSVC6_MEM_T_BUG_WORKAROUND
//#define _STLP_NEED_ADDITIONAL_STATIC_DECLSPEC




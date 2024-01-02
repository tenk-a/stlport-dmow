 /*
 *
 * Copyright (c) 1994
 * Hewlett-Packard Company
 *
 * Copyright (c) 1996,1997
 * Silicon Graphics Computer Systems, Inc.
 *
 * Copyright (c) 1997
 * Moscow Center for SPARC Technology
 *
 * Copyright (c) 1999
 * Boris Fomitchev
 *
 * This material is provided "as is", with absolutely no warranty expressed
 * or implied. Any use is at your own risk.
 *
 * Permission to use or copy this software for any purpose is hereby granted
 * without fee, provided the above notices are retained on all copies.
 * Permission to modify the code and to distribute modified code is granted,
 * provided the above notices are retained, and a notice that the code was
 * modified is included with the above copyright notice.
 *
 */

#define _STLP_EXPOSE_GLOBALS_IMPLEMENTATION

#include "stlport_prefix.h"

#if !defined (_STLP_DEBUG) && ! defined (_STLP_ASSERTIONS)
#  if !defined (__APPLE__) || !defined (__GNUC__) || (__GNUC__ < 3) || ((__GNUC__ == 3) && (__GNUC_MINOR__ < 3))
/* dums: Please if the following code was being uncommented please explain why
 * as for the moment it only looks like a source of inconsistency in the way
 * STLport different translation units are compiled.
 */
//#    define _STLP_ASSERTIONS 1
#  endif
#endif

#include <utility>
#include <memory>
#include <vector>
#include <set>
#include <list>
#include <slist>
#include <deque>
#include <hash_map>
#include <limits>
#include <string>
#include <stdexcept>
#include <bitset>
#include <locale>


#define FORCE_SYMBOL extern

#if defined (_WIN32) && defined (_STLP_USE_DECLSPEC) && !defined (_STLP_USE_STATIC_LIB)
// stlportmt.cpp : Defines the entry point for the DLL application.
//
#  undef FORCE_SYMBOL
#  define FORCE_SYMBOL APIENTRY

extern "C" {

BOOL APIENTRY DllMain( HANDLE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID) {
  switch (ul_reason_for_call) {
    case DLL_PROCESS_ATTACH:
      DisableThreadLibraryCalls((HINSTANCE)hModule);
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
      break;
    }
  return TRUE;
}

} /* extern "C" */

#if !defined (_STLP_MSVC) && !defined (__MINGW32__)
_STLP_BEGIN_NAMESPACE

static void FORCE_SYMBOL
force_link() {
  set<int>::iterator iter;
  // _M_increment; _M_decrement instantiation
  ++iter;
  --iter;
}

_STLP_END_NAMESPACE
#endif

#endif /* _WIN32 */

#if defined (__ICL) && (__ICL >= 900) && (_STLP_MSVC_LIB < 1300)
#  undef std

namespace std
{
  void _STLP_CALL unexpected() {
    unexpected_handler hdl;
    set_unexpected(hdl = set_unexpected((unexpected_handler)0));
    hdl();
  }
}
#endif

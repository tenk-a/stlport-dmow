/*
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
#if defined(__cplusplus) && defined(_STLP_KKKK_H_INCLUDE_NEW_C_HEADERS) && !defined(_STLP_CLIMITS)
#  include <climits>
#endif

#if !defined (_STLP_OUTERMOST_HEADER_ID)
#  define _STLP_OUTERMOST_HEADER_ID 0x201
#  include <stl/_cprolog.h>
#elif (_STLP_OUTERMOST_HEADER_ID == 0x201) && ! defined (_STLP_DONT_POP_HEADER_ID)
#  define _STLP_DONT_POP_HEADER_ID
#endif

#if defined(_STLP_WCE_EVC3)
struct _exception;
#endif

#if defined (_STLP_HAS_INCLUDE_NEXT)
#  include_next <limits.h>
#else
#  include _STLP_NATIVE_C_HEADER(limits.h)
#endif

#if (_STLP_OUTERMOST_HEADER_ID == 0x201)
#  if ! defined (_STLP_DONT_POP_HEADER_ID)
#    include <stl/_epilog.h>
#    undef  _STLP_OUTERMOST_HEADER_ID
#  endif
#  undef  _STLP_DONT_POP_HEADER_ID
#endif

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

#if 1 //!defined(_STLP_NO_FORCE_INSTANTIATE)
#include <new>
//#include <stdexcept>

#include <stl/_range_errors.h>
#include <stl/_range_errors.c>

_STLP_BEGIN_NAMESPACE

#if defined (_STLP_NO_EXCEPTION_HEADER) || defined (_STLP_BROKEN_EXCEPTION_CLASS)
exception::exception() _STLP_NOTHROW {}
exception::~exception() _STLP_NOTHROW {}
bad_exception::bad_exception() _STLP_NOTHROW {}
bad_exception::~bad_exception() _STLP_NOTHROW {}
const char* exception::what() const _STLP_NOTHROW { return "class exception"; }
const char* bad_exception::what() const _STLP_NOTHROW { return "class bad_exception"; }
#endif

#if defined (_STLP_OWN_STDEXCEPT)
#  include <stl/_stdexcept_base.c>
//#error "‚­‚é"
// boris : those are needed to force typeinfo nodes to be created in here only
logic_error::~logic_error() _STLP_NOTHROW_INHERENTLY {}
runtime_error::~runtime_error() _STLP_NOTHROW_INHERENTLY {}
domain_error::~domain_error() _STLP_NOTHROW_INHERENTLY {}
invalid_argument::~invalid_argument() _STLP_NOTHROW_INHERENTLY {}
length_error::~length_error() _STLP_NOTHROW_INHERENTLY {}
out_of_range::~out_of_range() _STLP_NOTHROW_INHERENTLY {}
range_error::~range_error() _STLP_NOTHROW_INHERENTLY {}
overflow_error::~overflow_error() _STLP_NOTHROW_INHERENTLY {}
underflow_error::~underflow_error() _STLP_NOTHROW_INHERENTLY {}

#endif

#if !defined(_STLP_WCE_EVC3) && !defined(__WATCOMC__) && !defined(__DMC__)
#  if defined (_STLP_NO_BAD_ALLOC)
const nothrow_t nothrow /* = {} */;
#  endif
#endif

_STLP_END_NAMESPACE

#endif

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
#include <utility>
#include <memory>

#if !defined (_STLP_NO_FORCE_INSTANTIATE) && defined (_STLP_USE_PTR_SPECIALIZATIONS)
_STLP_BEGIN_NAMESPACE

_STLP_MOVE_TO_PRIV_NAMESPACE
template class  _STLP_CLASS_DECLSPEC _STLP_alloc_proxy<void***, void**, allocator<void**> >;
_STLP_MOVE_TO_STD_NAMESPACE

_STLP_END_NAMESPACE
#endif

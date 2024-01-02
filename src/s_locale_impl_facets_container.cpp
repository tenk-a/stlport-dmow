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
#include <vector>
#include <locale>

#if !defined (_STLP_NO_FORCE_INSTANTIATE)
_STLP_BEGIN_NAMESPACE

//Export of _Locale_impl facets container:
#  if !defined (_STLP_USE_PTR_SPECIALIZATIONS)
template class _STLP_CLASS_DECLSPEC allocator<locale::facet*>;

_STLP_MOVE_TO_PRIV_NAMESPACE
template class _STLP_CLASS_DECLSPEC _STLP_alloc_proxy<locale::facet**, locale::facet*, allocator<locale::facet*> >;
template class _STLP_CLASS_DECLSPEC _Vector_base<locale::facet*, allocator<locale::facet*> >;
_STLP_MOVE_TO_STD_NAMESPACE

#  endif
#  if defined (_STLP_DEBUG)
_STLP_MOVE_TO_PRIV_NAMESPACE
#    define _STLP_NON_DBG_VECTOR _STLP_NON_DBG_NAME(vector)
template class _STLP_CLASS_DECLSPEC __construct_checker<_STLP_PRIV _STLP_NON_DBG_VECTOR<locale::facet*, allocator<locale::facet*> > >;
template class _STLP_CLASS_DECLSPEC _STLP_NON_DBG_VECTOR<locale::facet*, allocator<locale::facet*> >;
#    undef _STLP_NON_DBG_VECTOR
_STLP_MOVE_TO_STD_NAMESPACE
#  endif

template class _STLP_CLASS_DECLSPEC vector<locale::facet*, allocator<locale::facet*> >;
//End of export of _Locale_impl facets container.

_STLP_END_NAMESPACE
#endif

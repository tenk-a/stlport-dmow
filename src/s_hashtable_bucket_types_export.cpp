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

#if !defined (_STLP_NO_FORCE_INSTANTIATE)
#include <memory>
#include <vector>
#include <slist>

_STLP_BEGIN_NAMESPACE

//Export of the types used to represent buckets in the hashtable implementation.
/*
 * For the vector class we do not use any MSVC6 workaround even if we export it from
 * the STLport dynamic libraries because we know what methods are called and none is
 * a template method. Moreover the exported class is an instanciation of vector with
 * _Slist_node_base struct that is an internal STLport class that no user should ever
 * use.
 */
#  if !defined (_STLP_USE_PTR_SPECIALIZATIONS)
template class _STLP_CLASS_DECLSPEC allocator<_STLP_PRIV _Slist_node_base*>;

_STLP_MOVE_TO_PRIV_NAMESPACE
template class _STLP_CLASS_DECLSPEC _STLP_alloc_proxy<_Slist_node_base**, _Slist_node_base*,
                                                      allocator<_Slist_node_base*> >;
template class _STLP_CLASS_DECLSPEC _Vector_base<_Slist_node_base*,
                                                 allocator<_Slist_node_base*> >;
_STLP_MOVE_TO_STD_NAMESPACE
#  endif

#  if defined (_STLP_DEBUG)
_STLP_MOVE_TO_PRIV_NAMESPACE
template class _STLP_CLASS_DECLSPEC _STLP_NON_DBG_NAME(vector)<_Slist_node_base*,
                                                               allocator<_Slist_node_base*> >;
_STLP_MOVE_TO_STD_NAMESPACE
#  endif

template class _STLP_CLASS_DECLSPEC vector<_STLP_PRIV _Slist_node_base*,
                                           allocator<_STLP_PRIV _Slist_node_base*> >;
//End of hashtable bucket types export.

_STLP_END_NAMESPACE
#endif

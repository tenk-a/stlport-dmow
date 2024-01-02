/*
 * Copyright (c) 1999
 * Silicon Graphics Computer Systems, Inc.
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
#include "stlport_prefix.h"

#if !defined (_STLP_NO_FORCE_INSTANTIATE) && !defined (_STLP_USE_NO_IOSTREAMS)

#include <ostream>

_STLP_BEGIN_NAMESPACE

// instantiations
template class _STLP_CLASS_DECLSPEC basic_ostream<char, char_traits<char> >;

# if defined (_STLP_USE_TEMPLATE_EXPORT)
template  class _STLP_CLASS_DECLSPEC _Osentry<char, char_traits<char> >;
# endif

#ifndef _STLP_NO_WCHAR_T
template class _STLP_CLASS_DECLSPEC basic_ostream<wchar_t, char_traits<wchar_t> >;

# if defined (_STLP_USE_TEMPLATE_EXPORT)
template class _STLP_CLASS_DECLSPEC _Osentry<wchar_t, char_traits<wchar_t> >;
# endif
#endif

_STLP_END_NAMESPACE

#endif

// Local Variables:
// mode:C++
// End:

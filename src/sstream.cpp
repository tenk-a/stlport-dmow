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

#if !defined (_STLP_KKKK_USE_HEADER_ONLY) && !defined (_STLP_USE_NO_IOSTREAMS)

#include <sstream>

_STLP_BEGIN_NAMESPACE

// Force instantiation of stringstream classes.
template class _STLP_CLASS_DECLSPEC basic_stringbuf<char, char_traits<char>, allocator<char> >;
template class _STLP_CLASS_DECLSPEC basic_ostringstream<char, char_traits<char>, allocator<char> >;
template class _STLP_CLASS_DECLSPEC basic_istringstream<char, char_traits<char>, allocator<char> >;
template class _STLP_CLASS_DECLSPEC basic_stringstream<char, char_traits<char>, allocator<char> >;

#  if !defined (_STLP_NO_WCHAR_T)
template class _STLP_CLASS_DECLSPEC basic_stringbuf<wchar_t, char_traits<wchar_t>, allocator<wchar_t> >;
template class _STLP_CLASS_DECLSPEC basic_ostringstream<wchar_t, char_traits<wchar_t>, allocator<wchar_t> >;
template class _STLP_CLASS_DECLSPEC basic_istringstream<wchar_t, char_traits<wchar_t>, allocator<wchar_t> >;
template class _STLP_CLASS_DECLSPEC basic_stringstream<wchar_t, char_traits<wchar_t>, allocator<wchar_t> >;
#  endif

_STLP_END_NAMESPACE

#endif

// Local Variables:
// mode:C++
// End:

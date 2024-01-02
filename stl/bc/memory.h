/*
 * Copyright (c) 1997-1999
 * Silicon Graphics
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

#ifndef __SGI_STL_MEMORY
#define __SGI_STL_MEMORY

#include <stl_algobase.h>
#include <stl_alloc.h>
#include <stl_construct.h>
#include <stl_iterator.h>
#include <stl_uninitialized.h>
#include <stl_tempbuf.h>
#include <stl_raw_storage_iter.h>

#if __MSL__ >= 0x2405	/*  980401 vss  MSL 2.4  Pro 3 Release  */	
# include <new_mem.h>
#endif

__STL_BEGIN_NAMESPACE

template <class _Tp> class auto_ptr;

// The standard specifies that this will be a private nested class within auto_ptr,
// but that arrangement doesn't appear to work in some important cases. In any case
// this change is undetectable by conforming code. dwa 1/11/99 
template <class _Tp> struct auto_ptr_ref
{
	_Tp* _M_ptr;
	auto_ptr_ref( _Tp* __p ) : _M_ptr( __p ) {} 
};

template <class _Tp> class auto_ptr {
private:
  _Tp* _M_ptr;
  typedef auto_ptr<_Tp> _Self;
public:
  typedef _Tp element_type;

  explicit auto_ptr(_Tp* __p = 0) __STL_NOTHROW : _M_ptr(__p) {}

#ifdef __STL_MEMBER_TEMPLATES
  template <class _Tp1> auto_ptr(auto_ptr<_Tp1>& __a) __STL_NOTHROW
    : _M_ptr(__a.release()) {}
#endif /* __STL_MEMBER_TEMPLATES */

  // dwa 12/28/98 - a template copy constructor is not a substitute
  // for the default copy constructor!
  auto_ptr(_Self& __a) __STL_NOTHROW : _M_ptr(__a.release()) {}

#ifdef __STL_MEMBER_TEMPLATES
  template <class _Tp1>
  _Self& operator=(auto_ptr<_Tp1>& __a) __STL_NOTHROW {
    this->reset(__a.release());
    return *this;
  }
#endif /* __STL_MEMBER_TEMPLATES */

  // dwa 12/28/98 - a template assignment operator is not a substitute
  // for the default copy assignment operator!
  _Self& operator=(_Self& __a) __STL_NOTHROW {
    this->reset(__a.release());
    return *this;
  }

  // dwa 1/11/99 - not specified by the standard, but required to fulfill its intent
  _Self& operator=(auto_ptr_ref<_Tp> __ref) __STL_NOTHROW {
    this->reset(__ref._M_ptr);
    return *this;
  }

  ~auto_ptr() __STL_NOTHROW { delete _M_ptr; }

  _Tp& operator*() const __STL_NOTHROW {
    return *_M_ptr;
  }
  _Tp* operator->() const __STL_NOTHROW {
    return _M_ptr;
  }
  _Tp* get() const __STL_NOTHROW {
    return _M_ptr;
  }
  _Tp* release() __STL_NOTHROW {
    _Tp* __tmp = _M_ptr;
    _M_ptr = 0;
    return __tmp;
  }
  void reset(_Tp* __p = 0) __STL_NOTHROW {
    if (_M_ptr != __p) {
      delete _M_ptr;
      _M_ptr = __p;
    }
  }

  auto_ptr(auto_ptr_ref<_Tp> __ref) __STL_NOTHROW
    : _M_ptr(__ref._M_ptr) {}

  // According to the C++ standard, these conversions are required.  Most
  // present-day compilers, however, do not enforce that requirement---and, 
  // in fact, most present-day compilers do not support the language 
  // features that these conversions rely on.
  
#if defined(__STL_MEMBER_TEMPLATES) && !defined(__STL_NO_TEMPLATE_CONVERSIONS)

  template <class _Y>
  auto_ptr(auto_ptr_ref<_Y> __ref) __STL_NOTHROW
    : _M_ptr(__ref._M_ptr) {}
  template <class _Tp1> operator auto_ptr_ref<_Tp1>() __STL_NOTHROW 
    { return auto_ptr_ref<_Tp>(this->release()); }
  template <class _Tp1> operator auto_ptr<_Tp1>() __STL_NOTHROW
    { return auto_ptr<_Tp1>(this->release()); }
#else
	operator auto_ptr_ref<_Tp>() __STL_NOTHROW 
		{ return auto_ptr_ref<_Tp>(this->release()); }
#endif /* auto ptr conversions && member templates */
};

__STL_END_NAMESPACE

#endif /* __SGI_STL_MEMORY */

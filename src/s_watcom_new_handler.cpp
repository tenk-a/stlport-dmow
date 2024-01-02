#if defined(__WATCOMC__)

#include "stlport_prefix.h"
#include _STLP_NATIVE_CPP_RUNTIME_HEADER(new)

namespace std {
  struct nothrow_t {};
  const nothrow_t nothrow;
  typedef void (*new_handler)();
 #if defined (_STLP_USE_EXCEPTIONS)
  new_handler set_new_handler(new_handler __new_handler) throw() {
    return (new_handler)::set_new_handler( (PFV)__new_handler );
  }
 #endif
}
#endif

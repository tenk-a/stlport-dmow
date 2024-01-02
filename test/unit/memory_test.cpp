#include <memory>
#include <cstdio>

#include "cppunit/cppunit_proxy.h"

#if !defined (STLPORT) || defined(_STLP_USE_NAMESPACES)
using namespace std;
#endif

//
// TestCase class
//
class MemoryTest : public CPPUNIT_NS::TestCase
{
  CPPUNIT_TEST_SUITE(MemoryTest);
#if defined (_STLP_MSVC) && (_STLP_MSVC < 1310)
  CPPUNIT_IGNORE;
#endif
  CPPUNIT_TEST(auto_ptr_test);
  CPPUNIT_TEST_SUITE_END();

protected:
  void auto_ptr_test();
};

CPPUNIT_TEST_SUITE_REGISTRATION(MemoryTest);

#if !defined (_STLP_MSVC) || (_STLP_MSVC >= 1310)
auto_ptr<int> CreateAutoPtr(int val)
{
  return auto_ptr<int>(new int(val));
}

bool CheckEquality(auto_ptr<int> pint, int val)
{ return *pint == val; }
#endif

//
// tests implementation
//
void MemoryTest::auto_ptr_test()
{
#if !defined (_STLP_MSVC) || (_STLP_MSVC >= 1310)
  {
    auto_ptr<int> pint(new int(1));
    CPPUNIT_CHECK( *pint == 1 );
    *pint = 2;
    CPPUNIT_CHECK( *pint == 2 );
  }

  {
    auto_ptr<int> pint0;
    CPPUNIT_CHECK(pint0.get() == 0);
    auto_ptr<int> pint1(new int(1));
    CPPUNIT_CHECK( *pint1 == 1 );
    auto_ptr<int> pint2(new int(2));
    CPPUNIT_CHECK( *pint2 == 2 );
    //printf("pint0:1:2 = %p:%p:%p\n", &*pint0, &*pint1, &*pint2);
    pint0 = pint1;
    CPPUNIT_CHECK( *pint0 == 1 );
    CPPUNIT_CHECK( pint1.get() == 0);
    pint2 = pint0;
    CPPUNIT_CHECK( *pint2 == 1 );
    CPPUNIT_CHECK( pint0.get() == 0);
    pint2.reset();
    CPPUNIT_CHECK( pint2.get() == 0);
    pint0 = auto_ptr<int>(new int(13));
    CPPUNIT_CHECK( *pint0 == 13 );
  }

  {
    auto_ptr<int> pint(CreateAutoPtr(3));
    CPPUNIT_CHECK( *pint == 3 );
    CPPUNIT_CHECK( CheckEquality(pint, 3) );
  }

  {
    auto_ptr<const int> pint(new int(2));
    CPPUNIT_CHECK( *pint == 2 );
  }
  {
    auto_ptr<volatile int> pint(new int(2));
    CPPUNIT_CHECK( *pint == 2 );
  }
  {
    auto_ptr<const volatile int> pint(new int(2));
    CPPUNIT_CHECK( *pint == 2 );
  }
#endif
}

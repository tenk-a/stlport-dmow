#ifndef SINGLE
//  An adapted ObjectSpace example for use with SGI STL

#include <vector.h>
#include <algo.h>
#include <iostream.h>
#include <stdlib.h>

#include "fadapter.h"

#ifdef MAIN 
#define genern1_test main
#endif
#endif


static int cxxrand() { return rand();}

int genern1_test(int, char**)
{
  cout<<"Results of genern1_test:"<<endl;

#ifndef __STL_MEMBER_POINTER_PARAM_BUG		//*TY 07/18/98 - added conditional
											// since ptr_gen() is not defined under this condition 
											// (see xfunction.h)
  vector <int> v1(10);

  generate_n(v1.begin(), v1.size(), ptr_gen(cxxrand));

  for(int i = 0; i < 10; i++)
    cout << v1[i] << ' ';
  cout << endl;
#endif	//	__STL_MEMBER_POINTER_PARAM_BUG	//*TY 07/18/98 - added

  return 0;
}

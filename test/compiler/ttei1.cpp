/*
 * It is known that this code not compiled by following compilers:
 *   gcc 2.95.3
 *   MSVC 6
 *   WATCOMC1.9
 *
 * It is known that this code compiled by following compilers:
 *   gcc 3.3.3
 *   gcc 3.4.1
 *   MSVC 8 Beta
 *   dmc 8.52
 */

struct A
{
  private:
    struct B
    {
        template <typename T>
        static void f( T& ) {}

        template <bool V>
        struct C
        {
            template <typename T>
            static void f( T& ) {}
        };
    };
};

template <> template <typename T>
void A::B::C<true>::f( T& ) {}


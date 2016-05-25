~~~ { .cpp }
#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

// Boost test main entry point

#define BOOST_TEST_MAIN

// Boost test module

#define BOOST_TEST_MODULE UnitTests

// Boost test includes

#include "boost/test/unit_test.hpp"


#include <iostream>

static struct DisableStdCoutBuffering
{
        DisableStdCoutBuffering()
        {
                std::cout.setf(std::ios_base::unitbuf);
        }
} s_disableStdCoutBuffering;

~~~

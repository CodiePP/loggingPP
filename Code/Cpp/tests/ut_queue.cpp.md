
// Copyright header

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * LoggingPP
 *
 * Copyright (c) 2013-2016 Alexander Diemand
 * All rights reserved.
 *
 * Author:     Alexander Diemand
 * Address:    Switzerland
 * Project:    Logging in C++
 *
 * Implemented features:
 * i)   runtime control of logging details
 * ii)  suppressing of identical log lines
 * iii) asynchronous and multi-threaded
 *
 * Repository: https://github.com/CodiePP
 * Date:       2013-10-31
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


// Boost link dynamically

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

// Boost test includes

#include "boost/test/unit_test.hpp"


#include "queue.hpp"
#include <boost/filesystem.hpp>

#include <iostream>
#include <fstream>

// Boost test start suite 'UT_Queue'

BOOST_AUTO_TEST_SUITE( UT_Queue )


// Boost test case 'enqueue'

BOOST_AUTO_TEST_CASE( enqueue )

{
    // namespace
    LPP::Q q;
    BOOST_CHECK( ! q.ready() );

    q.enqueue({ "1999-09-19 19:09:29.6789", "obj1", "intentionally left blank ..", "../src/test.cpp", 99, "this is a message"});
    BOOST_CHECK( q.ready() );

    // namespace
    LPP::LogData _d = q.dequeue();
    BOOST_CHECK_EQUAL( 99, _d.fline );
    BOOST_CHECK_EQUAL( "this is a message", _d.msg );
    BOOST_CHECK( ! q.ready() );
}

// Boost test case 'timing'

BOOST_AUTO_TEST_CASE( timing )

{
    // namespace
    LPP::Q q;
    BOOST_CHECK( ! q.ready() );

    for (int i=0; i<100000; i++)
        q.enqueue({ "1999-09-19 19:09:29.6789", "obj1", "intentionally left blank ..", "../src/test.cpp", i, "this is a message"});

    BOOST_CHECK( q.ready() );

    int _idx = 0;
    // namespace
    LPP::LogData _d;
//    q.dequeue(_d);
//    BOOST_CHECK_EQUAL( 0, _d.fline );
//    q.dequeue(_d);
//    BOOST_CHECK_EQUAL( 1, _d.fline );

    while (q.ready())
    {
        _d = q.dequeue();
        BOOST_CHECK_EQUAL( _d.fline, _idx );
        _idx += 1;
    }

    BOOST_CHECK( ! q.ready() );
}

// Boost test end suite

BOOST_AUTO_TEST_SUITE_END()



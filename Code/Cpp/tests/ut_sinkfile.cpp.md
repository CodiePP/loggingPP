
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


#include "loggingpp.hpp"
#include "queue.hpp"
#include "sinkfile.hpp"
#include <boost/filesystem.hpp>

// Boost test start suite 'UT_SinkFile'

BOOST_AUTO_TEST_SUITE( UT_SinkFile )


// Boost test case 'drop_duplicate_messages'

BOOST_AUTO_TEST_CASE( drop_duplicate_messages )

{
    // namespace
    LPP::SinkFile *s = new LPP::SinkFile(std::string("testfile.log"));
    BOOST_CHECK( s->ready() );
    std::string tstamp("1999-09-19 19:09:29.6789");
    s->log2sink({tstamp, "obj101", "_", "my_code.cpp", 324, "blabla"});
    for (int i = 0; i< 10000; i++)
    {
        s->log2sink({tstamp, "obj101", "_", "my_code.cpp", 324, "blabla"});
    }
    s->log2sink({tstamp, "obj102", "_", "my_code.cpp", 324, "blublu"});
    for (int i = 0; i< 10000; i++)
    {
        s->log2sink({tstamp, "obj101", "_", "my_code.cpp", 324, "blabla"});
    }
    for (int i = 0; i< 10000; i++)
    {
        s->log2sink({tstamp, "obj101", "_", "my_code.cpp", 324, "blublu"});
    }
    s->log2sink({tstamp, "obj102", "_", "my_code.cpp", 324, "blublu"});
    s->log2sink({tstamp, "obj102", "_", "my_code.cpp", 324, "elqelq"});
    s->log2sink({tstamp, "obj102", "_", "my_code.cpp", 324, "blublu"});
    delete s;

    // namespace
    LPP::LoggingPP::singleton()->flush();

    boost::filesystem::path _p("testfile.log");
    BOOST_CHECK( boost::filesystem::exists(_p) );

    BOOST_CHECK_EQUAL( 228UL, boost::filesystem::file_size(_p) );
}

// Boost test end suite

BOOST_AUTO_TEST_SUITE_END()



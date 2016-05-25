~~~ { .cpp }
#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"

#include <boost/chrono.hpp>
#include <boost/chrono/chrono_io.hpp>
#include <boost/chrono/thread_clock.hpp>
#include "loggingpp.hpp"
#include "sinkfile.hpp"
#include "mock_SinkFile.hpp"

#include <iostream>
#include <fstream>
~~~


~~~ { .cpp }
struct HeyMe {
    std::string name;
};

namespace LPP {

template<>
 const std::string LoggingPP::val2str(HeyMe & v) const;

}
~~~

## Test suite 'UT_LoggingPP'
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( UT_LoggingPP )
~~~


## Test case 'no_warning_because_below_error'
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( no_warning_because_below_error )
{
    std::shared_ptr< LPP::SinkImpl> _sink(new LPP::mock_SinkFile("something"));

    LPP::LoggingPP::singleton()->attachSink(std::make_shared<LPP::Sink>(_sink));
    
    LPP::LoggingPP::singleton()->setLogLevel(LPP::LoggingPP::LOG_LEVEL_ERROR);
    double obj = 3.14;
    const char msg[] = "no message";
    LPP_LOG_WARNING(obj, msg);

    LPP::LoggingPP::singleton()->flush();
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->queued(), 0 );
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->processed(), 0 );
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->logged(), 0 );
}
~~~

## Test case 'logging_some_class'
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( logging_some_class )
{
    std::shared_ptr<LPP::SinkImpl> _sink(new LPP::mock_SinkFile("something"));
    LPP::LoggingPP::singleton()->attachSink(std::make_shared<LPP::Sink>(_sink));
    
    LPP::LoggingPP::singleton()->setLogLevel(LPP::LoggingPP::LOG_LEVEL_INFO);
    HeyMe obj;
    obj.name="darling";
    const char msg[] = "it is me!!";
    LPP_LOG_WARNING(obj, msg);

    LPP::LoggingPP::singleton()->flush();
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->queued(), 0 );
    BOOST_CHECK(LPP::LoggingPP::singleton()->processed() >= 1 );
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->logged(), 1 );
}
~~~

## Test case 'logging_to_stream'
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( logging_to_stream )
{
    std::shared_ptr<LPP::SinkImpl> _sink(new LPP::mock_SinkFile("something"));
    LPP::LoggingPP::singleton()->attachSink(std::make_shared<LPP::Sink>(_sink));

    LPP::LoggingPP::singleton()->setLogLevel(LPP::LoggingPP::LOG_LEVEL_INFO);
    {
        HeyMe obj;
        obj.name="darling";
        const char *msg = "it is me!!";
        LPPLOG(LPP::LoggingPP::LOG_LEVEL_WARNING) <<
            "logged" << LPPVAR(obj) << LPPVAR(msg) << " number=" << 3.14f;
    }

    LPP::LoggingPP::singleton()->flush();
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->queued(), 0 );
    BOOST_CHECK(LPP::LoggingPP::singleton()->processed() >= 1 );
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->logged(), 1 );
}
~~~

## Test case 'time_to_log'
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( time_to_log )
{
    std::shared_ptr<LPP::SinkImpl>_sink(new LPP::mock_SinkFile("something"));
    LPP::LoggingPP::singleton()->attachSink(std::make_shared<LPP::Sink>(_sink));

    LPP::LoggingPP::singleton()->setLogLevel(LPP::LoggingPP::LOG_LEVEL_INFO);
    unsigned long obj=0xffee00;
    const char msg[] = "do not miss";
    const int n = 10000;
    boost::chrono::thread_clock::time_point t0 = boost::chrono::thread_clock::now();
    for (int i=1; i<=n; i++)
    {
        LPP_LOG_WARNING(obj, msg);
        obj += i;
    }
    LPP::LoggingPP::singleton()->flush();

    boost::chrono::thread_clock::time_point t1 = boost::chrono::thread_clock::now();
    std::ostringstream _ss;
    _ss << " time spent in the calling thread: " << (t1 - t0) / n << " per log message.";
    BOOST_TEST_MESSAGE( _ss.str() );
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->queued(), 0 );
    BOOST_CHECK(LPP::LoggingPP::singleton()->processed() >= 1 );
    _ss.str(""); _ss.clear();
    _ss << " processed: " << LPP::LoggingPP::singleton()->processed();
    BOOST_TEST_MESSAGE( _ss.str() );
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->logged(), n );
}
~~~

## Test case 'time_to_log2'
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( time_to_log2 )
{
    std::shared_ptr<LPP::SinkImpl> _sink(new LPP::mock_SinkFile("enormous"));

    LPP::LoggingPP::singleton()->attachSink(std::make_shared<LPP::Sink>(_sink));

    LPP::LoggingPP::singleton()->setLogLevel(LPP::LoggingPP::LOG_LEVEL_INFO);
    unsigned long obj=0xffee00;
    const char msg[] = "do not miss";
    const int n = 10;
    boost::chrono::thread_clock::time_point t0 = boost::chrono::thread_clock::now();
    for (int i=1; i<=n; i++)
    {
        LPPLOG(LPP::LoggingPP::LOG_LEVEL_WARNING) << LPPVAR(obj) << msg;
        obj += i;
    }
    LPP::LoggingPP::singleton()->flush();

    boost::chrono::thread_clock::time_point t1 = boost::chrono::thread_clock::now();
    std::ostringstream _ss;
    _ss << " time spent in the calling thread: " << (t1 - t0) / n << " per log message.";
    BOOST_TEST_MESSAGE( _ss.str() );
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->queued(), 0 );
    BOOST_CHECK(LPP::LoggingPP::singleton()->processed() >= 1 );
    BOOST_CHECK_EQUAL(LPP::LoggingPP::singleton()->logged(), n );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~


~~~ { .cpp }
// definition of specialization of val2str on struct HeyMe
namespace LPP {
template<>
const std::string LoggingPP::val2str(HeyMe & v) const
{
        return "HeyMe " + v.name;
}
} // namespace
~~~


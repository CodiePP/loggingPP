~~~ { .cpp }
#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "configuration.hpp"

#include <iostream>
#include <fstream>
#include "boost/thread.hpp"
#include "boost/date_time/posix_time/posix_time.hpp"
~~~

## Test suite UT_Configuration
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( UT_Configuration )
~~~

### test case 'get_value'
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_value )

{
    const std::string fp("/tmp/test_config1.cfg");
    std::ofstream fout;
    fout.open(fp);
    BOOST_CHECK(fout);
    fout << "[hello_world]" << std::endl;
    fout << "one = 1" << std::endl;
    fout << "two = 2" << std::endl;
    fout << "s1 = one" << std::endl;
    fout << "s2 = two" << std::endl;
    fout.close();

    std::shared_ptr<LPP::Configuration> _config(new LPP::Configuration(fp));
    int _v_i;
    BOOST_CHECK( _config->get("hello_world.one", _v_i) );
    BOOST_CHECK( _config->has("hello_world.one") );
    BOOST_CHECK( _config->has("hello_world.s1") );
    BOOST_CHECK( ! _config->has("hello_world.qioewjtr") );
}
~~~

### Test case 'reload_config'
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( reload_config )

{
        const std::string fp("/tmp/test_config2.cfg");
        {
            std::ofstream fout;
            fout.open(fp);
            BOOST_CHECK(fout);
            fout << "[first_part]" << std::endl;
            fout << "one = 1" << std::endl;
            fout << "two = 2" << std::endl;
            fout << "s1 = one" << std::endl;
            fout << "s2 = two" << std::endl;
            fout.close();
        }
        // namespace
        LPP::Configuration _config {fp};
        BOOST_CHECK( _config.has("first_part.one") );
        BOOST_CHECK(! _config.has("second_part.one") );
        boost::this_thread::sleep(boost::posix_time::milliseconds(1100));
        {
            std::ofstream fout;
            fout.open(fp, std::ios_base::app);
            BOOST_CHECK(fout);
            fout << "[second_part]" << std::endl;
            fout << "one = 1" << std::endl;
            fout << "two = 2" << std::endl;
            fout.flush();
            fout.close();
        }
        boost::this_thread::sleep(boost::posix_time::milliseconds(1100));

        BOOST_CHECK( _config.has("first_part.one") );
        BOOST_CHECK( _config.has("second_part.one") );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~


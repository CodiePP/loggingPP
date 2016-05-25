
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


#include "filewatcher.hpp"
#include "boost/filesystem.hpp"
#include "boost/date_time/posix_time/posix_time.hpp"

#include <iostream>
#include <sstream>
#include <fstream>

// Boost test start suite 'UT_FileWatcher'

BOOST_AUTO_TEST_SUITE( UT_FileWatcher )


class mockFileListener : public LPP::FileChangeListener
{
public:
        virtual void newFileEvent(const std::string d, const std::string fn) override { std::cout << "newFileEvent: " << fn << std::endl; _add++; }
        virtual void modFileEvent(const std::string d, const std::string fn) override { std::cout << "modFileEvent: " << fn << std::endl; _mod++; }
        virtual void delFileEvent(const std::string d, const std::string fn) override { std::cout << "delFileEvent: " << fn << std::endl; _del++; }
        int getAdd() const { return _add; }
        int getDel() const { return _del; }
        int getMod() const { return _mod; }
private:
        int _add = {0};
        int _del = {0};
        int _mod = {0};
};

// Boost test case 'newfile'

BOOST_AUTO_TEST_CASE( newfile )

{
        std::string fp;
        for (int i=0; ; i++)
        {
                std::stringstream _ss;
                _ss << "/tmp/test_newfile." << i;
                fp = _ss.str();
                if (! boost::filesystem::exists(fp)) 
                { 
                        boost::filesystem::create_directory(fp);
                        break;
                }
        }
        mockFileListener *_listener = new mockFileListener();
        // namespace
        LPP::FileWatcher _fw(fp, _listener);
        BOOST_CHECK_EQUAL( 0, _listener->getAdd() );
        BOOST_CHECK_EQUAL( 0, _listener->getDel() );
        BOOST_CHECK_EQUAL( 0, _listener->getMod() );

        std::ofstream of;
        of.open(fp + "/test1");
        of << "this is a test " ;
        of.close();

        boost::this_thread::sleep(boost::posix_time::milliseconds(200));

        BOOST_CHECK_EQUAL( 1, _listener->getAdd() );
        BOOST_CHECK_EQUAL( 0, _listener->getDel() );
        BOOST_CHECK_EQUAL( 1, _listener->getMod() );
}

// Boost test case 'delfile'

BOOST_AUTO_TEST_CASE( delfile )

{
        std::string fp;
        for (int i=0; ; i++)
        {
                std::stringstream _ss;
                _ss << "/tmp/test_newfile." << i;
                fp = _ss.str();
                if (! boost::filesystem::exists(fp)) 
                { 
                        boost::filesystem::create_directory(fp);
                        break;
                }
        }
        std::ofstream of;
        of.open(fp + "/test1");
        of << "this is a test " ;
        of.close();

        mockFileListener *_listener = new mockFileListener();
        // namespace
        LPP::FileWatcher _fw(fp, _listener);
        BOOST_CHECK_EQUAL( 0, _listener->getAdd() );
        BOOST_CHECK_EQUAL( 0, _listener->getDel() );
        BOOST_CHECK_EQUAL( 0, _listener->getMod() );

        boost::filesystem::remove(fp + "/test1");

        boost::this_thread::sleep(boost::posix_time::milliseconds(100));

        BOOST_CHECK_EQUAL( 0, _listener->getAdd() );
        BOOST_CHECK_EQUAL( 1, _listener->getDel() );
        BOOST_CHECK_EQUAL( 0, _listener->getMod() );
}

// Boost test case 'modfile'

BOOST_AUTO_TEST_CASE( modfile )

{
        std::string fp;
        for (int i=0; ; i++)
        {
                std::stringstream _ss;
                _ss << "/tmp/test_newfile." << i;
                fp = _ss.str();
                if (! boost::filesystem::exists(fp)) 
                { 
                        boost::filesystem::create_directory(fp);
                        break;
                }
        }
        std::ofstream of;
        of.open(fp + "/test1");
        of << "this is a test " ;
        of.close();

        mockFileListener *_listener = new mockFileListener();
        // namespace
        LPP::FileWatcher _fw(fp, _listener);
        BOOST_CHECK_EQUAL( 0, _listener->getAdd() );
        BOOST_CHECK_EQUAL( 0, _listener->getDel() );
        BOOST_CHECK_EQUAL( 0, _listener->getMod() );

        of.open(fp + "/test1", std::ios_base::app);
        of << "; this is another test." ;
        of.close();

        boost::this_thread::sleep(boost::posix_time::milliseconds(100));

        BOOST_CHECK_EQUAL( 0, _listener->getAdd() );
        BOOST_CHECK_EQUAL( 0, _listener->getDel() );
        BOOST_CHECK_EQUAL( 1, _listener->getMod() );
}

// Boost test end suite

BOOST_AUTO_TEST_SUITE_END()



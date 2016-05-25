~~~ { .cpp }
#pragma once


#include "sink.hpp"
#include <string>
#include <memory>
#include <iostream>
#include <sstream>

extern "C" const char * _local_filename(const char *);
~~~

namespace LPP {

# class LoggingPP final
{
public:

>[LoggingPP](loggingpp.cpp.md) (); 

>virtual [~LoggingPP](loggingpp.cpp.md)(); 

>LoggingPP (const LoggingPP &) = delete; 

>enum loglevel { LOG_LEVEL_ERROR=0, LOG_LEVEL_WARNING, LOG_LEVEL_INFO, LOG_LEVEL_DEBUG };

>static std::shared_ptr\\< LoggingPP \\> singleton();
        
~~~ { .cpp }
#define _stringize(a) #a

#define LPP_LOG_ERROR(obj, m)  LPP ::LoggingPP::singleton()->log_level( LPP ::LoggingPP::LOG_LEVEL_ERROR,\\
_stringize(obj),  LPP::LoggingPP::singleton()->val2str(obj),  _local_filename(__FILE__), __LINE__, m)

#define LPP_LOG_WARNING(obj, m)  LPP ::LoggingPP::singleton()->log_level( LPP ::LoggingPP::LOG_LEVEL_WARNING,\\
_stringize(obj),  LPP::LoggingPP::singleton()->val2str(obj),  _local_filename(__FILE__), __LINE__, m)

#define LPP_LOG_INFO(obj, m)  LPP ::LoggingPP::singleton()->log_level( LPP ::LoggingPP::LOG_LEVEL_INFO,\\
_stringize(obj),  LPP::LoggingPP::singleton()->val2str(obj),  _local_filename(__FILE__), __LINE__, m)

#define LPPLOG(lvl) (std::make_shared< LPP ::_log_entry>(lvl, __FILE__, __LINE__))->getStream()

#define LPPLOGIF(lvl, cond)  if ( (cond) ) \\
                LPPLOG(lvl)

#define LPPVAR(v) (" " + std::string(#v) + "[" +  LPP::LoggingPP::singleton()->val2str(v) + "]")
~~~
        
public:
        
>void [log_level](loggingpp.cpp.md)(const LoggingPP::loglevel lvl, const std::string objname, const std::string objval, 
                       const std::string fname, const int fline, const std::string m);
        
>void setLogLevel(const loglevel l) { _curr_log_level = l; }

>loglevel getLogLevel() const { return _curr_log_level; }
        
>void [flush](loggingpp.cpp.md)() const;
        
>unsigned long [queued](loggingpp.cpp.md)() const;

>unsigned long [processed](loggingpp.cpp.md)() const;

>unsigned long [logged](loggingpp.cpp.md)() const;
        
>void [attachSink](loggingpp.cpp.md)(const std::shared_ptr\\<Sink\\> p_sink);
        
>const std::string [val2str](loggingpp.cpp.md)(const char* &v) const;

>const std::string [val2str](loggingpp.cpp.md)(const std::string &v) const;

>template\\<typename T\\>
         const std::string [val2str](loggingpp.cpp.md)(T & v) const;
        
private:

>loglevel _curr_log_level;

>struct pimpl;

>std::unique_ptr\\<struct pimpl\\> _pimpl;

~~~ { .cpp }
};
~~~

# struct _log_entry

~~~ { .cpp }
{
        explicit _log_entry(const LoggingPP::loglevel lvl, const char *_f, int _ln);
        ~_log_entry();
        std::ostream & getStream() { return sstr; }
        private:
        LoggingPP::loglevel lvl; const std::string fn; int ln;
        std::ostringstream sstr;
};
~~~


~~~ { .cpp }
} // namespace
~~~


~~~ { .cpp }
#pragma once


#include <string>
#include <iostream>

namespace LPP {
~~~

# struct LogData
~~~ { .cpp }
{
    public:
        LogData() : valid(false)
        {}

        LogData(std::string s1,std::string s2,std::string s3,std::string s4,int i5,std::string s6)
            :  tstamp(s1)
               ,  objname(s2)
               ,  objvalue(s3)
               ,  fname(s4)
               ,  fline(i5)
               ,  msg(s6)
               ,  valid(true)
        {}

        std::string  tstamp;
        std::string  objname;
        std::string  objvalue;
        std::string  fname;
        int fline;
        std::string  msg;
        bool valid = false;


        const  std::string  hash() const;
        friend std::ostream & operator<<(std::ostream &, const LogData &);
};
~~~

~~~ { .cpp }
} // namespace
~~~


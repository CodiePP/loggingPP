~~~ { .cpp }
#include "sink.hpp"

#include <iostream>
#include <fstream>

namespace LPP
{

class mock_SinkFile : public SinkImpl
{
    public:
        mock_SinkFile(const std::string & fn) : SinkImpl(), _fn(fn) {}

        virtual bool ready() const override { return true; }
        virtual bool busy() const override { return false; }
        virtual void log2sink(LogData _d) const override
            { log2sink(_d.tstamp, _d.objname, _d.objvalue, _d.fname, _d.fline, _d.msg); }
        virtual void log2sink(const std::string time, const std::string obj,
            const std::string oval, const std::string fname,
            const int line, const std::string m) const override
            { ((mock_SinkFile*)(this))->incr(); }

    private:
        std::string _fn;
        void incr() { counter += 1; }
        volatile int counter { 0 };
};

} // namespace
~~~

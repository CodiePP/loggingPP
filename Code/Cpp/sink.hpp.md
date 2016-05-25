---
layout: default
---

~~~ { .cpp }
#pragma once


#include "logdata.hpp"
#include <string>
#include <memory>

namespace  LPP 
{
~~~

# class SinkImpl
{

public:

>virtual bool busy() const = 0;

>virtual bool ready() const = 0;

>virtual void log2sink(LogData) const = 0;

>virtual void log2sink(const std::string time, const std::string obj, const std::string oval, const std::string fname, const int line, const std::string m) const = 0;

};


# class Sink
{

public:

>[Sink](sink.cpp.md) ( std::shared_ptr\\<SinkImpl\\> & ); 

>virtual [~Sink](sink.cpp.md)(); 

>void [log2sink](sink.cpp.md)(LogData);

>bool [busy](sink.cpp.md)() const;

>bool [ready](sink.cpp.md)() const;

>unsigned long [processed](sink.cpp.md)() const;

private:

>struct pimpl; // forward

>std::unique_ptr\\<struct pimpl\\> _pimpl; // the instance

};


} // namespace


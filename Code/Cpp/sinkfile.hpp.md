---
layout: default
---
~~~ { .cpp }
#pragma once


#include "sink.hpp"
#include <string>

namespace  LPP 
{
~~~

# class SinkFile : public [SinkImpl](sink.hpp.md)

{

public:

>SinkFile(const std::string&);

>virtual ~SinkFile(); 

>virtual bool busy() const override;
        
>virtual bool ready() const override;
        
>virtual void log2sink(const LogData) const override;

>virtual void log2sink(const std::string time, const std::string obj, 
              const std::string oval, const std::string fname,
              const int line, const std::string m) const override;
        
private:

>       struct pimpl; // forward

>       std::unique_ptr<struct pimpl> _pimpl; // the instance
        
};


} // namespace


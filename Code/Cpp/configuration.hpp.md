
~~~ { .cpp }
#pragma once

#include <string>
#include <memory>

namespace  LPP 
{
~~~

# class Configuration final
{
public:

>explicit [Configuration](configuration.cpp.md)(const std::string & p);

>virtual [~Configuration](configuration.cpp.md)();

        //static std::shared_ptr<Configuration> singleton(const std::string & confpath = "");

>template \\<typename T\\>
     bool get(const std::string & k, T & r) const;

>bool has(const std::string & k) const;

private:

>class pimpl;
        std::unique_ptr\\<pimpl\\> _pimpl;

}; // class

} // namespace

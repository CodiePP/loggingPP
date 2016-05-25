~~~ { .cpp }
#pragma once

#include <string>
#include <memory>

namespace  LPP 
{
~~~

# class FileChangeListener
{

public:

>virtual void fileChangedEvent(const std::string p) = 0;

};

# class FileWatcher final
{

public:

>[FileWatcher](filewatcher.cpp.md)(const std::string & p, FileChangeListener*);

>[~FileWatcher](filewatcher.cpp.md)();

private:

>       struct pimpl;
        std::unique_ptr\\<pimpl\\> _pimpl;

~~~ { .cpp }
}; // class

} // namespace
~~~


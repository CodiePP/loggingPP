---
layout: default
---

~~~ { .cpp }
#pragma once


#include "loggingpp.hpp"
#include "logdata.hpp"
#include <string>
#include <memory>

namespace  LPP 
{
~~~

# class Q

{

public:

>[Q](queue.cpp.md) (); 

>virtual [~Q](queue.cpp.md)(); 

>void [enqueue](queue.cpp.md)(const LogData tolog);
        
>LogData [dequeue](queue.cpp.md)();
        
>bool [ready](queue.cpp.md)() const;
        
>unsigned long [queued](queue.cpp.md)() const;

>unsigned long [processed](queue.cpp.md)() const;
        
private:

>struct pimpl; // forward

>std::unique_ptr\\<struct pimpl\\> _pimpl; // the instance
        
Q (const Q &) = delete; 

~~~ { .cpp }
};

} // namespace
~~~


---
layout: default
---

~~~ { .cpp }
#pragma once


#include <boost/thread.hpp>
#include <boost/asio.hpp>

#include <string>
#include <memory>

namespace  LPP 
{
~~~

# class ThreadPool final

{

public:

>    explicit [ThreadPool](threadpool.cpp.md)(int n_threads);

>    virtual ~[ThreadPool](threadpool.cpp.md)();

~~~ { .cpp }
private:
    ThreadPool();
    ThreadPool(const ThreadPool &) = delete;
    ThreadPool & operator=(const ThreadPool &) = delete;

private:
    boost::asio::io_service _service;
    std::unique_ptr<boost::asio::io_service::work> _working;
    boost::thread_group _threads;

public:
    template<class F>
    void enqueue(const F & f)
    {
         _service.post(f);
    }

}; // class

} // namespace
~~~

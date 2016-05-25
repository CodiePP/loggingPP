---
layout: default
---

declared in [threadpool](threadpool.hpp.md]

#ctor
sets up the boost asio service and creates the desired number of worker threads
~~~ { .cpp }
ThreadPool::ThreadPool(int n_threads)
    : _service()
{
    _working.reset(new boost::asio::io_service::work(_service));
    for (int i=0; i<n_threads; i++)
    {
        _threads.create_thread(boost::bind(&boost::asio::io_service::run, &_service));
    }
}
~~~

## dtor 
stops all threads and closes the boost asio service
~~~ { .cpp }
ThreadPool::~ThreadPool()
{
    std::clog << "stopping thread pool!" << std::endl;
    _service.stop();
    _threads.join_all();
    _working.reset();
}
~~~


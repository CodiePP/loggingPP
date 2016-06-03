
~~~ { .cpp }

struct FileWatcher::pimpl {
        std::string _path;
        FileChangeListener *_listener {nullptr};
        boost::thread *_thr;
        std::time_t _wlast { 0L };

        void run() throw();
};

void FileWatcher::pimpl::run() throw()
{
    try {
        while (true) {
            if (_listener && !_path.empty()) {
                std::time_t _wtime = boost::filesystem::last_write_time(_path);
                //std::clog << "   " << _path << "  time = " << _wtime << " =?= " << _wlast << std::endl;
                if (_wtime > _wlast) {
                    _wlast = _wtime;
                    _listener->fileChangedEvent(_path);
                }
            }

            boost::this_thread::sleep(boost::posix_time::milliseconds(1000));
        }
    } catch (...) {
        std::clog << " ending .. " << std::endl;
    }
}

FileWatcher::FileWatcher(const std::string & p, FileChangeListener *listener)
{
    //std::clog << "new FileWatcher on " << p << std::endl;
    _pimpl.reset(new FileWatcher::pimpl());
    _pimpl->_wlast = boost::filesystem::last_write_time(p);
    _pimpl->_path = p;
    _pimpl->_listener = listener;
    _pimpl->_thr = new boost::thread(boost::bind(&FileWatcher::pimpl::run, _pimpl.get()));
}

FileWatcher::~FileWatcher()
{
        _pimpl->_thr->interrupt();
        _pimpl->_thr->try_join_for(boost::chrono::milliseconds(100));
        _pimpl->_thr->join();
}
~~~

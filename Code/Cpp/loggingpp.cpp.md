~~~ { .cpp }
        _log_entry::_log_entry(LoggingPP::loglevel p_lvl, const char *p_fname, int p_lnum)
                : lvl(p_lvl), fn(p_fname), ln(p_lnum)
        { }
        _log_entry::~_log_entry()
        {
                if (LoggingPP::singleton()->getLogLevel() < lvl) { return; }
                if (sstr.good())
                {
                        std::string _m = sstr.str();
                        LoggingPP::singleton()->log_level(lvl, "LOG", "-", fn, ln, _m);
                }
        }
~~~

~~~ { .cpp }
        struct LoggingPP::pimpl
        {
            pimpl()
            {
                _queue.reset(new Q());
                std::string cfp = "LoggingPP.conf"; 
                for (char *ecfp = getenv("LOGGINGSERVER_CONF"); ecfp; ecfp = NULL) { cfp = ecfp; }
                _config.reset(new Configuration(cfp));
                int n_thr = 1;
                if (_config->has("LoggingPP.NumThreads"))
                {
                        _config->get("LoggingPP.NumThreads", n_thr);
                        if (n_thr < 1 || n_thr > 4)
                        {
                                n_thr = 1;
                        }
                }
                _pool.reset(new ThreadPool(n_thr));  // the number of threads that work through the queued log entries
                _thr.reset(new boost::thread(boost::bind(&LoggingPP::pimpl::run, this)));
            }

            ~pimpl()
            {
                _pool.reset(); // stop thread pool

                _thr->try_join_for(boost::chrono::milliseconds(300));
                _thr->interrupt();
                _thr->join();
                _thr.reset();

                _sink.reset();
                _queue.reset();
            }

            void run()
            {
                int sleep_time = 12;
                _config->get("LoggingPP.SleepTime", sleep_time);
                while (true)
                {
                    if (_sink && _sink->ready())
                    {
                        while (_queue->ready())
                        {
                            _pool->enqueue(boost::bind(& LPP ::Sink::log2sink, _sink.get(), _queue->dequeue()));
                            boost::this_thread::yield();
                        }
                    } else {
                        std::clog << "sink not ready!!" << std::endl;
                    }
                    boost::this_thread::sleep(boost::posix_time::milliseconds(sleep_time));
                }
            }
            std::unique_ptr<boost::thread> _thr;
            std::unique_ptr<Configuration> _config;
            std::unique_ptr< LPP ::ThreadPool> _pool;
            std::shared_ptr< LPP ::Sink> _sink;
            std::shared_ptr< LPP ::Q> _queue;
            boost::mutex _sebiglogg;
        }; // struct pimpl
~~~
        
~~~ { .cpp }
        LoggingPP::LoggingPP()
            :  _curr_log_level(LOG_LEVEL_ERROR)
        {
            std::clog << "new LoggingPP" << std::endl;
            _pimpl.reset(new LoggingPP::pimpl());
        }
        
        LoggingPP::~LoggingPP()
        {
            //dtor
        }
        
        std::shared_ptr<LoggingPP> LoggingPP::singleton()
        {
            static std::shared_ptr<LoggingPP> _singleton(new LoggingPP());
            return _singleton;
        }
        
        void LoggingPP::flush() const
        {
            while (_pimpl->_queue->ready())
            {
                boost::this_thread::sleep(boost::posix_time::milliseconds(20));
            }
            std::clog << "  queue is finally empty!" << std::endl;
            if (_pimpl->_sink) {
                while (_pimpl->_sink->busy())
                {
                    boost::this_thread::sleep(boost::posix_time::milliseconds(20));
                }
                std::clog << "  sink's sunk!" << std::endl;
            }
        }
        
        unsigned long LoggingPP::queued() const
        {
            return _pimpl->_queue->queued();
        }
        
        unsigned long LoggingPP::processed() const
        {
            return _pimpl->_queue->processed();
        }
        
        unsigned long LoggingPP::logged() const
        {
            if (_pimpl->_sink) {
                return _pimpl->_sink->processed(); }
            return 0UL;
        }
        
        void LoggingPP::attachSink(const std::shared_ptr<Sink> p_sink)
        {
            _pimpl->_sink = p_sink;
        }
        
        void LoggingPP::log_level(const loglevel l, const std::string obj, const std::string oval, const std::string fname, const int line, const std::string m)
        {
            if (!_pimpl->_sink) { return; }
            if (_curr_log_level < l) { return; }

            // make timestamp now!
            time_t _t = time(NULL);
            const int tlen = 64;
            char tbuf[tlen];
            struct tm _tm;
            localtime_r(&_t, &_tm);
            struct timeval _tv;
            gettimeofday(&_tv, NULL);
            strftime(tbuf, tlen, "%Y%m%d@%H:%M:%S", &_tm);
            tbuf[17] = '.';
            snprintf(tbuf+18, 4, "%03d", (int)(_tv.tv_usec/1000L));

            LogData _d;
            _d.fline=line;
            _d.fname=fname;
            _d.msg = m;
            _d.objname = obj;
            _d.objvalue = oval;
            _d.tstamp = tbuf;
            _d.valid = true;
            _pimpl->_queue->enqueue(_d);
        }
        
        template<typename T>
        const std::string LoggingPP::val2str(T & v) const
        {
                std::stringstream _ss;
                _ss << v;
                return (_ss.str());
        }

        template const std::string LoggingPP::val2str(unsigned int & v) const;
        template const std::string LoggingPP::val2str(int & v) const;
        template const std::string LoggingPP::val2str(unsigned long & v) const;
        template const std::string LoggingPP::val2str(long & v) const;
        template const std::string LoggingPP::val2str(float & v) const;
        template const std::string LoggingPP::val2str(double & v) const;
        template const std::string LoggingPP::val2str(bool & v) const;

        const std::string LoggingPP::val2str(const char* &v) const
        {
            return v;
        }

        const std::string LoggingPP::val2str(const std::string &v) const
        {
            return v;
        }
        

extern "C"
const char * _local_filename(const char *fp)
{
        char * p = (char*)strrchr(fp, '/');
        if (!p) { return fp; }
        return (p+1);
}
~~~


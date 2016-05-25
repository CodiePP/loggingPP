---
layout: default
---

## private implementation
~~~ { .cpp }
        struct Q::pimpl
        {
            boost::mutex _sebiglogg;
            typedef std::queue<LogData> _qtype;
            _qtype _msgqueue;
            unsigned long _nproc { 0UL };
        };
~~~
        

## ctor / dtor
~~~ { .cpp }
        Q::Q()
        {
            _pimpl.reset(new Q::pimpl());
        }
        
        Q::~Q()
        { }
~~~

## ready
~~~ { .cpp }
        bool Q::ready() const
        {
                return (_pimpl->_msgqueue.size() > 0);
        }
~~~

## queued
~~~ { .cpp }
        unsigned long Q::queued() const
        {
                return _pimpl->_msgqueue.size();
        }
~~~

## processed
~~~ { .cpp }
        unsigned long Q::processed() const
        {
                return _pimpl->_nproc;
        }
~~~

## enqueue
~~~ { .cpp }
        void Q::enqueue(const LogData tolog)
        {
            if (!tolog.valid) { return; }

            boost::lock_guard<boost::mutex> _lock(_pimpl->_sebiglogg);

                _pimpl->_msgqueue.push(tolog);
        }
~~~

## dequeue
~~~ { .cpp }
        LogData Q::dequeue()
        {
            boost::lock_guard<boost::mutex> _lock(_pimpl->_sebiglogg);

            if (!ready()) { return LogData(); }

                LogData tolog = _pimpl->_msgqueue.front();
                _pimpl->_msgqueue.pop();
                _pimpl->_nproc++;
                return tolog;
        }
~~~

~~~ { .cpp }
        const std::string LogData::hash() const
        {
            std::stringstream _ss;
            _ss << fname << ":" << fline << " " << objname << ":" << objvalue << ":" << msg;
            std::string msg = _ss.str();

            if (msg.empty()) { return ""; }
            const char *m = msg.c_str();
            int _mlen = msg.length();
            unsigned char _td[MD5_DIGEST_LENGTH+1];
            unsigned char *_md5msg = MD5((const unsigned char*)m, _mlen, _td);
            _td[MD5_DIGEST_LENGTH] = '\0';
            char _buf[MD5_DIGEST_LENGTH * 2 + 1];
            for (int i=0; i<MD5_DIGEST_LENGTH; i++)
            {
                char _c = (char)(_td[i] >> 4) & 0x0f;
                if (_c > 9)
                {
                    _buf[i*2] = _c + 'A' - 10;
                } else {
                    _buf[i*2] = _c + '0';
                }
                _c = (char)_td[i] & 0x0f;
                if (_c > 9)
                {
                    _buf[i*2+1] = _c + 'A' - 10;
                } else {
                    _buf[i*2+1] = _c + '0';
                }
            }
            return std::string(_buf, 128/8*2);
        }
        
        std::ostream & operator<<(std::ostream & o, const LogData & d)
        {
                o << d.fname << "@" << d.fline << " " << d.objname << "=" << d.objvalue << " : " << d.msg;
                return o;
        }
~~~

---
layout: default
---

~~~ { .cpp }
// Implementation of methods of class Sink

struct Sink::pimpl
{
    pimpl(std::shared_ptr<SinkImpl> & p_snk) : snk(p_snk) {}
    const std::string md5msg(const std::string) const;

    std::shared_ptr<SinkImpl> snk;
    boost::mutex _sebiglogg;
    typedef std::map<const std::string, unsigned long> _maptype;
    _maptype _msgmap;
    unsigned long _nproc { 0UL };
    bool _unavailable { false };
};

Sink::Sink(std::shared_ptr<SinkImpl> & p_snk)
{
    _pimpl.reset(new Sink::pimpl(p_snk));
}

Sink::~Sink()
{
    _pimpl->_unavailable = true;

    if (_pimpl) {
        std::clog << "~Sink " << _pimpl->_nproc << std::endl; }
    if (_pimpl->snk) {
        boost::lock_guard<boost::mutex> _lock(_pimpl->_sebiglogg);
        // wait for all data flushed
    }
}
~~~

~~~ { .cpp }
bool Sink::busy() const
{
    return _pimpl->snk->busy();
}

bool Sink::ready() const
{
    if (_pimpl->_unavailable) { return false; }
    return _pimpl->snk->ready();
}

unsigned long Sink::processed() const
{
    return _pimpl->_nproc;
}

void Sink::log2sink(LogData _d)
{
    if (! _d.valid) { return; }

    if (! ready()) { return; }

    boost::lock_guard<boost::mutex> _lock(_pimpl->_sebiglogg);

    const std::string _h(_d.hash());

    time_t _t = time(NULL);

    // test if in map
    pimpl::_maptype::const_iterator _entry = _pimpl->_msgmap.find(_h);
    if (_entry != _pimpl->_msgmap.end())
    {
        // test if older than x seconds
        if ((*_entry).second > (_t - MSG_RETENTION_TIME))
        {
            std::cout << "found near hit: " << _h << "@" << (*_entry).second << std::endl;
            return; // its too near
        }
    } else {
        //std::cout << "storing: " << _h << " for " << _d << std::endl;
        _pimpl->_msgmap[_h] = (unsigned long)_t;
    }

    _pimpl->_nproc++;
    _pimpl->snk->log2sink(_d.tstamp, _d.objname, _d.objvalue, _d.fname, _d.fline, _d.msg); // reimplemented by subclasses
}
~~~

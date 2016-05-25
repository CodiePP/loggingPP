---
layout: default
---

~~~ { .cpp }
struct SinkFile::pimpl
{
    std::string _outpath;
    FILE * _outfile;
    boost::mutex _sebiglogg;
    bool _busy { false };
};

SinkFile::SinkFile(const std::string & fp)
{
    _pimpl.reset(new SinkFile::pimpl());
    _pimpl->_outpath = fp;
    _pimpl->_outfile = fopen(fp.c_str(), "w");
}

SinkFile::~SinkFile()
{
    if (_pimpl->_outfile)
    {
        fclose(_pimpl->_outfile);
    }
}

void SinkFile::log2sink(const LogData d) const
{
    if (d.valid) {
        log2sink(d.tstamp, d.objname, d.objvalue, d.fname, d.fline, d.msg); }
}

void SinkFile::log2sink(const std::string time, const std::string objname, const std::string oval, const std::string fname, const int line, const std::string m) const
{
    if (_pimpl->_outfile)
    {
        _pimpl->_busy = true;
        boost::lock_guard<boost::mutex> _lock(_pimpl->_sebiglogg);
        fputs(time.c_str(), _pimpl->_outfile);
        fputs("|", _pimpl->_outfile);
        // objname
        fputs(objname.c_str(), _pimpl->_outfile);
        fputs(":", _pimpl->_outfile);
        // obj value
        fputs(oval.c_str(), _pimpl->_outfile);
        fputs("|", _pimpl->_outfile);
        // fname/line
        {
            std::stringstream _ss;
            _ss << fname << ":" << line << "|";
            fputs(_ss.str().c_str(), _pimpl->_outfile);
        }
        // message
        fputs(m.c_str(), _pimpl->_outfile);
        fputs("\n", _pimpl->_outfile);
        _pimpl->_busy = false;
    }
}

bool SinkFile::busy() const
{
    return _pimpl->_busy;
}

bool SinkFile::ready() const
{
    return _pimpl->_outfile && !feof(_pimpl->_outfile);
}
~~~


---
layout: default
---

~~~ { .cpp }

class Configuration::pimpl : public FileChangeListener
{
public:
        std::string _confpath;
        boost::mutex _sebiglogg;
        boost::property_tree::ptree _prefs;
        std::unique_ptr<FileWatcher> _fw;

        virtual void fileChangedEvent(const std::string p) override { reload(); }
        virtual void reload();
};


Configuration::Configuration(const std::string & p)
{
        _pimpl.reset(new Configuration::pimpl());
        _pimpl->_confpath = p;
        _pimpl->_fw.reset(new FileWatcher(p, _pimpl.get()));
        _pimpl->reload();
}

Configuration::~Configuration()
{ }


//std::shared_ptr<Configuration> Configuration::singleton(const std::string & p_confpath)
//{
//    static std::shared_ptr<Configuration> _singleton(new Configuration(p_confpath));
//    return _singleton;
//}

void Configuration::pimpl::reload()
{
    boost::lock_guard<boost::mutex> _lock(_sebiglogg);

    try
    {
        boost::property_tree::ini_parser::read_ini(_confpath, _prefs);
        std::cout << "reload config file: " << _confpath << std::endl;
    } catch (std::exception & e) {
        std::cerr << "failed to load config file: " << e.what() << std::endl;
        std::cerr << "   maybe set env var: LOGGINGSERVER_CONF" << std::endl;
    }
}

bool Configuration::has(const std::string & k) const
{
    boost::lock_guard<boost::mutex> _lock(_pimpl->_sebiglogg);
    // find key
    try
    {
                std::string val = _pimpl->_prefs.get<std::string>(k);
    } catch (...) {
        return false;
    }
    return true;
}

template<typename T>
bool Configuration::get(const std::string & k, T & val) const
{
    boost::lock_guard<boost::mutex> _lock(_pimpl->_sebiglogg);
        T old_value = val;
        try
        {
                // get option's value
                val = _pimpl->_prefs.get<T>(k);
                return true;
        } catch (...) {
                // restore old value
                val = old_value;
        }
        return false;
}

template bool Configuration::get(const std::string &, bool &) const;
template bool Configuration::get(const std::string &, int &) const;
template bool Configuration::get(const std::string &, long &) const;
template bool Configuration::get(const std::string &, double &) const;
template bool Configuration::get(const std::string &, std::string &) const;
~~~

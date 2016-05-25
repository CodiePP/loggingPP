---
layout: default
---

~~~ { .cpp }
#include "sink.hpp"
#include "queue.hpp"

#include "boost/thread/mutex.hpp"
#include "boost/thread/lock_guard.hpp"

#include <map>
#include <iostream>
#include <string>
#include <sstream>
#include <cstring>
#include <ctime>

namespace  LPP 
{

// time in seconds to prevent another message of same signature to be output
#define MSG_RETENTION_TIME 60UL

~~~

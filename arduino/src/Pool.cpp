#include "Pool.h"

Pool::Pool(unsigned long duration, void (*onExecute)()) : duration(duration), onExecute(onExecute)
{
    _lastExecute = millis();
};

void Pool::loop()
{
    _now = millis();

    if (_now > _lastExecute + duration)
    {
        onExecute();
        _lastExecute = _now;
    }
}
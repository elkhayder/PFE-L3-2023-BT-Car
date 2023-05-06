#ifndef _POOL_H
#define _POOL_H

#include <Arduino.h>

class Pool
{
public:
    unsigned long duration;

    Pool(unsigned long duration, void (*onExecute)());

    void loop();

private:
    void (*onExecute)();
    unsigned long _lastExecute;
    unsigned long _now;
};

#endif
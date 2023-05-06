#ifndef _LM293_H
#define _LM293_H

#include <Arduino.h>
#include "Wheel.h"

class LM293 {
  public:
    static int HolesCount;

    uint8_t pin;

    long startTime = 0;
    bool prevState = false;
    bool isCounting = false;
    int count = 0;

    double rps;
    double speedKmH;

    LM293(uint8_t p);

    void setup();
    void measure();
};

#endif

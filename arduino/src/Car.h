#ifndef _CAR_H
#define _CAR_H

#include <Arduino.h>

#include "Wheel.h"

class Car
{
public:
    static uint8_t MaxVelocity;
    static uint8_t SpeedCoefficient;

    Wheel *frontRight, *frontLeft, *backRight, *backLeft;

    Car(int, int, int, int, int, int, int, int, int, int, int, int);
    ~Car();

    void setup();
    void goForward();
    void goBackward();
    void brake();
    void goLeft();
    void goRight();

    void goForwardRight();
    void goForwardLeft();
    void goBackwardRight();
    void goBackwardLeft();
};

#endif

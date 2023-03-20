#ifndef _CAR_H
#define _CAR_H

#include <Arduino.h>

#include "Wheel.h"

class Car {
public:
    static uint8_t Velocity;
    static uint8_t SpeedCoefficient;
    
    Wheel *frontRight, *frontLeft, *backRight, *backLeft;

    Car(int, int, int, int, int, int, int, int, int, int, int, int);
    ~Car();
    
    void setup();
    void goAhead();
    void goBack();
    void brake();
    void goLeft();
    void goRight();
    
    void goAheadRight();
    void goAheadLeft();
    void goBackRight();
    void goBackLeft();
};

#endif

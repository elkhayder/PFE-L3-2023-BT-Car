#include "Car.h"

Car::Car(
    // Input1, Input2, Enable
    int fr1, int fr2, int frE, // Front Right
    int br1, int br2, int brE, // Back Right
    int fl1, int fl2, int flE, // Front Left
    int bl1, int bl2, int blE  // Back Left
)
{
  frontRight = new Wheel(fr1, fr2, frE);
  backRight = new Wheel(br1, br2, brE);
  frontLeft = new Wheel(fl1, fl2, flE);
  backLeft = new Wheel(bl1, bl2, blE);
}

Car::~Car()
{
  delete frontRight;
  delete backRight;
  delete frontLeft;
  delete backLeft;
}

uint8_t Car::MaxVelocity = 100;
uint8_t Car::SpeedCoefficient = 4;

void Car::setup()
{
  frontRight->setup();
  backRight->setup();
  frontLeft->setup();
  backLeft->setup();
}

void Car::brake()
{
  frontRight->brake();
  backRight->brake();
  frontLeft->brake();
  backLeft->brake();
}

void Car::goForward()
{
  frontRight->forward(MaxVelocity);
  backRight->forward(MaxVelocity);
  frontLeft->forward(MaxVelocity);
  backLeft->forward(MaxVelocity);
}

void Car::goBackward()
{
  frontRight->backward(MaxVelocity);
  backRight->backward(MaxVelocity);
  frontLeft->backward(MaxVelocity);
  backLeft->backward(MaxVelocity);
}

void Car::goLeft()
{
  frontRight->forward(MaxVelocity);
  backRight->forward(MaxVelocity);
  frontLeft->backward(MaxVelocity);
  backLeft->backward(MaxVelocity);
}

void Car::goRight()
{
  frontRight->backward(MaxVelocity);
  backRight->backward(MaxVelocity);
  frontLeft->forward(MaxVelocity);
  backLeft->forward(MaxVelocity);
}

void Car::goForwardRight()
{
  frontRight->forward(MaxVelocity / SpeedCoefficient);
  backRight->forward(MaxVelocity / SpeedCoefficient);
  frontLeft->forward(MaxVelocity);
  backLeft->forward(MaxVelocity);
}

void Car::goForwardLeft()
{
  frontRight->forward(MaxVelocity);
  backRight->forward(MaxVelocity);
  frontLeft->forward(MaxVelocity / SpeedCoefficient);
  backLeft->forward(MaxVelocity / SpeedCoefficient);
}

void Car::goBackwardRight()
{
  frontRight->backward(MaxVelocity / SpeedCoefficient);
  backRight->backward(MaxVelocity / SpeedCoefficient);
  frontLeft->backward(MaxVelocity);
  backLeft->backward(MaxVelocity);
}

void Car::goBackwardLeft()
{
  frontRight->backward(MaxVelocity);
  backRight->backward(MaxVelocity);
  frontLeft->backward(MaxVelocity / SpeedCoefficient);
  backLeft->backward(MaxVelocity / SpeedCoefficient);
}

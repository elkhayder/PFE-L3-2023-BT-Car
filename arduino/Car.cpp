#include "Car.h"

Car::Car(
  // Input1, Input2, Enable
  int fr1, int fr2, int frE, // Front Right
  int br1, int br2, int brE, // Back Right
  int fl1, int fl2, int flE, // Front Left
  int bl1, int bl2, int blE // Back Left
) {
  frontRight = new Wheel(fr1, fr2, frE);
  backRight = new Wheel(br1, br2, brE);
  frontLeft = new Wheel(fl1, fl2, flE);
  backLeft = new Wheel(bl1, bl2, blE);
}

Car::~Car() {
  delete frontRight;
  delete backRight;
  delete frontLeft;
  delete backLeft;
}

uint8_t Car::Velocity = 100;
uint8_t Car::SpeedCoefficient = 4;

void Car::setup() {
  frontRight->setup();
  backRight->setup();
  frontLeft->setup();
  backLeft->setup();
}

void Car::brake() {
  frontRight->brake();
  backRight->brake();
  frontLeft->brake();
  backLeft->brake();
}

void Car::goAhead() {
  frontRight->forward(Velocity);
  backRight->forward(Velocity);
  frontLeft->forward(Velocity);
  backLeft->forward(Velocity);
}

void Car::goBack() {
  frontRight->backward(Velocity);
  backRight->backward(Velocity);
  frontLeft->backward(Velocity);
  backLeft->backward(Velocity);
}

void Car::goLeft() {
  frontRight->forward(Velocity);
  backRight->forward(Velocity);
  frontLeft->backward(Velocity);
  backLeft->backward(Velocity);
}

void Car::goRight() {
  frontRight->backward(Velocity);
  backRight->backward(Velocity);
  frontLeft->forward(Velocity);
  backLeft->forward(Velocity);
}

void Car::goAheadRight() {
  frontRight->forward(Velocity / SpeedCoefficient);
  backRight->forward(Velocity / SpeedCoefficient);
  frontLeft->forward(Velocity);
  backLeft->forward(Velocity);
}

void Car::goAheadLeft() {
  frontRight->forward(Velocity);
  backRight->forward(Velocity);
  frontLeft->forward(Velocity / SpeedCoefficient);
  backLeft->forward(Velocity / SpeedCoefficient);
}

void Car::goBackRight() {
  frontRight->backward(Velocity / SpeedCoefficient);
  backRight->backward(Velocity / SpeedCoefficient);
  frontLeft->backward(Velocity);
  backLeft->backward(Velocity);
}

void Car::goBackLeft() {
  frontRight->backward(Velocity);
  backRight->backward(Velocity);
  frontLeft->backward(Velocity / SpeedCoefficient);
  backLeft->backward(Velocity / SpeedCoefficient);
}

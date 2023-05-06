#ifndef _WHEELS_H
#define _WHEELS_H

#include <Arduino.h>

#define FORWARD HIGH
#define BACKWARD LOW

class Wheel
{
public:
  Wheel(int input1, int input2, int enable);

  static double Diameter;

  void setup();
  void forward(uint8_t velocity);
  void backward(uint8_t velocity);
  void brake();

private:
  int in1, in2, enable;
};

#endif

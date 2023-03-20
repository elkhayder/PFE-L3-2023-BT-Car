#ifndef _WHEELS_H
#define _WHEELS_H

#include <Arduino.h>

class Wheel {
public:
  Wheel(int input1, int input2, int enable);

  static double Diameter;
  
  void setup();
  void forward(uint8_t velocity);
  void backward(uint8_t velocity);
  void brake();

private:
  int _in1, _in2, _enable;
};

#endif

#include "Wheel.h"

double Wheel::Diameter = 6.6;

Wheel::Wheel(int in1, int in2, int enable) {
  _in1 = in1; 
  _in2 = in2; 
  _enable = enable;
}

void Wheel::setup() {
  pinMode(_in1, OUTPUT);
  pinMode(_in2, OUTPUT);
}

void Wheel::forward(uint8_t velocity) {
  digitalWrite(_in1, HIGH);
  digitalWrite(_in2, LOW);
  analogWrite(_enable, velocity);
}

void Wheel::backward(uint8_t velocity) {
  digitalWrite(_in1, LOW);
  digitalWrite(_in2, HIGH);
  analogWrite(_enable, velocity);
}

void Wheel::brake() {
  digitalWrite(_in1, LOW);
  digitalWrite(_in2, LOW);
}

#include "Wheel.h"

double Wheel::Diameter = 6.6;

Wheel::Wheel(int in1, int in2, int enable) : in1(in1), in2(in2), enable(enable)
{
}

void Wheel::setup()
{
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(enable, OUTPUT);
}

void Wheel::forward(uint8_t velocity)
{
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);
  analogWrite(enable, velocity);
}

void Wheel::backward(uint8_t velocity)
{
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);
  analogWrite(enable, velocity);
}

void Wheel::brake()
{
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);
}

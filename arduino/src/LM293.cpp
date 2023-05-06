#include "LM293.h"

int LM293::HolesCount = 20;

LM293::LM293(uint8_t p) {
  pin = p;
}

void LM293::setup() {
  pinMode(pin, INPUT);
}

void LM293::measure() {
  if (isCounting) {
    if (millis() < startTime + 1000) {
      if (digitalRead(pin) != prevState) {
        prevState = !prevState;
        count += 1;
      }
    } else {
      rps = float(count) / float(2 * HolesCount);
      speedKmH = rps * PI * Wheel::Diameter * 0.36; // 0.36 = 3600 / 10000
      isCounting = false;
    }
  } else {
    isCounting = true;
    count = 0;
    startTime = millis();
  }
}

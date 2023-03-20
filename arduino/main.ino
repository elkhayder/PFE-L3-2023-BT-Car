#include <LiquidCrystal_I2C.h>

#include "Car.h"
#include "LM293.h"

char command;            //Int to store app command state

Car *car;
LM293 *lm293;
LiquidCrystal_I2C lcd(0x27, 20, 4);

long lastPrint = 0;

void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);

  car = new Car(
    // In1, In2, Enable
    2, 3, 5, // Front Right
    4, 7, 6, // Back Right
    8, 9, 10, // Front Left
    12, 13, 11 // Back Left
  );

  lm293 = new LM293(52);
  lm293->setup();
  lcd.init();
  lcd.backlight();
  lcd.clear();
}


void loop() {
  lm293->measure();

  if (millis() > lastPrint + 1000) {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("RPS: ");
    lcd.print(lm293->rps);
    lcd.print(" tr/s");

    lcd.setCursor(0, 1);
    lcd.print("Speed: ");
    lcd.print(lm293->speedKmH);
    lcd.print(" km/h");

    lastPrint = millis();
  }

  if (Serial1.available() > 0) {
    command = Serial1.read();
    car->brake();

    switch (command) {
      case 'F': car->goAhead(); break;
      case 'B': car->goBack(); break;
      case 'L': car->goLeft(); break;
      case 'R': car->goRight(); break;

      case 'I': car->goAheadRight(); break;
      case 'G': car->goAheadLeft(); break;
      case 'J': car->goBackRight(); break;
      case 'H': car->goBackLeft(); break;

      case '0': Car::Velocity = 100; break;
      case '1': Car::Velocity = 115; break;
      case '2': Car::Velocity = 130; break;
      case '3': Car::Velocity = 145; break;
      case '4': Car::Velocity = 160; break;
      case '5': Car::Velocity = 175; break;
      case '6': Car::Velocity = 190; break;
      case '7': Car::Velocity = 205; break;
      case '8': Car::Velocity = 220; break;
      case '9': Car::Velocity = 235; break;
      case 'q': Car::Velocity = 255; break;
    }
  }
}

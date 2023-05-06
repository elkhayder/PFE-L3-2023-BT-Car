#include <LiquidCrystal_I2C.h>
#include <ArduinoJson.h>

#include "src/Car.h"
#include "src/LM293.h"
#include "src/Pool.h"

// TODO: Change this to Serial1 after
#define BTSerial Serial1

#define MAX_JSON_SIZE 1024

Car car(       // In1, In2, Enable
    2, 3, 5,   // Front Right
    4, 7, 6,   // Back Right
    8, 9, 10,  // Front Left
    12, 13, 11 // Back Left
);

// RPS Sensor
LM293 lm293(52);

LiquidCrystal_I2C lcd(0x27, 20, 4);

String _receivedPayloadBuffer = "";

long lastPrint = 0;

void updateLCD()
{
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("RPS: ");
  lcd.print(lm293.rps);
  lcd.print(" tr/s");

  lcd.setCursor(0, 1);
  lcd.print("Speed: ");
  lcd.print(lm293.speedKmH);
  lcd.print(" km/h");

  lcd.setCursor(0, 2);
  lcd.print("Max Speed: ");
  lcd.print(20.0 * Car::MaxVelocity / 255.0);
  lcd.print(" km/h");
}

void sendSpeed()
{
  DynamicJsonDocument _json(MAX_JSON_SIZE);
  _json["type"] = "Speed";
  _json["value"] = lm293.speedKmH;
  serializeJson(_json, BTSerial);
}

Pool _lcdPool(1000, &updateLCD);
Pool _sendSpeedPool(100, &sendSpeed);

void setup()
{
  Serial.begin(115200);
  BTSerial.begin(9600);

  // Init
  lm293.setup();
  car.setup();

  lcd.init();
  lcd.backlight();
  lcd.clear();
}

void loop()
{
  lm293.measure();

  _sendSpeedPool.loop();
  _lcdPool.loop();

  /**
   * @remark I can use the already defined method of readString, but this method is blocking, which will affect the PID Controller precision after
   */
  if (BTSerial.available())
  {
    char c = BTSerial.read();

    // LineFeed
    if (c == '\n')
    {
      parseReceivedPayload(_receivedPayloadBuffer);
      _receivedPayloadBuffer = ""; // Clear buffer
    }
    else
    {
      _receivedPayloadBuffer += c; // Concat received char
    }
  }
}

void parseReceivedPayload(String payload)
{
  DynamicJsonDocument _json(MAX_JSON_SIZE);
  Serial.println(payload);

  DeserializationError err = deserializeJson(_json, payload);

  Serial.println(err.c_str());

  String type = _json["type"];

  Serial.println(type);

  if (type == "Direction")
  {
    uint8_t direction = _json["value"];

    switch (direction)
    {
    case 0:
      car.brake();
      break;

    case 1:
      car.goForward();
      break;

    case 2:
      car.goForwardRight();
      break;

    case 3:
      car.goRight();
      break;

    case 4:
      car.goBackwardRight();
      break;

    case 5:
      car.goBackward();
      break;

    case 6:
      car.goBackwardLeft();
      break;

    case 7:
      car.goLeft();
      break;

    case 8:
      car.goForwardLeft();
      break;
    }
  }
  else if (type == "Speed")
  {
    double value = _json["value"];
    Car::MaxVelocity = (uint8_t)(value * 255.0 / 20.0);
  }
}

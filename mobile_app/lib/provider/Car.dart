import 'package:flutter/material.dart';

class Car extends ChangeNotifier {
  double _speed = 0;
  double _rpm = 0;

  set speed(double value) {
    _speed = value;
    notifyListeners();
  }

  double get speed => _speed;

  set rpm(double value) {
    _rpm = value;
    notifyListeners();
  }

  double get rpm => _rpm;
}

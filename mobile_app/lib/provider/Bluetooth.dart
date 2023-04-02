import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/includes/GlobalNavigatorKey.dart';
import 'package:mobile_app/provider/Car.dart';
import 'package:mobile_app/widgets/joystick.dart';
import 'package:provider/provider.dart';

/// *
/// Bluetooth Command Format
/// Command:ARG1,ARG2,...
class Bluetooth extends ChangeNotifier {
  BluetoothConnection? connection;
  BluetoothDiscoveryResult? connectedDevice;

  String _buffer = "";

  void connectToDevice(BluetoothDiscoveryResult result) async {
    // Disconnect if previously connected
    connection?.close();
    connection = null;
    connectedDevice = null;

    String name = result.device.name ?? result.device.address;

    Fluttertoast.showToast(
      msg: "Trying to connect to: $name",
    );

    try {
      connection = await BluetoothConnection.toAddress(result.device.address);
      connectedDevice = result;

      connection?.input?.listen((bytes) {
        int lineFeedIndex = bytes.indexOf(0x0A); // \n
        // If the LF exists
        if (lineFeedIndex >= 0) {
          // take the first n elements (excluding LF) and add them to the buffer
          _buffer += ascii.decode(bytes.take(lineFeedIndex).toList());
          _parsePayload(_buffer);
          // Reset teh buffer with the values from n to the end of the list
          _buffer = ascii.decode(bytes.sublist(lineFeedIndex));
        } else {
          // Copy the received bytes exactly
          _buffer += ascii.decode(bytes);
        }
      });

      Fluttertoast.showToast(
        msg: "Successfully connected to device: $name",
      );
    } catch (exception) {
      Fluttertoast.showToast(
        msg: "Error connecting to device: $name",
      );
    } finally {
      notifyListeners();
    }
  }

  void _parsePayload(String payload) {
    final parts = payload.split(":");
    if (parts.length != 2) return; // Bad payload
    final command = parts[0];
    final args = parts[1].split(":");

    if (GlobalNavigatorKey.currentContext == null) return;

    final car = Provider.of<Car>(GlobalNavigatorKey.currentContext!, listen: false);

    switch (command) {
      case "Speed":
        car.speed = double.tryParse(args[0]) ?? 0;
        break;
      case "RPM":
        car.rpm = double.tryParse(args[0]) ?? 0;
        break;
    }
  }

  void sendPosition(Vec2 pos) {
    // X & Y position up to 4 decimal places
    connection?.output
        .add(ascii.encode("Position:${pos.x.toStringAsFixed(4)},${pos.y.toStringAsFixed(4)}"));
  }

  void sendVelocity(double velocity) {
    // Velocity up to 2 decimal places
    connection?.output.add(ascii.encode("Velocity:${velocity.toStringAsFixed(2)}"));
  }
}

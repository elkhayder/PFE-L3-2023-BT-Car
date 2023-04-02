import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/includes/extensions.dart';
import 'package:mobile_app/includes/global_navigator_key.dart';
import 'package:mobile_app/provider/car.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/includes/vector.dart';

/// *
/// Bluetooth Command Format
/// Command:ARG1,ARG2,...
class Bluetooth extends ChangeNotifier {
  BluetoothConnection? _connection;
  BluetoothDiscoveryResult? _connectedDevice;
  StreamSubscription? _stream;

  bool get isConnected => _connection != null;
  BluetoothDiscoveryResult? get connectedDevice => _connectedDevice;

  String _buffer = "";

  void connectToDevice(BluetoothDiscoveryResult result) async {
    // Disconnect if previously connected
    _handleDisconnect();

    String name = result.device.name ?? result.device.address;

    Fluttertoast.showToast(
      msg: "Trying to connect to: $name",
    );

    try {
      _connection = await BluetoothConnection.toAddress(result.device.address);
      _connectedDevice = result;

      _stream = _connection?.input?.listen(_handleIncomingData);

      _stream?.onDone(_handleDisconnect);

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

    if (globalNavigatorKey.currentContext == null) return;

    final car = Provider.of<Car>(globalNavigatorKey.currentContext!, listen: false);

    switch (command) {
      case "Speed":
        car.speed = double.tryParse(args[0]) ?? 0;
        break;
      case "RPM":
        car.rpm = double.tryParse(args[0]) ?? 0;
        break;
    }
  }

  void _handleIncomingData(Uint8List bytes) {
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
  }

  void _handleDisconnect() {
    _connection?.close();
    _stream?.cancel();
    _stream = null;
    _connection = null;
    _connectedDevice = null;
    notifyListeners();
  }

  void _sendObject(Object payload) {
    final data = Uint8List.fromList(
      [
        ...ascii.encode(jsonEncode(payload)),
        0x0A, // Add LF
      ],
    );
    _connection?.output.add(
      data,
    );
    print(ascii.decode(data));
  }

  void sendDirectionVector(DirectionVec2 vec) {
    final object = {
      "type": "Direction",
      "velocity": vec.velocity.toPrecision(2),
      "angle": vec.angle * 180 ~/ pi, // Convert to degrees and discard decimal place
    };

    _sendObject(object);
  }

  void sendSpeed(double value) {
    final object = {
      "type": "Speed",
      "value": value,
    };

    _sendObject(object);
  }
}

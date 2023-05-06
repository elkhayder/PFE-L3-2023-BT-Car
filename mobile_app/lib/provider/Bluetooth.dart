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
  static const POLLING_DURATION = Duration(milliseconds: 100);

  BluetoothConnection? _connection;
  BluetoothDiscoveryResult? _connectedDevice;
  StreamSubscription? _stream;

  bool get isConnected => _connection != null;
  BluetoothDiscoveryResult? get connectedDevice => _connectedDevice;

  final List<Map<String, Object>> _payloadsBuffer = [];

  double speed = 0;

  String _buffer = "";

  Bluetooth() {
    Timer.periodic(POLLING_DURATION, (timer) {
      _onInterval();
    });
  }

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
    print(payload);
    Map<String, Object> json = jsonDecode(payload);

    if (json["type"] == "Speed") {
      speed = json["value"] as double;
      notifyListeners();
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
    print(_buffer);
  }

  void _handleDisconnect() {
    _connection?.close();
    _stream?.cancel();
    _stream = null;
    _connection = null;
    _connectedDevice = null;
    notifyListeners();
  }

  void _sendObject(Map<String, Object> payload) {
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

  void _bufferPayload(Map<String, Object> payload) {
    final index = _payloadsBuffer.indexWhere((e) => e["type"] == payload["type"]);
    if (index >= 0) {
      _payloadsBuffer.removeAt(index);
    }
    _payloadsBuffer.add(payload);
  }

  void sendDirection(int direction) {
    final object = {
      "type": "Direction",
      "value": direction,
    };

    _bufferPayload(object);
  }

  void sendSpeed(double value) {
    final object = {
      "type": "Speed",
      "value": value,
    };

    _bufferPayload(object);
  }

  void _onInterval() {
    for (var e in _payloadsBuffer) {
      _sendObject(e);
    }
    _payloadsBuffer.clear();
  }
}

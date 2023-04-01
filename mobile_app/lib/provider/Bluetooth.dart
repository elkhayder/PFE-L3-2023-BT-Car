import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Bluetooth extends ChangeNotifier {
  BluetoothConnection? connection;
  BluetoothDiscoveryResult? connectedDevice;

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
}

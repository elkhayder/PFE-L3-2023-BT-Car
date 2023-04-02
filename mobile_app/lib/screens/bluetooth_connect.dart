import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mobile_app/provider/bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BluetoothConnectScreen extends StatefulWidget {
  const BluetoothConnectScreen({super.key});

  @override
  State<BluetoothConnectScreen> createState() => _BluetoothConnectScreenState();
}

class _BluetoothConnectScreenState extends State<BluetoothConnectScreen> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  final List<BluetoothDiscoveryResult> _bluetoothDevices = [];

  bool isDiscovering = false;

  @override
  void initState() {
    super.initState();
    // _startDiscovery();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();

    super.dispose();
  }

  void _startDiscovery() async {
    _bluetoothDevices.clear();

    const permissions = [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      // Permission.bluetooth,
    ];

    for (final p in permissions) {
      await p.request();
      if (!await p.isGranted) {
        return;
      }
    }

    setState(() {
      isDiscovering = true;
    });

    _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        final existingIndex =
            _bluetoothDevices.indexWhere((element) => element.device.address == r.device.address);
        if (existingIndex >= 0) {
          _bluetoothDevices[existingIndex] = r;
        } else {
          _bluetoothDevices.add(r);
        }
        inspect(_bluetoothDevices);
      });
    });

    _streamSubscription?.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bluetoothProvider = Provider.of<Bluetooth>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Connection"),
        actions: [
          IconButton(
            onPressed: isDiscovering
                ? () => setState(() {
                      _streamSubscription?.cancel();
                      isDiscovering = false;
                    })
                : _startDiscovery,
            icon: Icon(isDiscovering ? Icons.stop : Icons.play_arrow),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isDiscovering)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final item = _bluetoothDevices[index];
                bool isConnected = item.device.isConnected ||
                    bluetoothProvider.connectedDevice?.device.address == item.device.address;

                return ListTile(
                  // Device Mac Address
                  title: Text(item.device.address),
                  // Device Name if exists
                  subtitle: item.device.name is String ? Text(item.device.name!) : null,
                  // Connect Status
                  trailing: Text(
                    isConnected ? "Connected" : "Disconnected",
                    style: TextStyle(
                      color: isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                  onTap: () => bluetoothProvider.connectToDevice(item),
                );
              },
              itemCount: _bluetoothDevices.length,
            ),
          ),
        ],
      ),
    );
  }
}

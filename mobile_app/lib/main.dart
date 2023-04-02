import 'package:flutter/material.dart';
import 'package:mobile_app/provider/Bluetooth.dart';
import 'package:mobile_app/provider/Car.dart';
import 'package:mobile_app/screens/BluetoothConnect.dart';
import 'package:mobile_app/screens/Cockpit.dart';
import 'package:mobile_app/includes/GlobalNavigatorKey.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Bluetooth()),
        ChangeNotifierProvider(create: (_) => Car()),
      ],
      child: const EntryPoint(),
    ),
  );
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    Bluetooth bluetooth = Provider.of<Bluetooth>(context);
    return MaterialApp(
      navigatorKey: GlobalNavigatorKey,
      debugShowCheckedModeBanner: false,
      home: bluetooth.connection == null ? const BluetoothConnectScreen() : const CockpitScreen(),
    );
  }
}

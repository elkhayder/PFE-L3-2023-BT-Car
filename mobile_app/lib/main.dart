import 'package:flutter/material.dart';
import 'package:mobile_app/provider/bluetooth.dart';
import 'package:mobile_app/provider/car.dart';
import 'package:mobile_app/screens/cockpit.dart';
import 'package:mobile_app/includes/global_navigator_key.dart';

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
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      debugShowCheckedModeBanner: false,
      home: const CockpitScreen(),
    );
  }
}

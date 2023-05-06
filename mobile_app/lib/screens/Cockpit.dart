import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:mobile_app/includes/extensions.dart';
import 'package:mobile_app/provider/bluetooth.dart';
import 'package:mobile_app/screens/bluetooth_connect.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/includes/vector.dart';

import '../widgets/arrow.dart';

class CockpitScreen extends StatefulWidget {
  const CockpitScreen({super.key});

  @override
  State<CockpitScreen> createState() => _CockpitScreenState();
}

class _CockpitScreenState extends State<CockpitScreen> {
  double _velocity = 1.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  void _onVelocityUpdate(double newValue) {
    setState(() {
      _velocity = newValue;
    });

    Provider.of<Bluetooth>(context, listen: false).sendSpeed(newValue);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var bluetooth = Provider.of<Bluetooth>(context);

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text("Cockpit"),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BluetoothConnectScreen(),
                ),
              ),
              icon: Icon(bluetooth.isConnected ? Icons.bluetooth_connected : Icons.bluetooth),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  // color: Colors.red,
                  padding: const EdgeInsets.all(24),
                  child: Stack(
                    children: const [
                      Arrow(position: 1),
                      Arrow(position: 2),
                      Arrow(position: 3),
                      Arrow(position: 4),
                      Arrow(position: 5),
                      Arrow(position: 6),
                      Arrow(position: 7),
                      Arrow(position: 8),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const SizedBox(
                      width: 200,
                      child: Image(
                        image: AssetImage("assets/UnivStrasbourgLogo.png"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text("Direction Vector"),
                    // Text("Normalized Velocity: ${pos.module.toPrecision(3)}"),
                    // Text("Angle (Degrees): ${pos.angle * 180 ~/ pi}"),
                    Text("Max Velocity: ${_velocity.toPrecision(3)} Km/s"),
                    Text("Speed: ${bluetooth.speed} Km/s"),
                    const SizedBox(height: 24),
                    Slider(
                      value: _velocity,
                      onChanged: _onVelocityUpdate,
                      min: 1,
                      max: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

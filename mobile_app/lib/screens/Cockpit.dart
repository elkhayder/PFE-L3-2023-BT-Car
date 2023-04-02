import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:mobile_app/includes/extensions.dart';
import 'package:mobile_app/provider/bluetooth.dart';
import 'package:mobile_app/screens/bluetooth_connect.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/includes/vector.dart';

import '../widgets/joystick.dart';

class CockpitScreen extends StatefulWidget {
  const CockpitScreen({super.key});

  @override
  State<CockpitScreen> createState() => _CockpitScreenState();
}

class _CockpitScreenState extends State<CockpitScreen> {
  double _velocity = 0;
  Vec2 pos = Vec2(0, 0);
  DirectionVec2 direction = DirectionVec2(0, 0);

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

  void _onPosUpdate(Vec2 value) {
    setState(() {
      direction = DirectionVec2.fromVec2(value);
      pos.x = value.x;
      pos.y = value.y;
    });

    Provider.of<Bluetooth>(context, listen: false).sendDirectionVector(
      direction,
    );
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
              Joystick(
                size: media.size.height * 0.5,
                onPosUpdate: _onPosUpdate,
              ),
              Column(
                children: [
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 200,
                    child: Image(
                        image: AssetImage("assets/UnivStrasbourgLogo.png"), fit: BoxFit.fitWidth),
                  ),
                  const SizedBox(height: 24),
                  const Text("Direction Vector"),
                  Text("Normalized Velocity: ${direction.velocity.toPrecision(3)}"),
                  Text("Angle (Degrees): ${direction.angle * 180 ~/ pi}"),
                  Text("Max Velocity: ${_velocity.toPrecision(3)} Km/s"),
                ],
              ),
              RotatedBox(
                quarterTurns: -1,
                child: Slider(
                  value: _velocity,
                  onChanged: _onVelocityUpdate,
                  min: 1,
                  max: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

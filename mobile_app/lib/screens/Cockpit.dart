import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:mobile_app/provider/Bluetooth.dart';
import 'package:provider/provider.dart';

import '../widgets/joystick.dart';

class CockpitScreen extends StatefulWidget {
  const CockpitScreen({super.key});

  @override
  State<CockpitScreen> createState() => _CockpitScreenState();
}

class _CockpitScreenState extends State<CockpitScreen> {
  double _velocity = 0;
  Vec2 pos = Vec2(0, 0);

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

    Provider.of<Bluetooth>(context, listen: false).sendVelocity(newValue);
  }

  void _onPosUpdate(Vec2 value) {
    Provider.of<Bluetooth>(context, listen: false).sendPosition(value);
    setState(() {
      pos.x = value.x;
      pos.y = value.y;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                  Text("Position: [${pos.x}, ${pos.y}]"),
                  Text("Max Velocity: $_velocity"),
                  SizedBox(
                    width: 200,
                    child: Image(
                        image: AssetImage("assets/UnivStrasbourgLogo.png"), fit: BoxFit.fitWidth),
                  ),
                ],
              ),
              RotatedBox(
                quarterTurns: -1,
                child: Slider(
                  value: _velocity,
                  onChanged: _onVelocityUpdate,
                  label: "$_velocity km/h",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

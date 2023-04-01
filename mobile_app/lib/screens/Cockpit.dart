import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import '../widgets/joystick.dart';

class CockpitScreen extends StatefulWidget {
  const CockpitScreen({super.key});

  @override
  State<CockpitScreen> createState() => _CockpitScreenState();
}

class _CockpitScreenState extends State<CockpitScreen> {
  double v = 0;

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
              ),
              RotatedBox(
                quarterTurns: -1,
                child: Slider(
                  value: v,
                  onChanged: (x) {
                    setState(() {
                      v = x;
                    });
                  },
                  label: "$v km/h",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

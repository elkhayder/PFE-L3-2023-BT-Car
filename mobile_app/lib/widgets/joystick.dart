import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_app/includes/vector.dart';

class Joystick extends StatefulWidget {
  final double size;
  final double handleSize = 50;
  final void Function(Vec2 pos) onPosUpdate;

  const Joystick({super.key, required this.size, required this.onPosUpdate});

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Vec2 pos = Vec2(0, 0);
  late double module;

  @override
  void initState() {
    module = widget.size * sqrt2;
    super.initState();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Get X and Y position, and center them in the middle
    double centeredX = max(0, min(widget.size, details.localPosition.dx)) - widget.size / 2;
    double centeredY = max(0, min(widget.size, details.localPosition.dy)) - widget.size / 2;

    double angle = atan2(centeredY, centeredX); // in rad

    double angleCos = cos(angle) * widget.size / 2;
    double angleSin = sin(angle) * widget.size / 2;

    setState(() {
      pos.x = centeredX.isNegative ? max(angleCos, centeredX) : min(angleCos, centeredX);
      pos.y = centeredY.isNegative ? max(angleSin, centeredY) : min(angleSin, centeredY);
    });

    widget.onPosUpdate(
      // Dividing by half of the size to get the cos and sine values
      Vec2(
        pos.x / (widget.size / 2),
        // Inverting Y axis because I don't know WTF is happening
        -pos.y / (widget.size / 2),
      ),
    );
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      pos.x = 0;
      pos.y = 0;
    });
    widget.onPosUpdate(pos);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(widget.size)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              top: pos.y + widget.size / 2 - widget.handleSize / 2,
              left: pos.x + widget.size / 2 - widget.handleSize / 2,
              child: Container(
                width: widget.handleSize,
                height: widget.handleSize,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(widget.size)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_app/provider/bluetooth.dart';
import 'package:provider/provider.dart';

class Arrow extends StatefulWidget {
  final int position;
  const Arrow({super.key, required this.position});

  @override
  State<Arrow> createState() => _ArrowState();
}

class _ArrowState extends State<Arrow> {
  double get angle => (widget.position - 1) * 2 * pi / 8;

  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(
        sin(angle),
        -cos(angle),
      ),
      child: Transform.rotate(
        angle: angle,
        child: GestureDetector(
          //
          onLongPressEnd: (_) => stop(),
          onLongPressCancel: () => stop(),
          //
          onLongPressDown: (_) => go(),
          //
          child: SizedBox(
            width: 70,
            height: 70,
            // color: Colors.red,
            child: Icon(
              Icons.arrow_upward,
              size: 50,
              color: isClicked ? Colors.red : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void go() {
    Provider.of<Bluetooth>(context, listen: false).sendDirection(widget.position);
    setState(() => isClicked = true);
  }

  void stop() {
    Provider.of<Bluetooth>(context, listen: false).sendDirection(0);
    setState(() => isClicked = false);
  }
}

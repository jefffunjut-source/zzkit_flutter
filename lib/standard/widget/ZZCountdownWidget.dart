// ignore_for_file: unused_import, use_key_in_widget_constructors, file_names

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/page/ZZBootupController.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';

class ZZCountdownWidget extends StatefulWidget {
  @override
  ZZCountdownWidgetState createState() => ZZCountdownWidgetState();
}

class ZZCountdownWidgetState extends State<ZZCountdownWidget> {
  late Timer _timer;
  double _countdown = 5;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    ZZBootupController controller = Get.find();
    _countdown = controller.adCountdown;
    startCountdown();
  }

  void startCountdown() {
    const oneTenthSec = Duration(milliseconds: 100);
    _timer = Timer.periodic(
      oneTenthSec,
      (Timer timer) {
        if (_countdown <= 0) {
          timer.cancel();
        } else {
          setState(() {
            _countdown -= 0.1;
            if (_countdown < 0) {
              _countdown = 0;
              ZZBootupController controller = Get.find();
              controller.offAdOrMainPage();
            }
            _progress = max(0, _countdown / 5);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.black.withAlpha(100),
              borderRadius: const BorderRadius.all(Radius.circular(52))),
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(4),
          child: CustomPaint(
            painter: ZZCountdownPainter(progress: _progress),
          ),
        ),
        Text(
          "跳过\n${_countdown.toStringAsFixed(0)}秒",
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class ZZCountdownPainter extends CustomPainter {
  final double progress;

  ZZCountdownPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromCircle(
        center: size.center(Offset.zero), radius: size.width / 2);

    canvas.drawArc(
      rect,
      -pi / 2 + 2 * pi * progress, // start angle at top
      -2 * pi * progress, // sweep angle based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

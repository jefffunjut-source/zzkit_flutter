// ignore_for_file: use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/bootup/zz_bootup_page.dart';
import 'package:zzkit_flutter/standard/page/zz_base_scaffold.dart';
import 'package:zzkit_flutter/standard/widget/zz_image.dart';
import 'package:zzkit_flutter/util/zz_const.dart';
import 'dart:async';
import 'dart:math';

class ZZAdPage extends StatefulWidget {
  @override
  ZZAdPageState createState() => ZZAdPageState();
}

class ZZAdPageState extends State<ZZAdPage> {
  ZZAdData? adData;

  @override
  void initState() {
    super.initState();
    ZZBootupController controller = Get.find();
    if (controller.adBlock != null) {
      controller.adBlock!().then((value) {
        controller.adBlockCompleted = true;
        if (value != null) {
          setState(() {
            adData = value;
          });
        } else {
          controller.offAdOrMainPage();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ZZBootupController controller = Get.find();

    return ZZBaseScaffold(
      safeAreaBottom: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () async {
              if (controller.onTapAd != null) {
                controller.offAdOrMainPage();
                Future.delayed(
                  const Duration(milliseconds: 1000),
                ).then((value) => controller.onTapAd!(adData));
              }
            },
            child: Container(
              width: zzScreenWidth,
              height: zzScreenHeight,
              color: Colors.white,
              child: ZZImage(
                width: zzScreenWidth,
                height: zzScreenHeight,
                fit: BoxFit.cover,
                source: adData?.pic,
              ),
            ),
          ),
          adData != null
              ? Positioned(
                right: 30,
                top: 30 + zzStatusBarHeight,
                child: GestureDetector(
                  onTap: () {
                    ZZBootupController controller = Get.find();
                    controller.offAdOrMainPage();
                  },
                  child: ZZCountdownWidget(),
                ),
              )
              : Container(),
        ],
      ),
    );
  }
}

class ZZCountdownWidget extends StatefulWidget {
  const ZZCountdownWidget({super.key});

  @override
  ZZCountdownWidgetState createState() => ZZCountdownWidgetState();
}

class ZZCountdownWidgetState extends State<ZZCountdownWidget> {
  static const Duration _tickDuration = Duration(milliseconds: 100);
  static const double _tickStep = 0.1;

  Timer? _timer;
  late final double _totalCountdown;

  double _countdown = 0;
  double _progress = 1.0;

  ZZBootupController get _controller => Get.find<ZZBootupController>();

  @override
  void initState() {
    super.initState();
    _totalCountdown = _controller.adCountdown;
    _countdown = _totalCountdown;
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(_tickDuration, (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _countdown -= _tickStep;

        if (_countdown <= 0) {
          _countdown = 0;
          _progress = 0;
          timer.cancel();
          _controller.offAdOrMainPage();
        } else {
          _progress = max(0, _countdown / _totalCountdown);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(100),
            borderRadius: BorderRadius.circular(52),
          ),
          child: CustomPaint(painter: ZZCountdownPainter(progress: _progress)),
        ),
        Text(
          '跳过\n${_countdown.toStringAsFixed(0)}秒',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ZZCountdownPainter extends CustomPainter {
  final double progress;

  const ZZCountdownPainter({required this.progress});

  static const double _strokeWidth = 4;
  static const Color _color = Colors.orange;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = _color
          ..strokeWidth = _strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final Rect rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );

    canvas.drawArc(rect, -pi / 2, -2 * pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant ZZCountdownPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

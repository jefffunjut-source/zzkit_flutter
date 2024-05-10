// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field, file_names
import 'dart:async';
import 'package:zzkit_flutter/util/core/ZZConst.dart';

class ZZCountdown {
  double countdown = 5;
  double step = 1;
  ZZCallback1Int? callback;
  ZZCountdown({required this.countdown, required this.step, this.callback});

  Timer? _timer;
  bool _started = false;

  void startCountdown() {
    if (_started == true) {
      return;
    }
    _started = true;
    Duration oneTenthSec = Duration(milliseconds: (1000 * step).toInt());
    _timer = Timer.periodic(
      oneTenthSec,
      (Timer timer) {
        countdown -= step;
        if (countdown < zzZero) {
          countdown = 0;
          _started = false;
          timer.cancel();
        }
        if (callback != null) {
          callback!((countdown * 1000).toInt());
        }
      },
    );
  }

  void dispose() {
    _started = false;
    _timer?.cancel();
  }
}

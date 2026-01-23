import 'dart:async';
import 'package:zzkit_flutter/util/core/zz_const.dart';

/// 倒计时工具类
class ZZCountdown {
  /// 当前剩余时间（单位：秒）
  double countdown;

  /// 每次递减步长（单位：秒）
  final double step;

  /// 每次倒计时回调，参数为剩余时间毫秒数
  final ZZCallback1Int? callback;

  ZZCountdown({required this.countdown, this.step = 1.0, this.callback})
    : assert(step > 0, 'Step must be greater than zero');

  Timer? _timer;
  bool _started = false;

  /// 开始倒计时
  void startCountdown() {
    if (_started) return;

    _started = true;
    final interval = Duration(milliseconds: (1000 * step).toInt());

    _timer = Timer.periodic(interval, (timer) {
      countdown -= step;
      if (countdown <= zzZero) {
        countdown = 0;
        _started = false;
        timer.cancel();
      }
      callback?.call((countdown * 1000).toInt());
    });
  }

  /// 停止倒计时并释放资源
  void dispose() {
    _started = false;
    _timer?.cancel();
    _timer = null;
  }
}

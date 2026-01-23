import 'dart:async';

/// 防抖 / 节流工具类
class ZZThrottle {
  Timer? _timer;
  final int milliseconds;
  final void Function() callback;

  /// [milliseconds] 默认 500ms
  ZZThrottle({this.milliseconds = 500, required this.callback});

  /// 启动节流
  void start() {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), callback);
  }

  /// 取消节流
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// 释放资源
  void dispose() => cancel();
}

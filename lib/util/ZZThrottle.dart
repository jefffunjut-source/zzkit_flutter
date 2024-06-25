// ignore_for_file: file_names

import 'dart:async';

class ZZThrottle {
  Timer? debounce;
  int? milliseconds;
  void Function()? callback;
  ZZThrottle({
    this.milliseconds,
    required this.callback,
  });

  void start() {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(Duration(milliseconds: milliseconds ?? 500), () async {
      if (callback != null) {
        callback!();
      }
    });
  }
}

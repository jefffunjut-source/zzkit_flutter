import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/zz_count_down.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';

class ZZGetCodeController extends GetxController {
  final RxBool validMobile = false.obs;

  /// Request code callback, return true if request succeeds
  Future<bool> Function()? getCodeBlock;

  /// Total countdown seconds
  double countdownSeconds = 60.0;

  /// Countdown step in seconds
  double countdownStep = 1.0;

  /// Text style when enabled
  TextStyle? enabledTextStyle;

  /// Text style when disabled
  TextStyle? disabledTextStyle;
}

class ZZGetCodeWidget extends StatefulWidget {
  const ZZGetCodeWidget({super.key});

  @override
  State<ZZGetCodeWidget> createState() => ZZGetCodeState();
}

class ZZGetCodeState extends State<ZZGetCodeWidget> {
  late final ZZCountdown _countdown;

  /// Remaining seconds
  late final RxDouble _countdownSecond;

  ZZGetCodeController get _controller => Get.find<ZZGetCodeController>();

  @override
  void initState() {
    super.initState();

    _countdownSecond = _controller.countdownSeconds.obs;

    _countdown = ZZCountdown(
      countdown: _controller.countdownSeconds,
      step: _controller.countdownStep,
      callback: (millisec) {
        final double seconds = millisec / 1000.0;
        _countdownSecond.value =
            seconds < zzZero ? _controller.countdownSeconds : seconds;
      },
    );
  }

  void _onTap() {
    if (!_controller.validMobile.value) {
      ZZ.toast('请输入手机号');
      return;
    }

    final Future<bool> Function()? request = _controller.getCodeBlock;
    if (request == null) return;

    request().then((bool success) {
      if (success) {
        _countdown.startCountdown();
      }
    });
  }

  TextStyle _enabledStyle() {
    return _controller.enabledTextStyle ??
        ZZ.textStyle(color: Colors.orange, fontSize: 14.sp);
  }

  TextStyle _disabledStyle() {
    return _controller.disabledTextStyle ??
        ZZ.textStyle(color: Colors.grey, fontSize: 14.sp);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Obx(() {
        final bool isInitial =
            _countdownSecond.value == _controller.countdownSeconds;

        return Container(
          padding: EdgeInsets.all(8.w),
          alignment: Alignment.center,
          child:
              isInitial
                  ? Text(
                    '获取验证码',
                    style:
                        _controller.validMobile.value
                            ? _enabledStyle()
                            : _disabledStyle(),
                  )
                  : Text(
                    '重新获取${_countdownSecond.value.toInt()}秒',
                    style: _disabledStyle(),
                  ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _countdown.dispose();
    super.dispose();
  }
}

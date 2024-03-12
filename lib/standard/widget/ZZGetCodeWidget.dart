// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/ZZCountdown.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class ZZGetCodeController extends GetxController {
  Future<bool> Function()? getCodeBlock;
  double countdownSeconds = 60.0;
  double countdownStep = 1.0;
  RxString mobile = "".obs;
  TextStyle? enabledTextStyle;
  TextStyle? disabledTextStyle;
}

class ZZGetCodeWidget extends StatefulWidget {
  const ZZGetCodeWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return ZZGetCodeState();
  }
}

class ZZGetCodeState extends State {
  late ZZCountdown countdown;
  RxBool gotCodeSuccess = false.obs;
  RxDouble countdownSecond = 0.0.obs;

  @override
  void initState() {
    super.initState();
    ZZGetCodeController codeController = Get.find();
    gotCodeSuccess = false.obs;
    countdownSecond = codeController.countdownSeconds.obs;
    countdown = ZZCountdown(
      countdown: codeController.countdownSeconds,
      step: codeController.countdownStep,
      callback: (millisec) {
        countdownSecond.value = millisec / 1000.0;
        if (countdownSecond.value < zzZero) {
          countdownSecond.value = codeController.countdownSeconds;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ZZGetCodeController codeController = Get.find();
    return GestureDetector(
      onTap: () {
        if (codeController.mobile.isEmpty) {
          return;
        }
        if (codeController.getCodeBlock != null) {
          codeController.getCodeBlock!().then((value) {
            if (value) {
              countdown.startCountdown();
            }
          });
        }
      },
      child: Obx(() => Container(
            padding: EdgeInsets.all(8.w),
            child: Center(
              child: countdownSecond.value == codeController.countdownSeconds
                  ? Text(
                      "获取验证码",
                      style: codeController.mobile.isEmpty
                          ? codeController.disabledTextStyle ??
                              ZZ.textStyle(color: Colors.grey, fontSize: 14.sp)
                          : codeController.enabledTextStyle ??
                              ZZ.textStyle(
                                  color: Colors.orange, fontSize: 14.sp),
                    )
                  : Text(
                      "重新获取${countdownSecond.value.toInt()}秒",
                      style: codeController.disabledTextStyle ??
                          ZZ.textStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    countdown.dispose();
    super.dispose();
  }
}

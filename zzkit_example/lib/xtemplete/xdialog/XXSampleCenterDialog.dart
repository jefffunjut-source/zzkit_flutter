// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_example/r.dart';
import 'package:zzkit_flutter/standard/dialog/ZZBaseCenterDialog.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class XXSampleCenterDialog extends ZZBaseCenterDialog {
  @override
  Color backgroundColor() {
    return Colors.transparent;
  }

  @override
  Color contentBackgroundColor() {
    return Colors.transparent;
  }

  @override
  Color actionsBackgroundColor() {
    return Colors.white;
  }

  @override
  int buttonCount() {
    return 1;
  }

  @override
  double buttonHeight() {
    return 64.w;
  }

  @override
  double radius() {
    return 6;
  }

  // @override
  // EdgeInsetsGeometry leftButtonMargin() {
  //   return EdgeInsets.only(left: 14.w, right: 14.w, bottom: 8.w, top: 8.w);
  // }

  @override
  EdgeInsetsGeometry rightButtonMargin() {
    return EdgeInsets.only(left: 14.w, right: 14.w, bottom: 14.w, top: 14.w);
  }

  @override
  String rightButtonString() {
    return "我知道了";
  }

  @override
  Widget contentWidget() {
    return IntrinsicHeight(
      child: Container(
        width: 350.w,
        color: Colors.transparent,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 350.w,
                    height: 50.w,
                    color: Colors.white,
                  )),
              ZZ.image(
                    R.assetsImgIcBgRebateDialog,
                  ) ??
                  Container()
            ],
          ),
          Container(
            width: 350.w,
            color: Colors.white,
            child: const Text("温馨提示"),
          )
        ]),
      ),
    );
  }
}

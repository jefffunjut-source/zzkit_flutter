// ignore_for_file: file_names
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

abstract class ZZBaseCenterDialog {
  Widget contentWidget();

  bool barrierDismissible() {
    return true;
  }

  Color? barrierColor() {
    return null;
  }

  EdgeInsetsGeometry contentPadding() {
    return EdgeInsets.zero;
  }

  EdgeInsetsGeometry actionsPadding() {
    return EdgeInsets.zero;
  }

  double radius() {
    return 4.0;
  }

  Color backgroundColor() {
    return Colors.white;
  }

  Color contentBackgroundColor() {
    return Colors.white;
  }

  Color actionsBackgroundColor() {
    return Colors.white;
  }

  double buttonHeight() {
    return 48;
  }

  int buttonCount() {
    return 2;
  }

  String leftButtonString() {
    return "取消";
  }

  String rightButtonString() {
    return "确定";
  }

  TextStyle leftButtonTextStyle() {
    return ZZ.textStyle(
        color: zzColorRed, fontSize: 16.sp, fontWeight: FontWeight.bold);
  }

  TextStyle rightButtonTextStyle() {
    return ZZ.textStyle(
        color: zzColorWhite, fontSize: 16.sp, fontWeight: FontWeight.bold);
  }

  Color? leftButtonBackgroundColor() {
    return zzColorRed.withAlpha(25);
  }

  Color? rightButtonBackgroundColor() {
    return null;
  }

  Gradient? leftButtonBackgroundGradient() {
    return null;
  }

  Gradient? rightButtonBackgroundGradient() {
    return zzColorGradientOrangeRed;
  }

  EdgeInsetsGeometry leftButtonMargin() {
    return EdgeInsets.zero;
  }

  EdgeInsetsGeometry rightButtonMargin() {
    return EdgeInsets.zero;
  }

  void leftButtonTap() {
    Get.back();
  }

  void rightButtonTap() {
    Get.back();
  }

  Color? buttonSeparatorColor() {
    return zzColorGreyCC;
  }

  Future<dynamic> show() async {
    var ret = await showDialog(
      context: zzContext,
      barrierDismissible: barrierDismissible(),
      barrierColor: barrierColor(),
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          contentPadding: contentPadding(),
          actionsPadding: actionsPadding(),
          backgroundColor:
              radius() > 0 ? Colors.transparent : backgroundColor(),
          surfaceTintColor:
              radius() > 0 ? Colors.transparent : backgroundColor(),
          content: ZZ.outerBorderRadious(
              radiusTopLeft: radius(),
              radiusTopRight: radius(),
              widget: Container(
                  color: contentBackgroundColor(), child: contentWidget())),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ZZ.outerBorderRadious(
                radiusBottomLeft: radius(),
                radiusBottomRight: radius(),
                widget: Container(
                    color: actionsBackgroundColor(),
                    height: buttonHeight(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          children: [
                            buttonCount() == 2
                                ? Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                        onTap: () {
                                          leftButtonTap();
                                        },
                                        child: Container(
                                          margin: leftButtonMargin(),
                                          height: buttonHeight(),
                                          decoration: BoxDecoration(
                                            color: leftButtonBackgroundColor(),
                                            gradient: leftButtonBackgroundColor() !=
                                                    null
                                                ? null
                                                : leftButtonBackgroundGradient(),
                                          ),
                                          child: Center(
                                            child: Text(leftButtonString(),
                                                style: leftButtonTextStyle()),
                                          ),
                                        )),
                                  )
                                : Container(),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  rightButtonTap();
                                },
                                child: Container(
                                  margin: rightButtonMargin(),
                                  decoration: BoxDecoration(
                                    color: rightButtonBackgroundColor(),
                                    gradient:
                                        rightButtonBackgroundColor() != null
                                            ? null
                                            : rightButtonBackgroundGradient(),
                                  ),
                                  child: Center(
                                    child: Text(rightButtonString(),
                                        style: rightButtonTextStyle()),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // 按钮分割线
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 0.5,
                            color: buttonSeparatorColor(),
                          ),
                        ),
                        buttonCount() == 2
                            ? Positioned(
                                top: 0.5,
                                bottom: 0,
                                child: Container(
                                  width: 0.5,
                                  color: buttonSeparatorColor(),
                                ))
                            : Container()
                      ],
                    )))
          ],
        );
      },
    );
    return ret;
  }
}

// ignore_for_file: file_names
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

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
    return Colors.transparent;
  }

  Color actionsBackgroundColor() {
    return Colors.transparent;
  }

  double buttonHeight() {
    return 48;
  }

  int buttonCount() {
    return 2;
  }

  Color? buttonSkeletonColor() {
    return null;
  }

  String leftButtonString() {
    return "取消";
  }

  String rightButtonString() {
    return "确定";
  }

  TextStyle leftButtonTextStyle() {
    return ZZ.textStyle(color: zzColorRed, fontSize: 16.sp, bold: true);
  }

  TextStyle rightButtonTextStyle() {
    return ZZ.textStyle(color: zzColorWhite, fontSize: 16.sp, bold: true);
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

  double leftButtonRadius() {
    return 0;
  }

  double rightButtonRadius() {
    return 0;
  }

  void leftButtonTap() {}

  void rightButtonTap() {}

  bool useCustomLeftButtonTap() {
    return false;
  }

  bool useCustomRightButtonTap() {
    return false;
  }

  Future<dynamic> show() async {
    var ret = await showDialog(
      context: zzContext,
      barrierDismissible: barrierDismissible(),
      barrierColor: barrierColor(),
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: contentPadding(),
          actionsPadding: actionsPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius()),
          ),
          backgroundColor: backgroundColor(),
          surfaceTintColor: backgroundColor(),
          content: Container(
              color: contentBackgroundColor(), child: contentWidget()),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radius()),
                      bottomRight: Radius.circular(radius())),
                  color: actionsBackgroundColor(),
                ),
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
                                      if (!useCustomLeftButtonTap()) {
                                        Get.back();
                                      }
                                      leftButtonTap();
                                    },
                                    child: Container(
                                      margin: leftButtonMargin(),
                                      height: buttonHeight(),
                                      decoration: BoxDecoration(
                                        color: leftButtonBackgroundColor(),
                                        gradient:
                                            leftButtonBackgroundGradient(),
                                        borderRadius: leftButtonMargin() ==
                                                EdgeInsets.zero
                                            ? BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(radius()),
                                              )
                                            : BorderRadius.all(
                                                Radius.circular(
                                                    leftButtonRadius()),
                                              ),
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
                              if (!useCustomRightButtonTap()) {
                                Get.back();
                              }
                              rightButtonTap();
                            },
                            child: Container(
                              margin: rightButtonMargin(),
                              decoration: BoxDecoration(
                                color: rightButtonBackgroundColor(),
                                gradient: rightButtonBackgroundGradient(),
                                borderRadius: rightButtonMargin() ==
                                        EdgeInsets.zero
                                    ? BorderRadius.only(
                                        bottomRight: Radius.circular(radius()),
                                      )
                                    : BorderRadius.all(
                                        Radius.circular(rightButtonRadius())),
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
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 0.3,
                        color: buttonSkeletonColor(),
                      ),
                    ),
                    buttonCount() == 2
                        ? Positioned(
                            top: 0.3,
                            bottom: 0,
                            child: Container(
                              width: 0.3,
                              color: buttonSkeletonColor(),
                            ))
                        : Container()
                  ],
                ))
          ],
        );
      },
    );
    return ret;
  }
}

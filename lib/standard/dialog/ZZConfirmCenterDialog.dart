// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/dialog/ZZBaseCenterDialog.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZConfirmCenterDialog extends ZZBaseCenterDialog {
  String? title;
  String? content;
  TextStyle? titleStyle;
  TextStyle? contentStyle;
  TextStyle? leftStyle;
  TextStyle? rightStyle;
  String? leftText;
  String? rightText;
  bool? dismissible;
  ZZConfirmCenterDialog({
    required this.title,
    required this.content,
    this.titleStyle,
    this.contentStyle,
    this.leftStyle,
    this.rightStyle,
    this.leftText,
    this.rightText,
    this.dismissible,
  });
  @override
  int buttonCount() {
    return 2;
  }

  @override
  Widget contentWidget() {
    return SizedBox(
      width: 366.w,
      child: IntrinsicHeight(
        child: Column(
          children: [
            ZZ.isNullOrEmpty(title)
                ? Container()
                : Container(
                    height: 30.w,
                    margin: EdgeInsets.only(
                      top: 20.w,
                    ),
                    child: Text(
                      title!,
                      style: titleStyle ??
                          ZZ.textStyle(
                            color: ZZColor.dark,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
            ZZ.isNullOrEmpty(content)
                ? Container()
                : Container(
                    margin: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        bottom: 20.w,
                        top: ZZ.isNullOrEmpty(title) ? 24.w : 10.w),
                    child: RichText(
                      text: TextSpan(
                        style: contentStyle ??
                            ZZ.textStyle(
                                color: ZZColor.grey33,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.6),
                        children: [
                          TextSpan(
                            text: content,
                          ),
                        ],
                      ),
                    ))
          ],
        ),
      ),
    );
  }

  @override
  Color contentBackgroundColor() {
    return Colors.white;
  }

  @override
  Color actionsBackgroundColor() {
    return Colors.white;
  }

  @override
  double radius() {
    return 8.w;
  }

  @override
  Color? buttonSeparatorColor() {
    return ZZColor.seperate;
  }

  @override
  bool barrierDismissible() {
    return dismissible ?? false;
  }

  @override
  String leftButtonString() {
    return leftText ?? "取消";
  }

  @override
  String rightButtonString() {
    return rightText ?? "确定";
  }

  @override
  Color? rightButtonBackgroundColor() {
    return Colors.white;
  }

  @override
  Color? leftButtonBackgroundColor() {
    return Colors.white;
  }

  @override
  TextStyle leftButtonTextStyle() {
    return leftStyle ?? ZZ.textStyle(color: ZZColor.grey99, fontSize: 14.sp);
  }

  @override
  TextStyle rightButtonTextStyle() {
    return rightStyle ??
        ZZ.textStyle(color: ZZColor.reddishOrange, fontSize: 14.sp);
  }
}

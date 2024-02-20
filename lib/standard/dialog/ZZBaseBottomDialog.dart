// ignore_for_file: file_names
library zzkit;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit/r.dart';
import 'package:zzkit/util/core/ZZAppConsts.dart';
import 'package:zzkit/util/core/ZZAppManager.dart';

abstract class ZZBaseBottomDialog {
  List<Widget> contentWidgets();

  double maxHeight() {
    return kScreenHeight * 0.8;
  }

  String title() {
    return "标题";
  }

  double? titleHeight() {
    return 64;
  }

  Color? titleBackgroundColor() {
    return Colors.white;
  }

  TextStyle? titleTextStyle() {
    return APP.textStyle(color: kColorBlack, fontSize: 22.sp, bold: true);
  }

  bool enableClose() {
    return true;
  }

  Color? seperatorColor() {
    return kColorGreyCC;
  }

  double radius() {
    return 8.0;
  }

  Color backgroundColor() {
    return Colors.white;
  }

  Color contentBackgroundColor() {
    return Colors.white;
  }

  Color bottomBarBackgroundColor() {
    return Colors.white;
  }

  double? contentHeight() {
    return null;
  }

  bool dismissible() {
    return true;
  }

  void show() {
    showModalBottomSheet(
        context: kContext,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: backgroundColor(),
        isDismissible: dismissible(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius()), // 设置为0.0去除左上角圆角
            topRight: Radius.circular(radius()), // 设置为0.0去除右上角圆角
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: min(
                maxHeight(),
                contentHeight() != null
                    ? (contentHeight()! +
                        (titleHeight() ?? 0) +
                        kBottomBarHeight)
                    : maxHeight()),
            child: Column(
              children: [
                titleHeight() != null
                    ? Column(
                        children: [
                          Container(
                            width: 414.w,
                            height: titleHeight()! - 1,
                            decoration: BoxDecoration(
                                color: titleBackgroundColor(),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(radius()),
                                    topRight: Radius.circular(radius()))),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  title(),
                                  style: titleTextStyle(),
                                ),
                                Positioned(
                                  right: 12.w,
                                  child: GestureDetector(
                                    onTap: () => Get.back(),
                                    child: SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: Image.asset(
                                          R.assetsImgIcNavCloseBlack),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 414.w,
                            height: 0.5,
                            color: seperatorColor(),
                          )
                        ],
                      )
                    : Container(),
                Container(
                    color: contentBackgroundColor(),
                    height: contentHeight() != null
                        ? contentHeight()! + kBottomBarHeight
                        : maxHeight() - (titleHeight() ?? 0),
                    child: SingleChildScrollView(
                        child: Column(
                      children: contentWidgets() +
                          [
                            Container(
                              height: kBottomBarHeight,
                              color: bottomBarBackgroundColor(),
                            )
                          ],
                    )))
              ],
            ),
          );
        });
  }
}

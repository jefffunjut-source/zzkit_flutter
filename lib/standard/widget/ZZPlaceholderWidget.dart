// ignore_for_file: must_be_immutable, file_names, unnecessary_library_name
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZNoDataWidget extends StatelessWidget {
  Image? placeholderImage;
  String? hintText;
  TextStyle? hintTextStyle;
  String? buttonText;
  Color? buttonBgColor;
  TextStyle? buttonTextStyle;
  Color? bgColor;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? placeholderImagePadding;
  EdgeInsetsGeometry? hintTextPadding;
  EdgeInsetsGeometry? reloadPadding;
  VoidCallback? onReloadTap;
  MainAxisSize mainAxisSize;

  ZZNoDataWidget({
    super.key,
    this.placeholderImage,
    this.hintText,
    this.hintTextStyle,
    this.buttonText,
    this.buttonBgColor,
    this.buttonTextStyle,
    this.bgColor,
    this.padding = const EdgeInsets.only(
      left: 24,
      right: 24,
      top: 24,
      bottom: 24,
    ),
    this.placeholderImagePadding = const EdgeInsets.only(left: 36, right: 36),
    this.hintTextPadding = const EdgeInsets.only(top: 36),
    this.reloadPadding = const EdgeInsets.only(top: 36, bottom: 24),
    this.onReloadTap,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    if (mainAxisSize == MainAxisSize.min) {
      return minWidget();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(width: 1, height: 1),
          minWidget(),
          const SizedBox(width: 1, height: 1),
        ],
      );
    }
  }

  Widget minWidget() {
    return Container(
      color: bgColor ?? Colors.white,
      width: 414.w,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: bgColor ?? Colors.white,
            padding: placeholderImagePadding,
            child:
                placeholderImage ??
                ZZ.image(
                  R.assetsImgIcPlaceholderNoData,
                  bundleName: zzBundleName,
                  fit: BoxFit.fitWidth,
                ),
          ),
          Container(
            color: bgColor ?? Colors.white,
            alignment: Alignment.center,
            padding: hintTextPadding,
            child: Text(
              hintText ?? "没有数据",
              style:
                  hintTextStyle ??
                  ZZ.textStyle(
                    color: ZZColor.grey99,
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
            ),
          ),
          onReloadTap != null
              ? Container(
                color: bgColor ?? Colors.white,
                padding: reloadPadding,
                child: GestureDetector(
                  onTap: onReloadTap,
                  child: Container(
                    alignment: Alignment.center,
                    color: buttonBgColor ?? ZZColor.red.withAlpha(10),
                    width: 96.w,
                    height: 36.w,
                    child: Text(
                      buttonText ?? "重新加载",
                      style:
                          buttonTextStyle ??
                          ZZ.textStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
              : Container(),
        ],
      ),
    );
  }
}

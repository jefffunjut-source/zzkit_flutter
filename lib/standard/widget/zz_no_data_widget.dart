import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/zz_const.dart';
import 'package:zzkit_flutter/util/zz_manager.dart';

class ZZNoDataWidget extends StatelessWidget {
  final Image? placeholderImage;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final String? buttonText;
  final Color? buttonBgColor;
  final TextStyle? buttonTextStyle;
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? placeholderImagePadding;
  final EdgeInsetsGeometry? hintTextPadding;
  final EdgeInsetsGeometry? reloadPadding;
  final VoidCallback? onReloadTap;
  final MainAxisSize mainAxisSize;
  final double? width;

  const ZZNoDataWidget({
    super.key,
    this.placeholderImage,
    this.hintText,
    this.hintTextStyle,
    this.buttonText,
    this.buttonBgColor,
    this.buttonTextStyle,
    this.bgColor,
    this.padding = const EdgeInsets.all(24),
    this.placeholderImagePadding = const EdgeInsets.symmetric(horizontal: 36),
    this.hintTextPadding = const EdgeInsets.only(top: 36),
    this.reloadPadding = const EdgeInsets.only(top: 36, bottom: 24),
    this.onReloadTap,
    this.mainAxisSize = MainAxisSize.max,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: mainAxisSize,
      children: [
        Padding(
          padding: placeholderImagePadding!,
          child:
              placeholderImage ??
              ZZ.image(
                R.assetsImgIcPlaceholderNoData,
                bundleName: zzBundleName,
                fit: BoxFit.fitWidth,
              ),
        ),
        Padding(
          padding: hintTextPadding!,
          child: Text(
            hintText ?? "没有数据",
            style:
                hintTextStyle ??
                ZZ.textStyle(
                  color: ZZColor.grey99,
                  fontSize: 14.sp,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        if (onReloadTap != null)
          Padding(
            padding: reloadPadding!,
            child: GestureDetector(
              onTap: onReloadTap,
              child: Container(
                alignment: Alignment.center,
                width: 96.w,
                height: 36.w,
                color: buttonBgColor ?? ZZColor.red.withAlpha(10),
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
          ),
      ],
    );

    return Container(
      width: width ?? double.infinity,
      padding: padding,
      color: bgColor ?? Colors.white,
      child: content,
    );
  }
}

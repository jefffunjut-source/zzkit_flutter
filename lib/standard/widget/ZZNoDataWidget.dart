// ignore_for_file: must_be_immutable, file_names
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class ZZNoDataWidget extends StatelessWidget {
  bool? nodata;
  String? hintText;
  String? img;
  Color? bgColor;
  double paddingTop;
  double paddingBottom;
  double marginLeft;
  double marginRight;
  MainAxisSize mainAxisSize;
  VoidCallback? onTap;

  ZZNoDataWidget(
      {super.key,
      this.nodata = false,
      this.bgColor,
      this.hintText,
      this.img,
      this.paddingTop = 24,
      this.paddingBottom = 24,
      this.marginLeft = 0,
      this.marginRight = 0,
      this.mainAxisSize = MainAxisSize.max,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    if (nodata!) {
      return Container(
        color: bgColor ?? Colors.white,
        width: 414.w,
        margin: EdgeInsets.only(
          left: marginLeft,
          right: marginRight,
        ),
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: paddingTop,
          bottom: paddingBottom,
        ),
        child: Column(
          mainAxisSize: mainAxisSize,
          children: [
            ZZ.image(R.assetsImgIcPlaceholderNoData,
                    bundleName: zzBundleName) ??
                Container(),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.only(top: 24.w, bottom: 24.w),
                child: Text(
                  hintText ?? "重新加载",
                  style: ZZ.textStyle(
                      color: zzColorRed, fontSize: 14.sp, bold: true),
                  strutStyle: const StrutStyle(height: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return ZZ.empty();
    }
  }
}

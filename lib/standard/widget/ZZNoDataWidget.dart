// ignore_for_file: must_be_immutable, file_names
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZNoDataWidget extends StatelessWidget {
  bool? nodata;
  String? hintText;
  String? img;
  Color? bgColor;
  EdgeInsetsGeometry? padding;
  MainAxisSize mainAxisSize;
  VoidCallback? onTap;

  ZZNoDataWidget(
      {super.key,
      this.nodata = false,
      this.hintText,
      this.img,
      this.bgColor,
      this.padding =
          const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
      this.mainAxisSize = MainAxisSize.max,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    if (nodata == true) {
      return Container(
        color: bgColor ?? Colors.white,
        width: 414.w,
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: mainAxisSize,
          children: [
            ZZ.image(R.assetsImgIcPlaceholderNoData,
                    bundleName: zzBundleName,
                    width: 300.w,
                    fit: BoxFit.fitWidth) ??
                Container(),
            GestureDetector(
              onTap: onTap,
              child: Container(
                alignment: Alignment.center,
                color: zzColorRed.withAlpha(5),
                width: 96.w,
                height: 24.w,
                child: Text(
                  "重新加载",
                  style: ZZ.textStyle(
                      color: zzColorRed,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

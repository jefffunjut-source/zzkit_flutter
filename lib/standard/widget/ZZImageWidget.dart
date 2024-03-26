// ignore_for_file: file_names, must_be_immutable

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class ZZImageWidget extends StatelessWidget {
  String? url;
  Uint8List? base64;
  Image? placeholderImage;
  BoxFit? fit;
  // 指定width、height后按照参数大小显示，否则自适应
  // 设置圆角等参数时候，必须指定width和height才生效
  double? width;
  double? height;
  double? radius;
  Color? bottomColor;
  double? bottomHeight;
  String? bottomTitle;
  TextStyle? bottomTitleStyle;
  int? index;
  Object? extra;
  ZZAppCallback1Int1Object? onTap;

  ZZImageWidget(
      {super.key,
      this.url,
      this.base64,
      this.placeholderImage,
      this.fit,
      this.width,
      this.height,
      this.radius,
      this.bottomColor,
      this.bottomHeight,
      this.bottomTitle,
      this.bottomTitleStyle,
      this.index,
      this.extra,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!(index, extra);
          }
        },
        child: mainWidget(),
      );
    } else {
      return mainWidget();
    }
  }

  Widget mainWidget() {
    if (url != null && url!.contains("http")) {
      // url形式
      return CachedNetworkImage(
          width: width,
          height: height,
          fit: fit,
          imageUrl: url!,
          placeholder: (context, url) {
            return Container(
              width: width,
              height: width,
              color: zzColorClear,
              child: Center(
                child: CupertinoActivityIndicator(
                  radius: min(14.0, (width ?? double.infinity) / 5.0),
                ),
              ),
            );
          },
          errorWidget: (context, url, e) {
            return Center(
              child: placeholderImage ??
                  ZZ.image(R.assetsImgIcPlaceholderImage,
                      bundleName: zzBundleName),
            );
          });
    } else if (base64 != null) {
      // base64形式
      return Image.memory(
        base64!,
        fit: fit,
        width: width,
        height: height,
      );
    }
    // Placeholder
    if (placeholderImage != null) {
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: placeholderImage,
        ),
      );
    } else {
      return Container();
    }
  }
}

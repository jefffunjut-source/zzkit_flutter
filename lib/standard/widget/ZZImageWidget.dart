// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';

class ZZRoundClipper extends CustomClipper<RRect> {
  double? width;
  double? height;
  double? radius;

  @override
  RRect getClip(size) {
    return RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, width ?? 0, height ?? 0),
        Radius.circular(radius ?? 0));
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) {
    return false;
  }
}

class ZZImageWidget extends StatelessWidget {
  String? url;
  Uint8List? base64;
  String? placeholderImage;
  BoxFit? fit;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  // 指定width、height后按照参数大小显示，否则自适应
  // 设置圆角等参数时候，必须指定width和height才生效
  double? width;
  double? height;
  double? borderWidth;
  Color? borderColor;
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
      this.margin,
      this.padding,
      this.width,
      this.height,
      this.borderWidth,
      this.borderColor,
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
    Widget mainWidget = getWidget();
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(index, extra);
        }
      },
      child: mainWidget,
    );
  }

  Widget getWidget() {
    ZZRoundClipper? clipper;
    if (width != null && height != null) {
      clipper = ZZRoundClipper();
      clipper.width = width!;
      clipper.height = height!;
      clipper.radius = radius;
    }
    if (url != null && url!.contains("http")) {
      return Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
            border: Border.all(
                color: borderColor ?? kColorTransparent,
                width: borderWidth ?? 0),
            borderRadius:
                BorderRadius.circular((radius ?? 0) + (borderWidth ?? 0)),
            color: kColorTransparent),
        child: ClipRRect(
          clipper: clipper,
          child: Stack(children: [
            (width != null && height != null)
                ? CachedNetworkImage(
                    width: width,
                    height: height,
                    fit: fit,
                    imageUrl: url!,
                    placeholder: (context, url) {
                      return Container(
                        color: kColorTransparent,
                        child: const SizedBox(
                            child: Center(
                          child: CupertinoActivityIndicator(
                            radius: 14,
                          ),
                        )),
                      );
                    },
                    errorWidget: (context, url, e) {
                      return Center(
                        child: Image.asset(R.assetsImgIcPlaceholderImage
                                .addPrefix(kAssetImagePrefixName) ??
                            ""),
                      );
                    })
                : CachedNetworkImage(
                    fit: fit,
                    imageUrl: url!,
                    placeholder: (context, url) {
                      return Container(
                        color: kColorTransparent,
                        child: const SizedBox(
                            child: Center(
                          child: CupertinoActivityIndicator(
                            radius: 14,
                          ),
                        )),
                      );
                    },
                    errorWidget: (context, url, e) {
                      return Center(
                        child: Image.asset(R.assetsImgIcPlaceholderImage
                                .addPrefix(kAssetImagePrefixName) ??
                            ""),
                      );
                    }),
            Positioned(
                bottom: 0,
                child: Container(
                  width: width,
                  height: bottomHeight ?? ((height ?? 0) / 4),
                  color: bottomColor,
                  child: Center(
                    child: Text(
                      bottomTitle ?? "",
                      style: bottomTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
          ]),
        ),
      );
    } else {
      if (placeholderImage != null && placeholderImage!.isNotEmpty) {
        return Container(
            margin: margin,
            padding: padding,
            decoration: BoxDecoration(
                border: Border.all(
                    color: borderColor ?? kColorTransparent,
                    width: borderWidth ?? 0),
                borderRadius:
                    BorderRadius.circular((radius ?? 0) + (borderWidth ?? 0)),
                color: kColorTransparent),
            child: (width != null && height != null)
                ? ClipRRect(
                    clipper: clipper,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        base64 != null
                            ? Image.memory(
                                base64!,
                                fit: fit,
                                width: width,
                                height: height,
                              )
                            : Image(
                                image: AssetImage(placeholderImage!),
                                fit: fit,
                                width: width,
                                height: height,
                              ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              width: width,
                              height: bottomHeight ?? ((height ?? 0) / 4),
                              color: bottomColor,
                              child: Center(
                                child: Text(
                                  bottomTitle ?? "",
                                  style: bottomTitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ))
                      ],
                    ))
                : Center(
                    child: Image(image: AssetImage(placeholderImage!)),
                  ));
      }
      return Container();
    }
  }
}

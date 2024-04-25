// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'dart:math';
import 'dart:ui' as ui show Image;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

double get maxDragOffset => 100;
double hideHeight = maxDragOffset / 2.3;
double refreshHeight = maxDragOffset / 1.5;

class ZZPullToRefreshHeader extends StatelessWidget {
  const ZZPullToRefreshHeader(
    this.info, {
    super.key,
    this.color,
    this.refreshingIdleText,
    this.refreshingReleaseText,
    this.refreshingText,
    this.refreshingCompleteText,
  });

  final PullToRefreshScrollNotificationInfo? info;
  final Color? color;
  final String? refreshingIdleText;
  final String? refreshingReleaseText;
  final String? refreshingText;
  final String? refreshingCompleteText;

  @override
  Widget build(BuildContext context) {
    final PullToRefreshScrollNotificationInfo? _info = info;
    if (_info == null) {
      return Container();
    }
    String text = '';
    if (_info.mode == PullToRefreshIndicatorMode.armed) {
      text = refreshingReleaseText ?? zzRefreshingReleaseText;
    } else if (_info.mode == PullToRefreshIndicatorMode.refresh ||
        _info.mode == PullToRefreshIndicatorMode.snap) {
      text = refreshingText ?? zzRefreshingText;
    } else if (_info.mode == PullToRefreshIndicatorMode.done) {
      text = refreshingCompleteText ?? zzRefreshingCompleteText;
    } else if (_info.mode == PullToRefreshIndicatorMode.drag) {
      text = refreshingIdleText ?? zzRefreshingIdleText;
    } else if (_info.mode == PullToRefreshIndicatorMode.canceled) {
      text = zzRefreshingCancelRefreshText;
    }

    final double dragOffset = info?.dragOffset ?? 0.0;

    final double top = -hideHeight + dragOffset;
    return Container(
      height: dragOffset,
      color: color ?? Colors.transparent,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            right: 0.0,
            top: top,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 12.0),
                    child: ZZRefreshImage(top),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(text,
                        style:
                            ZZ.textStyle(color: Colors.grey, fontSize: 14.sp)),
                  ],
                ),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ZZRefreshImage extends StatelessWidget {
  const ZZRefreshImage(this.top, {super.key});

  final double top;

  @override
  Widget build(BuildContext context) {
    const double imageSize = 0;
    return ExtendedImage.asset(
      R.assetsImgIcTransparent.addPrefix(zzBundleName),
      width: imageSize,
      height: imageSize,
      afterPaintImage: (Canvas canvas, Rect rect, ui.Image image, Paint paint) {
        final double imageHeight = image.height.toDouble();
        final double imageWidth = image.width.toDouble();
        final Size size = rect.size;
        final double y =
            (1 - min(top / (refreshHeight - hideHeight), 1)) * imageHeight;

        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0.0, y, imageWidth, imageHeight - y),
          Rect.fromLTWH(rect.left, rect.top + y / imageHeight * size.height,
              size.width, (imageHeight - y) / imageHeight * size.height),
          Paint()
            ..colorFilter =
                const ColorFilter.mode(Color(0xFFea5504), BlendMode.srcIn)
            ..isAntiAlias = false
            ..filterQuality = FilterQuality.low,
        );

        //canvas.restore();
      },
    );
  }
}

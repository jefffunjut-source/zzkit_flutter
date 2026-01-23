import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/standard/widget/zz_outer_radius_widget.dart';
import 'package:zzkit_flutter/util/zz_const.dart';
import 'package:zzkit_flutter/util/zz_manager.dart';

class ZZNoticeController extends GetxController {
  RxString noticeNumber = "".obs;
  RxBool highlighted = false.obs;
}

class ZZNoticeWidget extends StatefulWidget {
  final Image? noticeImage;
  final Image? highlightedNoticeImage;
  final Color? pointBackgroundColor;
  final Color? highlightedPointBackgroundColor;
  final TextStyle? textStyle;
  final TextStyle? highlightedTextStyle;
  final Color? borderColor;
  final Color? highlightedBorderColor;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final double? noticeXFromCenter;
  final double? noticeYFromCenter;

  const ZZNoticeWidget({
    super.key,
    this.noticeImage,
    this.highlightedNoticeImage,
    this.pointBackgroundColor,
    this.highlightedPointBackgroundColor,
    this.textStyle,
    this.highlightedTextStyle,
    this.borderColor,
    this.highlightedBorderColor,
    this.width,
    this.height,
    this.backgroundColor,
    this.noticeXFromCenter,
    this.noticeYFromCenter,
  });

  @override
  State<ZZNoticeWidget> createState() => _ZZNoticeWidgetState();
}

class _ZZNoticeWidgetState extends State<ZZNoticeWidget> {
  late final double width;
  late final double height;

  @override
  void initState() {
    super.initState();
    width = widget.width ?? 64.w;
    height = widget.height ?? 44.w;
  }

  @override
  Widget build(BuildContext context) {
    final ZZNoticeController controller = Get.find();

    return Obx(() {
      final noticeText = controller.noticeNumber.value.trim();
      final isHighlighted = controller.highlighted.value;

      return Container(
        width: width,
        height: height,
        color: widget.backgroundColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 图片显示逻辑
            if (widget.noticeImage != null ||
                widget.highlightedNoticeImage != null)
              isHighlighted
                  ? (widget.highlightedNoticeImage ?? widget.noticeImage!)
                  : (widget.noticeImage ?? widget.highlightedNoticeImage!)
            else
              ZZ.image(R.assetsImgIcNavNotice, bundleName: zzBundleName)!,

            // 红点/数字显示
            if (noticeText.isNotEmpty)
              Positioned(
                left: width / 2 + (widget.noticeXFromCenter ?? 2),
                top: height / 2 - (widget.noticeYFromCenter ?? 16),
                child: ZZOuterRadiusWidget(
                  radius: 7.w,
                  color:
                      isHighlighted
                          ? widget.highlightedPointBackgroundColor
                          : (widget.pointBackgroundColor ?? Colors.red),
                  borderColor:
                      isHighlighted
                          ? (widget.highlightedBorderColor ?? Colors.red)
                          : (widget.borderColor ?? Colors.red),
                  child: Container(
                    height: 14.w,
                    width: noticeText.length <= 1 ? 14.w : null,
                    padding:
                        noticeText.length <= 1
                            ? null
                            : EdgeInsets.symmetric(horizontal: 4.w),
                    alignment: Alignment.center,
                    child: Text(
                      noticeText.length > 2 ? "···" : noticeText,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style:
                          isHighlighted
                              ? widget.highlightedTextStyle
                              : (widget.textStyle ??
                                  ZZ.textStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  )),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

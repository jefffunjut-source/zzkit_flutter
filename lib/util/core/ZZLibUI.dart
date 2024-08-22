// ignore_for_file: file_names

part of 'ZZManager.dart';

class ZZUrlAnalysisResult {
  final String category;
  final String value;

  ZZUrlAnalysisResult(this.category, this.value);

  @override
  String toString() {
    return 'Category: $category, Value: $value';
  }
}

extension ZZLibUI on ZZManager {
  /// 渐变颜色
  Gradient grandientColor(
      {required Color beginColor,
      required Color endColor,
      required Alignment beginAlign,
      required Alignment endAlign}) {
    return LinearGradient(
      colors: [beginColor, endColor],
      begin: beginAlign,
      end: endAlign,
    );
  }

  /// 随机色
  Color randomColor() {
    return Color.fromRGBO(
        Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);
  }

  /// 文本TextStyle
  TextStyle textStyle({
    required Color color,
    required double fontSize,
    String? fontFamily,
    FontWeight? fontWeight,
    double height = 1.0,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        height: height,
        decoration: decoration);
  }

  TextSpan textSpan(String text, TextStyle textStyle) {
    return TextSpan(text: text, style: textStyle);
  }

  /// Toast
  void toast(String? msg, {int duration = 2, bool fromSnackBar = false}) {
    if (msg != null && msg != "") {
      if (fromSnackBar) {
        ScaffoldMessenger.of(zzContext).showSnackBar(
          SnackBar(
            content: Text(msg),
            duration: Duration(seconds: duration),
          ),
        );
      } else {
        EasyLoading.showToast(msg, duration: Duration(seconds: duration));
      }
    }
  }

  /// 图片
  Image? image(String? asset,
      {String? bundleName,
      double? width,
      double? height,
      BoxFit? fit,
      AlignmentGeometry alignment = Alignment.center}) {
    if (asset == null || asset.isEmpty) {
      debugPrint("ZZImage:asset == null");
      return null;
    }
    if (bundleName != null && bundleName.isNotEmpty) {
      debugPrint("ZZImage:bundle=$bundleName,asset=$asset");
      return Image.asset(
        asset.addPrefix(bundleName),
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
      );
    } else {
      debugPrint("ZZImage:asset=$asset");
      return Image.asset(
        asset,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
      );
    }
  }

  String? appbarIconString(ZZNavBarIcon? icon) {
    switch (icon) {
      case ZZNavBarIcon.none:
        return null;
      case ZZNavBarIcon.backblack:
        return R.assetsImgIcNavBackBlack;
      case ZZNavBarIcon.backwhite:
        return R.assetsImgIcNavBackWhite;
      case ZZNavBarIcon.closeblack:
        return R.assetsImgIcNavCloseBlack;
      default:
        return R.assetsImgIcNavBackBlack;
    }
  }

  /// 通用Appbar
  AppBar appbar(
      {Color? backgroundColor = Colors.white,
      String? title,
      Widget? titleWidget,
      TextStyle? titleStyle = const TextStyle(
        color: Color(0xFF000000),
        fontFamily: "CircularBold",
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      bool? centerTitle = true,
      double? titleSpacing = 0,
      List<Widget>? actions,
      PreferredSizeWidget? bottom,
      double? elevation = 0,
      Color? surfaceTintColor,
      bool automaticallyImplyLeading = true,
      ZZNavBarIcon? leftIcon = ZZNavBarIcon.backblack,
      VoidCallback? onLeftIconTap,
      VoidCallback? onTitleDoubleTap}) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: titleWidget ??
          (title != null
              ? (onTitleDoubleTap != null
                  ? GestureDetector(
                      onDoubleTap: () => onTitleDoubleTap(),
                      child: Text(
                        title,
                        style: titleStyle,
                      ),
                    )
                  : Text(
                      title,
                      style: titleStyle,
                    ))
              : null),
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      bottom: bottom,
      elevation: elevation,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: appbarIconString(leftIcon) == null
          ? Container()
          : GestureDetector(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: ZZ.image(appbarIconString(leftIcon)!,
                    bundleName: zzBundleName, width: 48.w),
              ),
              onTap: () {
                if (onLeftIconTap != null) {
                  onLeftIconTap();
                } else {
                  if (Navigator.of(zzContext).canPop()) {
                    Navigator.of(zzContext).pop();
                  }
                }
              },
            ),
      actions: actions,
    );
  }

  /// 通用Tabbar RoundedRectangle
  TabBar tabbarRoundedRectangle({
    required List<String> tabs,
    required TabController? controller,
    ValueChanged<int>? onTap,
    Color? indicatorColor = ZZColor.orange,
    double? indicatorRadius,
    Gradient? indicatorGradient,
    EdgeInsetsGeometry? indicatorPadding,
    Color? labelColor,
    Color? unselectedLabelColor,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    bool? isScrollable,
    TabAlignment? tabAlignment,
  }) {
    if (indicatorColor == null && indicatorGradient == null) {
      indicatorGradient = ZZColor.gradientOrangeEnabled;
    }
    return TabBar(
      onTap: onTap,
      dividerHeight: 0,
      tabAlignment: isScrollable == true
          ? (tabAlignment == TabAlignment.fill
              ? TabAlignment.start
              : (tabAlignment ?? TabAlignment.start))
          : (tabAlignment ?? TabAlignment.start),
      isScrollable: isScrollable ?? true,
      tabs: tabs
          .map((e) => Tab(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
                  child: Text(
                    e,
                  ),
                ),
              ))
          .toList(),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(indicatorRadius ?? 22.w),
        color: indicatorColor,
        gradient: indicatorGradient,
      ),
      indicatorPadding: indicatorPadding ??
          EdgeInsets.only(top: 6.w, bottom: 10.w, left: 0.w, right: 0.w),
      labelColor: labelColor ?? (labelStyle == null ? Colors.white : null),
      unselectedLabelColor: unselectedLabelColor ??
          (unselectedLabelStyle == null ? ZZColor.dark : null),
      labelStyle: labelColor == null
          ? (labelStyle ??
              ZZ.textStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold))
          : null,
      unselectedLabelStyle: unselectedLabelColor == null
          ? (unselectedLabelStyle ??
              ZZ.textStyle(color: Colors.white, fontSize: 14.sp))
          : null,
      controller: controller,
    );
  }

  TabBar tabbarUnderline({
    required List<String> tabs,
    required TabController? controller,
    ValueChanged<int>? onTap,
    Color? indicatorColor = ZZColor.orange,
    double? indicatorRadius,
    Gradient? indicatorGradient,
    EdgeInsetsGeometry? indicatorPadding,
    double? indicatorWeight,
    Color? labelColor,
    Color? unselectedLabelColor,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    bool? isScrollable,
    TabAlignment? tabAlignment,
    List<String>? redTabs,
  }) {
    if (indicatorColor == null && indicatorGradient == null) {
      indicatorGradient = ZZColor.gradientOrangeEnabled;
    }
    return TabBar(
      onTap: onTap,
      dividerHeight: 0,
      tabAlignment: isScrollable == true
          ? (tabAlignment == TabAlignment.fill
              ? TabAlignment.start
              : (tabAlignment ?? TabAlignment.start))
          : (tabAlignment ?? TabAlignment.start),
      isScrollable: isScrollable ?? true,
      tabs: tabs
          .map((e) => Tab(
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      Text(e),
                      redTabs?.contains(e) == true
                          ? ZZOuterRadiusWidget(
                              margin: const EdgeInsets.only(left: 6),
                              radius: 6,
                              child: Container(
                                width: 6,
                                height: 6,
                                color: ZZColor.red,
                              ))
                          : Container()
                    ],
                  ),
                ),
              ))
          .toList(),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(indicatorRadius ?? 6.w),
        color: indicatorColor,
        gradient: indicatorGradient,
      ),
      indicatorPadding: indicatorPadding ??
          EdgeInsets.only(top: 35.w, bottom: 8.w, left: 2.w, right: 2.w),
      indicatorWeight: indicatorWeight ?? 4.w,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: labelColor ?? (labelStyle == null ? ZZColor.dark : null),
      unselectedLabelColor: unselectedLabelColor ??
          (unselectedLabelStyle == null ? ZZColor.grey66 : null),
      labelStyle: labelColor == null
          ? (labelStyle ??
              ZZ.textStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold))
          : null,
      unselectedLabelStyle: unselectedLabelColor == null
          ? (unselectedLabelStyle ??
              ZZ.textStyle(color: Colors.white, fontSize: 14.sp))
          : null,
      controller: controller,
    );
  }

  ZZUrlAnalysisResult _analyzeUrl(String url) {
    if (url.contains("https://www.55haitaoshop.com/store/")) {
      String v = url.replaceFirst("https://www.55haitaoshop.com/store/", "");
      v = v.replaceFirst(".html", "");
      v = v.replaceFirst("/", "");
      if (v.isNotEmpty) {
        return ZZUrlAnalysisResult("store", v);
      }
    } else if (url.contains("https://www.55haitaoshop.com/topic/")) {
      String v = url.replaceFirst("https://www.55haitaoshop.com/topic/", "");
      v = v.replaceFirst(".html", "");
      v = v.replaceFirst("/", "");
      if (v.isNotEmpty) {
        return ZZUrlAnalysisResult("topic", v);
      }
    } else if (url.contains("https://www.55haitaoshop.com/deals/")) {
      String v = url.replaceFirst("https://www.55haitaoshop.com/deals/", "");
      v = v.replaceFirst(".html", "");
      v = v.replaceFirst("/", "");
      if (v.isNotEmpty) {
        return ZZUrlAnalysisResult("deals", v);
      }
    }
    return ZZUrlAnalysisResult("", ""); // 处理不匹配的情况
  }

  Widget customMarkdownBody(String content) {
    return MarkdownBody(
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(zzContext)).copyWith(
        a: const TextStyle(
            color: Color(0xFF333333),
            decoration: TextDecoration.underline,
            fontSize: 14,
            height: 1.8),
        p: const TextStyle(color: Color(0xFF333333), fontSize: 14, height: 1.6),
        pPadding: EdgeInsets.only(top: 2.w),
        listIndent: 15.w,
        strong: const TextStyle(color: Color(0xFF333333), fontSize: 14),
        del: const TextStyle(color: Color(0xFF333333), fontSize: 14),
        em: const TextStyle(color: Color(0xFF333333), fontSize: 14),
      ),
      styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
      data: content,
      onTapLink: (text, href, title) {
        if (href != null) {
          ZZUrlAnalysisResult res = _analyzeUrl(href);
          if (res.category == "deals") {
          } else if (res.category == "topic") {
          } else if (res.category == "store") {
          } else {
            if (!href.contains("http")) {
              href = "https://$href";
            }
          }
        }
      },
    );
  }

  /// 展示
  void show({String? message = "loading..."}) {
    EasyLoading.show(status: message);
  }

  /// 隐藏
  void dismiss({VoidCallback? finished}) {
    EasyLoading.dismiss();
    if (finished != null) {
      Future.delayed(const Duration(milliseconds: 200), () {
        finished();
      });
    }
  }

  /// iOS风格的底部弹框
  Future<String?> showBottomSheet({
    String? title,
    List<String>? items,
    TextStyle? titleStyle,
    TextStyle? itemTextStyle,
    TextStyle? cancelTextStyle,
  }) {
    List<Widget> widgets = [];
    if (!ZZ.isNullOrEmpty(title)) {
      widgets.add(ZZOuterRadiusWidget(
          radiusTopLeft: 12.w,
          radiusTopRight: 12.w,
          child: _bottomSheetItemWidget(title!, titleStyle, () {})));
      widgets.add(Container(
        height: .5,
        color: Colors.grey[300],
      ));
    }

    if (items != null && items.isNotEmpty) {
      for (var element in items) {
        if (element == items.first && element == items.last) {
          if (!ZZ.isNullOrEmpty(title)) {
            widgets.add(ZZOuterRadiusWidget(
                radiusBottomLeft: 12.w,
                radiusBottomRight: 12.w,
                child: _bottomSheetItemWidget(element, itemTextStyle, null)));
          } else {
            widgets.add(ZZOuterRadiusWidget(
                radius: 12.w,
                child: _bottomSheetItemWidget(element, itemTextStyle, null)));
          }
        } else if (element == items.first) {
          if (!ZZ.isNullOrEmpty(title)) {
            widgets.add(_bottomSheetItemWidget(element, itemTextStyle, null));
          } else {
            widgets.add(ZZOuterRadiusWidget(
                radiusTopLeft: 12.w,
                radiusTopRight: 12.w,
                child: _bottomSheetItemWidget(element, itemTextStyle, null)));
          }
        } else if (element == items.last) {
          widgets.add(Container(
            height: .5,
            color: Colors.grey[300],
          ));
          widgets.add(ZZOuterRadiusWidget(
              radiusBottomLeft: 12.w,
              radiusBottomRight: 12.w,
              child: _bottomSheetItemWidget(element, itemTextStyle, null)));
        } else {
          widgets.add(Container(
            height: .5,
            color: Colors.grey[300],
          ));
          widgets.add(_bottomSheetItemWidget(element, itemTextStyle, null));
        }
      }
    }
    widgets.add(Container(
      height: 12.w,
      color: Colors.transparent,
    ));

    widgets.add(ZZOuterRadiusWidget(
        margin: EdgeInsets.only(bottom: zzBottomBarHeight),
        radius: 12.w,
        child: _bottomSheetItemWidget("取消", itemTextStyle, null)));

    return showCupertinoModalPopup(
      context: zzContext,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(left: 12.w, right: 12.w),
          child: Wrap(alignment: WrapAlignment.center, children: widgets),
        );
      },
    );
  }

  Widget _bottomSheetItemWidget(
      String element, TextStyle? textStyle, GestureTapCallback? onTap) {
    return Container(
      alignment: Alignment.center,
      height: 64.w,
      color: Colors.white,
      child: ListTile(
        title: Text(
          textAlign: TextAlign.center,
          element,
          style: textStyle ??
              TextStyle(
                fontWeight: ui.FontWeight.w500,
                fontSize: 16.sp,
                color: Colors.black87,
              ),
        ),
        onTap: () {
          if (onTap != null) {
            onTap();
          } else {
            Navigator.pop(zzContext, element);
          }
        },
      ),
    );
  }

  /// 全屏截图
  Future<Uint8List?> captureFullScreen({
    required GlobalKey globalKey,
    double pixelRatio = 3.0,
  }) async {
    try {
      // 获取 RepaintBoundary 的 RenderRepaintBoundary
      RenderRepaintBoundary boundary =
          globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

      // 将 RenderRepaintBoundary 转换为图像
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

      // 将图像转换为字节数据
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      // 返回字节数据
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error capturing screenshot: $e");
      return null;
    }
  }
}

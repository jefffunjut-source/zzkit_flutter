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

  List<TextSpan> changeBackText(
      List<String> text, TextStyle highlightedStyle, TextStyle normalStyle) {
    List<TextSpan> widgetArr = [];
    // 返利数值
    widgetArr.add(textSpan(text[0], highlightedStyle));
    // 空格
    widgetArr.add(textSpan(" ", normalStyle));
    // 返利
    widgetArr.add(textSpan(text[1], normalStyle));
    widgetArr.add(textSpan(text[2], normalStyle));

    return widgetArr;
  }

  List<TextSpan> changeBackText2(List<String?> cashBack,
      TextStyle highlightedStyle, TextStyle normalStyle) {
    List<TextSpan> widgetArr = [];
    // List<String> result = splitRebateDesc(text);
    // 返利数值
    if (cashBack[0] != null && cashBack[0]!.isNotEmpty) {
      widgetArr.add(textSpan(cashBack[0]!, highlightedStyle));
      // 空格
      widgetArr.add(textSpan(" ", normalStyle));
    }
    // max
    if (cashBack[1] != null && cashBack[1]!.isNotEmpty) {
      widgetArr.add(textSpan(cashBack[1]!, normalStyle));
      // 空格
      widgetArr.add(textSpan(" ", normalStyle));
    }
    // cash back
    if (cashBack[2] != null && cashBack[2]!.isNotEmpty) {
      widgetArr.add(textSpan(cashBack[2]!, normalStyle));
    }
    return widgetArr;
  }

  TextSpan textSpan(String text, TextStyle textStyle) {
    return TextSpan(text: text, style: textStyle);
  }

  /// Toast
  void toast(String? msg, {int duration = 2}) {
    if (msg != null && msg != "") {
      EasyLoading.showToast(msg, duration: Duration(seconds: duration));
    }
  }

  /// 空格控件
  Widget space(
      {Color color = Colors.transparent,
      double width = 10,
      double height = 10}) {
    return Container(
      width: width,
      height: height,
      color: color,
    );
  }

  Widget empty() {
    return const SizedBox(width: 0, height: 0);
  }

  Widget line({double? width}) {
    return Container(
        height: 1.w / 2, width: width, color: const Color(0xFFE6E6E6));
  }

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

  Widget outerBorderRadious(
      {required Widget widget,
      double? borderWidth,
      Color? borderColor,
      double? radius,
      double? radiusTopLeft,
      double? radiusTopRight,
      double? radiusBottomLeft,
      double? radiusBottomRight,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding,
      Color? color,
      AlignmentGeometry? alignment,
      VoidCallback? onTap,
      bool debug = false}) {
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: _outerBorderRadious(
            widget: widget,
            borderWidth: borderWidth,
            borderColor: borderColor,
            radius: radius,
            radiusTopLeft: radiusTopLeft,
            radiusTopRight: radiusTopRight,
            radiusBottomLeft: radiusBottomLeft,
            radiusBottomRight: radiusBottomRight,
            margin: margin,
            padding: padding,
            color: color,
            alignment: alignment,
            debug: debug),
      );
    } else {
      return _outerBorderRadious(
          widget: widget,
          borderWidth: borderWidth,
          borderColor: borderColor,
          radius: radius,
          radiusTopLeft: radiusTopLeft,
          radiusTopRight: radiusTopRight,
          radiusBottomLeft: radiusBottomLeft,
          radiusBottomRight: radiusBottomRight,
          margin: margin,
          padding: padding,
          color: color,
          alignment: alignment,
          debug: debug);
    }
  }

  Widget _outerBorderRadious(
      {required Widget widget,
      double? borderWidth = 0,
      Color? borderColor = Colors.transparent,
      double? radius,
      double? radiusTopLeft,
      double? radiusTopRight,
      double? radiusBottomLeft,
      double? radiusBottomRight,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding,
      Color? color,
      AlignmentGeometry? alignment,
      bool debug = false}) {
    return Container(
      alignment: alignment,
      decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: radius != null
              ? BorderRadius.all(Radius.circular(radius))
              : ((radiusTopLeft != null ||
                      radiusTopRight != null ||
                      radiusBottomLeft != null ||
                      radiusBottomRight != null)
                  ? BorderRadius.only(
                      topLeft: Radius.circular(radiusTopLeft ?? 0),
                      topRight: Radius.circular(radiusTopRight ?? 0),
                      bottomLeft: Radius.circular(radiusBottomLeft ?? 0),
                      bottomRight: Radius.circular(radiusBottomRight ?? 0),
                    )
                  : null),
          border: (borderColor != null && borderWidth != null)
              ? Border.all(color: borderColor, width: borderWidth)
              : null),
      margin: margin,
      padding: padding,
      child: ClipRRect(
        borderRadius: radius != null
            ? BorderRadius.all(Radius.circular(radius - 2.w))
            : (BorderRadius.only(
                topLeft: Radius.circular(radiusTopLeft ?? 0),
                topRight: Radius.circular(radiusTopRight ?? 0),
                bottomLeft: Radius.circular(radiusBottomLeft ?? 0),
                bottomRight: Radius.circular(radiusBottomRight ?? 0),
              )),
        child: Container(
          color: debug ? Colors.amber : Colors.transparent,
          margin: EdgeInsets.zero,
          child: widget,
        ),
      ),
    );
  }

  Widget enabledButton(
      {String? title,
      EdgeInsetsGeometry? margin,
      double? width,
      double? height,
      bool enabled = true,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        width: width,
        height: height,
        margin: margin,
        alignment: Alignment.center,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Text(
                title ?? "",
                style: textStyle(color: Colors.white, fontSize: 16.sp),
              ),
            )
          ],
        ),
      ),
    );
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
              child: ZZ.image(appbarIconString(leftIcon)!,
                  bundleName: zzBundleName),
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
    Color? indicatorColor = zzColorRed,
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
          color: indicatorColor,
          borderRadius: BorderRadius.circular(indicatorRadius ?? 22.w),
          gradient: indicatorColor == null
              ? (indicatorGradient ?? zzColorGradientOrangeRed)
              : null),
      indicatorPadding: indicatorPadding ??
          EdgeInsets.only(top: 6.w, bottom: 10.w, left: 0.w, right: 0.w),
      labelColor: labelColor ?? (labelStyle == null ? Colors.white : null),
      unselectedLabelColor: unselectedLabelColor ??
          (unselectedLabelStyle == null ? zzColorBlack : null),
      labelStyle: labelColor == null
          ? (labelStyle ??
              ZZ.textStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
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
    Color? indicatorColor = zzColorRed,
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
  }) {
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
                text: e,
              ))
          .toList(),
      indicator: BoxDecoration(
          color: indicatorGradient == null ? indicatorColor : Colors.red,
          borderRadius: BorderRadius.circular(indicatorRadius ?? 6.w),
          gradient: indicatorColor == null
              ? (indicatorGradient ?? zzColorGradientOrangeRed)
              : null),
      indicatorPadding: indicatorPadding ??
          EdgeInsets.only(top: 35.w, bottom: 8.w, left: 2.w, right: 2.w),
      indicatorWeight: indicatorWeight ?? 4.w,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: labelColor ?? (labelStyle == null ? zzColorBlack : null),
      unselectedLabelColor: unselectedLabelColor ??
          (unselectedLabelStyle == null ? zzColorGrey99 : null),
      labelStyle: labelColor == null
          ? (labelStyle ??
              ZZ.textStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
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

  void test() {}

  /// iOS风格的底部弹框
  Future<String?> showBottomSheet({
    List<String>? items,
    TextStyle? itemTextStyle,
    TextStyle? cancelTextStyle,
  }) {
    List<Widget> widgets = [];
    if (items != null && items.isNotEmpty) {
      for (var element in items) {
        if (element == items.first && element == items.last) {
          widgets.add(ZZ.outerBorderRadious(
              radius: 12.w,
              widget: Container(
                alignment: Alignment.center,
                height: 64.w,
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    textAlign: TextAlign.center,
                    element,
                    style: itemTextStyle ??
                        TextStyle(
                          fontWeight: ui.FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                  ),
                  onTap: () {
                    Navigator.pop(zzContext, element);
                  },
                ),
              )));
        } else if (element == items.first) {
          widgets.add(ZZ.outerBorderRadious(
              radiusTopLeft: 12.w,
              radiusTopRight: 12.w,
              widget: Container(
                alignment: Alignment.center,
                height: 64.w,
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    textAlign: TextAlign.center,
                    element,
                    style: itemTextStyle ??
                        TextStyle(
                          fontWeight: ui.FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                  ),
                  onTap: () {
                    Navigator.pop(zzContext, element);
                  },
                ),
              )));
        } else if (element == items.last) {
          widgets.add(Container(
            height: .5,
            color: Colors.grey[300],
          ));
          widgets.add(ZZ.outerBorderRadious(
              radiusBottomLeft: 12.w,
              radiusBottomRight: 12.w,
              widget: Container(
                alignment: Alignment.center,
                height: 64.w,
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    textAlign: TextAlign.center,
                    element,
                    style: itemTextStyle ??
                        TextStyle(
                          fontWeight: ui.FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                  ),
                  onTap: () {
                    Navigator.pop(zzContext, element);
                  },
                ),
              )));
        } else {
          widgets.add(Container(
            height: .5,
            color: Colors.grey[300],
          ));
          widgets.add(Container(
            alignment: Alignment.center,
            height: 64.w,
            color: Colors.white,
            child: ListTile(
              title: Text(
                textAlign: TextAlign.center,
                element,
                style: itemTextStyle ??
                    TextStyle(
                      fontWeight: ui.FontWeight.w500,
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
              ),
              onTap: () {
                Navigator.pop(zzContext, element);
              },
            ),
          ));
        }
      }
    }
    widgets.add(Container(
      height: 12.w,
      color: Colors.transparent,
    ));

    widgets.add(ZZ.outerBorderRadious(
        margin: EdgeInsets.only(bottom: zzBottomBarHeight),
        radius: 12.w,
        widget: Container(
          alignment: Alignment.center,
          height: 64.w,
          color: Colors.white,
          child: ListTile(
            title: Text(
              textAlign: TextAlign.center,
              "取消",
              style: cancelTextStyle ??
                  TextStyle(
                    fontWeight: ui.FontWeight.normal,
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
            ),
            onTap: () {
              Navigator.pop(zzContext, "取消");
            },
          ),
        )));

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
}

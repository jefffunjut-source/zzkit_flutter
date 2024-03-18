// ignore_for_file: file_names

part of 'ZZAppManager.dart';

class ZZAppUrlAnalysisResult {
  final String category;
  final String value;

  ZZAppUrlAnalysisResult(this.category, this.value);

  @override
  String toString() {
    return 'Category: $category, Value: $value';
  }
}

extension ZZAppLibUI on ZZAppManager {
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
    bool bold = false,
    double height = 1.0,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: bold ? 'CircularBold' : 'CircularBook',
        fontWeight: FontWeight.bold,
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
            // Image(
            //   fit: BoxFit.fill,
            //   image: enabled
            //       ? AssetImage(R.assetsImgIcButtonEnableRed34248)
            //       : AssetImage(R.assetsImgIcButtonDisablePink34248),
            // ),
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

  String? appbarIconString(ZZAppBarIcon? icon) {
    switch (icon) {
      case ZZAppBarIcon.none:
        return null;
      case ZZAppBarIcon.backblack:
        return R.assetsImgIcNavBackBlack.addPrefix(zzPackagePrefix);
      case ZZAppBarIcon.backwhite:
        return R.assetsImgIcNavBackWhite.addPrefix(zzPackagePrefix);
      case ZZAppBarIcon.closeblack:
        return R.assetsImgIcNavCloseBlack.addPrefix(zzPackagePrefix);
      default:
        return R.assetsImgIcNavBackBlack.addPrefix(zzPackagePrefix);
    }
  }

  /// 通用Appbar
  AppBar appbar(
      {Color bgColor = Colors.white,
      List<Widget>? actions,
      PreferredSizeWidget? bottom,
      String? title,
      bool? centerTitle,
      double? titleSpacing,
      TextStyle? titleStyle,
      double? elevation,
      bool? automaticallyImplyLeading,
      ZZAppBarIcon? leftIcon = ZZAppBarIcon.backblack,
      VoidCallback? onLeftIconTap,
      VoidCallback? onTitleDoubleTap}) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      titleSpacing: titleSpacing ?? 0,
      backgroundColor: bgColor,
      leading: appbarIconString(leftIcon) == null
          ? Container()
          : GestureDetector(
              child: Image.asset(appbarIconString(leftIcon)!),
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
      title: GestureDetector(
        onDoubleTap: () {
          if (onTitleDoubleTap != null) {
            onTitleDoubleTap();
          } else {}
        },
        child: Text(
          title ?? "",
          style: titleStyle ??
              ZZ.textStyle(color: zzColorBlack, fontSize: 18.sp, bold: true),
        ),
      ),
      centerTitle: centerTitle ?? true,
      elevation: elevation ?? 0,
      actions: actions == null
          ? []
          : [
              Padding(
                padding: EdgeInsets.only(right: 18.w),
                child: Row(
                    children: actions
                        .map((e) => Padding(
                              padding: EdgeInsets.all(6.w),
                              child: e,
                            ))
                        .toList()),
              )
            ],
      bottom: bottom,
    );
  }

  /// 通用Tabbar RoundedRectangle
  TabBar tabbarRoundedRectangle(
      {required List<String> tabs,
      TabController? controller,
      Color? indicatorColor = zzColorRed,
      double? indicatorRadius,
      Gradient? indicatorGradient,
      EdgeInsetsGeometry? indicatorPadding,
      Color? labelColor,
      Color? unselectedLabelColor,
      TextStyle? labelStyle,
      TextStyle? unselectedLabelStyle,
      bool? isScrollable,
      TabAlignment? tabAlignment}) {
    return TabBar(
      dividerHeight: 0,
      tabAlignment: tabAlignment ?? TabAlignment.start,
      isScrollable: isScrollable ?? true,
      tabs: tabs
          .map((e) => Tab(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
                  child: Text(
                    e,
                  ),
                ),
              ))
          .toList(),
      indicator: BoxDecoration(
          color: indicatorColor,
          borderRadius: BorderRadius.circular(indicatorRadius ?? 22.w),
          gradient: indicatorGradient ?? zzColorGradientOrangeRed),
      indicatorPadding: indicatorPadding ??
          EdgeInsets.only(top: 6.w, bottom: 10.w, left: 0.w, right: 0.w),
      labelColor: labelColor ?? Colors.white,
      unselectedLabelColor: unselectedLabelColor ?? zzColorBlack,
      labelStyle:
          ZZ.textStyle(color: Colors.white, fontSize: 16.sp, bold: true),
      unselectedLabelStyle: ZZ.textStyle(color: Colors.white, fontSize: 14.sp),
      controller: controller,
    );
  }

  TabBar tabbarUnderline(
      {required List<String> tabs,
      TabController? controller,
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
      TabAlignment? tabAlignment}) {
    return TabBar(
      dividerHeight: 0,
      tabAlignment: tabAlignment ?? TabAlignment.start,
      isScrollable: isScrollable ?? true,
      tabs: tabs
          .map((e) => Tab(
                text: e,
              ))
          .toList(),
      indicator: BoxDecoration(
          color: indicatorColor,
          borderRadius: BorderRadius.circular(indicatorRadius ?? 6.w),
          gradient: indicatorGradient ?? zzColorGradientOrangeRed),
      indicatorPadding: indicatorPadding ??
          EdgeInsets.only(top: 35.w, bottom: 8.w, left: 2.w, right: 2.w),
      indicatorWeight: indicatorWeight ?? 4.w,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: labelColor ?? zzColorBlack,
      labelStyle: labelStyle ??
          ZZ.textStyle(color: Colors.white, fontSize: 16.sp, bold: true),
      unselectedLabelColor: unselectedLabelColor ?? zzColorGrey99,
      unselectedLabelStyle: unselectedLabelStyle ??
          ZZ.textStyle(color: Colors.white, fontSize: 14.sp),
      controller: controller,
    );
  }

  ZZAppUrlAnalysisResult _analyzeUrl(String url) {
    if (url.contains("https://www.55haitaoshop.com/store/")) {
      String v = url.replaceFirst("https://www.55haitaoshop.com/store/", "");
      v = v.replaceFirst(".html", "");
      v = v.replaceFirst("/", "");
      if (v.isNotEmpty) {
        return ZZAppUrlAnalysisResult("store", v);
      }
    } else if (url.contains("https://www.55haitaoshop.com/topic/")) {
      String v = url.replaceFirst("https://www.55haitaoshop.com/topic/", "");
      v = v.replaceFirst(".html", "");
      v = v.replaceFirst("/", "");
      if (v.isNotEmpty) {
        return ZZAppUrlAnalysisResult("topic", v);
      }
    } else if (url.contains("https://www.55haitaoshop.com/deals/")) {
      String v = url.replaceFirst("https://www.55haitaoshop.com/deals/", "");
      v = v.replaceFirst(".html", "");
      v = v.replaceFirst("/", "");
      if (v.isNotEmpty) {
        return ZZAppUrlAnalysisResult("deals", v);
      }
    }
    return ZZAppUrlAnalysisResult("", ""); // 处理不匹配的情况
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
          ZZAppUrlAnalysisResult res = _analyzeUrl(href);
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

  ///展示
  void show() {
    EasyLoading.show(status: 'loading...');
  }

  ///隐藏
  void dismiss({VoidCallback? finished}) {
    EasyLoading.dismiss();
    if (finished != null) {
      Future.delayed(const Duration(milliseconds: 200), () {
        finished();
      });
    }
  }
}

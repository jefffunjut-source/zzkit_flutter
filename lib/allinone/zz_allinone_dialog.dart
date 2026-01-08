import 'dart:math';
import 'package:flutter/material.dart';

enum ZZDialogType { bottomSheet, centerDialog }

abstract class ZZDialog {
  final BuildContext context;

  ZZDialog(this.context);

  Future<void> init() async {}

  /// ====== 配置项 ======
  ZZDialogType get dialogType => ZZDialogType.bottomSheet;
  bool get dismissible => true;
  bool get enableDrag => true;
  bool get useSafeArea => true;
  Color get barrierColor => Colors.black.withAlpha(100);
  Color get backgroundColor => Colors.white;
  double get radius => 16;
  double get maxHeight => MediaQuery.of(context).size.height * 0.8;
  double get width => MediaQuery.of(context).size.width * 0.8;

  /// 内容 Widgets
  List<Widget> get contentWidgets;
  double get contentHeight;
  Color get contentBackgroundColor => Colors.white;

  /// 如果使用自定义 title，则优先 titleWidget
  Widget? titleWidget;
  String? title;
  double get titleHeight => 50;
  Color get titleBackgroundColor => Colors.white;
  Color get titleSeparatorColor => Colors.grey;
  TextStyle get titleTextStyle =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  /// 底部栏
  Widget? bottomBarWidget;
  double get bottomBarHeight => 0;
  Color get bottomBarBackgroundColor => Colors.white;

  /// ================= Show =================
  Future<dynamic> show() async {
    await init();

    switch (dialogType) {
      case ZZDialogType.centerDialog:
        return _showCenterDialog();
      case ZZDialogType.bottomSheet:
        return _showBottomSheet();
    }
  }

  /// ===== BottomSheet 实现 =====
  Future<dynamic> _showBottomSheet() async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      isScrollControlled: true,
      isDismissible: dismissible,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: SizedBox(
            height: min(
              maxHeight,
              ((title != null || titleWidget != null) ? titleHeight : 0) +
                  contentHeight +
                  bottomBarHeight,
            ),
            child: Column(
              children: [
                _buildTitle(),
                Expanded(
                  child: Container(
                    color: contentBackgroundColor,
                    child: _buildScrollableContent(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ===== Center Dialog 实现 =====
  Future<dynamic> _showCenterDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: dismissible,
      barrierColor: barrierColor,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          backgroundColor: backgroundColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
              minWidth: width,
              maxHeight: min(
                maxHeight,
                ((title != null || titleWidget != null) ? titleHeight : 0) +
                    contentHeight +
                    bottomBarHeight,
              ),
              minHeight: min(
                maxHeight,
                ((title != null || titleWidget != null) ? titleHeight : 0) +
                    contentHeight +
                    bottomBarHeight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(),
                Flexible(
                  child: Container(
                    color: contentBackgroundColor,
                    child: Column(children: contentWidgets),
                  ),
                ),
                Container(
                  height: bottomBarHeight,
                  color: bottomBarBackgroundColor,
                  child: bottomBarWidget,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ====== Title 处理 ======
  Widget _buildTitle() {
    if (titleWidget != null) return titleWidget!;

    if (title == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: titleHeight - 1.0,
          decoration: BoxDecoration(
            color: titleBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(title!, style: titleTextStyle),
              Positioned(
                right: 12,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 22),
                ),
              ),
            ],
          ),
        ),
        Container(height: 1.0, color: titleSeparatorColor),
      ],
    );
  }

  /// ===== 内容 Scroll + Bottom Bar =====
  Widget _buildScrollableContent() {
    final widgets = contentWidgets;

    Widget list = SingleChildScrollView(child: Column(children: widgets));

    if (bottomBarWidget == null) return list;

    return Column(
      children: [
        Expanded(child: list),
        Container(
          height: bottomBarHeight,
          color: bottomBarBackgroundColor,
          child: bottomBarWidget,
        ),
      ],
    );
  }
}

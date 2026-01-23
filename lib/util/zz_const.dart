// ignore_for_file: file_names, non_constant_identifier_names, slash_for_doc_comments, dead_code, unnecessary_library_name, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:zzkit_flutter/util/zz_manager.dart';
import 'package:event_bus/event_bus.dart';
import 'dart:ui' as ui;

typedef ZZCallbackVoid = void Function(void);
typedef ZZCallback1String = void Function(String?);
typedef ZZCallback1String1Object = void Function(String?, Object?);
typedef ZZCallback2String = void Function(String?, String?);
typedef ZZCallback1Object = void Function(Object?);
typedef ZZCallback2Object = void Function(Object?, Object?);
typedef ZZCallback1Int = void Function(int);
typedef ZZCallback1Int1String = void Function(int?, String?);
typedef ZZCallback1Int1Object = void Function(int?, Object?);
typedef ZZCallback3String = void Function(String?, String?, String?);

enum ZZNavBarIcon { none, backblack, backwhite, closeblack }

ZZManager ZZ = ZZManager();

/************************
 *    全局常量（不可变）   *
 ************************/
/// ZZKit Package名称
const String zzBundleName = "packages/zzkit_flutter/";
const String zzHeaderIdleText = "下拉刷新";
const String zzHeaderReleaseText = "释放刷新";
const String zzHeaderRefreshingText = "正在加载中...";
const String zzHeaderCompleteText = "完成";
const String zzHeaderCancelRefreshText = "取消刷新";
const String zzFooterLoadingText = "正在加载中...";
const String zzFooterNoDataText = "已经到底了";
const String zzFooterCanLoadingText = "释放加载";
const String zzReversedHeaderRefreshingText = "正在加载中...";
const String zzReversedFooterLoadingText = "正在加载中...";
const String zzReversedFooterNoDataText = "已经到头了";
const String zzReversedFooterCanLoadingText = "释放加载";

/// Context
GlobalKey<NavigatorState> zzNavigatorKey = GlobalKey<NavigatorState>();
BuildContext zzContext = zzNavigatorKey.currentState!.overlay!.context;

/// Geometry常量（全局安全访问）
double get zzScreenWidth =>
    ui.window.physicalSize.width / ui.window.devicePixelRatio;

double get zzScreenHeight =>
    ui.window.physicalSize.height / ui.window.devicePixelRatio;

/// 状态栏高度
double get zzStatusBarHeight =>
    ui.window.padding.top / ui.window.devicePixelRatio;

/// 底部安全区高度（比如 iPhone 的 Home 指示器区域）
double get zzBottomBarHeight =>
    ui.window.padding.bottom / ui.window.devicePixelRatio;

double zzZero = 0.0001;
const String zzCenterDot = "·";

/// EventBug
EventBus zzEventBus = EventBus();

/************************
 *     全局常量（可变）    *
 ************************/
bool zzIsKeyboardVisible = false;
bool zzIsHomeInit = false;

class ZZColor {
  /// 颜色常量
  static const transparent = Color(0x00000000);
  static const dark = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const orange = Color(0xFFFF9869);
  static const reddishOrange = Color(0xFFFF5E4E);
  static const red = Color(0xFFFF4E4E);
  static const blue = Color(0xFF27A1FF);
  static const yellow = Color(0xFFFDAB19);

  static const grey1F = Color(0xFF1F1F1F);
  static const grey33 = Color(0xFF333333);
  static const grey66 = Color(0xFF666666);
  static const grey99 = Color(0xFF999999);
  static const greyCC = Color(0xFFCCCCCC);
  static const greyDD = Color(0xFFDDDDDD);
  static const greyE1 = Color(0xFFE1E1E1);
  static const greyE6 = Color(0xFFE6E6E6);
  static const greyEE = Color(0xFFEEEEEE);
  static const greyEF = Color(0xFFEFEFEF);
  static const greyF3 = Color(0xFFF3F3F3);
  static const greyF9 = Color(0xFFF9F9F9);

  static const background = greyF3;
  static const lightBackground = greyF9;
  static const disable = greyDD;
  static const border = greyE1;
  static const line = greyE6;
  static const seperate = greyEF;

  static Gradient gradientOrangeEnabled = ZZ.grandientColor(
    beginColor: red,
    endColor: orange,
    beginAlign: Alignment.topLeft,
    endAlign: Alignment.bottomRight,
  );

  static Gradient gradientOrangeDisabled = ZZ.grandientColor(
    beginColor: red.withAlpha(100),
    endColor: orange.withAlpha(100),
    beginAlign: Alignment.topLeft,
    endAlign: Alignment.bottomRight,
  );
}

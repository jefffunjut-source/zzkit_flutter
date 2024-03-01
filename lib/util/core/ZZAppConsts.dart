// ignore_for_file: file_names, non_constant_identifier_names, slash_for_doc_comments, dead_code
library zzkit;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ZZAppCallbackVoid = void Function(void);
typedef ZZAppCallback1String = void Function(String?);
typedef ZZAppCallback1String1Object = void Function(String?, Object?);
typedef ZZAppCallback2String = void Function(String?, String?);
typedef ZZAppCallback1Object = void Function(Object?);
typedef ZZAppCallback2Object = void Function(Object?, Object?);
typedef ZZAppCallback1Int = void Function(int);
typedef ZZAppCallback1Int1String = void Function(int?, String?);
typedef ZZAppCallback1Int1Object = void Function(int?, Object?);

enum ZZAppBarIcon {
  none,
  backblack,
  backwhite,
  closeblack,
}

ZZAppManager App = ZZAppManager();

/************************
 *    全局常量（不可变）   *
 ************************/
/// ZZKit Package名称
const String kAssetImagePrefixName = "packages/zzkit_flutter/";

/// 页面名称
const String kPageTest = "kPageTest";

/// 沙盒存储的Key常量名称
const kPrefsAppVersion = "kPrefsAppVersion";
const kPrefsUserToken = "kPrefsUserToken";

/// Context
GlobalKey<NavigatorState> kNavigatorKey = GlobalKey<NavigatorState>();
BuildContext kContext = kNavigatorKey.currentState!.overlay!.context;

/// Dio
late Dio kDio;

/// Geometry常量
double kScreenWidth = ScreenUtil().screenWidth;
double kScreenHeight = ScreenUtil().screenHeight;
double kStatusBarHeight = ScreenUtil().statusBarHeight;
double kBottomBarHeight = ScreenUtil().bottomBarHeight;

/// 颜色常量
const kColorTransparent = Color(0x00000000);
const kColorBlack = Color(0xFF000000);
const kColorWhite = Color(0xFFFFFFFF);
const kColorGrey33 = Color(0xFF333333);
const kColorGrey66 = Color(0xFF666666);
const kColorGrey99 = Color(0xFF999999);
const kColorGreyCC = Color(0xFFCCCCCC);
const kColorGreyF5 = Color(0xFFF5F5F5);
const kColorRed = Color(0xFFFF604B);
Gradient kColorGradientOrangeRed = App.grandientColor(
    beginColor: const Color(0xFFFF694B),
    endColor: const Color(0xFFFF5063),
    beginAlign: Alignment.centerLeft,
    endAlign: Alignment.centerRight);
Gradient kColorGradientRedYellow = App.grandientColor(
    beginColor: const Color(0xFFFF4A5E),
    endColor: const Color(0xFFFF9869),
    beginAlign: Alignment.centerLeft,
    endAlign: Alignment.centerRight);

/// EventBug
EventBus kEventBus = EventBus();

/************************
 *     全局常量（可变）    *
 ************************/
bool gIsKeyboardVisible = false;
bool gIsHomeInit = false;

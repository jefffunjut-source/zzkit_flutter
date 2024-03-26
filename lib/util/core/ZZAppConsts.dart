// ignore_for_file: file_names, non_constant_identifier_names, slash_for_doc_comments, dead_code
library zzkit;

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

ZZAppManager ZZ = ZZAppManager();

/************************
 *    全局常量（不可变）   *
 ************************/
/// ZZKit Package名称
const String zzBundleName = "packages/zzkit_flutter/";

/// Context
GlobalKey<NavigatorState> zzNavigatorKey = GlobalKey<NavigatorState>();
BuildContext zzContext = zzNavigatorKey.currentState!.overlay!.context;

/// Geometry常量
double zzScreenWidth = ScreenUtil().screenWidth;
double zzScreenHeight = ScreenUtil().screenHeight;
double zzStatusBarHeight = ScreenUtil().statusBarHeight;
double zzBottomBarHeight = ScreenUtil().bottomBarHeight;

double zzZero = 0.0001;

/// 颜色常量
const zzColorClear = Color(0x00000000);
const zzColorBlack = Color(0xFF000000);
const zzColorWhite = Color(0xFFFFFFFF);
const zzColorGrey33 = Color(0xFF333333);
const zzColorGrey66 = Color(0xFF666666);
const zzColorGrey99 = Color(0xFF999999);
const zzColorGreyCC = Color(0xFFCCCCCC);
const zzColorGreyF5 = Color(0xFFF5F5F5);
const zzColorRed = Colors.red;
Gradient zzColorGradientOrangeRed = ZZ.grandientColor(
    beginColor: Colors.orange,
    endColor: Colors.red,
    beginAlign: Alignment.centerLeft,
    endAlign: Alignment.centerRight);

/// EventBug
EventBus zzEventBus = EventBus();

/************************
 *     全局常量（可变）    *
 ************************/
bool zzIsKeyboardVisible = false;
bool zzIsHomeInit = false;

// ignore_for_file: slash_for_doc_comments, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/page/ZZHomePage.dart';

class ZZBootupController extends GetxController {
  /// canvas画布的宽高（设计稿的宽高）
  double? canvasWidth;
  double? canvasHeight;

  /// 当前app版本号
  late String appVersion;

  /// 用户隐私阻塞弹窗
  RxBool enablePrivacyPrompt = false.obs;
  late Future Function() privacyPrompt;

  /// 多语言
  Translations? translations;
  Locale? locale;
  Locale? fallbackLocale;

  /// 开屏闪页介绍页面
  StatefulWidget? onboardPage;

  bool debugOnboardPage = false;

  /// 当前Tab页码
  RxInt tabIndex = 0.obs;

  /// 主页列表
  late List<Widget> pages;

  /// 主页底部tab列表
  /**
    BottomNavigationBarItem(
      icon: Image(
        image: AssetImage(R.assetsImgIcTabDeal),
        width: 24.w,
        height: 24.w,
      ),
      activeIcon: Image(
        image: AssetImage(R.assetsImgIcTabDealSelected),
        width: 24.w,
        height: 24.w,
      ),
      label: "优惠"),
   */
  late List<BottomNavigationBarItem> bottomNavigationbarItems;

  /// 主页底部tabbar类型
  BottomNavigationBarType? bottomNavigationBarType;

  /// 主页底部tabbar背景色
  Color? tabbarBackgroundColor;

  /// app生命周期状态
  Rx<AppLifecycleState> state = AppLifecycleState.hidden.obs;

  /// 闪页结束跳转广告或主页
  void offAdOrMainPage() {
    Get.offAll(const ZZHomePage());
  }
}

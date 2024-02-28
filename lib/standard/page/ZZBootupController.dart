// ignore_for_file: slash_for_doc_comments, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZZBootupController extends GetxController {
  /// 当前app版本号
  late String appVersion;

  /// 用户隐私阻塞弹窗
  RxBool enablePrivacyPrompt = false.obs;
  late Future Function() privacyPrompt;

  /// 多语言
  Translations? translations;
  Locale? locale;
  Locale? fallbackLocale;

  /// 广告页面
  StatefulWidget? onboardPage;

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
}

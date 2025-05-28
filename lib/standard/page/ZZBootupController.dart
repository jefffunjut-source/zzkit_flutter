// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: slash_for_doc_comments, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:zzkit_flutter/standard/page/ZZAdPage.dart';
import 'package:zzkit_flutter/standard/page/ZZHomePage.dart';

typedef ZZCallbackAd = void Function(ZZAdData?);

class ZZBottomNavigationBarItem {
  String? label;
  String? labelKey;
  Widget icon;
  Widget? activeIcon;
  Color? backgroundColor;
  ZZBottomNavigationBarItem({
    this.label,
    this.labelKey,
    required this.icon,
    this.activeIcon,
    this.backgroundColor,
  });
}

class ZZBootupController extends GetxController {
  /// canvas画布的宽高（设计稿的宽高）
  double? designWidth;
  double? designHeight;

  /// 当前app版本号
  late String appVersion;

  /// 用户隐私阻塞弹窗
  RxBool enablePrivacyPrompt = false.obs;
  late Future Function() agreePrivacyBlock;

  /// 广告阻塞
  bool disableAd = false;
  Future<ZZAdData?> Function()? adBlock;
  // 请求Ad接口成功
  bool adBlockCompleted = false;
  double adCountdown = 5;
  ZZCallbackAd? onTapAd;

  /// 多语言
  Translations? translations;
  Locale? locale;
  Locale? fallbackLocale;

  /// 开屏闪页介绍页面
  Widget? onboardPage;

  bool debugOnboardPage = false;

  /// 当前Tab页码
  RxInt tabIndex = 0.obs;

  /// 主页列表
  late List<Widget> tabPages;

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
  late List<ZZBottomNavigationBarItem> bottomNavigationbarItems;

  /// 主页底部tabbar类型
  BottomNavigationBarType? bottomNavigationBarType;

  /// 主页底部tabbar背景色
  Color? tabbarBackgroundColor;

  /// 文字正常和选择高亮的TextStyle
  TextStyle? tabbarItemSelectedTextStyle;
  TextStyle? tabbarItemNormalTextStyle;

  /// app生命周期状态
  Rx<AppLifecycleState> state = AppLifecycleState.hidden.obs;

  /// 闪页结束跳转广告或主页
  void offAdOrMainPage() {
    if (adBlockCompleted) {
      Get.offAll(() => const ZZHomePage());
    } else {
      Get.offAll(() => ZZAdPage());
    }
  }
}

class ZZAdData {
  // 广告ID
  String? id;
  // 广告标题
  String? title;
  // 广告图
  String? pic;
  // 广告类型
  String? type;
  // 广告跳转ID
  String? linkData;
  // 打开广告前是否需要登录
  String? needLogin;
}

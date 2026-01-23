import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/page/zz_not_found_page.dart';
import 'package:zzkit_flutter/standard/page/zz_ad_page.dart';
import 'package:zzkit_flutter/standard/page/zz_home_page.dart';
import 'package:zzkit_flutter/util/zz_event.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';

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

class ZZBootupPage extends StatefulWidget {
  const ZZBootupPage({super.key});

  @override
  ZZBootupPageState createState() {
    return ZZBootupPageState();
  }
}

class ZZBootupPageState extends State<ZZBootupPage> {
  @override
  Widget build(BuildContext context) {
    ZZBootupController controller = Get.find();
    _checkPrivacy();
    return ScreenUtilInit(
      designSize: Size(
        controller.designWidth ?? 414.0,
        controller.designHeight ?? 896.0,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        translations: controller.translations,
        locale: controller.locale,
        fallbackLocale: controller.fallbackLocale,
        theme: ThemeData(brightness: Brightness.light),
        themeMode: ThemeMode.light,
        navigatorKey: zzNavigatorKey,
        debugShowCheckedModeBanner: false,
        //关掉模拟器右上角debug图标
        builder: EasyLoading.init(
          builder: (context, child) {
            return KeyboardVisibilityBuilder(
              builder: (context, isKeyboardVisible) {
                if (isKeyboardVisible != zzIsKeyboardVisible) {
                  zzIsKeyboardVisible = isKeyboardVisible;
                  zzEventBus.fire(
                    ZZEventKeyboard()..visible = isKeyboardVisible,
                  );
                }
                return Scaffold(
                  // Global GestureDetector that will dismiss the keyboard
                  resizeToAvoidBottomInset: false,
                  body: GestureDetector(
                    onTap: () {
                      ZZ.collapseKeyboard();
                    },
                    child: child,
                  ),
                );
              },
            );
          },
        ),
        home:
            controller.debugOnboardPage
                ? controller.onboardPage
                : Obx(() => _whichPage()),
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return const ZZNotFoundPage();
            },
          );
        },
      ),
    );
  }

  Widget _whichPage() {
    ZZBootupController controller = Get.find();
    if (controller.enablePrivacyPrompt.value) {
      return Container();
    } else {
      if ((ZZ.getNewInstallOrUpdate(controller.appVersion) ?? false)) {
        if (controller.onboardPage != null) {
          return controller.onboardPage!;
        }
      }
      if (controller.adBlockCompleted ||
          controller.disableAd ||
          controller.adBlock == null) {
        return const ZZHomePage();
      } else {
        return ZZAdPage();
      }
    }
  }

  void _checkPrivacy() async {
    ZZBootupController controller = Get.find();
    if (controller.enablePrivacyPrompt.value == false) {
      return;
    }
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      controller.agreePrivacyBlock().then((value) {
        controller.enablePrivacyPrompt.value = false;
      });
    });
  }
}

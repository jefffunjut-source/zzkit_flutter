// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zzkit_example/sample/sample_translations.dart';
import 'package:zzkit_example/sample/home_page.dart';
import 'package:zzkit_flutter/standard/page/ZZBootupController.dart';
import 'package:zzkit_flutter/standard/page/ZZBootupPage.dart';
import 'package:zzkit_flutter/standard/page/ZZWebViewPage.dart';
import 'package:zzkit_flutter/standard/widget/ZZNoticeWidget.dart';
import 'package:zzkit_flutter/util/ZZTranslations.dart';
import 'package:zzkit_flutter/util/api/ZZDevice.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_example/r.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeImmediately();

  Future.delayed(Duration(milliseconds: 500)).then((value) {
    _initializeWithDelay();
  });

  /// 主程序启动
  SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ])
      .then((value) {
        if (kDebugMode) {
          runZonedGuarded(() => runApp(const ZZBootupPage()), (error, stack) {
            debugPrint("FlutterError: ${stack.toString()}");
          });
        } else {
          runApp(const ZZBootupPage());
        }
      })
      .catchError((error) {
        if (kDebugMode) {
          runZonedGuarded(() => runApp(const ZZBootupPage()), (error, stack) {
            debugPrint("FlutterError: ${stack.toString()}");
          });
        } else {
          runApp(const ZZBootupPage());
        }
      });
}

Future<void> _initializeImmediately() async {
  /// 异常捕获
  if (kDebugMode) {
    FlutterError.onError = (FlutterErrorDetails details) {
      // 检查错误是否为资源加载错误
      if (details.exception is FlutterError) {
        debugPrint("FlutterError: ${details.exception}");
      } else {
        // 其他类型的错误，使用默认处理方式
        FlutterError.presentError(details);
      }

      // PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      //   // 豁免该崩溃
      //   return true;
      // };
    };
  }

  if (Platform.isAndroid) {
    SystemUiOverlayStyle dark = const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarDividerColor: null,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(dark);
  }

  bool finishedInitSomething = await ZZ.initSomething();
  // bool finishedInitDio = await ApiProvider.initDio();
  if (!finishedInitSomething) {
    debugPrint("APP initSomething failed");
  }
  // if (!finishedInitDio) {
  //   debugPrint("APIProvider initialDio failed");
  // }

  /// 配置ZZBootupController
  List<Widget> pages = [
    // Center(child: Text("Page 1")),
    HomePage(),
    Center(child: Text("Page 2")),
    Center(child: Text("Page 3")),
  ];

  List<ZZBottomNavigationBarItem> bottoms = [
    ZZBottomNavigationBarItem(
      icon: Image(
        image: AssetImage(R.assetsImgIcTabDeal),
        width: 24,
        height: 24,
      ),
      activeIcon: Image(
        image: AssetImage(R.assetsImgIcTabDealSelected),
        width: 24,
        height: 24,
      ),
      labelKey: "优惠",
    ),
    ZZBottomNavigationBarItem(
      icon: Image(
        image: AssetImage(R.assetsImgIcTabSns),
        width: 24,
        height: 24,
      ),
      activeIcon: Image(
        image: AssetImage(R.assetsImgIcTabSnsSelected),
        width: 24,
        height: 24,
      ),
      label: "社区",
    ),
    ZZBottomNavigationBarItem(
      icon: Image(image: AssetImage(R.assetsImgIcTabMe), width: 24, height: 24),
      activeIcon: Image(
        image: AssetImage(R.assetsImgIcTabMeSelected),
        width: 24,
        height: 24,
      ),
      label: "我的",
    ),
  ];

  /// Device Controller
  // HTDeviceController deviceController = HTDeviceController()..initialize();
  // Get.put(deviceController, permanent: true);

  /// User Controller
  // HTUserController userController = HTUserController()..initialize();
  // Get.put(userController, permanent: true);

  /// Golbal Controller
  // HTGlobalController globalController = HTGlobalController();
  // Get.put(globalController, permanent: true);

  /// Notice
  Get.put(ZZNoticeController(), permanent: true);

  ZZDevice.designWidth = 414.0;
  ZZDevice.designHeight = 896.0;

  /// Bootup Controller
  ZZBootupController bootupController = ZZBootupController();
  bootupController.appVersion = "8.5.4";
  bootupController.translations = SampleTranslations();
  bootupController.locale = ZZTranslations.locale;
  bootupController.fallbackLocale = ZZTranslations.localeEn;
  bootupController.tabPages = pages;
  bootupController.bottomNavigationbarItems = bottoms;
  bootupController.designWidth = 414.0;
  bootupController.designHeight = 896.0;
  // bootupController.debugOnboardPage = false;
  // bootupController.onboardPage = const HTOnBoardingPage();
  // bootupController.enablePrivacyPrompt.value = true;
  // bootupController.agreePrivacyBlock = () async {
  //   bool? hasAgreedLicense = ZZ.prefs.getBool("hasAgreedLicense");
  //   if (hasAgreedLicense == null || hasAgreedLicense == false) {
  //     zzEventBus.on<HTEventCanInit3rd>().listen((event) {
  //       _init3rdWithAgreedLicences();
  //     });
  //     await HTLicenseCenterDialog().show();
  //   } else {
  //     _init3rdWithAgreedLicences();
  //   }
  // };
  // bootupController.disableAd = false;
  // bootupController.adCountdown = 5;
  // bootupController.adBlock = () async {
  //   ZZAPIResponse value =
  //       await ZZAPIRequest(
  //         provider: ApiProvider,
  //         apiUrl: HTAPIUrl.iflyad,
  //         httpMethod: ZZHTTPMethod.get,
  //       ).request();
  //   HtResponseLflyAd? resp = value.resp;
  //   if (resp != null) {
  //     ZZAdData adData = ZZAdData();
  //     if (resp.data?.haitaoAd != null) {
  //       adData.id = resp.data?.haitaoAd?.id;
  //       adData.linkData = resp.data?.haitaoAd?.linkData;
  //       adData.needLogin = resp.data?.haitaoAd?.needLogin;
  //       adData.pic = resp.data?.haitaoAd?.pic;
  //       adData.title = resp.data?.haitaoAd?.title;
  //       adData.type = resp.data?.haitaoAd?.type;
  //       return adData;
  //     }
  //   }
  //   return null;
  // };
  // bootupController.onTapAd = (adData) {
  //   HTConst.forward(
  //     type: adData?.type,
  //     value: adData?.linkData,
  //     title: adData?.title,
  //   );
  // };
  Get.put(bootupController, permanent: true);
}

void _initializeWithDelay() {
  ZZBootupController bootupController = Get.find();

  /// WebView
  ZZWebViewController zzWebViewController = ZZWebViewController();
  // Web白名单和黑名单
  zzWebViewController.userAgentAddon =
      Platform.isAndroid
          ? " (WWHT,Android,${bootupController.appVersion})"
          : " (WWHT,iOS,${bootupController.appVersion})";
  zzWebViewController.defaultAction = (name, message, extra) {
    debugPrint(name);
    debugPrint(message);
  };
  // TODO: 测试Actions
  zzWebViewController.actions = {
    // 验证码
    "appNvc": (message, extra) {},
  };
  Get.put(zzWebViewController, permanent: true);
}

void _init3rdWithAgreedLicences() async {}

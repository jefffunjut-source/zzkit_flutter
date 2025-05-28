// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/page/ZZ404Page.dart';
import 'package:zzkit_flutter/standard/page/ZZAdPage.dart';
import 'package:zzkit_flutter/standard/page/ZZBootupController.dart';
import 'package:zzkit_flutter/standard/page/ZZHomePage.dart';
import 'package:zzkit_flutter/util/ZZEvent.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

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
              return const ZZ404Page();
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

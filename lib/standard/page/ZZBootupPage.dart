// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/page/ZZ404Page.dart';
import 'package:zzkit_flutter/standard/page/ZZBootupController.dart';
import 'package:zzkit_flutter/standard/page/ZZHomePage.dart';
import 'package:zzkit_flutter/util/ZZEvent.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class ZZBootupPage extends StatelessWidget {
  const ZZBootupPage({super.key});

  @override
  Widget build(BuildContext context) {
    ZZBootupController controller = Get.find();
    return ScreenUtilInit(
        designSize: const Size(414.0, 896.0),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return _mainMaterialApp(child);
        },
        child: App.getNewInstallOrUpdate(controller.appVersion)
            ? controller.onboardPage ?? const ZZHomePage()
            : const ZZHomePage());
  }

  GetMaterialApp _mainMaterialApp(Widget? child) {
    ZZBootupController controller = Get.find();
    return GetMaterialApp(
      translations: controller.translations,
      locale: controller.locale,
      fallbackLocale: controller.fallbackLocale,
      theme: ThemeData(brightness: Brightness.light),
      themeMode: ThemeMode.light,
      navigatorKey: kNavigatorKey,
      debugShowCheckedModeBanner: false,
      //关掉模拟器右上角debug图标
      builder: EasyLoading.init(builder: (context, child) {
        return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          if (isKeyboardVisible != gIsKeyboardVisible) {
            gIsKeyboardVisible = isKeyboardVisible;
            kEventBus.fire(ZZEventKeyboard()..visible = isKeyboardVisible);
          }
          return Scaffold(
            // Global GestureDetector that will dismiss the keyboard
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: () {
                App.collapseKeyboard();
              },
              child: child,
            ),
          );
        });
      }),
      home: child,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) {
          return const ZZ404Page();
        });
      },
    );
  }
}

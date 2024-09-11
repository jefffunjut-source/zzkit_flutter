// ignore_for_file: public_member_api_docs, sort_constructors_first, slash_for_doc_comments, file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/page/ZZBootupController.dart';
import 'package:zzkit_flutter/standard/page/ZZTabNavigationBar.dart';
import 'package:zzkit_flutter/util/ZZEvent.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';

class ZZHomePage extends StatefulWidget {
  const ZZHomePage({super.key});

  @override
  ZZHomePageState createState() {
    return ZZHomePageState();
  }
}

class ZZHomePageState extends State<ZZHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    zzIsHomeInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    ZZBootupController controller = Get.find();
    return Obx(() => Scaffold(
          bottomNavigationBar: ZZTabNavigationBar(
            items: controller.bottomNavigationbarItems,
            onTap: (value) {
              debugPrint("value:$value");
              controller.tabIndex.value = value;
            },
            type: controller.bottomNavigationBarType ??
                BottomNavigationBarType.fixed,
            currentIndex: controller.tabIndex.value,
            backgroundColor: controller.tabbarBackgroundColor ?? Colors.white,
          ),
          body: IndexedStack(
            index: controller.tabIndex.value,
            children: controller.tabPages,
          ),
        ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    ZZBootupController controller = Get.find();
    controller.state.value = state;
    zzEventBus.fire(ZZEventAppLife()..state = state);
    switch (state) {
      //进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:
        if (kDebugMode) {
          print("应用状态：AppLifecycleState.resumed");
        }
        break;
      // 应用状态处于闲置状态，并且没有用户的输入事件，
      // 注意：这个状态切换到 前后台 会触发，所以流程应该是先冻结窗口，然后停止UI
      case AppLifecycleState.inactive:
        if (kDebugMode) {
          print("应用状态：AppLifecycleState.inactive");
        }
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        if (kDebugMode) {
          print("应用状态：AppLifecycleState.detached");
        }
        break;
      // 应用程序处于不可见状态
      case AppLifecycleState.paused:
        if (kDebugMode) {
          print("应用状态：AppLifecycleState.paused");
        }
        break;
      case AppLifecycleState.hidden:
        if (kDebugMode) {
          print("应用状态：AppLifecycleState.hidden");
        }
        break;
    }
  }
}

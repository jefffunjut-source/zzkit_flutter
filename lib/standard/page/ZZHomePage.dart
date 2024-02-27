// ignore_for_file: public_member_api_docs, sort_constructors_first, slash_for_doc_comments
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/page/ZZTabNavigationBar.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';

class ZZHomeController extends GetxController {
  late List<Widget> pages;
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
  BottomNavigationBarType? bottomNavigationBarType;
  Color? backgroundColor;
  Rx<AppLifecycleState> state = AppLifecycleState.hidden.obs;
  // 当前Tab页码
  RxInt tabIndex = 0.obs;
}

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
    gIsHomeInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    ZZHomeController controller = Get.find();
    return Scaffold(
      bottomNavigationBar: ZZTabNavigationBar(
        items: controller.bottomNavigationbarItems,
        onTap: (value) {
          controller.tabIndex.value = value;
        },
        type:
            controller.bottomNavigationBarType ?? BottomNavigationBarType.fixed,
        currentIndex: controller.tabIndex.value,
        backgroundColor: controller.backgroundColor ?? Colors.white,
      ),
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: controller.pages,
          )),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    ZZHomeController controller = Get.find();
    controller.state.value = state;
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

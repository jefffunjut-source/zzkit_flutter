// ignore_for_file: file_names, unused_local_variable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_example/sample/allinone/multi_type_feed_allinone.dart';
import 'package:zzkit_example/sample/complex/pull_to_refresh_outer_page.dart';
import 'package:zzkit_example/sample/complex/tab_deal_page.dart';
import 'package:zzkit_example/sample/dialog/bottom_dialog.dart';
import 'package:zzkit_example/sample/dialog/center_dialog.dart';
import 'package:zzkit_example/sample/list/store_card_list_page.dart';
import 'package:zzkit_example/sample/list/tab_list_page.dart';
import 'package:zzkit_example/sample/list/nestedscroll_tab_page_2.dart';
import 'package:zzkit_example/sample/list/nestedscroll_tab_page_1.dart';
import 'package:zzkit_example/sample/list/nestedscroll_tab_page_3.dart';
import 'package:zzkit_example/sample/list/tab_waterfall_page.dart';
import 'package:zzkit_example/sample/list/store_card_waterfall_page.dart';
import 'package:zzkit_flutter/standard/page/zz_base_scaffold.dart';
import 'package:zzkit_flutter/standard/widget/zz_notice_widget.dart';
import 'package:zzkit_flutter/util/zz_translations.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';

class TestPortalController extends GetxController {
  RxString name = "".obs;
  RxString password = "".obs;
  RxBool validResult = false.obs;

  bool valid() {
    validResult.value =
        name.value.trim().isNotEmpty && password.value.trim().isNotEmpty;
    return validResult.value;
  }
}

class TestPortalPage extends StatefulWidget {
  const TestPortalPage({super.key});

  @override
  TestPortalPageState createState() => TestPortalPageState();
}

class TestPortalPageState extends State<TestPortalPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => TestPortalController());
  }

  /// 可复用按钮组件
  Widget _buildButton({
    required String title,
    required VoidCallback onTap,
    double width = 140,
    double height = 30,
    double fontSize = 12,
    Color color = Colors.blueAccent,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        color: color,
        child: Center(
          child: Text(
            title,
            style: ZZ.textStyle(color: Colors.white, fontSize: fontSize),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TestPortalController test3rdController = Get.find();

    return ZZBaseScaffold(
      backgroundColor: Colors.white,
      appBar: ZZ.appbar(
        title: "Test",
        onLeftIconTap: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "输入账号"),
              onChanged: (value) {
                test3rdController.name.value = value;
                test3rdController.valid();
              },
            ),
            TextField(
              decoration: const InputDecoration(hintText: "输入密码"),
              onChanged: (value) {
                test3rdController.password.value = value;
                test3rdController.valid();
              },
            ),
            Obx(
              () => Text(
                // 使用 Obx 来监听 RxString 的变化
                '（登录框验证）RxString Value: ${test3rdController.validResult}',
                style: ZZ.textStyle(
                  color: Colors.cyan,
                  fontSize: 18.sp,
                  height: 2,
                ),
              ),
            ),
            Wrap(
              spacing: 8, // 子组件左右间距
              runSpacing: 8, // 子组件上下间距
              children: [
                _buildButton(
                  title: "Valid",
                  onTap: () {
                    bool valid = test3rdController.valid();
                    debugPrint(valid.toString());
                  },
                  width: 100.w,
                ),
                _buildButton(
                  title: "Back",
                  onTap: () {
                    Get.back();
                  },
                  width: 100.w,
                ),
              ],
            ),

            const SizedBox(height: 10),
            Wrap(
              spacing: 8, // 子组件左右间距
              runSpacing: 8, // 子组件上下间距
              children: [
                Text(
                  "1".tr,
                  style: ZZ.textStyle(color: Colors.red, fontSize: 14.sp),
                ),
                _buildButton(
                  title: "英文",
                  onTap: () {
                    ZZTranslations.changeLocale(const Locale('en', 'US'));
                  },
                ),

                _buildButton(
                  title: "中文",
                  onTap: () {
                    ZZTranslations.changeLocale(const Locale('zh', 'CN'));
                  },
                ),

                _buildButton(
                  title: "法语",
                  onTap: () {
                    ZZTranslations.changeLocale(const Locale('fr', 'FR'));
                  },
                ),
                _buildButton(
                  title: "俄语",
                  onTap: () {
                    ZZTranslations.changeLocale(const Locale('ru', 'RU'));
                  },
                ),
                _buildButton(
                  title: "主题",
                  onTap: () {
                    Get.changeTheme(
                      Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
                    );
                  },
                ),
                _buildButton(
                  title: "to an unknown page",
                  onTap: () {
                    Get.toNamed("page休息休息请问");
                  },
                ),
                _buildButton(
                  title: "to a list page",
                  onTap: () {
                    Get.to(StoreCardListPage());
                  },
                ),
                _buildButton(
                  title: "to a tab list page",
                  onTap: () {
                    Get.to(const TabListPage());
                  },
                ),

                _buildButton(
                  title: "to a waterfall page",
                  onTap: () {
                    Get.to(StoreCardWaterfallPage());
                  },
                ),

                _buildButton(
                  title: "to a tab waterfall page",
                  onTap: () {
                    Get.to(const TabWaterfallPage());
                  },
                ),
                _buildButton(
                  title: "center dialog",
                  onTap: () {
                    CenterDialog(context).show();
                  },
                ),

                _buildButton(
                  title: "bottom dialog",
                  onTap: () {
                    BottomDialog(context).show();
                  },
                ),

                GestureDetector(
                  child: Container(
                    width: 44.w,
                    height: 30.w,
                    color: Colors.blueAccent,
                    child: Center(
                      child: ZZNoticeWidget(
                        width: 44.w,
                        height: 64.w,
                        noticeImage: null,
                        highlightedNoticeImage: null,
                        pointBackgroundColor: null,
                        highlightedPointBackgroundColor: null,
                        textStyle: null,
                        highlightedTextStyle: null,
                        borderColor: null,
                        highlightedBorderColor: null,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),

                _buildButton(
                  title: "change notice",
                  onTap: () {
                    ZZNoticeController controller = Get.find();
                    controller.noticeNumber.value = "12";
                  },
                  width: 80.w,
                ),
                _buildButton(
                  title: "nestedscroll tab page 1",
                  onTap: () {
                    Get.to(const NestedScrollTabPage1());
                  },
                ),

                _buildButton(
                  title: "nestedscroll tab page 2",
                  onTap: () {
                    Get.to(const NestedScrollTabPage2());
                  },
                ),
                _buildButton(
                  title: "nestedscroll tab page 3",
                  onTap: () {
                    Get.to(const NestedScrollTabPage3());
                  },
                ),
                _buildButton(
                  title: "complex home page",
                  onTap: () {
                    Get.to(const TabDealPage());
                  },
                ),
                _buildButton(
                  title: "extendnestscroll",
                  onTap: () {
                    Get.to(const PullToRefreshOuterPage());
                  },
                ),
                _buildButton(
                  title: "allinone list",
                  onTap: () {
                    Get.to(MultiTypeFeedListPage());
                  },
                ),
                _buildButton(
                  title: "allinone waterfall",
                  onTap: () {
                    Get.to(MultiTypeFeedWaterfallPage());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

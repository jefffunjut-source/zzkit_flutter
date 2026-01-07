// ignore_for_file: file_names, unused_local_variable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_example/sample/allinone/multi_type_feed_allinone.dart';
import 'package:zzkit_example/sample/complex/XXSamplePullToRefreshOuterPage.dart';
import 'package:zzkit_example/sample/complex/XXTabDealPage.dart';
import 'package:zzkit_example/sample/dialog/XXSampleBottomDialog.dart';
import 'package:zzkit_example/sample/dialog/XXSampleCenterDialog.dart';
import 'package:zzkit_example/sample/list/store_card_list_page.dart';
import 'package:zzkit_example/sample/list/tab_list_page.dart';
import 'package:zzkit_example/sample/testportal/XXTestNestedScrollTab2Page.dart';
import 'package:zzkit_example/sample/testportal/XXTestNestedScrollTabPage.dart';
import 'package:zzkit_example/sample/testportal/XXTestTabNestedScrollPage.dart';
import 'package:zzkit_example/sample/list/tab_waterfall_page.dart';
import 'package:zzkit_example/sample/list/store_card_waterfall_page.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/standard/widget/ZZNoticeWidget.dart';
import 'package:zzkit_flutter/util/ZZTranslations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

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
            SizedBox(
              width: 414.w,
              height: 200.w,
              child: Center(
                child: Text(
                  "Test 3rd Page\n",
                  style: ZZ.textStyle(color: Colors.black, fontSize: 20.sp),
                ),
              ),
            ),
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
                'RxString Value: ${test3rdController.validResult}',
                style: ZZ.textStyle(color: Colors.cyan, fontSize: 18.sp),
              ),
            ),
            GestureDetector(
              child: Container(
                width: 100.w,
                height: 30.w,
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    "Valid",
                    style: ZZ.textStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ),
              onTap: () {
                bool valid = test3rdController.valid();
                debugPrint(valid.toString());
              },
            ),
            const SizedBox(height: 10),
            GestureDetector(
              child: Container(
                width: 100.w,
                height: 30.w,
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    "Back",
                    style: ZZ.textStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ),
              onTap: () {
                Get.back();
              },
            ),
            const SizedBox(height: 10),
            Text(
              "1".tr,
              style: ZZ.textStyle(color: Colors.red, fontSize: 14.sp),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "英文",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        ZZTranslations.changeLocale(const Locale('en', 'US'));
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "中文",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        ZZTranslations.changeLocale(const Locale('zh', 'CN'));
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "法语",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        ZZTranslations.changeLocale(const Locale('fr', 'FR'));
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "俄语",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        ZZTranslations.changeLocale(const Locale('ru', 'RU'));
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "主题",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.changeTheme(
                          Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "to an unknown page",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.toNamed("page");
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "to a list page",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        var widget = Column(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 200,
                                width: zzScreenWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(height: 4),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 20,
                                width: zzScreenWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(height: 4),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 20,
                                width: zzScreenWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(height: 4),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 20,
                                width: zzScreenWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(height: 4),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 20,
                                width: zzScreenWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(height: 4),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 20,
                                width: zzScreenWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                        Get.to(StoreCardListPage());
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "to a tab list page",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(const TabListPage());
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "to a waterfall page",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(StoreCardWaterfallPage());
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "to a tab waterfall page",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(const TabWaterfallPage());
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "dialog",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "dialog",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        XXSampleCenterDialog().show();
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "bottom",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        XXSampleBottomDialog().show();
                      },
                    ),
                    const SizedBox(width: 8),
                    ZZNoticeWidget(
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
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "change notice",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        ZZNoticeController controller = Get.find();
                        controller.noticeNumber.value = "100";
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "test",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "to test nesttab1",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(const XXTestNestedScrollTabPage());
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "to test nesttab2",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(const XXTestNestedScrollTab2Page());
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "to test tabnest",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(const XXTestTabNestedScrollPage());
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            "complex",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(const XXTabDealPage());
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "extendnestscroll sample",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(const XXSamplePullToRefreshOuterPage());
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "allinone list",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(MultiTypeFeedListPage());
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "allinone waterfall",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(MultiTypeFeedWaterfallPage());
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        width: 60.w,
                        height: 30.w,
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            "reserve",
                            style: ZZ.textStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

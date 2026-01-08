// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_example/sample/testportal/test_portal_page.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ZZManager().initSomething();
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  Widget _scaffold() {
    return ZZBaseScaffold(
      backgroundColor: Colors.white,
      appBar: ZZ.appbar(title: "Test"),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 414.w,
              height: 414.w,
              child: Center(
                child: Text(
                  "Home Page\n",
                  style: ZZ.textStyle(color: Colors.black, fontSize: 20.sp),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                width: 160.w,
                height: 60.w,
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    "Test Portal Page",
                    style: ZZ.textStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ),
              onTap: () {
                Get.to(() => TestPortalPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_example/xtemplete/xtest/XXTest3rdPage.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class XXTestPage extends StatefulWidget {
  const XXTestPage({
    super.key,
  });

  @override
  XXTestPageState createState() => XXTestPageState();
}

class XXTestPageState extends State<XXTestPage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  Widget _scaffold() {
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
                height: 414.w,
                child: Center(
                  child: Text("Test Page\n",
                      style:
                          ZZ.textStyle(color: Colors.black, fontSize: 20.sp)),
                ),
              ),
              GestureDetector(
                child: Container(
                    width: 160.w,
                    height: 60.w,
                    color: Colors.blueAccent,
                    child: Center(
                      child: Text("To Test 3rd Page",
                          style: ZZ.textStyle(
                              color: Colors.white, fontSize: 14.sp)),
                    )),
                onTap: () {
                  Get.off(const XXTest3rdPage());
                },
              )
            ],
          )),
    );
  }
}

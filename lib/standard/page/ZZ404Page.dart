// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class ZZ404Page extends StatefulWidget {
  const ZZ404Page({super.key});

  @override
  ZZ404State createState() => ZZ404State();
}

class ZZ404State extends State<ZZ404Page> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZZBaseScaffold(
      backgroundColor: Colors.white,
      appBar: ZZ.appbar(title: "Unknown"),
      body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 414.w,
                height: 414.w,
                child: Center(
                  child: Text("Unknown Page\n请检查你的路由设置",
                      style:
                          ZZ.textStyle(color: Colors.black, fontSize: 20.sp)),
                ),
              )
            ],
          )),
    );
  }
}

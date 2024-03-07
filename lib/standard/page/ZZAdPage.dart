// ignore_for_file: use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/page/ZZBootupController.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/standard/widget/ZZCountdownWidget.dart';
import 'package:zzkit_flutter/standard/widget/ZZImageWidget.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';

class ZZAdPage extends StatefulWidget {
  @override
  ZZAdPageState createState() => ZZAdPageState();
}

class ZZAdPageState extends State<ZZAdPage> {
  ZZAdData? adData;

  @override
  void initState() {
    super.initState();
    ZZBootupController controller = Get.find();
    if (controller.adBlock != null) {
      controller.adBlock!().then((value) {
        controller.triedAd = true;
        if (value != null) {
          setState(() {
            adData = value;
          });
        } else {
          controller.offAdOrMainPage();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZZBaseScaffold(
        safeAreaBottom: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: zzScreenWidth,
              height: zzScreenHeight,
              color: Colors.transparent,
              child: ZZImageWidget(
                width: zzScreenWidth,
                height: zzScreenHeight,
                fit: BoxFit.cover,
                url: adData?.pic,
              ),
            ),
            Positioned(
              right: 30,
              top: 30 + zzStatusBarHeight,
              child: GestureDetector(
                onTap: () {
                  ZZBootupController controller = Get.find();
                  controller.offAdOrMainPage();
                },
                child: ZZCountdownWidget(),
              ),
            )
          ],
        ));
  }
}

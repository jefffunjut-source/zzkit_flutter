// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:zzkit_example/r.dart';
import 'package:zzkit_flutter/allinone/zz_allinone_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';
import 'package:get/get.dart';

class CenterDialog extends ZZDialog {
  CenterDialog(super.context);

  @override
  ZZDialogType get dialogType => ZZDialogType.centerDialog;

  @override
  String? get title => "温馨提示";

  @override
  List<Widget> get contentWidgets => [
    Container(
      height: 100.w,
      width: 300.w,
      color: Colors.black,
      child: ZZ.image(R.assetsImgIcBgRebateDialog),
    ),
  ];

  @override
  Widget? get bottomBarWidget => Row(
    children: [
      Expanded(
        child: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("取消"),
        ),
      ),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text("确定"),
        ),
      ),
    ],
  );

  @override
  double get radius => 4.0;

  @override
  double get bottomBarHeight => 56;

  @override
  double get contentHeight => 120;

  @override
  // Color get backgroundColor => Colors.grey.withAlpha(128);
  @override
  Color get titleBackgroundColor => Colors.white;

  @override
  Color get titleSeparatorColor => Colors.white;

  @override
  Color get contentBackgroundColor => Colors.amber;

  @override
  Color get bottomBarBackgroundColor => Colors.blue;
}

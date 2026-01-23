// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:zzkit_example/r.dart';
import 'package:zzkit_flutter/standard/widget/zz_dialog.dart';
import 'package:zzkit_flutter/util/zz_const.dart';
import 'package:zzkit_flutter/util/zz_manager.dart';
import 'package:get/get.dart';

class CenterDialog extends ZZDialog {
  CenterDialog(super.context);

  @override
  ZZDialogType get dialogType => ZZDialogType.centerDialog;

  // @override
  // String? get title => "温馨提示";

  @override
  List<Widget> get contentWidgets => [
    Container(
      width: width,
      height: width * 134.0 / maxWidth,
      color: Colors.transparent,
      child: ZZ.image(R.assetsImgIcBgRebateDialog, fit: BoxFit.cover),
    ),
  ];

  @override
  Widget? get bottomWidget => Row(
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
  double get width => 400;

  @override
  double get radius => 4.0;

  @override
  double get bottomHeight => 52;

  @override
  double get contentHeight => width * 134.0 / maxWidth;

  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get titleBackgroundColor => Colors.white;

  @override
  Color get titleSeparatorColor => Colors.white;

  @override
  Color get contentBackgroundColor => Colors.transparent;

  @override
  Color get bottomBarBackgroundColor => Colors.blue;
}

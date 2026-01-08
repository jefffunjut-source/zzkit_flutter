// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:zzkit_flutter/allinone/zz_allinone_dialog.dart';

class BottomDialog extends ZZDialog {
  BottomDialog(super.context);

  @override
  String? get title => "选择图片";

  @override
  Color get backgroundColor => Colors.grey.withAlpha(100);

  @override
  Color get titleBackgroundColor => Colors.red;

  @override
  Color get contentBackgroundColor => Colors.amber;

  @override
  Color get bottomBarBackgroundColor => Colors.blue;

  @override
  List<Widget> get contentWidgets => [
    ListTile(title: Text("相机")),
    ListTile(title: Text("相册")),
  ];

  @override
  Widget? get bottomBarWidget => Row(
    children: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("取消", style: TextStyle(color: Colors.white)),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("确定", style: TextStyle(color: Colors.white)),
      ),
    ],
  );

  @override
  double get bottomBarHeight => 50;

  @override
  double get contentHeight => 114;
}

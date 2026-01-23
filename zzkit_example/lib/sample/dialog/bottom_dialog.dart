// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:zzkit_flutter/standard/widget/zz_dialog.dart';

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
    ListTile(title: Text("Item1")),
    ListTile(title: Text("Item2")),
    ListTile(title: Text("Item3")),
    ListTile(title: Text("Item4")),
    ListTile(title: Text("Item5")),
    ListTile(title: Text("Item6")),
    ListTile(title: Text("Item7")),
    ListTile(title: Text("Item8")),
    ListTile(title: Text("Item9")),
    ListTile(title: Text("Item10")),
    ListTile(title: Text("Item11")),
    ListTile(title: Text("Item12")),
    ListTile(title: Text("Item13")),
    ListTile(title: Text("Item14")),
    ListTile(title: Text("Item15")),
  ];

  @override
  Widget? get bottomWidget => Row(
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
  double get bottomHeight => 50;

  @override
  double get contentHeight => 10000;
}

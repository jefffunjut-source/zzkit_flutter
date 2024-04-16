// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names, use_key_in_widget_constructors, must_be_immutable
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ZZBaseBrick<T> extends StatelessWidget {
  // 控件的数据
  T? object;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class ZZBaseBrickObject<T> {
  // 数据对应的控件
  T? _widget;
  get widget => _widget;
  set widget(value) {
    _widget = value;
    (_widget as ZZBaseBrick).object = this;
  }
}

class ZZBrickList {
  List dataSource = [];
  int? crossAxisCount;
  double? mainAxisSpacing;
  double? crossAxisSpacing;
  EdgeInsetsGeometry? padding;
  ZZBrickList(
      {required this.dataSource,
      this.crossAxisCount,
      this.mainAxisSpacing,
      this.crossAxisSpacing,
      this.padding});
}

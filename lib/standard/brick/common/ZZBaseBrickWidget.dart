// ignore_for_file: file_names, use_key_in_widget_constructors, must_be_immutable
library zzkit;

import 'package:flutter/material.dart';

class ZZBaseBrickWidget<T> extends StatelessWidget {
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
    (_widget as ZZBaseBrickWidget).object = this;
  }

  // 控件的外围描述
  // 高度 可null null时会自适应高度
  double? height;
  // 外边距
  EdgeInsetsGeometry? margin;
  // 内边距
  EdgeInsetsGeometry? padding;
  // 容器背景色，当内边距有值时生效
  int? colorHex;
}

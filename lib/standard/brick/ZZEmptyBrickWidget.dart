// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names
library zzkit;

import 'package:flutter/material.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrickWidget.dart';

class ZZEmptyBrickWidget extends ZZBaseBrickWidget<ZZEmptyBrickObject> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: object?.height,
      color: Color(object?.color ?? 0x00000000),
    );
  }
}

class ZZEmptyBrickObject extends ZZBaseBrickObject<ZZEmptyBrickWidget> {
  // 默认透明颜色
  int color = 0x00000000;
}

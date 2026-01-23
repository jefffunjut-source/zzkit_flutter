import 'package:flutter/material.dart';
import 'package:zzkit_flutter/deprecated/list/widget/zz_base_brick.dart';

class ZZEmptyBrick extends ZZBaseBrick<ZZEmptyBrickObject> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: object?.height ?? 120,
      color: Color(object?.color ?? 0x00000000),
    );
  }
}

class ZZEmptyBrickObject extends ZZBaseBrickObject<ZZEmptyBrick> {
  // 默认透明颜色
  int color = 0x00000000;

  double? height;
}

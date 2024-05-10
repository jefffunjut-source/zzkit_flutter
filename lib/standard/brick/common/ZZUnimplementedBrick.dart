// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrick.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZUnimplementedBrick extends ZZBaseBrick<ZZUnimplementedBrickObject> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 414.w,
        height: 30.w,
        child: Center(
            child: Text(
          "Unimplemented",
          style: ZZ.textStyle(color: Colors.red, fontSize: 12),
        )));
  }
}

class ZZUnimplementedBrickObject
    extends ZZBaseBrickObject<ZZUnimplementedBrick> {
  Widget? customWidget;
}

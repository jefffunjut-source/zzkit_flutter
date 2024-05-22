// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrick.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZUnimplementedBrick extends ZZBaseBrick<ZZUnimplementedBrickObject> {
  @override
  Widget build(BuildContext context) {
    return kDebugMode
        ? Container(
            color: Colors.amber,
            alignment: Alignment.centerLeft,
            width: 414.w,
            height: 60.w,
            child: Text(
              "Unimplemented",
              style: ZZ.textStyle(color: Colors.red, fontSize: 12),
            ))
        : Container();
  }
}

class ZZUnimplementedBrickObject
    extends ZZBaseBrickObject<ZZUnimplementedBrick> {
  Widget? customWidget;
}

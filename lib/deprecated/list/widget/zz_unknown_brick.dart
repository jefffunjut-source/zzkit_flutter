import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/deprecated/list/widget/zz_base_brick.dart';
import 'package:zzkit_flutter/util/zz_const.dart';
import 'package:zzkit_flutter/util/zz_manager.dart';

class ZZUnknownBrick extends ZZBaseBrick<ZZUnknownBrickObject> {
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
          ),
        )
        : Container();
  }
}

class ZZUnknownBrickObject extends ZZBaseBrickObject<ZZUnknownBrick> {
  Widget? customWidget;
}

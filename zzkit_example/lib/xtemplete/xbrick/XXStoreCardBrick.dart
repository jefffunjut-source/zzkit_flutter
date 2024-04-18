// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrick.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class XXStoreCardBrick extends ZZBaseBrick<XXStoreCardBrickObject> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          color: Colors.red,
          child: IntrinsicHeight(
            child: Column(children: [
              object?.pic != null
                  ? Image.network(object?.pic as String)
                  : Container(),
              Text(
                object?.title ?? "",
                style: ZZ.textStyle(
                    color: zzColorWhite,
                    fontSize: 16.sp,
                    bold: true,
                    height: 1.8),
              ),
              Text(
                object?.desc ?? "",
                style: ZZ.textStyle(
                    color: zzColorWhite, fontSize: 14.sp, height: 1.5),
              ),
            ]),
          )),
    );
  }
}

class XXStoreCardBrickObject extends ZZBaseBrickObject<XXStoreCardBrick> {
  String? id;
  String? pic;
  String? title;
  String? desc;
}

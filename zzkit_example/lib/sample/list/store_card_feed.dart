// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';
import 'package:zzkit_flutter/standard/allinone/ZZAllinoneList.dart';

class StoreCardFeed implements ZZFeed {
  final String id;
  final String pic;
  final String title;
  final String desc;

  StoreCardFeed({
    required this.id,
    required this.pic,
    required this.title,
    required this.desc,
  });

  @override
  Widget get widget {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(10.r),
        padding: EdgeInsets.all(10.r),
        color: Colors.green,
        child: IntrinsicHeight(
          child: Column(
            children: [
              pic.isNotEmpty ? Image.network(pic) : Container(),
              Text(
                title,
                style: ZZ.textStyle(
                  color: ZZColor.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.8,
                ),
              ),
              Text(
                desc,
                style: ZZ.textStyle(
                  color: ZZColor.white,
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

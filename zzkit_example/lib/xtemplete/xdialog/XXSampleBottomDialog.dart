// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/dialog/ZZBaseBottomDialog.dart';

class XXSampleBottomDialog extends ZZBaseBottomDialog {
  @override
  List<Widget> contentWidgets() {
    return [
      Container(
        color: Colors.amber,
        width: 414.w,
        height: 300.w,
        child: const Center(
            child: Text(
          '你好',
          style: TextStyle(color: Colors.black),
        )),
      )
    ];
  }

  @override
  double? contentHeight() {
    return 300.w;
  }
}

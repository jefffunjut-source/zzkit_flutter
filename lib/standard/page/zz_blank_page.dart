// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, file_names
import 'package:flutter/material.dart';

import 'package:zzkit_flutter/util/core/zz_const.dart';

class ZZBlankPage extends StatelessWidget {
  Color? color;
  ZZBlankPage({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: zzScreenWidth,
      height: zzScreenHeight,
      color: color ?? Colors.white,
    );
  }
}

import 'package:flutter/material.dart';

import 'package:zzkit_flutter/util/zz_const.dart';

class ZZBlankPage extends StatelessWidget {
  final Color? color;
  const ZZBlankPage({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: zzScreenWidth,
      height: zzScreenHeight,
      color: color ?? Colors.white,
    );
  }
}

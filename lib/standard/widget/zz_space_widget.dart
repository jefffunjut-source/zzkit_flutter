import 'package:flutter/material.dart';

/// 通用间距/占位组件
class ZZSpaceWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  /// [width] 默认 10
  /// [height] 默认 10
  /// [color] 默认透明，可设置背景色辅助调试布局
  const ZZSpaceWidget({
    super.key,
    this.width = 10.0,
    this.height = 10.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child:
          color != null
              ? DecoratedBox(decoration: BoxDecoration(color: color))
              : null,
    );
  }
}

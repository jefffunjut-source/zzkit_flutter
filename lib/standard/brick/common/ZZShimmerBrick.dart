// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrick.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';

class ZZShimmerBrick extends ZZBaseBrick<ZZShimmerBrickObject> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: object?.height ?? 120,
      child: object?.customWidget ??
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: object?.height ?? 120,
              width: zzScreenWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
    );
  }
}

class ZZShimmerBrickObject extends ZZBaseBrickObject<ZZShimmerBrick> {
  double? height;
  Widget? customWidget;
}

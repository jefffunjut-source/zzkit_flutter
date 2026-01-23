import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zzkit_flutter/standard/list/widget/zz_base_brick.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';

class ZZShimmerBrick extends ZZBaseBrick<ZZShimmerBrickObject> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: object?.height ?? 120,
      child:
          object?.customWidget ??
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: object?.height ?? 120,
              width: zzScreenWidth,
              decoration: const BoxDecoration(color: Colors.white),
            ),
          ),
    );
  }
}

class ZZShimmerBrickObject extends ZZBaseBrickObject<ZZShimmerBrick> {
  double? height;
  Widget? customWidget;
}

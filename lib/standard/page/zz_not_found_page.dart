import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/page/zz_base_scaffold.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';

class ZZNotFoundPage extends StatefulWidget {
  const ZZNotFoundPage({super.key});

  @override
  State<ZZNotFoundPage> createState() => _ZZNotFoundPageState();
}

class _ZZNotFoundPageState extends State<ZZNotFoundPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZZBaseScaffold(
      backgroundColor: Colors.white,
      appBar: ZZ.appbar(title: "Unknown"),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 414.w,
                height: 414.w,
                child: Center(
                  child: Text(
                    "Unknown Page\n请检查你的路由设置",
                    textAlign: TextAlign.center,
                    style: ZZ.textStyle(color: Colors.black, fontSize: 20.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

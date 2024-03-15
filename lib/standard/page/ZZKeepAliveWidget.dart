// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ZZKeepAliveWidget extends StatefulWidget {
  final Widget child;

  const ZZKeepAliveWidget({super.key, required this.child});

  @override
  KeepAliveWidgetState createState() => KeepAliveWidgetState();
}

class KeepAliveWidgetState extends State<ZZKeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

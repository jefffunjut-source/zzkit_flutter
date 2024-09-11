// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names
library zzkit;

import 'package:flutter/material.dart';

class ZZEventAppLife {
  AppLifecycleState? state;
}

class ZZEventKeyboard {
  bool? visible;
}

class ZZEventNestedScrollViewRefresh {
  String? name;
  ZZEventNestedScrollViewRefresh({
    required this.name,
  });
}

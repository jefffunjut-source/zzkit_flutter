// ignore_for_file: implementation_imports, library_prefixes, file_names, library_names
// ignore_for_file: non_constant_identifier_names, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, depend_on_referenced_packages

library zzkit;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';
import 'package:zzkit_flutter/util/api/ZZAPIProvider.dart';

import 'ZZAppConsts.dart';

part 'ZZAppLibUI.dart';
part 'ZZAppLibUtil.dart';

class ZZAppManager {
  /// ZZAppManager单例
  static final ZZAppManager singleton = ZZAppManager.internal();
  factory ZZAppManager() {
    return singleton;
  }
  ZZAppManager.internal();

  // sp
  late SharedPreferences prefs;

  // 当前页面
  String? pageName;

  // 上一页面
  String? prePageName;

  // 当前Tab页码
  int tabIndex = 0;

  // app是否新安装或更新
  bool? isNewInstallOrUpdate;

  Future<bool> initSomething() async {
    prefs = await SharedPreferences.getInstance();
    ZZAPIProvider.initailDio();
    return true;
  }
}

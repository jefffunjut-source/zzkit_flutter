// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, no_logic_in_create_state, file_names
// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class ZZWebViewController extends GetxController {
  // Progress bar
  bool enableProgress = true;
  RxDouble progress = 0.0.obs;
  int estimatedFinishedProgress = 80;
  double progressBarWidth = 414.w;
  double progressBarHeight = 1.0;
  Color? progressBarBackgroundColor;
  Color? progressTintColor;

  // Title & Url
  RxString title = "".obs;
  RxString url = "".obs;

  // UserAgent
  String? userAgent;

  // Forbidden Urls
  List<String> forbiddenUrls = [];
  // Forbidden Hosts
  List<String> forbiddenHosts = [];

  // JavaScript
  Map<String, ZZAppCallback1String>? actions;
  ZZAppCallback2String? defaultAction;
}

class ZZWebViewPage extends StatefulWidget {
  String? title;
  String? url;
  ZZWebViewPage({
    super.key,
    this.title,
    this.url,
  });

  @override
  ZZWebViewPageState createState() {
    ZZWebViewController zzWebViewController = Get.find();
    zzWebViewController.title.value = title ?? "";
    zzWebViewController.url.value = url ?? "";
    return ZZWebViewPageState();
  }
}

class ZZWebViewPageState extends State<ZZWebViewPage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    ZZWebViewController zzWebViewController = Get.find();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent(zzWebViewController.userAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int proceed) {
            debugPrint('WebView is loading (progress : $proceed%)');
            zzWebViewController.progress.value = proceed.toDouble() / 100.0;
            if (proceed > zzWebViewController.estimatedFinishedProgress) {
              zzWebViewController.progress.value = 1.0;
              Future.delayed(const Duration(seconds: 2), () {
                ZZ.dismiss();
              });
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (zzWebViewController.forbiddenHosts.isNotEmpty) {
              Uri uri = Uri.parse(request.url);
              String h = uri.host;
              for (String host in zzWebViewController.forbiddenHosts) {
                if (host == h) {
                  return NavigationDecision.prevent;
                }
              }
            }
            if (zzWebViewController.forbiddenUrls.isNotEmpty) {
              for (String url in zzWebViewController.forbiddenHosts) {
                if (url == request.url) {
                  return NavigationDecision.prevent;
                }
              }
            }
            // 同意跳转
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'action', //商家
        onMessageReceived: (JavaScriptMessage message) {
          if (zzWebViewController.defaultAction != null) {
            zzWebViewController.defaultAction!("action", message.message);
          }
        },
      )
      ..loadRequest(Uri.parse(zzWebViewController.url.value));

    zzWebViewController.actions?.forEach((key, value) {
      controller.addJavaScriptChannel(key,
          onMessageReceived: (JavaScriptMessage message) {
        value(message.message);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ZZWebViewController zzWebViewController = Get.find();
    return ZZBaseScaffold(
      backgroundColor: zzColorWhite,
      appBar: AppBar(
        backgroundColor: zzColorGreyF5,
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 6),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  zzWebViewController.title.value,
                  style: ZZ.textStyle(
                      color: zzColorBlack, fontSize: 18.sp, bold: true),
                ),
              ),
            ),
            Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Row(
                  children: [
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(left: 24.w),
                        child: ZZ.image(R.assetsImgIcNavBackBlack,
                            bundleName: zzBundleName),
                      ),
                      onTap: () {
                        Future<bool> can = controller.canGoBack();
                        can.then((value) {
                          if (value) {
                            controller.goBack().then((value) {
                              if (Platform.isIOS) {
                                // 处理302跳转返回白屏
                                Future<String?>? currentUrl =
                                    controller.currentUrl();
                                currentUrl.then((value) {
                                  if (value == zzWebViewController.url.value &&
                                      zzWebViewController
                                          .url.value.isNotEmpty) {
                                    controller.reload();
                                  }
                                });
                              }
                            });
                          } else {
                            Get.back();
                          }
                        });
                      },
                    ),
                  ],
                )),
            Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Row(
                  children: [
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(right: 24.w),
                        child: ZZ.image(R.assetsImgIcNavCloseBlack,
                            bundleName: zzBundleName),
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ],
                )),
          ],
        ),
        titleSpacing: 0,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const ZZProgressBarWidget(),
          Expanded(child: WebViewWidget(controller: controller))
        ],
      ),
    );
  }
}

class ZZProgressBarWidget extends StatefulWidget {
  const ZZProgressBarWidget({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return ZZProgressBarWidgetState();
  }
}

class ZZProgressBarWidgetState extends State<ZZProgressBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ZZWebViewController zzWebViewController = Get.find();
    return Obx(() {
      if (zzWebViewController.enableProgress &&
          (zzWebViewController.progress.value > 0 &&
              zzWebViewController.progress.value < 1.0)) {
        return Container(
          width: zzWebViewController.progressBarWidth,
          height: zzWebViewController.progressBarHeight,
          color: zzWebViewController.progressBarBackgroundColor ?? Colors.white,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: zzWebViewController.progressBarHeight,
                width: min(
                    zzWebViewController.progress.value *
                        zzWebViewController.progressBarWidth,
                    zzWebViewController.progressBarWidth),
                decoration: BoxDecoration(
                    color: zzWebViewController.progressTintColor ?? zzColorRed,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                            zzWebViewController.progressBarHeight / 2.0),
                        bottomRight: Radius.circular(
                            zzWebViewController.progressBarHeight / 2.0))),
              )
            ],
          ),
        );
      } else {
        return SizedBox(
          width: zzWebViewController.progressBarWidth,
          height: 0,
        );
      }
    });
  }
}

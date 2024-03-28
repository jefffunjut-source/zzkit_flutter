// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, no_logic_in_create_state, file_names, unused_element
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

  // Forward & Back
  RxBool canBack = false.obs;
  RxBool canForward = false.obs;

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

  // Scroll
  double scrollDelta = 2.0;
  RxBool scrollingDown = false.obs;
  double canvasHeight = double.infinity;
  double scrollHeight = double.infinity;
}

class ZZWebViewPage extends StatefulWidget {
  String? title;
  String? url;
  bool? hideNavigationBar;
  bool? hideProgressBar;
  Widget? titleView;
  Widget? bottomView;
  bool? hideBottomViewScrollingDown;
  ZZWebViewPage(
      {super.key,
      this.title,
      this.url,
      this.hideNavigationBar,
      this.hideProgressBar,
      this.titleView,
      this.bottomView,
      this.hideBottomViewScrollingDown});

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
  double lastY = 0;

  @override
  void dispose() {
    ZZWebViewController zzWebViewController = Get.find();
    zzWebViewController.canBack.value = false;
    zzWebViewController.canForward.value = false;
    zzWebViewController.title.value = "";
    zzWebViewController.url.value = "";
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ZZWebViewController zzWebViewController = Get.find();
    controller = WebViewController()
      ..setOnScrollPositionChange((change) {
        debugPrint("canvasHeight:${zzWebViewController.canvasHeight}");
        debugPrint("scrollHeight:${zzWebViewController.scrollHeight}");
        debugPrint("y:${change.y}");
        if (change.y < 0) return;
        if (change.y - lastY > zzWebViewController.scrollDelta) {
          zzWebViewController.scrollingDown.value = true;
          // debugPrint("scrollingDown");
        } else if (lastY - change.y > zzWebViewController.scrollDelta) {
          zzWebViewController.scrollingDown.value = false;
          // debugPrint("scrollingUp");
        }
        lastY = change.y;
      })
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
          onPageStarted: (String url) {
            _updateContentHeight();
          },
          onPageFinished: (String url) {
            _updateContentHeight();
            controller.canGoBack().then((value) {
              zzWebViewController.canBack.value = value;
              debugPrint("canBack:$value");
            });
            controller.canGoForward().then((value) {
              zzWebViewController.canForward.value = value;
              debugPrint("canForward:$value");
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            controller.canGoBack().then((value) {
              zzWebViewController.canBack.value = value;
              debugPrint("canBack:$value");
            });
            controller.canGoForward().then((value) {
              zzWebViewController.canForward.value = value;
              debugPrint("canForward:$value");
            });
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
    if (widget.hideNavigationBar ?? false) {
      return _mainWidget();
    } else {
      return ZZBaseScaffold(
        backgroundColor: zzColorWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Container(
            color: Colors.white,
            height: 54.w,
            child: Stack(
              children: [
                Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    top: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Back
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
                                          if (value ==
                                                  zzWebViewController
                                                      .url.value &&
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
                            // Forwards
                            Obx(() => GestureDetector(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 24.w),
                                    child: ZZ.image(
                                        zzWebViewController.canForward.value
                                            ? R.assetsImgIcNavForwardBlack
                                            : R.assetsImgIcNavForwardGray,
                                        bundleName: zzBundleName),
                                  ),
                                  onTap: () {
                                    if (zzWebViewController.canForward.value) {
                                      controller.goForward();
                                    }
                                  },
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            // Close
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
                        )
                      ],
                    )),
                widget.titleView ??
                    Container(
                      margin: const EdgeInsets.only(left: 2, right: 2),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          zzWebViewController.title.value,
                          style: ZZ.textStyle(
                              color: zzColorBlack, fontSize: 18.sp, bold: true),
                        ),
                      ),
                    )
              ],
            ),
          ),
          titleSpacing: 0,
          centerTitle: true,
          elevation: 0,
        ),
        body: _mainWidget(),
      );
    }
  }

  Widget _mainWidget() {
    return Column(
      children: [
        (widget.hideProgressBar ?? false)
            ? Container()
            : const ZZProgressBarWidget(),
        Expanded(child: WebViewWidget(controller: controller)),
        widget.bottomView ?? Container()
      ],
    );
  }

  void _updateContentHeight() {
    String javaScript = 'document.documentElement.clientHeight';
    controller.runJavaScriptReturningResult(javaScript).then((value) {
      ZZWebViewController zzWebViewController = Get.find();
      if (value is double) {
        zzWebViewController.canvasHeight = value;
      } else {
        zzWebViewController.canvasHeight =
            double.tryParse("$value") ?? double.infinity;
      }
    });

    javaScript = '''
      (function() {
        return Math.max(
          document.body.scrollHeight, document.documentElement.scrollHeight,
          document.body.offsetHeight, document.documentElement.offsetHeight,
          document.body.clientHeight, document.documentElement.clientHeight
        );
      })()
    ''';
    controller.runJavaScriptReturningResult(javaScript).then((value) {
      ZZWebViewController zzWebViewController = Get.find();
      if (value is double) {
        zzWebViewController.scrollHeight = value;
      } else {
        zzWebViewController.scrollHeight =
            double.tryParse("$value") ?? double.infinity;
      }
    });
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

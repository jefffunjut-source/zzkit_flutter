// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, no_logic_in_create_state, file_names, unused_element, prefer_final_fields
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
  RxDouble _progress = 0.0.obs;
  RxDouble get progress => _progress;
  int estimatedFinishedProgress = 80;
  double progressBarWidth = 414.w;
  double progressBarHeight = 1.0;
  Color? progressBarBackgroundColor;
  Color? progressTintColor;

  // Forward & Back
  RxBool _canBack = false.obs;
  RxBool get canBack => _canBack;
  RxBool _canForward = false.obs;
  RxBool get canForward => _canForward;

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
  RxBool _scrollingDown = false.obs;
  RxBool get scrollingDown => _scrollingDown;

  double _canvasHeight = double.infinity;
  double get canvasHeight => _canvasHeight;

  double _scrollHeight = double.infinity;
  double get scrollHeight => _scrollHeight;

  // WebViewController
  WebViewController? _controller;
  WebViewController? get controller => _controller;
}

class ZZWebViewPage extends StatefulWidget {
  String? title;
  String? url;
  bool? hideNavigationBar;
  bool? hideProgressBar;
  Widget? appBar;
  Widget? titleView;
  Widget? bottomView;
  bool? hideBottomViewScrollingDown;
  bool? safeAreaBottom;
  Color? backgroundColor;
  Color? appBarBackgroundColor;
  double? elevation;
  double? titleSpacing;
  bool? centerTitle;
  TextStyle? titleTextStyle;
  ZZWebViewPage(
      {super.key,
      this.title,
      this.url,
      this.hideNavigationBar,
      this.hideProgressBar,
      this.appBar,
      this.titleView,
      this.bottomView,
      this.hideBottomViewScrollingDown = false,
      this.safeAreaBottom = true,
      this.backgroundColor = Colors.white,
      this.appBarBackgroundColor = Colors.white,
      this.elevation = 0,
      this.titleSpacing = 0,
      this.centerTitle = true,
      this.titleTextStyle = const TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)});

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
    zzWebViewController._canBack.value = false;
    zzWebViewController._canForward.value = false;
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
        // debugPrint("canvasHeight:${zzWebViewController.canvasHeight}");
        // debugPrint("scrollHeight:${zzWebViewController.scrollHeight}");
        // debugPrint("y:${change.y}");
        if (change.y < 0) return;
        if (change.y - lastY > zzWebViewController.scrollDelta) {
          zzWebViewController._scrollingDown.value = true;
          // debugPrint("scrollingDown");
        } else if (lastY - change.y > zzWebViewController.scrollDelta) {
          zzWebViewController._scrollingDown.value = false;
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
            zzWebViewController._progress.value = proceed.toDouble() / 100.0;
            if (proceed > zzWebViewController.estimatedFinishedProgress) {
              zzWebViewController._progress.value = 1.0;
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
              zzWebViewController._canBack.value = value;
              // debugPrint("canBack:$value");
            });
            controller.canGoForward().then((value) {
              zzWebViewController._canForward.value = value;
              // debugPrint("canForward:$value");
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            controller.canGoBack().then((value) {
              zzWebViewController._canBack.value = value;
              // debugPrint("canBack:$value");
            });
            controller.canGoForward().then((value) {
              zzWebViewController._canForward.value = value;
              // debugPrint("canForward:$value");
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
        backgroundColor: widget.backgroundColor,
        safeAreaBottom: widget.safeAreaBottom,
        appBar: AppBar(
          backgroundColor: widget.appBarBackgroundColor,
          automaticallyImplyLeading: false,
          title: Container(
            color: widget.appBarBackgroundColor,
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
                                        zzWebViewController._canForward.value
                                            ? R.assetsImgIcNavForwardBlack
                                            : R.assetsImgIcNavForwardGray,
                                        bundleName: zzBundleName),
                                  ),
                                  onTap: () {
                                    if (zzWebViewController._canForward.value) {
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
                widget.appBar ??
                    Container(
                      margin: const EdgeInsets.only(left: 2, right: 2),
                      child: Container(
                        alignment: Alignment.center,
                        child: widget.titleView ??
                            Text(
                              zzWebViewController.title.value,
                              style: widget.titleTextStyle,
                            ),
                      ),
                    )
              ],
            ),
          ),
          titleSpacing: widget.titleSpacing,
          centerTitle: widget.centerTitle,
          elevation: widget.elevation,
        ),
        body: _mainWidget(),
      );
    }
  }

  Widget _mainWidget() {
    ZZWebViewController zzWebViewController = Get.find();
    return Column(
      children: [
        (widget.hideProgressBar ?? false)
            ? Container()
            : const ZZProgressBarWidget(),
        Expanded(child: WebViewWidget(controller: controller)),
        widget.hideBottomViewScrollingDown == true
            ? // 底部控件向下滚动时消失，网上滑动显示底部控件
            Obx(() => (zzWebViewController._scrollingDown.value
                ? Container()
                : widget.bottomView ?? Container()))
            // 底部控件常显
            : (widget.bottomView ?? Container())
      ],
    );
  }

  void _updateContentHeight() {
    String javaScript = 'document.documentElement.clientHeight';
    controller.runJavaScriptReturningResult(javaScript).then((value) {
      ZZWebViewController zzWebViewController = Get.find();
      if (value is double) {
        zzWebViewController._canvasHeight = value;
      } else {
        zzWebViewController._canvasHeight =
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
        zzWebViewController._scrollHeight = value;
      } else {
        zzWebViewController._scrollHeight =
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
          (zzWebViewController._progress.value > 0 &&
              zzWebViewController._progress.value < 1.0)) {
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
                    zzWebViewController._progress.value *
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

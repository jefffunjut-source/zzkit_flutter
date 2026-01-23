import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android & iOS features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/standard/page/zz_base_scaffold.dart';
import 'package:zzkit_flutter/util/zz_extension.dart';
import 'package:zzkit_flutter/util/zz_const.dart';
import 'package:zzkit_flutter/util/zz_manager.dart';

/// WebView控制器
class ZZWebViewController extends GetxController {
  // Progress bar
  bool enableProgress = true;
  final RxDouble _progress = 0.0.obs;
  RxDouble get progress => _progress;
  int estimatedFinishedProgress = 80;
  double progressBarWidth = 414.w;
  double progressBarHeight = 1.0;
  Color? progressBarBackgroundColor;
  Color? progressTintColor;

  // Forward & Back
  final RxBool _canBack = false.obs;
  RxBool get canBack => _canBack;
  final RxBool _canForward = false.obs;
  RxBool get canForward => _canForward;

  // Title & Url
  final RxString title = "".obs;
  final RxString url = "".obs;

  // UserAgent
  String? userAgent;
  String? userAgentAddon;

  // Forbidden Urls
  List<String> forbiddenUrls = [];
  // Forbidden Hosts
  List<String> forbiddenHosts = [];

  // JavaScript
  Map<String, ZZCallback2String>? actions;
  ZZCallback3String? defaultAction;

  // Scroll
  double scrollDelta = 2.0;
  final RxBool _scrollingDown = false.obs;
  RxBool get scrollingDown => _scrollingDown;

  double _canvasHeight = double.infinity;
  double get canvasHeight => _canvasHeight;

  double _scrollHeight = double.infinity;
  double get scrollHeight => _scrollHeight;

  // WebViewController
  WebViewController? _controller;
  WebViewController? get controller => _controller;

  // 白名单
  List<String> whiteList = [];
  // 黑名单
  List<String> blackList = [];
}

/// WebView页面
class ZZWebViewPage extends StatefulWidget {
  final String? title;
  final String? url;
  final bool? hideNavigationBar;
  final bool? hideProgressBar;
  final Widget? appBar;
  final Widget? titleView;
  final Widget? bottomView;
  final bool? hideBottomViewScrollingDown;
  final bool safeAreaBottom;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final double? elevation;
  final double? titleSpacing;
  final bool? centerTitle;
  final TextStyle? titleTextStyle;
  final String? extra;

  const ZZWebViewPage({
    super.key,
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
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    this.extra,
  });

  @override
  ZZWebViewPageState createState() {
    return ZZWebViewPageState();
  }
}

class ZZWebViewPageState extends State<ZZWebViewPage> {
  late WebViewController controller;
  String? title;
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
    zzWebViewController.title.value = widget.title ?? "";
    zzWebViewController.url.value = widget.url ?? "";
    title = zzWebViewController.title.value;

    _initializeWebView(zzWebViewController);
  }

  /// 初始化WebView
  void _initializeWebView(ZZWebViewController zzWebViewController) {
    // 创建WebView控制器
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    controller = WebViewController.fromPlatformCreationParams(params);

    // 设置UserAgent
    _setupUserAgent(zzWebViewController);

    // 配置WebView
    _configureWebView(zzWebViewController);

    // 设置JavaScript通道
    _setupJavaScriptChannels(zzWebViewController);

    // 配置平台特定功能
    _configurePlatformFeatures();

    // 打印UserAgent
    _printUserAgent();

    zzWebViewController._controller = controller;
  }

  /// 设置UserAgent
  void _setupUserAgent(ZZWebViewController zzWebViewController) {
    if (zzWebViewController.userAgent == null) {
      if (zzWebViewController.userAgentAddon != null &&
          zzWebViewController.userAgentAddon!.isNotEmpty) {
        controller.getUserAgent().then((value) async {
          String newUA = "$value${zzWebViewController.userAgentAddon}";
          zzWebViewController.userAgent = newUA;
          controller.setUserAgent(zzWebViewController.userAgent);
          await controller.reload();
          controller.getUserAgent().then((value) {
            debugPrint("After Reloading WebView Flutter UserAgent:$value");
          });
        });
      }
    }
  }

  /// 配置WebView
  void _configureWebView(ZZWebViewController zzWebViewController) {
    controller
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
          onPageFinished: (String url) async {
            _updateContentHeight();
            _updateNavigationStatus();
            _updatePageTitle();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            _updateNavigationStatus();

            if (request.url.startsWith("http") ||
                request.url.startsWith("https")) {
              return _handleHttpNavigation(zzWebViewController, request);
            } else {
              return _handleNonHttpNavigation(zzWebViewController, request);
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'action',
        onMessageReceived: (JavaScriptMessage message) {
          if (zzWebViewController.defaultAction != null) {
            zzWebViewController.defaultAction!(
              "action",
              message.message,
              widget.extra,
            );
          }
        },
      )
      ..loadRequest(Uri.parse(zzWebViewController.url.value));
  }

  /// 更新导航状态
  void _updateNavigationStatus() {
    ZZWebViewController zzWebViewController = Get.find();
    controller.canGoBack().then((value) {
      zzWebViewController._canBack.value = value;
      // debugPrint("canBack:$value");
    });
    controller.canGoForward().then((value) {
      zzWebViewController._canForward.value = value;
      // debugPrint("canForward:$value");
    });
  }

  /// 更新页面标题
  void _updatePageTitle() {
    ZZWebViewController zzWebViewController = Get.find();
    if (ZZ.isNullOrEmpty(title)) {
      controller.runJavaScriptReturningResult("document.title").then((value) {
        if (value is String) {
          zzWebViewController.title.value = value;
        }
      });
    }
  }

  /// 处理HTTP导航请求
  NavigationDecision _handleHttpNavigation(
    ZZWebViewController zzWebViewController,
    NavigationRequest request,
  ) {
    if (zzWebViewController.forbiddenHosts.isNotEmpty) {
      Uri uri = Uri.parse(request.url);
      String host = uri.host;
      for (String forbiddenHost in zzWebViewController.forbiddenHosts) {
        if (forbiddenHost == host) {
          return NavigationDecision.prevent;
        }
      }
    }

    if (zzWebViewController.forbiddenUrls.isNotEmpty) {
      for (String forbiddenUrl in zzWebViewController.forbiddenUrls) {
        if (forbiddenUrl == request.url) {
          return NavigationDecision.prevent;
        }
      }
    }

    return NavigationDecision.navigate;
  }

  /// 处理非HTTP导航请求
  Future<NavigationDecision> _handleNonHttpNavigation(
    ZZWebViewController zzWebViewController,
    NavigationRequest request,
  ) async {
    Uri uri = Uri.parse(request.url);

    if (zzWebViewController.whiteList.isNotEmpty) {
      if (zzWebViewController.whiteList.contains(uri.scheme)) {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          return NavigationDecision.prevent;
        } else {
          return NavigationDecision.navigate;
        }
      } else {
        return NavigationDecision.prevent;
      }
    } else if (zzWebViewController.blackList.isNotEmpty) {
      if (zzWebViewController.blackList.contains(uri.scheme)) {
        return NavigationDecision.prevent;
      } else {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          return NavigationDecision.prevent;
        } else {
          return NavigationDecision.navigate;
        }
      }
    } else {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return NavigationDecision.prevent;
      } else {
        return NavigationDecision.navigate;
      }
    }
  }

  /// 设置JavaScript通道
  void _setupJavaScriptChannels(ZZWebViewController zzWebViewController) {
    zzWebViewController.actions?.forEach((key, value) {
      controller.addJavaScriptChannel(
        key,
        onMessageReceived: (JavaScriptMessage message) {
          value(message.message, widget.extra);
        },
      );
    });
  }

  /// 配置平台特定功能
  void _configurePlatformFeatures() {
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  /// 打印UserAgent
  void _printUserAgent() {
    controller.getUserAgent().then((value) {
      debugPrint("WebView Flutter UserAgent:$value");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hideNavigationBar ?? false) {
      return _mainWidget();
    } else {
      return ZZBaseScaffold(
        backgroundColor: widget.backgroundColor,
        safeAreaBottom: widget.safeAreaBottom,
        appBar: _buildAppBar(),
        body: _mainWidget(),
      );
    }
  }

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar() {
    ZZWebViewController zzWebViewController = Get.find();

    return AppBar(
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
                      // 后退
                      _buildBackButton(),
                      // 前进
                      _buildForwardButton(zzWebViewController),
                    ],
                  ),
                  Row(
                    children: [
                      // 关闭
                      _buildCloseButton(),
                    ],
                  ),
                ],
              ),
            ),
            widget.appBar ?? _buildTitleContainer(zzWebViewController),
          ],
        ),
      ),
      titleSpacing: widget.titleSpacing,
      centerTitle: widget.centerTitle,
      elevation: widget.elevation,
    );
  }

  /// 构建后退按钮
  Widget _buildBackButton() {
    ZZWebViewController zzWebViewController = Get.find();
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 24.w),
        child: ZZ.image(R.assetsImgIcNavBackBlack, bundleName: zzBundleName),
      ),
      onTap: () async {
        bool canGoBack = await controller.canGoBack();
        if (canGoBack) {
          await controller.goBack();
          if (Platform.isIOS) {
            // 处理302跳转返回白屏
            String? currentUrl = await controller.currentUrl();
            if (currentUrl == zzWebViewController.url.value &&
                zzWebViewController.url.value.isNotEmpty) {
              await controller.reload();
            }
          }
        } else {
          Get.back();
        }
      },
    );
  }

  /// 构建前进按钮
  Widget _buildForwardButton(ZZWebViewController zzWebViewController) {
    return Obx(
      () => GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(left: 12.w, right: 12.w),
          child: ZZ.image(
            zzWebViewController._canForward.value
                ? R.assetsImgIcNavForwardBlack
                : R.assetsImgIcNavForwardGray,
            bundleName: zzBundleName,
          ),
        ),
        onTap: () {
          if (zzWebViewController._canForward.value) {
            controller.goForward();
          }
        },
      ),
    );
  }

  /// 构建关闭按钮
  Widget _buildCloseButton() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(right: 24.w),
        child: ZZ.image(R.assetsImgIcNavCloseBlack, bundleName: zzBundleName),
      ),
      onTap: () {
        Get.back();
      },
    );
  }

  /// 构建标题容器
  Widget _buildTitleContainer(ZZWebViewController zzWebViewController) {
    return Obx(
      () => Container(
        margin:
            (zzWebViewController.title.value.calculateTextLength() ?? 0) <= 16
                ? EdgeInsets.only(left: 100.w, right: 100.w)
                : EdgeInsets.only(left: 100.w, right: 60.w),
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child:
              widget.titleView ??
              Text(
                zzWebViewController.title.value,
                style: widget.titleTextStyle,
              ),
        ),
      ),
    );
  }

  Widget _mainWidget() {
    ZZWebViewController zzWebViewController = Get.find();
    return Column(
      children: [
        if (!(widget.hideProgressBar ?? false)) const ZZProgressBarWidget(),
        Expanded(child: WebViewWidget(controller: controller)),
        if (widget.hideBottomViewScrollingDown == true)
          // 底部控件向下滚动时消失，向上滑动显示底部控件
          Obx(
            () =>
                zzWebViewController._scrollingDown.value
                    ? const SizedBox.shrink()
                    : widget.bottomView ?? const SizedBox.shrink(),
          )
        // 底部控件常显
        else
          widget.bottomView ?? const SizedBox.shrink(),
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
  const ZZProgressBarWidget({super.key});

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
                  zzWebViewController.progressBarWidth,
                ),
                decoration: BoxDecoration(
                  color: zzWebViewController.progressTintColor ?? ZZColor.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      zzWebViewController.progressBarHeight / 2.0,
                    ),
                    bottomRight: Radius.circular(
                      zzWebViewController.progressBarHeight / 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return SizedBox(width: zzWebViewController.progressBarWidth, height: 0);
      }
    });
  }
}

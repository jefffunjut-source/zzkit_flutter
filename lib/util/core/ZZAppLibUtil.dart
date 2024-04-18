// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_interpolation_to_compose_strings, file_names, empty_catches

part of 'ZZAppManager.dart';

/// App版本Key
const kAppPrefsAppVersion = "kAppPrefsAppVersion";

class ZZAppPhoto {
  Future<String?> base64() async {
    Uint8List? mem = await memory;
    if (mem != null) {
      String base64Str = base64Encode(mem);
      return "data:image/png;base64," + base64Str;
    }
    return null;
  }

  Uint8List? actualMemory;
  Future<Uint8List?>? memory;
  String? image;
  String? is_cover;
  int? index;
  int? width;
  int? height;

  ZZAppPhoto(
      {this.memory,
      this.actualMemory,
      this.image,
      this.is_cover,
      this.index,
      this.width,
      this.height});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['is_cover'] = is_cover;
    data['index'] = index;
    data['width'] = width;
    data['height'] = height;
    return data;
  }

  ZZAppPhoto.fromJson(dynamic json) {
    image = json['image'];
    is_cover = json['is_cover'];
    index = json['index'];
    width = json['width'];
    height = json['height'];
  }
}

extension ZZAppLibUtil on ZZAppManager {
  /// Camera
  Future<List<ZZAppPhoto>?> selectPhoto(
      {int maxAssets = 3,
      int quality = 70,
      ThumbnailSize size = const ThumbnailSize(1000, 1000)}) async {
    final List<AssetEntity>? results = await AssetPicker.pickAssets(zzContext,
        pickerConfig: AssetPickerConfig(
          maxAssets: maxAssets,
          requestType: RequestType.image,
          textDelegate: const EnglishAssetPickerTextDelegate(),
          specialItemPosition: SpecialItemPosition.prepend,
          // textDelegate:  AssetPickerTextDelegate(),
          specialItemBuilder: (context, path, length) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final AssetEntity? result = await CameraPicker.pickFromCamera(
                  context,
                  pickerConfig: const CameraPickerConfig(
                      textDelegate: CameraPickerTextDelegate()),
                );

                if (result == null) {
                  return;
                }
                final AssetPicker<AssetEntity, AssetPathEntity> picker =
                    context.findAncestorWidgetOfExactType()!;
                final DefaultAssetPickerBuilderDelegate builder =
                    picker.builder as DefaultAssetPickerBuilderDelegate;
                final DefaultAssetPickerProvider p = builder.provider;
                await p.switchPath(
                  PathWrapper<AssetPathEntity>(
                    path: await p.currentPath!.path.obtainForNewProperties(),
                  ),
                );
                p.selectAsset(result);
              },
              child: const Center(
                child: Icon(Icons.camera_enhance, size: 42.0),
              ),
            );
          },
        ));
    return results?.map((entity) {
      return ZZAppPhoto(
        width: entity.width,
        height: entity.height,
        memory: entity.thumbnailDataWithSize(size, quality: quality),
      );
    }).toList();
  }

  ///avatar 头像，show_record攻略，normal通用
  Future<String?> uploadImage({String? base64, String? type = "avatar"}) async {
    if (base64 == null) {
      return null;
    }
    return null;
  }

  /// 收回键盘
  void collapseKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(zzContext);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// 拷贝文本到粘贴板
  void copyToClipboard(String content) {
    Clipboard.setData(ClipboardData(text: content))
        .then((value) => toast("复制成功"));
  }

  String generateRandomString(int length) {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();
    return randomString;
  }

  /// 返利
  List<String> splitRebateDesc(String? rebateDesc) {
    List<String> result = ["", ""];
    RegExp regExp =
        RegExp(r"((\SGD)?\$?\A?\C?\￡?\$?\€?(INR)?\d+(?:\.\d+)?\%?)");
    String? rebate;
    String? cashBack;

    if (rebateDesc != null && rebateDesc.isNotEmpty) {
      rebate = regExp.stringMatch(rebateDesc);
      if (rebate != null && rebate.isNotEmpty) {
        cashBack = rebateDesc.replaceAll(rebate, "");
      } else {
        cashBack = rebateDesc;
      }
    }
    result[0] = rebate ?? "";
    result[1] = cashBack ?? "";
    return result;
  }

  // msg 消息 详情跳转，1跳链接，2商家，3deal，4晒单，5评论，0不跳，注意要jump_data有数据才跳，0不跳转
  void msgForward(
    String? jumpType,
    String? jumpData,
    String? jumpDataId,
    String? topicId,
    String? commentType,
  ) {
    if (jumpData == null || jumpData == "") return;
    switch (jumpType) {
      case "1":
        {
          // 链接
          break;
        }

      default:
    }
  }

  void forward(String? type, String? title, String? linkData, String? id,
      String? needLogin) {}

  String getStoreBgColor(String storeLogo) {
    var uri = Uri.parse(storeLogo);
    return uri.queryParameters['store_logo_bg_color']
            ?.replaceAll("#", "0xFF") ??
        "0xFFFFFFFF";
  }

  String getStoreLogo(String storeLogo) {
    var uri = Uri.parse(storeLogo);
    return uri.queryParameters['replace_img'] ?? storeLogo;
  }

  void doFollow(
      String? currentFollow, String uid, ZZAppCallback1String? followCallback) {
    // 0无关系   1 a为b粉丝   2 a与b互相  3 b为a粉丝
  }

  void pushClick(Map<dynamic, dynamic> messageExtras) {
    if (Platform.isAndroid) {
      String messageContent = messageExtras['cn.jpush.android.EXTRA'];
      Map<String, dynamic> data = jsonDecode(messageContent);

      Future.delayed(const Duration(seconds: 1), () {
        // 推送
        String type = data["type"] ?? '';
        String value = data["value"] ?? '';
        String id = data["id"] ?? '';
        String name = data["name"] ?? '';
        forward(type, name, value, id, "0");
      });
    } else {
      String type = messageExtras["type"] ?? '';
      String value = messageExtras["value"] ?? '';
      String id = messageExtras["id"] ?? '';
      String name = messageExtras["name"] ?? '';
      if (kDebugMode) {
        print("flutter onOpenNotification ios: $messageExtras");
      }
      Future.delayed(const Duration(seconds: 1), () {
        forward(type, name, value, id, "0");
      });
    }
  }

  Future<ui.Image> getImageFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(Uint8List.fromList(bytes), (ui.Image img) {
      completer.complete(img);
    });

    return completer.future;
  }

  bool? getNewInstallOrUpdate(String currentVersion) {
    bool? isNewInstallOrUpdate = prefs.getBool("isNewInstallOrUpdate");
    if (isNewInstallOrUpdate != null) return isNewInstallOrUpdate;
    String? appPrefsVersion = ZZ.prefs.getString(kAppPrefsAppVersion);
    ZZ.prefs.setString(kAppPrefsAppVersion, currentVersion);
    if (appPrefsVersion == null || appPrefsVersion != currentVersion) {
      return true;
    }
    return false;
  }

  void debugPrintTime({String? keyword}) {
    debugPrint(
        "keyword=$keyword  ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}:${DateTime.now().millisecond}");
  }
}

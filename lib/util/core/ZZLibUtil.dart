// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_interpolation_to_compose_strings, file_names, empty_catches

part of 'ZZManager.dart';

/// App版本Key
const kAppPrefsAppVersion = "kAppPrefsAppVersion";

class ZZPhoto {
  String? image;
  int? width;
  int? height;
  String? isCover;
  List<ZZImageTag>? tags;
  int? index;

  Uint8List? memory;
  String? base64;

  ZZPhoto({
    this.image,
    this.width,
    this.height,
    this.isCover,
    this.tags,
    this.index,
    this.memory,
    this.base64,
  });

  static String? toBase64FromMemory(Uint8List? mem) {
    if (mem == null) return null;
    String base64Str = base64Encode(mem);
    return "data:image/png;base64," + base64Str;
  }

  ZZPhoto.fromJson(Map<String, dynamic> json) {
    if (json["image"] is String) {
      image = json["image"];
    }
    if (json["width"] is int) {
      width = json["width"];
    }
    if (json["height"] is int) {
      height = json["height"];
    }
    if (json["is_cover"] is String) {
      isCover = json["is_cover"];
    }
    if (json["tags"] is List) {
      tags = json["tags"] == null
          ? null
          : (json["tags"] as List).map((e) => ZZImageTag.fromJson(e)).toList();
    }
    if (json["index"] is int) {
      index = json["index"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["image"] = image;
    data["width"] = width;
    data["height"] = height;
    data["is_cover"] = isCover;
    if (tags != null) {
      data["tags"] = tags?.map((e) => e.toJson()).toList();
    }
    data["index"] = index;
    return data;
  }
}

class ZZImageTag {
  int? direction;
  String? id;
  String? name;
  String? status;
  String? type;
  String? v;
  double? x;
  double? y;

  ZZImageTag(
      {this.direction,
      this.id,
      this.name,
      this.status,
      this.type,
      this.v,
      this.x,
      this.y});

  ZZImageTag.fromJson(Map<String, dynamic> json) {
    if (json["direction"] is int) {
      direction = json["direction"];
    }
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["type"] is String) {
      type = json["type"];
    }
    if (json["v"] is String) {
      v = json["v"];
    }
    if (json["x"] is double) {
      x = json["x"];
    }
    if (json["y"] is double) {
      y = json["y"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["direction"] = direction;
    data["id"] = id;
    data["name"] = name;
    data["status"] = status;
    data["type"] = type;
    data["v"] = v;
    data["x"] = x;
    data["y"] = y;
    return data;
  }
}

extension ZZLibUtil on ZZManager {
  /// Camera
  Future<List<ZZPhoto>?> selectPhoto(
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
    List<ZZPhoto> list = [];
    if (results != null && results.isNotEmpty) {
      for (AssetEntity element in results) {
        Uint8List? mem =
            await element.thumbnailDataWithSize(size, quality: quality);
        list.add(ZZPhoto(
          width: element.width,
          height: element.height,
          memory: mem,
        ));
      }
    }
    return list;
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

  /// 随机字符串
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

  /// 获取网络图片
  Future<ui.Image> getImageFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(Uint8List.fromList(bytes), (ui.Image img) {
      completer.complete(img);
    });

    return completer.future;
  }

  /// 相比当前版本是否有更新或完全新下载
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

  /// 打印Log
  void debugPrintTime({String? keyword}) {
    debugPrint(
        "keyword=$keyword  ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}:${DateTime.now().millisecond}");
  }

  /// 指针空或空字符串
  bool isNullOrEmpty(String? text) {
    if (text == null) {
      return true;
    }
    if (text.isEmpty) {
      return true;
    }
    return false;
  }

  /// 计算缓存大小
  Future<String> getCacheSize() async {
    int size = await getCacheBytes();
    if (size < 1024) {
      return "";
    }
    int kb = size ~/ 1024;
    if (kb < 1024) {
      return "$kb KB";
    }
    int mb = kb ~/ 1024;
    if (mb < 1024) {
      return "$mb MB";
    }
    int gb = mb ~/ 1024;
    return "$gb GB";
  }

  /// 计算缓存大小
  Future<int> getCacheBytes() async {
    Directory cacheDir = await getTemporaryDirectory();
    int totalSize = 0;

    try {
      totalSize = await calculateDirectorySize(cacheDir);
    } catch (e) {
      debugPrint('Error calculating cache size: $e');
    }
    return totalSize;
  }

  /// 递归计算目录大小
  Future<int> calculateDirectorySize(Directory directory) async {
    int totalSize = 0;
    final List<FileSystemEntity> entities = directory.listSync();

    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        totalSize += await entity.length();
      } else if (entity is Directory) {
        totalSize += await calculateDirectorySize(entity);
      }
    }
    return totalSize;
  }

  /// 清除缓存
  Future<void> clearCache() async {
    Directory cacheDir = await getTemporaryDirectory();

    try {
      await deleteDirectory(cacheDir);
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  /// 递归删除目录
  Future<void> deleteDirectory(Directory directory) async {
    final List<FileSystemEntity> entities = directory.listSync();

    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        await entity.delete();
      } else if (entity is Directory) {
        await deleteDirectory(entity);
      }
    }
  }

  /// throttle时间阈值
  void throttle(
      {required Timer? debounce,
      int milliseconds = 500,
      void Function()? callback}) async {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(Duration(milliseconds: milliseconds), () {
      if (callback != null) {
        callback();
      }
    });
  }
}

// ignore_for_file: unused_field, library_private_types_in_public_api, file_names, must_be_immutable
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/widget/ZZOuterRadiusWidget.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';

typedef ZZImageInfoCallback = void Function(ZZCustomImageInfo? imageInfo);

enum ZZImageResize {
  none,
  adjustHeight,
  adjustWidth,
}

class ZZImageWidget extends StatefulWidget {
  final dynamic source;
  final Color? backgroundColor;
  final Widget? placeholderImage;
  final Widget? errorPlaceholderImage;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double? radius;
  final double? borderWidth;
  final Color? borderColor;
  final ZZImageResize? resize;
  final ZZImageInfoCallback? onImageInfoChange;
  final int? index;
  final Object? extra;
  final ZZCallback1Int1Object? onTap;

  const ZZImageWidget({
    super.key,
    required this.source,
    this.backgroundColor,
    this.placeholderImage,
    this.errorPlaceholderImage,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.radius,
    this.borderWidth,
    this.borderColor,
    this.resize = ZZImageResize.none,
    this.onImageInfoChange,
    this.index,
    this.extra,
    this.onTap,
  });

  @override
  _ZZImageWidgetState createState() => _ZZImageWidgetState();

  static Future<void> getImageInfoFromUrl(
      {required String? imageUrl,
      required ZZImageInfoCallback onImageInfoChange}) async {
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl.startsWith("http")) {
      try {
        Image image = Image(image: CachedNetworkImageProvider(imageUrl));
        image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo image, bool synchronousCall) {
              var myImage = image.image;
              ZZCustomImageInfo imageInfo = ZZCustomImageInfo();
              imageInfo.imageUrl = imageUrl;
              imageInfo.imageWidth = myImage.width;
              imageInfo.imageHeight = myImage.height;
              imageInfo.ratio = myImage.height / myImage.width;
              onImageInfoChange(imageInfo);
            },
          ),
        );
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  static Future<void> getImageInfoFromMemory(
      {required Uint8List? bytes,
      required ZZImageInfoCallback onImageInfoChange}) async {
    if (bytes != null) {
      try {
        final image = await decodeImageFromList(bytes);
        ZZCustomImageInfo imageInfo = ZZCustomImageInfo();
        imageInfo.imageWidth = image.width;
        imageInfo.imageHeight = image.height;
        imageInfo.ratio = image.height / image.width;
        onImageInfoChange(imageInfo);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  static Future<void> getImageInfoFromPath(
      {required String? path,
      required ZZImageInfoCallback onImageInfoChange}) async {
    if (path != null) {
      try {
        final image = Image.asset(path);
        ZZCustomImageInfo imageInfo = ZZCustomImageInfo();
        imageInfo.imageWidth = image.width as int?;
        imageInfo.imageHeight = image.height as int?;
        if (image.width == null || image.height == null) {
          imageInfo.ratio = null;
        } else {
          imageInfo.ratio = image.height! / image.width!;
        }
        onImageInfoChange(imageInfo);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}

class _ZZImageWidgetState extends State<ZZImageWidget> {
  ZZCustomImageInfo? customImageInfo;
  double? adjustedHeight;
  double? adjustedWidth;
  String? imageUrl;
  String? imagePath;
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _prepare();
    if (widget.onImageInfoChange != null ||
        widget.resize != ZZImageResize.none) {
      if (imageUrl != null) {
        ZZImageWidget.getImageInfoFromUrl(
          imageUrl: imageUrl,
          onImageInfoChange: (imageInfo) {
            if (widget.resize != ZZImageResize.none) {
              _resize() == true ? null : widget.onImageInfoChange!(imageInfo);
            } else {
              widget.onImageInfoChange!(imageInfo);
            }
          },
        );
      } else if (imagePath != null) {
        ZZImageWidget.getImageInfoFromPath(
          path: imagePath,
          onImageInfoChange: (imageInfo) {
            if (widget.resize != ZZImageResize.none) {
              _resize() == true ? null : widget.onImageInfoChange!(imageInfo);
            } else {
              widget.onImageInfoChange!(imageInfo);
            }
          },
        );
      } else if (imageBytes != null) {
        ZZImageWidget.getImageInfoFromMemory(
          bytes: imageBytes,
          onImageInfoChange: (imageInfo) {
            if (widget.resize != ZZImageResize.none) {
              _resize() == true ? null : widget.onImageInfoChange!(imageInfo);
            } else {
              widget.onImageInfoChange!(imageInfo);
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _prepare();
    return _imageWidgetWithRadius();
  }

  void _prepare() {
    imageUrl = null;
    imagePath = null;
    imageBytes = null;
    if (widget.source != null) {
      if (widget.source is String) {
        if (widget.source.contains("http")) {
          imageUrl = widget.source;
        } else {
          imagePath = widget.source;
        }
      } else if (widget.source is Int8List) {
        imageBytes = widget.source;
      }
    }
  }

  Widget _placehoderWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: widget.placeholderImage ??
          Center(
            child: SizedBox(
              width: min(36.w, widget.width ?? double.infinity),
              height: min(36.w, widget.height ?? double.infinity),
              child: const CupertinoActivityIndicator(
                animating: true,
              ),
            ),
          ),
    );
  }

  Widget _errorWidget() {
    return widget.errorPlaceholderImage ?? _placehoderWidget();
  }

  Widget _imageWidgetWithRadius() {
    if (widget.radius != null ||
        widget.borderWidth != null ||
        widget.borderColor != null) {
      return ZZOuterRadiusWidget(
          radius: widget.radius,
          borderWidth: widget.borderWidth,
          borderColor: widget.borderColor,
          child: _imageWidgetWithOnTap());
    } else {
      return _imageWidgetWithOnTap();
    }
  }

  Widget _imageWidgetWithOnTap() {
    if (widget.onTap != null) {
      return GestureDetector(
        onTap: () {
          widget.onTap!(widget.index, widget.extra);
        },
        child: _imageWidget(),
      );
    } else {
      return _imageWidget();
    }
  }

  Widget _imageWidget() {
    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        imageUrl!.startsWith("http")) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: adjustedWidth ?? widget.width,
        height: adjustedHeight ?? widget.height,
        color: widget.backgroundColor,
        fit: widget.fit,
        placeholder: (context, url) {
          return _placehoderWidget();
        },
        errorWidget: (context, url, error) {
          return _errorWidget();
        },
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Image(image: AssetImage(imagePath!));
    } else if (imageBytes != null) {
      return Image.memory(
        imageBytes!,
        width: adjustedWidth ?? widget.width,
        height: adjustedHeight ?? widget.height,
        color: widget.backgroundColor,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) {
          return _errorWidget();
        },
      );
    } else {
      return _placehoderWidget();
    }
  }

  bool _resize() {
    if (widget.resize == ZZImageResize.adjustHeight) {
      if (widget.width != null) {
        double h = widget.width! *
            (customImageInfo!.imageHeight! / customImageInfo!.imageWidth!);
        setState(() {
          adjustedHeight = h;
        });
        customImageInfo?.widgetWidth = widget.width;
        customImageInfo?.widgetHeight = h;
        if (widget.onImageInfoChange != null) {
          widget.onImageInfoChange!(customImageInfo);
        }
        return true;
      }
    } else if (widget.resize == ZZImageResize.adjustWidth) {
      if (widget.height != null) {
        double w = widget.height! *
            (customImageInfo!.imageWidth! / customImageInfo!.imageHeight!);
        setState(() {
          adjustedWidth = w;
        });
        customImageInfo?.widgetWidth = w;
        customImageInfo?.widgetHeight = widget.height;
        if (widget.onImageInfoChange != null) {
          widget.onImageInfoChange!(customImageInfo);
        }
        return true;
      }
    }
    return false;
  }
}

class ZZCustomImageInfo {
  String? imageUrl;
  int? imageWidth;
  int? imageHeight;
  double? ratio; // 高宽比
  double? widgetWidth;
  double? widgetHeight;
}

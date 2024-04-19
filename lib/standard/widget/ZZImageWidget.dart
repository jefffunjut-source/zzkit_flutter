// ignore_for_file: unused_field, library_private_types_in_public_api, file_names

import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

typedef ZZImageInfoCallback = void Function(ZZCustomImageInfo? imageInfo);

enum ZZImageSizeAjdust {
  none,
  adjustHeight,
  adjustWidth,
}

class ZZImageWidget extends StatefulWidget {
  final String? imageUrl;
  final Uint8List? imageBase64;
  final Color? backgroundColor;
  final Widget? placeholderImage;
  final Widget? errorPlaceholderImage;
  final BoxFit fit;
  final double? width;
  final double? height;
  final ZZImageInfoCallback? onImageLoaded;
  final int? index;
  final Object? extra;
  final ZZAppCallback1Int1Object? onTap;
  final ZZImageSizeAjdust? sizeAjdust;
  final double? radius;
  final double? borderWidth;
  final Color? borderColor;

  const ZZImageWidget({
    super.key,
    required this.imageUrl,
    this.imageBase64,
    this.backgroundColor,
    this.placeholderImage,
    this.errorPlaceholderImage,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.onImageLoaded,
    this.index,
    this.extra,
    this.onTap,
    this.sizeAjdust = ZZImageSizeAjdust.none,
    this.radius,
    this.borderWidth,
    this.borderColor,
  });

  @override
  _ZZImageWidgetState createState() => _ZZImageWidgetState();
}

class _ZZImageWidgetState extends State<ZZImageWidget> {
  bool _loading = true;
  bool _error = false;
  ZZCustomImageInfo? customImageInfo;
  double? adjustedHeight;
  double? adjustedWidth;

  @override
  void initState() {
    super.initState();
    if (widget.imageBase64 != null) {
      _getImageInfoFromBase64();
    } else if (widget.imageUrl != null) {
      _getImageInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageBase64 == null && widget.imageUrl == null) {
      return Container();
    }
    if (_error) {
      return widget.errorPlaceholderImage ??
          Container(color: Colors.grey, child: const Icon(Icons.error));
    }

    if (_loading) {
      return _placehoderWidget();
    } else {
      return _imageWidgetWithRadius();
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
    return widget.errorPlaceholderImage ??
        Container(color: Colors.grey, child: const Icon(Icons.error));
  }

  Widget _imageWidgetWithRadius() {
    if (widget.radius != null ||
        widget.borderWidth != null ||
        widget.borderColor != null) {
      return ZZ.outerBorderRadious(
          radius: widget.radius,
          borderWidth: widget.borderWidth,
          borderColor: widget.borderColor,
          widget: _imageWidgetWithOnTap());
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
    return widget.imageBase64 != null
        ? Image.memory(
            widget.imageBase64!,
            width: adjustedWidth ?? widget.width,
            height: adjustedHeight ?? widget.height,
            color: widget.backgroundColor,
            fit: widget.fit,
            errorBuilder: (context, error, stackTrace) {
              return _errorWidget();
            },
          )
        : CachedNetworkImage(
            imageUrl: widget.imageUrl!,
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
  }

  Future<void> _getImageInfoFromBase64() async {
    try {
      final Uint8List? bytes = widget.imageBase64;
      if (bytes == null) return;
      final image = await decodeImageFromList(bytes);
      customImageInfo ??= ZZCustomImageInfo();
      setState(() {
        customImageInfo?.imageWidth = image.width;
        customImageInfo?.imageHeight = image.height;
        customImageInfo?.ratio = image.height / image.width;
        customImageInfo?.imageSize = bytes.length;
        _loading = false;
        _error = false;
      });
      if (widget.onImageLoaded != null) {
        widget.onImageLoaded!(customImageInfo);
      }
      _adjustSize();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _getImageInfo() async {
    try {
      DefaultCacheManager cacheManager = DefaultCacheManager();
      FileInfo? fileInfo =
          await cacheManager.getFileFromCache(widget.imageUrl!);
      if (fileInfo != null) {
        Image image = Image.file(fileInfo.file);
        image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo imageInfo, bool synchronousCall) {
              customImageInfo ??= ZZCustomImageInfo();
              setState(() {
                customImageInfo?.imageUrl = widget.imageUrl;
                customImageInfo?.imageWidth = imageInfo.image.width;
                customImageInfo?.imageHeight = imageInfo.image.height;
                customImageInfo?.ratio =
                    imageInfo.image.height / imageInfo.image.width;
                customImageInfo?.imageSize = fileInfo.file.lengthSync();
                _loading = false;
                _error = false;
              });
              if (widget.onImageLoaded != null) {
                widget.onImageLoaded!(customImageInfo);
              }
              _adjustSize();
            },
          ),
        );
      } else {
        await cacheManager.downloadFile(widget.imageUrl!);
        _getImageInfo();
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void _adjustSize() {
    if (widget.sizeAjdust == ZZImageSizeAjdust.adjustHeight) {
      if (widget.width != null) {
        double h = widget.width! *
            (customImageInfo!.imageHeight! / customImageInfo!.imageWidth!);
        setState(() {
          adjustedHeight = h;
        });
        customImageInfo?.actualWidgetWidth = widget.width;
        customImageInfo?.actualWidgetHeight = h;
        if (widget.onImageLoaded != null) {
          widget.onImageLoaded!(customImageInfo);
        }
      }
    } else if (widget.sizeAjdust == ZZImageSizeAjdust.adjustWidth) {
      if (widget.height != null) {
        double w = widget.height! *
            (customImageInfo!.imageWidth! / customImageInfo!.imageHeight!);
        setState(() {
          adjustedWidth = w;
        });
        customImageInfo?.actualWidgetWidth = w;
        customImageInfo?.actualWidgetHeight = widget.height;
        if (widget.onImageLoaded != null) {
          widget.onImageLoaded!(customImageInfo);
        }
      }
    }
  }
}

class ZZCustomImageInfo {
  String? imageUrl;
  int? imageWidth;
  int? imageHeight;
  int? imageSize;
  // 高宽比
  double? ratio;
  double? actualWidgetWidth;
  double? actualWidgetHeight;
}

import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/widget/zz_outer_radius_widget.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';

typedef ZZImageInfoCallback = void Function(ZZCustomImageInfo? imageInfo);

enum ZZImageResize { none, adjustHeight, adjustWidth }

class ZZImage extends StatefulWidget {
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
  final ZZImageResize resize;
  final ZZImageInfoCallback? onImageInfoChange;
  final int? index;
  final Object? extra;
  final ZZCallback1Int1Object? onTap;

  const ZZImage({
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
  State<ZZImage> createState() => _ZZImageState();

  /* ---------- static image info helpers ---------- */

  static Future<void> getImageInfoFromUrl({
    required String? imageUrl,
    required ZZImageInfoCallback onImageInfoChange,
  }) async {
    if (imageUrl == null || imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      return;
    }

    try {
      final Image image = Image(image: CachedNetworkImageProvider(imageUrl));
      image.image
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener((ImageInfo info, bool _) {
              final imageInfo =
                  ZZCustomImageInfo()
                    ..imageUrl = imageUrl
                    ..imageWidth = info.image.width
                    ..imageHeight = info.image.height
                    ..ratio = info.image.height / info.image.width;
              onImageInfoChange(imageInfo);
            }),
          );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> getImageInfoFromMemory({
    required Uint8List? bytes,
    required ZZImageInfoCallback onImageInfoChange,
  }) async {
    if (bytes == null) return;

    try {
      final image = await decodeImageFromList(bytes);
      final imageInfo =
          ZZCustomImageInfo()
            ..imageWidth = image.width
            ..imageHeight = image.height
            ..ratio = image.height / image.width;
      onImageInfoChange(imageInfo);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> getImageInfoFromPath({
    required String? path,
    required ZZImageInfoCallback onImageInfoChange,
  }) async {
    if (path == null || path.isEmpty) return;

    try {
      final Image image = Image.asset(path);
      final imageInfo =
          ZZCustomImageInfo()
            ..imageWidth = image.width as int?
            ..imageHeight = image.height as int?;

      if (imageInfo.imageWidth != null && imageInfo.imageHeight != null) {
        imageInfo.ratio = imageInfo.imageHeight! / imageInfo.imageWidth!;
      }

      onImageInfoChange(imageInfo);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class _ZZImageState extends State<ZZImage> {
  ZZCustomImageInfo? _customImageInfo;

  double? _adjustedHeight;
  double? _adjustedWidth;

  String? _imageUrl;
  String? _imagePath;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _prepareSource();
    _loadImageInfoIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return _buildWithRadius();
  }

  /* ---------- preparation ---------- */

  void _prepareSource() {
    _imageUrl = null;
    _imagePath = null;
    _imageBytes = null;

    final source = widget.source;
    if (source is String) {
      if (source.startsWith('http')) {
        _imageUrl = source;
      } else {
        _imagePath = source;
      }
    } else if (source is Uint8List) {
      _imageBytes = source;
    }
  }

  void _loadImageInfoIfNeeded() {
    if (widget.onImageInfoChange == null &&
        widget.resize == ZZImageResize.none) {
      return;
    }

    if (_imageUrl != null) {
      ZZImage.getImageInfoFromUrl(
        imageUrl: _imageUrl,
        onImageInfoChange: _onImageInfoLoaded,
      );
    } else if (_imagePath != null) {
      ZZImage.getImageInfoFromPath(
        path: _imagePath,
        onImageInfoChange: _onImageInfoLoaded,
      );
    } else if (_imageBytes != null) {
      ZZImage.getImageInfoFromMemory(
        bytes: _imageBytes,
        onImageInfoChange: _onImageInfoLoaded,
      );
    }
  }

  void _onImageInfoLoaded(ZZCustomImageInfo? info) {
    if (info == null) return;
    _customImageInfo = info;

    if (widget.resize != ZZImageResize.none && _resize()) {
      return;
    }

    widget.onImageInfoChange?.call(info);
  }

  /* ---------- widget building ---------- */

  Widget _buildWithRadius() {
    final Widget child = _buildWithOnTap();

    if (widget.radius != null ||
        widget.borderWidth != null ||
        widget.borderColor != null) {
      return ZZOuterRadiusWidget(
        radius: widget.radius,
        borderWidth: widget.borderWidth,
        borderColor: widget.borderColor,
        child: child,
      );
    }
    return child;
  }

  Widget _buildWithOnTap() {
    if (widget.onTap == null) {
      return _buildImage();
    }

    return GestureDetector(
      onTap: () => widget.onTap!(widget.index, widget.extra),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (_imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: _imageUrl!,
        width: _adjustedWidth ?? widget.width,
        height: _adjustedHeight ?? widget.height,
        fit: widget.fit,
        placeholder: (_, __) => _placeholder(),
        errorWidget: (_, __, ___) => _errorWidget(),
      );
    }

    if (_imagePath != null) {
      return Image.asset(
        _imagePath!,
        width: _adjustedWidth ?? widget.width,
        height: _adjustedHeight ?? widget.height,
        fit: widget.fit,
      );
    }

    if (_imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        width: _adjustedWidth ?? widget.width,
        height: _adjustedHeight ?? widget.height,
        fit: widget.fit,
        errorBuilder: (_, __, ___) => _errorWidget(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child:
          widget.placeholderImage ??
          Center(
            child: SizedBox(
              width: min(36.w, widget.width ?? double.infinity),
              height: min(36.w, widget.height ?? double.infinity),
              child: const CupertinoActivityIndicator(),
            ),
          ),
    );
  }

  Widget _errorWidget() {
    return widget.errorPlaceholderImage ?? _placeholder();
  }

  /* ---------- resize ---------- */

  bool _resize() {
    try {
      final info = _customImageInfo;
      if (info == null || info.imageWidth == null || info.imageHeight == null) {
        return false;
      }

      if (widget.resize == ZZImageResize.adjustHeight && widget.width != null) {
        final double height =
            widget.width! * info.imageHeight! / info.imageWidth!;
        setState(() => _adjustedHeight = height);

        info
          ..widgetWidth = widget.width
          ..widgetHeight = height;

        widget.onImageInfoChange?.call(info);
        return true;
      }

      if (widget.resize == ZZImageResize.adjustWidth && widget.height != null) {
        final double width =
            widget.height! * info.imageWidth! / info.imageHeight!;
        setState(() => _adjustedWidth = width);

        info
          ..widgetWidth = width
          ..widgetHeight = widget.height;

        widget.onImageInfoChange?.call(info);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
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

// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:dio/dio.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';
import 'package:get/get.dart';

class ZZImageViewer extends StatefulWidget {
  final List<String> imageUrls; // 传入网络图片URL列表
  final int index; // 指定初始显示的图片索引
  const ZZImageViewer(
      {super.key, required this.imageUrls, required this.index});

  @override
  ZZImageViewerState createState() => ZZImageViewerState();

  static void show({required List<String>? images, int index = 0}) {
    if (images == null || images.isEmpty) return;
    Get.to(ZZImageViewer(
      imageUrls: images,
      index: index,
    ));
  }
}

class ZZImageViewerState extends State<ZZImageViewer> {
  int currentIndex = 0;
  late final PageController _pageController; // 使用 late 进行延迟初始化

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index; // 初始化当前页面索引为传入的索引
    _pageController =
        PageController(initialPage: currentIndex); // 初始化 PageController
  }

  // 下载当前图片到相册
  Future<void> _downloadImage() async {
    String currentImageUrl = widget.imageUrls[currentIndex];
    var response = await Dio().get(currentImageUrl,
        options: Options(responseType: ResponseType.bytes));
    await ImageGallerySaverPlus.saveImage(Uint8List.fromList(response.data),
        quality: 80);
    ZZ.toast("保存成功", fromSnackBar: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '图片浏览',
          style: ZZ.textStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadImage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController, // 使用初始化后的 PageController
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Center(
                  child: InteractiveViewer(
                    minScale: 0.5, // 设置缩小最小值
                    maxScale: 4.0, // 设置放大最大值
                    child: Image.network(
                      widget.imageUrls[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${currentIndex + 1} / ${widget.imageUrls.length}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}

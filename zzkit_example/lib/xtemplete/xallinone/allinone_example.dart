// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:zzkit_flutter/standard/allinone/ZZAllinoneList.dart';
import 'package:get/get.dart';

class TextFeedItem implements ZZFeedItem {
  final String content;
  final String author;
  final DateTime timestamp;

  TextFeedItem({
    required this.content,
    required this.author,
    required this.timestamp,
  });
}

class ImageFeedItem implements ZZFeedItem {
  final String imageUrl;
  final String caption;
  final String author;
  final DateTime timestamp;

  ImageFeedItem({
    required this.imageUrl,
    required this.caption,
    required this.author,
    required this.timestamp,
  });
}

class VideoFeedItem implements ZZFeedItem {
  final String videoUrl;
  final String title;
  final String author;
  final Duration duration;
  final DateTime timestamp;

  VideoFeedItem({
    required this.videoUrl,
    required this.title,
    required this.author,
    required this.duration,
    required this.timestamp,
  });
}

class BannerFeedItem implements ZZFeedItem {
  final List<String> imageUrls;
  final List<String> titles;
  final bool autoPlay;
  final Duration autoPlayInterval;

  BannerFeedItem({
    required this.imageUrls,
    required this.titles,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
  });
}

// 示例Controller - 多类型Feed控制器
class MultiTypeFeedController extends ZZBaseListController {
  @override
  Future<List<ZZFeedItem>> loadData(int page) async {
    // 模拟网络请求延迟
    await Future.delayed(const Duration(milliseconds: 800));

    // 根据页面返回不同类型的数据
    final feeds = <ZZFeedItem>[];
    final now = DateTime.now();

    for (int i = 0; i < 10; i++) {
      final itemIndex = (page - 1) * 10 + i;
      final timestamp = now.subtract(Duration(hours: itemIndex));

      // 循环创建不同类型的Feed
      switch (itemIndex % 3) {
        case 0:
          feeds.add(
            TextFeedItem(
              content:
                  '这是第${itemIndex + 1}条文本Feed内容。Flutter是一个优秀的跨平台UI框架，可以帮助开发者快速构建美观的应用界面。',
              author: '用户${itemIndex + 1}',
              timestamp: timestamp,
            ),
          );
          break;
        case 1:
          feeds.add(
            ImageFeedItem(
              imageUrl: 'https://picsum.photos/400/300?random=${itemIndex + 1}',
              caption: '美丽的风景图片 #${itemIndex + 1} - 这是来自网络的随机图片',
              author: '摄影师${itemIndex + 1}',
              timestamp: timestamp,
            ),
          );
          break;
        case 2:
          feeds.add(
            VideoFeedItem(
              videoUrl:
                  'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
              title: '精彩视频内容 #${itemIndex + 1}',
              author: '视频创作者${itemIndex + 1}',
              duration: Duration(
                minutes: 2 + (itemIndex % 5),
                seconds: itemIndex * 10 % 60,
              ),
              timestamp: timestamp,
            ),
          );
          break;
      }
    }

    // 模拟分页结束（第5页后没有更多数据）
    return page >= 5 ? [] : feeds;
  }
}

// 示例Delegate - 多类型Feed渲染器
class MultiTypeFeedDelegate extends ZZListDelegate {
  @override
  Widget buildItem(ZZFeedItem item, int index) {
    if (item is TextFeedItem) {
      return _buildTextItem(item, index);
    } else if (item is ImageFeedItem) {
      return _buildImageItem(item, index);
    } else if (item is VideoFeedItem) {
      return _buildVideoItem(item, index);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildTextItem(TextFeedItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 作者信息
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Text(
                  item.author[0],
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _formatTime(item.timestamp),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '文本',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 文本内容
          Text(item.content, style: const TextStyle(fontSize: 16, height: 1.5)),
          const SizedBox(height: 12),
          // 互动按钮
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageItem(ImageFeedItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 作者信息
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Text(
                  item.author[0],
                  style: const TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _formatTime(item.timestamp),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '图片',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 图片
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              height: MediaQuery.of(Get.context!).size.width * 0.4, // 响应式高度
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // 图片描述
          Text(item.caption, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          // 互动按钮
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItem(VideoFeedItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 作者信息
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red[100],
                child: Text(
                  item.author[0],
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _formatTime(item.timestamp),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '视频',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 视频预览
          Stack(
            children: [
              Container(
                height: MediaQuery.of(Get.context!).size.width * 0.4, // 响应式高度
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatDuration(item.duration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 视频标题
          Text(
            item.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '时长: ${_formatDuration(item.duration)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          // 互动按钮
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

// 示例页面 - 列表模式
class MultiTypeFeedListPage extends ZZBaseSliverPage<MultiTypeFeedController> {
  const MultiTypeFeedListPage({super.key});

  @override
  MultiTypeFeedController get controller => Get.put(MultiTypeFeedController());

  @override
  ZZListDelegate get delegate => MultiTypeFeedDelegate();

  @override
  int get crossAxisCount => 1; // 列表模式
}

// 示例页面 - 瀑布流模式
class MultiTypeFeedWaterfallPage
    extends ZZBaseSliverPage<MultiTypeFeedController> {
  const MultiTypeFeedWaterfallPage({super.key});

  @override
  MultiTypeFeedController get controller => Get.put(MultiTypeFeedController());

  @override
  ZZListDelegate get delegate => MultiTypeFeedDelegate();

  @override
  int get crossAxisCount => 2; // 瀑布流模式
}

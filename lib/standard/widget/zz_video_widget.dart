import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zzkit_flutter/standard/widget/zz_image.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 视频播放组件，支持播放/暂停、进度控制和封面图显示
class ZZVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String? videoUrlPic;
  final double? width;
  final double? height;

  const ZZVideoWidget({
    super.key,
    required this.videoUrl,
    this.videoUrlPic,
    this.width,
    this.height,
  });

  @override
  State<ZZVideoWidget> createState() => _ZZVideoWidgetState();
}

class _ZZVideoWidgetState extends State<ZZVideoWidget> {
  late final VideoPlayerController _controller;
  double? _aspectRatio;
  double _progress = 0.0;
  bool _progressChanging = false;
  String _remainingTime = "00:00:00";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        _aspectRatio = _controller.value.aspectRatio;
        setState(() {});
      });
    _controller.addListener(_updateProgress);
  }

  void _updateProgress() {
    if (!mounted) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    final remaining = duration - position;
    _remainingTime = _formatDuration(remaining);

    if (_controller.value.isPlaying && !_progressChanging) {
      _progress =
          duration.inSeconds > 0
              ? position.inSeconds / duration.inSeconds
              : 0.0;
    } else if (_controller.value.isCompleted) {
      _progress = 1.0;
    }
    setState(() {});
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _controller.removeListener(_updateProgress);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? 414.w;
    final height = widget.height ?? 200.w;

    if (_controller.value.isInitialized != true) {
      return Container(
        width: width,
        height: height,
        color: Colors.white,
        child: const Center(
          child: CupertinoActivityIndicator(animating: true, radius: 18),
        ),
      );
    }

    final displayHeight = _aspectRatio != null ? width / _aspectRatio! : height;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: width,
          height: displayHeight,
          color: Colors.white,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        if (!_controller.value.isPlaying && widget.videoUrlPic != null)
          ZZImage(
            source: widget.videoUrlPic,
            resize: ZZImageResize.none,
            width: width,
            height: displayHeight,
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            height: 30.w,
            color: Colors.black.withAlpha(30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                    setState(() {});
                  },
                  child: Text(
                    _controller.value.isPlaying ? "暂停" : "播放",
                    style: ZZ.textStyle(
                      color: ZZColor.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.0,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 4.0,
                      ),
                    ),
                    child: Slider(
                      value: _progress,
                      thumbColor: ZZColor.reddishOrange,
                      activeColor: ZZColor.reddishOrange,
                      onChangeStart: (_) => _progressChanging = true,
                      onChangeEnd: (_) => _progressChanging = false,
                      onChanged: (value) {
                        final duration = _controller.value.duration;
                        final seconds = (value * duration.inSeconds).toInt();
                        _controller.seekTo(Duration(seconds: seconds));
                        setState(() => _progress = value);
                      },
                    ),
                  ),
                ),
                Text(
                  _remainingTime,
                  style: ZZ.textStyle(
                    color: ZZColor.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

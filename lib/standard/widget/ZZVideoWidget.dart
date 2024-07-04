// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages, must_be_immutable, file_names

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zzkit_flutter/standard/widget/ZZImageWidget.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZZVideoWidget extends StatefulWidget {
  String? videoUrl;
  String? videoUrlPic;
  double? width;
  double? height;

  ZZVideoWidget({
    super.key,
    required this.videoUrl,
    this.videoUrlPic,
    this.width,
    this.height,
  });

  @override
  State<StatefulWidget> createState() {
    return ZZVideoWidgetState();
  }
}

class ZZVideoWidgetState extends State<ZZVideoWidget> {
  late VideoPlayerController controller;
  double? aspactRadio;
  double progress = 0.0;
  bool progressOnChange = false;
  String remainingTime = "00:00:00";

  @override
  Widget build(BuildContext context) {
    if (ZZ.isNullOrEmpty(widget.videoUrl) ||
        controller.value.isInitialized != true) {
      return Container(
        color: Colors.white,
        width: widget.width ?? 414.w,
        height: 200.w,
        child: Center(
          child: SizedBox(
            width: 36.w,
            height: 36.w,
            child: const CupertinoActivityIndicator(
              animating: true,
            ),
          ),
        ),
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: widget.width ?? 414.w,
            height: widget.height,
            color: Colors.white,
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          controller.value.isPlaying
              ? Container()
              : ZZImageWidget(
                  source: widget.videoUrlPic,
                  resize: ZZImageResize.none,
                  width: widget.width ?? 414.w,
                  height: aspactRadio == null
                      ? 200.w
                      : (widget.width ?? 414.w) / aspactRadio!,
                ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                height: 30.w,
                color: Colors.black.withAlpha(30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                        setState(() {});
                      },
                      child: Text(
                        controller.value.isPlaying ? "暂停" : "播放",
                        style: ZZ.textStyle(
                            color: ZZColor.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2.0,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 4.0),
                      ),
                      child: Slider(
                        onChangeStart: (value) {
                          progressOnChange = true;
                        },
                        onChangeEnd: (value) {
                          progressOnChange = false;
                        },
                        thumbColor: ZZColor.reddishOrange,
                        activeColor: ZZColor.reddishOrange,
                        value: progress,
                        onChanged: (value) {
                          setState(() {
                            progress = value;
                          });
                          double seconds = progress *
                              controller.value.duration.inSeconds.toDouble();
                          controller.seekTo(Duration(seconds: seconds.toInt()));
                        },
                      ),
                    )),
                    Text(
                      remainingTime,
                      style: ZZ.textStyle(
                          color: ZZColor.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ))
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl ?? ""))
          ..initialize().then((value) {
            aspactRadio = controller.value.aspectRatio;
            setState(() {});
          });
    controller.addListener(() {
      double seconds = controller.value.position.inSeconds.toDouble();
      double total = controller.value.duration.inSeconds.toDouble();
      Duration duration = controller.value.duration - controller.value.position;
      remainingTime = formatDuration(duration);
      if (controller.value.isPlaying) {
        if (progressOnChange == true) {
          return;
        }
        progress = max(0, seconds / total);
      } else if (controller.value.isCompleted) {
        progress = 1.0;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}

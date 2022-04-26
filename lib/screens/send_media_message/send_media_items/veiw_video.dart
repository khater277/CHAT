import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

class ViewVideo extends StatefulWidget {
  final File file;
  const ViewVideo({Key? key, required this.file}) : super(key: key);

  @override
  State<ViewVideo> createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {

  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  Future<void>? _future;

  Future<void> initVideoPlayer() async {

    await _controller!.initialize();
    setState(() {
      debugPrint(_controller!.value.aspectRatio.toString());
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        aspectRatio: _controller!.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file);
    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      return SizedBox(
        height: 25.h,
        //width: MediaQuery.of(context).size.width,
        child: _controller!.value.initialized
            ?
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.sp),
            child: Chewie(
              controller: _chewieController!,
            ),
          ),
        )
            : const CircularProgressIndicator(),
      );
    },);
  }
}

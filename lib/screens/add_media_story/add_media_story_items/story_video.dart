import 'package:chat/shared/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import '../../../cubit/app/app_cubit.dart';


class StoryVideo extends StatefulWidget {
  final AppCubit cubit;
  const StoryVideo({Key? key, required this.cubit}) : super(key: key);

  @override
  _StoryVideoState createState() => _StoryVideoState();
}

class _StoryVideoState extends State<StoryVideo> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.cubit.storyFile!)
      ..initialize().then((_) {
        widget.cubit.setVideoDuration(_controller!.value.duration.toString());
        // print("==============>${_controller!.value.duration}");
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
        });
      });
    _controller!.play();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller!.value.isInitialized
          ?
      AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_controller!),
            _ControlsOverlay(controller: _controller!),
            VideoProgressIndicator(_controller!, allowScrubbing: true,
              colors: VideoProgressColors(
              playedColor: MyColors.blue,
              backgroundColor: MyColors.lightBlack.withOpacity(0.5)
            ),),
          ],
        ),
      )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);


  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              :
          Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}

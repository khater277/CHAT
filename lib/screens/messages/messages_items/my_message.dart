import 'package:chat/shared/colors.dart';
import 'package:chat/shared/date_format.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../models/MessageModel.dart';

class MyMessage extends StatelessWidget {
  final MessageModel messageModel;
  const MyMessage({Key? key, required this.messageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
      alignment: Alignment.topRight,
      elevation: 0,
      margin: EdgeInsets.only(top: 2.h),
      backGroundColor: MyColors.blue.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          messageModel.message!.isEmpty?
          messageModel.isImage==true?
          MyImageMessage(media: messageModel.media!)
          :MyVideoMessage(media: messageModel.media!):
          MyTextMessage(message: messageModel.message!),
          SizedBox(height: messageModel.message!=""?0.5.h:1.h,),
          Text(
            DateFormatter().messageTimeFormat(messageModel.date!),
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 9.sp,
              color: MyColors.grey.withOpacity(0.8)
            ),
          )
        ],
      ),
    );
  }
}

class MyTextMessage extends StatelessWidget {
  final String message;
  const MyTextMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
            fontSize: 11.5.sp
        ),
      ),
    );
  }
}


class MyImageMessage extends StatelessWidget {
  final String media;
  const MyImageMessage({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.sp),
        child: Image.network(
          media,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


class MyVideoMessage extends StatefulWidget {
  final String media;
  const MyVideoMessage({Key? key, required this.media}) : super(key: key);

  @override
  State<MyVideoMessage> createState() => _MyVideoMessageState();
}
class _MyVideoMessageState extends State<MyVideoMessage> {

  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  Future<void>? _future;

  Future<void> initVideoPlayer() async {
    await _controller!.initialize();
    setState(() {
      print(_controller!.value.aspectRatio);
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        aspectRatio: _controller!.value.aspectRatio,
        autoPlay: false,
        looping: false,
        materialProgressColors: ChewieProgressColors(bufferedColor: Colors.white)
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.media);
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.4,
      child: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Center(
            child: _controller!.value.isInitialized
                ?
            FittedBox(
              fit: BoxFit.cover,
              child: Chewie(
                controller: _chewieController!,
              ),
            )
                : const CircularProgressIndicator(color: Colors.white,),
          );
        },),
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/date_format.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../models/LastMessageModel.dart';
import '../../../models/MessageModel.dart';
import '../../../shared/default_widgets.dart';
import '../../../styles/icons_broken.dart';
import 'delete_message.dart';

class FriendMessage extends StatefulWidget {
  final AppCubit cubit;
  final MessageModel messageModel;
  final int index;
  final String friendID;
  final String messageID;
  final LastMessageModel? lastMessageModel;
  const FriendMessage({Key? key, required this.cubit,required this.messageModel, required this.index,
    required this.friendID, required this.messageID, required this.lastMessageModel}) : super(key: key);

  @override
  State<FriendMessage> createState() => _FriendMessageState();
}

class _FriendMessageState extends State<FriendMessage> {

  ValueNotifier valueNotifier = ValueNotifier<bool>(false);
  bool showDate = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (BuildContext context, value, Widget? child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: ChatBubble(
            clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
            alignment: Alignment.topLeft,
            elevation: 0,
            margin: EdgeInsets.only(top: 2.h),
            backGroundColor: MyColors.lightBlack,
            child: ValueListenableBuilder(
              valueListenable: valueNotifier,
              builder: (BuildContext context, value, Widget? child) {
                return GestureDetector(
                  onTap: (){
                    valueNotifier.value = !valueNotifier.value;
                  },
                  onLongPress: (){
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return DeleteMessage(
                            cubit: widget.cubit,
                            friendID: widget.friendID,
                            messageID: widget.messageID,
                            lastMessageModel: widget.lastMessageModel,
                            messageModel: widget.messageModel
                        );
                      },
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        widget.messageModel.isImage==true?
                        FriendImageMessage(media: widget.messageModel.media!)
                            :widget.messageModel.isVideo==true?
                        FriendVideoMessage(media: widget.messageModel.media!)
                            :widget.messageModel.isDoc==true?
                        FriendFileMessage(message: widget.messageModel.message!):
                        FriendTextMessage(message: widget.messageModel.message!),
                        SizedBox(height: widget.messageModel.message!=""?0.5.h:1.h,),
                        if(valueNotifier.value)
                          Text(
                            DateFormatter().messageTimeFormat(widget.messageModel.date!),
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 9.sp,
                                color: MyColors.grey.withOpacity(0.8)
                            ),
                          )
                      ],
                    )
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class FriendTextMessage extends StatelessWidget {
  final String message;
  const FriendTextMessage({Key? key, required this.message}) : super(key: key);

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

class FriendImageMessage extends StatelessWidget {
  final String media;
  const FriendImageMessage({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.5;
    double height = MediaQuery.of(context).size.height * 0.4;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.sp),
      child: SizedBox(
        width: width,height: height,
        child: CachedNetworkImage(
            imageUrl: media,
            placeholder:(context,s)=> LoadingImage(width: width, height: height),
            fit: BoxFit.cover,
            errorWidget:(context,s,d)=>ErrorImage(
                width: width,
                height: height)
        ),
      ),
    );
  }
}

class FriendVideoMessage extends StatefulWidget {
  final String media;
  const FriendVideoMessage({Key? key, required this.media}) : super(key: key);

  @override
  State<FriendVideoMessage> createState() => _FriendVideoMessageState();
}
class _FriendVideoMessageState extends State<FriendVideoMessage> {

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

class FriendFileMessage extends StatelessWidget {
  final String message;
  const FriendFileMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(IconBroken.Document,color: MyColors.grey,size: 18.sp,),
        SizedBox(width: 2.w,),
        Flexible(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 12.sp
            ),
            //overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

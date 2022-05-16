import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/screens/messages/messages_items/delete_message.dart';
import 'package:chat/screens/messages/messages_items/story_reply_message.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/date_format.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../cubit/app/app_cubit.dart';
import '../../../models/LastMessageModel.dart';
import '../../../models/MessageModel.dart';
import '../../../shared/default_widgets.dart';
import '../../../styles/icons_broken.dart';

class MyMessage extends StatefulWidget {
  final AppCubit cubit;
  final MessageModel messageModel;
  final int index;
  final String friendID;
  final String messageID;
  final LastMessageModel? lastMessageModel;
  const MyMessage({Key? key, required this.cubit, required this.messageModel, required this.index,
    required this.friendID, required this.messageID, required this.lastMessageModel}) : super(key: key);

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: ChatBubble(
        clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        elevation: 0,
        backGroundColor: MyColors.blue.withOpacity(0.5),
        child: GestureDetector(
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
                    messageModel: widget.messageModel,
                  );
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.messageModel.isStoryReply==true)
                  Column(
                    children: [
                      StoryReplyMessage(
                        storyMedia: widget.messageModel.storyMedia!,
                      isStoryVideoReply: widget.messageModel.isStoryVideoReply!,
                      isValidDate: checkValidStory(date: widget.messageModel.storyDate!),
                      ),
                      SizedBox(height: 0.5.h,)
                    ],
                  ),
                SizedBox(
                  width: widget.messageModel.isStoryReply==true?50.w:null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.messageModel.isImage==true?
                      MyImageMessage(
                        media: widget.messageModel.media!,
                        date: widget.messageModel.date!,)
                          :widget.messageModel.isVideo==true?
                      MyVideoMessage(
                        cubit: widget.cubit,
                        media: widget.messageModel.media!,
                        messageID: widget.messageID,
                        date: widget.messageModel.date!,)
                          :widget.messageModel.isDoc==true?
                      MyFileMessage(message: widget.messageModel.message!):
                      MyTextMessage(message: widget.messageModel.message!,),
                      if(widget.messageModel.isImage==false&&widget.messageModel.isVideo==false)
                        widget.messageModel.isStoryReply==true?
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: MessageDate(date: widget.messageModel.date!),
                            ),
                          ),
                        )
                      :
                        Padding(
                          padding: EdgeInsets.only(left: 2.w),
                          child: MessageDate(date: widget.messageModel.date!),
                        ),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}


class MessageDate extends StatelessWidget {
  final String date;
  const MessageDate({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormatter().messageTimeFormat(date),
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: 9.sp,
          color: MyColors.grey.withOpacity(0.8)
      ),
    );
  }
}

class DeleteMessageLoader extends StatelessWidget {
  const DeleteMessageLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        width: 20.sp,height: 20.sp,
        child: Padding(
          padding: EdgeInsets.all(2.sp),
          child: CircularProgressIndicator(
            strokeWidth: 1.sp,
            color: MyColors.white,
          ),
        ));
  }
}

class MyTextMessage extends StatelessWidget {
  final String message;
  const MyTextMessage({Key? key, required this.message,}) : super(key: key);

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
  final String date;
  const MyImageMessage({Key? key, required this.media, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.5;
    double height = MediaQuery.of(context).size.height * 0.4;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.sp),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          SizedBox(
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
          Padding(
            padding: EdgeInsets.all(4.sp),
            child: MessageDate(date: date),
          ),
        ],
      ),
    );
  }
}

class MyVideoMessage extends StatefulWidget {
  final AppCubit cubit;
  final String media;
  final String messageID;
  final String date;
  const MyVideoMessage({Key? key, required this.cubit,required this.media,
    required this.messageID, required this.date}) : super(key: key);

  @override
  State<MyVideoMessage> createState() => _MyVideoMessageState();
}
class _MyVideoMessageState extends State<MyVideoMessage> {

  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  Future<void>? _future;
  bool done = false;

  Future<void> initVideoPlayer() async {
    await _controller!.initialize();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        debugPrint(_controller!.value.aspectRatio.toString());
        _chewieController = ChewieController(
            videoPlayerController: _controller!,
            aspectRatio: _controller!.value.aspectRatio,
            autoPlay: false,
            looping: false,
            materialProgressColors: ChewieProgressColors(bufferedColor: Colors.white)
        );
        done = true;
      });
    });
  }

  void checkVideoStatus() {
    DefaultCacheManager().getFileFromCache(widget.messageID)
        .then((value){
      _controller = VideoPlayerController.file(value!.file);
      _future = initVideoPlayer();
      debugPrint("FILE FOUNDED");
    }).catchError((error){
      _controller = VideoPlayerController.network(widget.media);
      _future = initVideoPlayer();
      DefaultCacheManager().downloadFile(widget.media,key: widget.messageID)
          .then((value){
        debugPrint("FILE DOWNLOADED");
      }).catchError((error){
        debugPrint(error.toString());
      });
    });
  }
  
  @override
  void initState() {
    super.initState();
    checkVideoStatus();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.42,
          height: MediaQuery.of(context).size.height * 0.4,
          child: _future!=null?
          FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

              return Center(
                child: _controller!.value.isInitialized
                    && done
                    ?
                FittedBox(
                  fit: BoxFit.cover,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.sp),
                    child: Chewie(
                      controller: _chewieController!,
                    ),
                  ),
                )
                    : const CircularProgressIndicator(color: Colors.white,),
              );
            },)
          :
          const Center(
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: CircularProgressIndicator(color: Colors.white,)
              )
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 2.w),
          child: MessageDate(date: widget.date),
        ),
      ],
    );
  }
}

class MyFileMessage extends StatelessWidget {
  final String message;
  const MyFileMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(IconBroken.Document,color: MyColors.grey,size: 18.sp,),
        SizedBox(width: 2.w,),
        Flexible(
          child: GestureDetector(
            onTap: ()async{
              final Directory? directory = await getExternalStorageDirectory();
              OpenFile.open("${directory!.path}/$message");
            },
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 12.sp,
                decoration: TextDecoration.underline,
                decorationThickness: 1
              ),
              //overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

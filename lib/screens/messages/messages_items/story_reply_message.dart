import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../shared/colors.dart';
import '../../../styles/icons_broken.dart';

class StoryName extends StatelessWidget {
  final bool isMyMessage;
  final String name;
  const StoryName({Key? key, required this.isMyMessage, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            "$name ",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(
                fontSize: 12.sp,
                color: isMyMessage?MyColors.white:MyColors.grey
            ),
          ),
        ),
        CircleAvatar(
          radius: 1.5.sp,
          backgroundColor: MyColors.grey,
        ),
        Text(
          " Story",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(
              fontSize: 12.sp,
              color: isMyMessage?MyColors.white:MyColors.grey,
          ),
        ),
        SizedBox(width: 2.w,)
      ],
    );
  }
}


class StoryReplyMessage extends StatefulWidget {
  final String storyMedia;
  final String name;
  final bool isStoryVideoReply;
  final bool isValidDate;
  final bool isMyMessage;
  const StoryReplyMessage({Key? key, required this.storyMedia,
    required this.isStoryVideoReply, required this.isValidDate,
    required this.isMyMessage, required this.name, }) : super(key: key);

  @override
  State<StoryReplyMessage> createState() => _StoryReplyMessageState();
}

class _StoryReplyMessageState extends State<StoryReplyMessage> {


  String? fileName;

  @override
  void initState() {
    if(widget.isStoryVideoReply) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async{
        VideoThumbnail.thumbnailFile(
          video: widget.storyMedia,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.WEBP,
          maxHeight: 64,
          quality: 75,
        ).then((value){
          setState(() {
            fileName = value!;
          });
          return null;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 1.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StoryName(isMyMessage: widget.isMyMessage,name: widget.name,),
                SizedBox(
                  height: 1.h,
                ),
                if(widget.storyMedia.isEmpty)
                  TextReply(isMyMessage: widget.isMyMessage,)
                else
                  MediaReply(
                    isVideo: widget.isStoryVideoReply,
                    isMyMessage: widget.isMyMessage,)
              ],
            ),
          ),
          SizedBox(
              width: widget.isStoryVideoReply&&fileName==null?20.sp:35.sp,
              height: widget.isStoryVideoReply&&fileName==null?20.sp:35.sp,
              child: !widget.isValidDate?
              Icon(
                IconBroken.Edit,
                color: widget.isMyMessage?MyColors.white:MyColors.blue,
                size: 20.sp,)
              :
              widget.storyMedia.isEmpty?
                  Icon(
                    IconBroken.Edit,
                    color: widget.isMyMessage?MyColors.white:MyColors.blue,
                    size: 20.sp,)
              :
                  widget.isStoryVideoReply?
                      fileName==null?
                       CircularProgressIndicator(strokeWidth: 1.5.sp,)
                      :
                      Image.file(File(fileName!))
                  :
              CachedNetworkImage(
                imageUrl:widget.storyMedia,
                fit: BoxFit.cover,
              )
          )
        ],
      ),
    );
  }
}


class TextReply extends StatelessWidget {
  final bool isMyMessage;
  const TextReply({Key? key, required this.isMyMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        "this is text story body",
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(
            fontSize: 12.sp,
            color: isMyMessage?MyColors.grey:Colors.grey,
            overflow: TextOverflow.ellipsis
        )
    );
  }
}

class MediaReply extends StatelessWidget {
  final bool isVideo;
  final bool isMyMessage;

  const MediaReply({Key? key, required this.isVideo, required this.isMyMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          isVideo?IconBroken.Video:IconBroken.Image_2,
          color: Colors.grey,size: 13.sp,
        ),
        SizedBox(width: 1.w,),
        Text(
          isVideo?"video":"photo",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(
              fontSize: 12.sp,
              color: isMyMessage?MyColors.grey:Colors.grey,
          ),
        ),
      ],
    );
  }
}


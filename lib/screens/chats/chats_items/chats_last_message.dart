import 'package:chat/models/LastMessageModel.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatsLastMessage extends StatelessWidget {
  final LastMessageModel lastMessage;
  const ChatsLastMessage({Key? key, required this.lastMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(lastMessage.senderID==uId)
          Text(
            "you : ",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 10.5.sp,
                color: MyColors.grey
            ),
            overflow: TextOverflow.ellipsis,
          ),
        Expanded(
          child: lastMessage.isVideo==true?
          const VideoMessage()
              :
              lastMessage.isImage==true?
                  const ImageMessage()
                  :
          TextMessage(message: lastMessage.message!,isDoc: lastMessage.isDoc!,),
        ),
        if(lastMessage.isRead==false)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.4.w),
          child: CircleAvatar(
            radius: 2.5.sp,
            backgroundColor: MyColors.blue,
          ),
        )
      ],
    );
  }
}

class TextMessage extends StatelessWidget {
  final String message;
  final bool isDoc;
  const TextMessage({Key? key, required this.message, required this.isDoc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(isDoc)
        Row(
          children: [
            Icon(IconBroken.Document,size: 15.sp,color: MyColors.blue,),
            SizedBox(width: 1.w),
          ],
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 10.5.sp,
              color: MyColors.grey
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class VideoMessage extends StatelessWidget {
  const VideoMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(IconBroken.Video,size: 15.sp,color: MyColors.blue,),
        SizedBox(width: 2.w),
        Text(
          "video",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 10.5.sp,
              color: MyColors.grey
          ),
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}

class ImageMessage extends StatelessWidget {
  const ImageMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(IconBroken.Image_2,size: 14.sp,color: MyColors.blue,),
        SizedBox(width: 2.w),
        Text(
          "photo",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 10.5.sp,
              color: MyColors.grey
          ),
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}


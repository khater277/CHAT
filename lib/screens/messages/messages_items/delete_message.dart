import 'package:chat/shared/constants.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../cubit/app/app_cubit.dart';
import '../../../models/LastMessageModel.dart';
import '../../../models/MessageModel.dart';
import '../../../shared/colors.dart';

class DeleteMessage extends StatelessWidget {
  final AppCubit cubit;
  final String friendID;
  final String messageID;
  final LastMessageModel? lastMessageModel;
  final MessageModel messageModel;
  const DeleteMessage({Key? key, required this.cubit, required this.friendID,
    required this.messageID,required this.lastMessageModel, required this.messageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 1.w),
      child: Container(
        decoration: BoxDecoration(
            color: MyColors.lightBlack,
            borderRadius: BorderRadius.circular(5.sp)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DeleteMessageForMe(
              cubit: cubit,
              messageID: messageID,
              lastMessageModel: lastMessageModel,
              friendID: friendID,
            ),
            if(messageModel.isDeleted!=true && messageModel.senderID==uId)
            DeleteMessageForEveryone(
              cubit: cubit,
              messageID: messageID,
              lastMessageModel: lastMessageModel,
              friendID: friendID,
              messageModel: messageModel,
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteMessageForMe extends StatelessWidget {
  final AppCubit cubit;
  final String friendID;
  final String messageID;
  final LastMessageModel? lastMessageModel;
  const DeleteMessageForMe({Key? key, required this.cubit, required this.friendID,
    required this.messageID,required this.lastMessageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
                "Delete message from me",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 12.5.sp,
                color: MyColors.white.withOpacity(0.7),
                letterSpacing: 0.4
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            cubit.deleteMessageForMe(
                friendID: friendID,
                messageID: messageID,
                lastMessageModel: lastMessageModel
            );
            Get.back();
          },
          icon: Icon(IconBroken.Delete,color: Colors.red,size: 16.sp,),
        )
      ],
    );
  }
}

class DeleteMessageForEveryone extends StatelessWidget {
  final AppCubit cubit;
  final String friendID;
  final String messageID;
  final LastMessageModel? lastMessageModel;
  final MessageModel messageModel;
  const DeleteMessageForEveryone({Key? key, required this.cubit, required this.friendID,
    required this.messageID,required this.lastMessageModel, required this.messageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              "Delete message for everyone",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 12.5.sp,
                  color: MyColors.white.withOpacity(0.7),
                  letterSpacing: 0.4
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            cubit.deleteMessageForEveryone(
                friendID: friendID,
                messageID: messageID,
                lastMessageModel: lastMessageModel,
            messageModel: messageModel);
            Get.back();
          },
          icon: Icon(IconBroken.Delete,color: Colors.red,size: 16.sp,),
        )
      ],
    );
  }
}

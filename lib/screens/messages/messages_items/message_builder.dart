import 'package:chat/models/MessageModel.dart';
import 'package:chat/screens/messages/messages_items/friend_message.dart';
import 'package:chat/screens/messages/messages_items/my_message.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/date_format.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/constants.dart';

class MessageBuilder extends StatelessWidget {
  final MessageModel message;
  final MessageModel previousMessage;
  final int index;
  const MessageBuilder({Key? key, required this.message, required this.index, required this.previousMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool showDay = DateFormatter().messageDate(message.date!)!=DateFormatter().messageDate(previousMessage.date!);
    return Column(
      children: [
        if(showDay||index==0)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h,),
          child: Card(
            color: MyColors.lightBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.sp)
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 0.8.h,
                right: 3.w,
                left: 3.w
              ),
              child: Text(
                DateFormatter().messageDate(message.date!),
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 11.sp,
                  letterSpacing: 1,
                  color: Colors.grey
                ),
              ),
            ),
          ),
        ),
        if (message.senderID==uId)
          MyMessage(messageModel: message,index: index,)
        else FriendMessage(messageModel: message,index: index,),
      ],
    );
  }
}

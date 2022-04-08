import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:sizer/sizer.dart';

class MyMessage extends StatelessWidget {
  const MyMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
      alignment: Alignment.topRight,
      elevation: 0,
      margin: EdgeInsets.only(top: 2.h),
      backGroundColor: MyColors.blue.withOpacity(0.5),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          "Lorem",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
            fontSize: 11.5.sp
          ),
        ),
      ),
    );
  }
}

class TabletMyMessage extends StatelessWidget {
  const TabletMyMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper3(
          type: BubbleType.sendBubble,
          nipSize: 9.sp,
          radius: 15.sp
      ),
      alignment: Alignment.topRight,
      elevation: 0,
      margin: EdgeInsets.only(top: 2.h),
      backGroundColor: MyColors.blue.withOpacity(0.5),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: EdgeInsets.symmetric(vertical: 0.8.h,horizontal: 1.5.w),
        child: Text(
          "Lorem",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 17.sp
          ),
        ),
      ),
    );
  }
}

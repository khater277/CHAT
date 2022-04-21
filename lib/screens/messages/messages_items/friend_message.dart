import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:sizer/sizer.dart';

class FriendMessage extends StatelessWidget {
  final String message;
  const FriendMessage({Key? key, required this.message,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // CircleAvatar(
              //   radius: 11.sp,
              //   backgroundColor: MyColors.blue.withOpacity(0.2),
              //   backgroundImage: CachedNetworkImageProvider(image),
              // ),
              Expanded(
                child: ChatBubble(
                  clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
                  alignment: Alignment.topLeft,
                  elevation: 0,
                  margin: EdgeInsets.only(top: 2.h),
                  backGroundColor: MyColors.lightBlack,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(
                      message,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 11.5.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
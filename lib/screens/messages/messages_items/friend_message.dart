import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:sizer/sizer.dart';

class FriendMessage extends StatelessWidget {
  const FriendMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 11.sp,
                backgroundColor: MyColors.blue.withOpacity(0.2),
                backgroundImage: const CachedNetworkImageProvider(
                    "https://img.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg?size=626&ext=jpg&uid=R42465912&ga=GA1.2.1541729706.1648353663"),
              ),
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
                      "Lorem ",
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

class TabletFriendMessage extends StatelessWidget {
  const TabletFriendMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.w),
      child: Row(
        children: [
          SizedBox(
            height: 15.3.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 18.5.sp,
                  backgroundColor: MyColors.blue.withOpacity(0.2),
                  backgroundImage: const CachedNetworkImageProvider(
                      "https://img.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg?size=626&ext=jpg&uid=R42465912&ga=GA1.2.1541729706.1648353663"),
                ),
              ],
            ),
          ),
          SizedBox(width: 1.w,),
          Expanded(
            child: ChatBubble(
              clipper: ChatBubbleClipper3(
                  type: BubbleType.receiverBubble,
                  nipSize: 10.sp,
                  radius: 15.sp
              ),
              alignment: Alignment.topLeft,
              elevation: 0,
              margin: const EdgeInsets.only(top: 20),
              backGroundColor: MyColors.lightBlack,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: EdgeInsets.symmetric(vertical: 0.8.h,horizontal: 1.5.w),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 17.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

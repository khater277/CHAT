import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_calling.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_friends_name.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FriendView extends StatelessWidget {
  final String image;
  final String name;
  final String senderID;
  final int remoteID;
  const FriendView(
      {Key? key,
      required this.image,
      required this.name,
      required this.senderID,
      required this.remoteID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image == "") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconBroken.Profile,
            color: MyColors.blue,
            size: 80.sp,
          ),
          SizedBox(
            height: 2.h,
          ),
          CallContentFriendName(name: name),
          if (senderID == uId && remoteID == 0) const CallContentCalling()
        ],
      );
    } else {
      return SizedBox(
        width: 100.w,
        height: 100.h,
        child: CachedNetworkImage(imageUrl: image),
      );
    }
  }
}

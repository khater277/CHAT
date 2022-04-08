import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatsProfileImage extends StatelessWidget {
  const ChatsProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 19.sp,
      backgroundColor: MyColors.blue.withOpacity(0.2),
      backgroundImage: const CachedNetworkImageProvider(
          "https://img.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg?size=626&ext=jpg&uid=R42465912&ga=GA1.2.1541729706.1648353663"
      ),
      // backgroundImage: const NetworkImage(
      //   "https://img.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg?size=626&ext=jpg&uid=R42465912&ga=GA1.2.1541729706.1648353663",
      // ),
    );
  }
}

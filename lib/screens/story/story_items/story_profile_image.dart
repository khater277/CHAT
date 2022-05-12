import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class StoryProfileImage extends StatelessWidget {
  final String image;
  const StoryProfileImage({Key? key, required this.image,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return SizedBox(
        width: 14.2.w,height: 7.2.h,
        child: CircleAvatar(
          radius: 22.sp,
          backgroundColor: MyColors.blue,
          child: CircleAvatar(
            radius: 20.sp,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: CircleAvatar(
              radius: 19.sp,
              backgroundColor: image==""?MyColors.lightBlack:MyColors.blue.withOpacity(0.2),
              backgroundImage: image!=""?CachedNetworkImageProvider(image):null,
              child: image==""?const Icon(IconBroken.Profile):null,
            ),
          ),
        ),
      );
    //}
  }
}

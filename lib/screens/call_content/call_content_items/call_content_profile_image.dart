import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CallContentProfileImage extends StatelessWidget {
  final String image;
  const CallContentProfileImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: MyColors.blue.withOpacity(0.15),
          blurRadius: 10,
          spreadRadius: 15.sp,
        ),
      ]),
      child: CircleAvatar(
        radius: 50.sp,
        backgroundColor: MyColors.lightBlack,
        backgroundImage: image.isNotEmpty?
        CachedNetworkImageProvider(image):null,
        child:
        image.isEmpty?
        Icon(IconBroken.Profile,color: MyColors.blue,size: 35.sp,):null,
      ),
    );
  }
}

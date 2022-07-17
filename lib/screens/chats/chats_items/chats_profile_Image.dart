// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/UserModel.dart';
import '../../../styles/icons_broken.dart';

class ChatsProfileImage extends StatelessWidget {
  final UserModel userModel;
  const ChatsProfileImage({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(userModel.image==""){
      return SizedBox(
          width: 13.w,height: 6.5.h,
          child: Icon(IconBroken.Profile,color: MyColors.blue,size: 25.sp,));
    }else{
      return SizedBox(
        width: 13.w,height: 6.4.h,
        child: CircleAvatar(
          radius: 19.sp,
          backgroundColor: MyColors.blue.withOpacity(0.2),
          backgroundImage: CachedNetworkImageProvider(
              "${userModel.image}"
          ),
        ),
      );
    }
  }
}

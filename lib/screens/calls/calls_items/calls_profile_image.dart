import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/UserModel.dart';
import '../../../styles/icons_broken.dart';

class CallsProfileImage extends StatelessWidget {
  final String userID;
  const CallsProfileImage({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users')
      .doc(userID).snapshots(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          UserModel userModel = UserModel.fromJson(snapshot.data!.data()!);
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
                    userModel.image!
                ),
              ),
            );
          }
        }else{
          return CircleAvatar(
            radius: 19.sp,
            backgroundColor: MyColors.blue.withOpacity(0.2),
          );
        }
      },);
  }
}

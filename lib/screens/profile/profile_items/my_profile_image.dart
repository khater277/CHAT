import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../cubit/app/app_states.dart';

class MyProfileImage extends StatelessWidget {
  final AppCubit cubit;
  final AppStates state;
  final String image;
  const MyProfileImage({Key? key, required this.cubit,required this.state,required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            if(cubit.profileImage!=null)
              CircleAvatar(
                radius: 60.sp,
                backgroundColor: MyColors.lightBlack,
                backgroundImage: FileImage(cubit.profileImage!),
              )
            else
            if(image.isNotEmpty)
              CircleAvatar(
              radius: 60.sp,
              backgroundColor: MyColors.lightBlack,
              backgroundImage: CachedNetworkImageProvider(image),
            )
            else
              CircleAvatar(
                radius: 60.sp,
                backgroundColor: MyColors.lightBlack,
                child: Icon(IconBroken.Profile,color: MyColors.blue,size: 60.sp,),
              ),
            GestureDetector(
              onTap: (){
                cubit.pickProfileImage();
              },
              child: CircleAvatar(
                radius: 18.sp,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: Icon(IconBroken.Camera,color: MyColors.blue,size: 20.sp,),
              ),
            )
          ],
        ),
        SizedBox(height: 2.h,),
        if(state is AppUpdateProfileImageLoadingState || cubit.profileImagePercentage!=null)
        LinearProgressIndicator(
          value: cubit.profileImagePercentage==0.0?0.05:cubit.profileImagePercentage,
          minHeight: 2,
          color: MyColors.blue.withOpacity(0.7),
          backgroundColor: MyColors.lightBlack,
        ),
      ],
    );
  }
}

import 'package:chat/cubit/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../styles/icons_broken.dart';

class SetImage extends StatelessWidget {
  final LoginCubit cubit;
  const SetImage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        CircleAvatar(
          radius: 55.sp,
          backgroundImage: cubit.image==null?
          const AssetImage(
            "assets/images/user.png",
          ):FileImage(cubit.image!) as ImageProvider,
          backgroundColor: MyColors.lightBlack,
        ),
        CircleAvatar(
          radius: 15.sp,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: GestureDetector(
            onTap: (){
              cubit.selectProfileImage();
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 0.2.h),
              child: Icon(
                IconBroken.Camera,
                color: MyColors.blue,
                size: 19.5.sp,),
            ),
          ),
        ),
      ],
    );
  }
}

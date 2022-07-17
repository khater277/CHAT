import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ViewerDetails extends StatelessWidget {
  final UserModel user;
  const ViewerDetails({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(user.image=="")
          SizedBox(
            width: 10.w,
            child: Icon(
              IconBroken.Profile,
              size: 20.sp,
              color: MyColors.blue,
            ),
          )
        else
          SizedBox(
            width: 10.w,
            child: CircleAvatar(
              radius: 15.sp,
              backgroundColor: MyColors.blue,
              backgroundImage: CachedNetworkImageProvider(
                  "${user.image}"
              ),
            ),
          ),
        SizedBox(width: 3.w,),
        Text(
          "${user.name}",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 13.sp
          ),
        ),
        SizedBox(width: 3.w,),
      ],
    );
  }
}

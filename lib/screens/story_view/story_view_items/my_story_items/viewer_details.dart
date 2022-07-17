import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/date_format.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ViewerDetails extends StatelessWidget {
  final UserModel user;
  final String viewDateTime;
  const ViewerDetails({Key? key, required this.user, required this.viewDateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool condition = DateTime.parse(viewDateTime).day == DateTime.now().day;

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
        Expanded(
          child: Text(
            "${user.name}",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 13.sp
            ),
          ),
        ),
        SizedBox(width: 2.w,),
        Text(
          "${DateFormatter().lastMessageDate(viewDateTime)} "
              "${!condition?"at ${DateFormatter().time(viewDateTime)}":""}",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 10.sp
          ),
        ),
        SizedBox(width: 3.w,),
      ],
    );
  }
}

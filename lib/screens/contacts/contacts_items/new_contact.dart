import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewContact extends StatelessWidget {
  const NewContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12.2.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: MyColors.blue,
            borderRadius: BorderRadius.circular(12.sp)
          ),
          child: Icon(IconBroken.Add_User,size: 19.sp,),
        ),
        SizedBox(width: 5.w,),
        Text(
          "New contact",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
            fontSize: 17.sp
          ),
        )
      ],
    );
  }
}

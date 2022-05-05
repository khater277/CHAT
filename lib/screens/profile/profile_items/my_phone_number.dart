import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyPhoneNumber extends StatelessWidget {
  final String phone;
  const MyPhoneNumber({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(IconBroken.Call,size: 20.sp,color: MyColors.grey,),
          SizedBox(width: 5.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phone number",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 13.sp,
                      color: Colors.white
                  ),
                ),
                SizedBox(height: 0.5.h,),
                Text(
                  phone,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 12.sp,
                      color: MyColors.blue
                  ),
                ),
              ],
            ),
          ),
          // Icon(IconBroken.Edit,size: 16.sp,color: MyColors.grey,),
        ],
      ),
    );
  }
}

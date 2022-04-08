import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginHead extends StatelessWidget {
  const LoginHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "loginHead".tr,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 15.5.sp,
          ),
        ),
        SizedBox(height: 3.h,),
        Text(
          "loginCaption".tr,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 13.sp,
            color: Colors.grey.shade500
          ),
        ),
      ],
    );
  }
}

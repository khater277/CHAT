import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 4.h,),
        Text(
          "loginCaption".tr,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 18.sp,
            color: Colors.grey.shade500
          ),
        ),
      ],
    );
  }
}

import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class OtpHead extends StatelessWidget {
  final String phoneNumber;
  const OtpHead({Key? key, required this.phoneNumber,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "otpHead".tr,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 4.5.h,),
        RichText(
            text: TextSpan(
              text: "otpCaption".tr,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 18.sp,
                color: MyColors.grey,
                height: 1.5
              ),
              children: [
                TextSpan(
                  text: phoneNumber,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 17.sp,
                      color: MyColors.blue
                  ),
                )
              ]
            )
        ),
      ],
    );
  }
}

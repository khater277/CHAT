import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class OtpHead extends StatelessWidget {
  final String phoneNumber;
  const OtpHead({Key? key, required this.phoneNumber,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verify your phone number",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 4.h,),
        RichText(
            text: TextSpan(
              text: "Enter your 6 digit code number sent to ",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 13.5.sp,
                color: MyColors.grey,
                height: 1.5
              ),
              children: [
                TextSpan(
                  text: phoneNumber,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 13.5.sp,
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

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginHead extends StatelessWidget {
  const LoginHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What is your phone number?",
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 4.h,),
        Text(
          "please enter your phone number to verify your account",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 18.sp,
            color: Colors.grey.shade600
          ),
        ),
      ],
    );
  }
}

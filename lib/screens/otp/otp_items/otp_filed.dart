// ignore_for_file: avoid_print

import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../cubit/login/login_cubit.dart';

class OtpFiled extends StatefulWidget {
  const OtpFiled({Key? key}) : super(key: key);

  @override
  State<OtpFiled> createState() => _OtpFiledState();
}

class _OtpFiledState extends State<OtpFiled> {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      obscureText: false,
      autoFocus: true,
      cursorColor: MyColors.white,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 8.h,
        fieldWidth: 12.w,
        borderWidth: 1,
        activeFillColor: MyColors.black.withOpacity(0.7),
        activeColor: MyColors.grey.withOpacity(0.3),
        inactiveColor: Colors.blue.withOpacity(0.4),
        selectedFillColor: MyColors.blue.withOpacity(0.2),
        selectedColor: MyColors.blue.withOpacity(0.5),
        disabledColor: Colors.blue.withOpacity(0.4),
        inactiveFillColor: MyColors.black.withOpacity(0.7)
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      enableActiveFill: true,
      onCompleted: (smsCode) {
        LoginCubit.get(context).submitOtp(smsCode);
        setState(() {
          otp = smsCode;
        });
      },
      onChanged: (value) {
        print(value);
      },
    );
  }
}

// ignore_for_file: avoid_print

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
      cursorColor: Colors.black,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 5.h,
        fieldWidth: 4.w,
        borderWidth: 1,
        activeFillColor: Colors.white,
        inactiveColor: Colors.blue.withOpacity(0.4),
        activeColor: Colors.grey.withOpacity(0.5),
        selectedFillColor: blue.withOpacity(0.2),
        selectedColor: Colors.blue.withOpacity(0.4),
        disabledColor: Colors.blue.withOpacity(0.4),
        inactiveFillColor: Colors.white
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
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

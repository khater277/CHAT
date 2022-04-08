import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../cubit/login/login_cubit.dart';
import '../../../cubit/login/login_states.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';
import '../../../shared/default_widgets.dart';


class VerifyButton extends StatelessWidget {
  final LoginStates state;

  const VerifyButton({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: DefaultElevatedButton(
          child: state is! LoginLoadingState
              ? Text(
                  "verify".tr,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: MyColors.black,
                      fontSize: 12.sp
                  ),
                )
              : DefaultButtonLoader(
              size: 16.sp, width: 2.sp, color: MyColors.black),
          color: MyColors.white,
          rounded: 2.5.sp,
          height: 5.8.h,
          width: 18.w,
          onPressed: () {
            if (otp!.length == 6) {
              LoginCubit.get(context).submitOtp(otp!);
            } else {
              //showSnackBar(text: "wrong code", context: context);
            }
          }),
    );
  }
}

// ignore_for_file: avoid_print

import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import '../../../cubit/login/login_cubit.dart';
import '../../../cubit/login/login_states.dart';
import '../../../shared/constants.dart';
import '../../../shared/default_widgets.dart';
import '../../../styles/icons_broken.dart';

class NextButton extends StatelessWidget {
  final LoginStates state;
  final String phoneNumber;

  const NextButton({Key? key, required this.phoneNumber, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: DefaultElevatedButton(
          child: state is! LoginLoadingState
              ? Text(
                  "next".tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: MyColors.black, fontSize: 12.sp),
                )
              : DefaultButtonLoader(
                  size: 16.sp, width: 2.sp, color: MyColors.black),
          color: MyColors.white,
          rounded: 2.5.sp,
          height: 5.8.h,
          width: 18.w,
          onPressed: () {
            if (!contactsPermission!) {
              Permission.contacts.request().then((value) {
                if (value.isGranted) {
                  GetStorage().write('contactsPermission', true).then((value) {
                    contactsPermission = true;
                    LoginCubit.get(context).getContacts(context);
                    if (LoginCubit.get(context).phoneTextFieldValidate == false) {
                      showSnackBar(
                          context: context,
                          title: "warning",
                          content: LoginCubit.get(context).validationMsg,
                          color: Colors.black,
                          fontColor: Colors.white,
                          icon: IconBroken.Danger);
                    } else {
                      LoginCubit.get(context).phoneAuth(phoneNumber: phoneNumber);
                    }
                  });
                }else{
                  showSnackBar(
                      context: context,
                      title: "warning",
                      content: "please confirm permission",
                      color: Colors.black,
                      fontColor: Colors.white,
                      icon: IconBroken.Danger);
                }
              });
            }
            else{
              if (LoginCubit.get(context).phoneTextFieldValidate == false) {
                showSnackBar(
                    context: context,
                    title: "warning",
                    content: LoginCubit.get(context).validationMsg,
                    color: Colors.black,
                    fontColor: Colors.white,
                    icon: IconBroken.Danger);
              } else {
                LoginCubit.get(context).phoneAuth(phoneNumber: phoneNumber);
              }
            }
          }),
    );
  }
}

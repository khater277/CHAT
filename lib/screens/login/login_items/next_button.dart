// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../cubit/login/login_cubit.dart';
import '../../../cubit/login/login_states.dart';
import '../../../shared/default_widgets.dart';
import '../../../styles/icons_broken.dart';


class NextButton extends StatelessWidget {
  final LoginStates state;
  final String phoneNumber;
  const NextButton({Key? key, required this.phoneNumber, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: DefaultElevatedButton(
          child: state is! LoginLoadingState?
          Text(
            "Next",
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.sp
            ),
          )
        :DefaultButtonLoader(size: 20.sp, width: 3.sp, color: Colors.black),
          color: Colors.white,
          rounded: 8.sp,
          height: 6.h,
          width: 10.w,
          onPressed: (){
            if(LoginCubit.get(context).phoneTextFieldValidate==false){
              showSnackBar(
                  context: context,
                  title: "warning",
                  content: LoginCubit.get(context).validationMsg,
                  color: Colors.black,
                  fontColor: Colors.white,
                  icon: IconBroken.Danger
              );
            }else{
              LoginCubit.get(context).phoneAuth(phoneNumber: phoneNumber);
            }
          }
      ),
    );
  }
}

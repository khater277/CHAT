// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
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
          const Text(
            "Next",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            ),
          )
        :const DefaultButtonLoader(size: 20, width: 3, color: Colors.white),
          color: Colors.black,
          rounded: 4,
          height: 45,
          width: 80,
          onPressed: (){
            if(LoginCubit.get(context).phoneTextFieldValidate==false){
              showSnackBar(
                  context: context,
                  title: "warning",
                  content: LoginCubit.get(context).validationMsg,
                  color: Colors.white,
                  fontColor: Colors.black,
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

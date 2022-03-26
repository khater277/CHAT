import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../cubit/login/login_cubit.dart';
import '../../cubit/login/login_states.dart';
import '../../shared/default_widgets.dart';
import '../otp/otp_screen.dart';
import 'login_items/country_and_phone.dart';
import 'login_items/login_head.dart';
import 'login_items/next_button.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit,LoginStates>(
      listener: (context,state){
        if(state is LoginCodeSentState){
          Get.to(()=> OtpScreen(phoneNumber: _phoneController.text,));
        }
        if(state is LoginErrorState){
          showSnackBar(
              context: context,
              title: "warning",
              content: state.error,
              color: Colors.white,
              fontColor: Colors.black,
              icon: IconBroken.Danger
          );
        }
      },
      builder: (context,state){
        return SafeArea(
            child:
            Scaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60,horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LoginHead(),
                      const SizedBox(height: 110,),
                      CountryAndPhone(phoneController: _phoneController,),
                      const SizedBox(height: 70,),
                      NextButton(phoneNumber: _phoneController.text,state: state,)
                    ],
                  ),
                ),
              ),
            )
        );
      },
    );
  }
}

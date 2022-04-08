import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/home/home_screen.dart';
import 'package:chat/screens/set_image/set_image_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../cubit/login/login_cubit.dart';
import '../../cubit/login/login_states.dart';
import '../../shared/default_widgets.dart';
import '../../styles/icons_broken.dart';
import 'otp_items/otp_filed.dart';
import 'otp_items/otp_head.dart';
import 'otp_items/verify_button.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit,LoginStates>(
      listener: (context,state){
        if(state is LoginSubmitOtpState){
          LoginCubit.get(context).checkUser(phoneNumber);
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
          //showSnackBar(text: state.error, context: context);
        }
      },
      builder: (context,state){
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60,horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OtpHead(phoneNumber: phoneNumber,),
                    SizedBox(height: 7.h,),
                    const OtpFiled(),
                    SizedBox(height: 10.5.h,),
                    VerifyButton(state: state,)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

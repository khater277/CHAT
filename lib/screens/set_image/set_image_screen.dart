import 'package:chat/cubit/login/login_cubit.dart';
import 'package:chat/cubit/login/login_states.dart';
import 'package:chat/screens/home/home_screen.dart';
import 'package:chat/screens/set_image/set_image_items/setImageButton.dart';
import 'package:chat/screens/set_image/set_image_items/set_image.dart';
import 'package:chat/screens/set_image/set_image_items/set_image_head.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SetImageScreen extends StatelessWidget {
  final String phone;
  const SetImageScreen({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit,LoginStates>(
      listener: (context,state){
        if(state is LoginCreateUserState){
          GetStorage().write(
              'uId',
              LoginCubit.get(context)
                  .getLoggedUser().uid)
              .then((value){
            Get.offAll(()=>const HomeScreen());
          });
        }
      },
      builder: (context,state){
        LoginCubit cubit = LoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                  onPressed: (){
                    cubit.createUser();
                  },
                  child: Text(
                    "SKIP",
                    style: TextStyle(
                        color: MyColors.blue,
                        fontSize: 17.sp
                    ),
                  )
              )
            ],
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 15.h,),
                      SetImageHead(phone: phone,),
                      SizedBox(height: 5.h,),
                      SetImage(cubit: cubit,),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  if(cubit.image!=null)
                  SetImageButton(cubit:cubit,state: state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

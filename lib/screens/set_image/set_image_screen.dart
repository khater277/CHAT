import 'package:chat/cubit/login/login_cubit.dart';
import 'package:chat/cubit/login/login_states.dart';
import 'package:chat/screens/home/home_screen.dart';
import 'package:chat/screens/set_image/set_image_items/setImageButton.dart';
import 'package:chat/screens/set_image/set_image_items/set_image.dart';
import 'package:chat/screens/set_image/set_image_items/set_image_head.dart';
import 'package:chat/screens/set_image/set_image_items/set_name_textfiled.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

class SetImageScreen extends StatefulWidget {
  final String phone;
  const SetImageScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<SetImageScreen> createState() => _SetImageScreenState();
}

class _SetImageScreenState extends State<SetImageScreen> {

  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
                        fontSize: 13.sp
                    ),
                  )
              )
            ],
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        SetImageHead(phone: widget.phone,),
                        SizedBox(height: 5.h,),
                        SetImage(cubit: cubit,),
                        SizedBox(height: 5.h,),
                        SetNameTextFiled(nameController: _nameController)
                      ],
                    ),
                    SizedBox(height: 10.h,),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _nameController,
                      builder: (BuildContext context, value, Widget? child) {
                        return (cubit.image!=null||value.text.isNotEmpty)?
                          SetImageButton(
                              cubit:cubit,
                              state: state,
                            nameController: _nameController,
                            phone: widget.phone,
                          ):const Text("");
                      },
                    ),
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

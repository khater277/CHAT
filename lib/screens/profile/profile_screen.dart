import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/profile/profile_items/my_name.dart';
import 'package:chat/screens/profile/profile_items/my_phone_number.dart';
import 'package:chat/screens/profile/profile_items/my_profile_image.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users')
          .doc(uId!).snapshots(),
          builder: (context, snapshot) {
            UserModel? myData;
            if(snapshot.hasData) {
             myData = UserModel.fromJson(snapshot.data!.data());
            }
            return WillPopScope(
              onWillPop: () async{
                cubit.removeProfileImage();
                return true;
                },
              child: Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  leading: IconButton(
                    onPressed: (){
                      Get.back();
                      cubit.removeProfileImage();
                    },
                    icon: Icon(
                      languageFun(ar: IconBroken.Arrow___Right_2, en: IconBroken.Arrow___Left_2),
                      size: 15.sp,
                    ),
                  ),
                  title: Text(
                    "Profile",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: MyColors.blue,
                        //fontSize: 18.sp,
                        letterSpacing: 1
                    ),
                  ),
                  actions: [
                    if(cubit.profileImage!=null)
                      TextButton(
                          onPressed: (){
                            cubit.updateProfileImage();
                          },
                          child: const Text(
                            "UPLOAD",
                            style: TextStyle(
                              color: MyColors.white,
                              //fontSize: 10.sp
                            ),
                          )
                      )
                  ],
                ),
                body: snapshot.hasData?
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 5.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MyProfileImage(cubit: cubit,state: state,image: myData!.image!,),
                        SizedBox(height: 4.h,),
                        MyName(cubit: cubit,name: myData.name!,),
                        SizedBox(height: 4.h,),
                        MyPhoneNumber(phone: myData.phone!)
                      ],
                    ),
                  ),
                )
                    :
                const DefaultProgressIndicator(icon: IconBroken.Profile),
              ),
            );
          },);
      },
    );
  }
}

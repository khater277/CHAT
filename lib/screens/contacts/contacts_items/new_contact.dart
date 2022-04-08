import 'package:chat/screens/add_new_contact/add_new_contact_screen.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../cubit/app/app_cubit.dart';

class NewContact extends StatelessWidget {
  final AppCubit cubit;
  const NewContact({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Get.to(()=>const AddNewContactScreen());
      },
      child: Row(
        children: [
          Container(
            width: 11.8.w,
            height: 6.2.h,
            decoration: BoxDecoration(
              color: MyColors.blue,
              borderRadius: BorderRadius.circular(5.sp)
            ),
            child: Icon(IconBroken.Add_User,size: 16.sp,),
          ),
          SizedBox(width: 3.w,),
          Text(
            "New contact",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 14.sp
            ),
          )
        ],
      ),
    );
  }
}

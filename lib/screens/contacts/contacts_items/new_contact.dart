import 'package:chat/screens/add_new_contact/add_new_contact_screen.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
            width: 12.2.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: MyColors.blue,
              borderRadius: BorderRadius.circular(12.sp)
            ),
            child: Icon(IconBroken.Add_User,size: 19.sp,),
          ),
          SizedBox(width: 5.w,),
          Text(
            "New contact",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 17.sp
            ),
          )
        ],
      ),
    );
  }
}

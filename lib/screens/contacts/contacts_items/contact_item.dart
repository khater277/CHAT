import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/messages/messages_screen.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';

class ContactItem extends StatelessWidget {
  final UserModel user;
  const ContactItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(user.uId!=uId){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.8.h),
        child: GestureDetector(
          onTap: (){
            Get.to(()=>MessagesScreen(
              user: user,
              isFirstMessage: true,
            ));},
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                if(user.image=="")
                  SizedBox(
                    width: 10.w,
                    child: Icon(
                      IconBroken.Profile,
                      size: 20.sp,
                      color: MyColors.blue,
                    ),
                  )
                else
                  SizedBox(
                    width: 10.w,
                    child: CircleAvatar(
                      radius: 15.sp,
                      backgroundColor: MyColors.blue,
                      backgroundImage: CachedNetworkImageProvider(
                          "${user.image}"
                      ),
                    ),
                  ),
                SizedBox(width: 3.w,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user.name}",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 13.sp
                        ),
                      ),
                      SizedBox(height: 0.5.h,),
                      Text(
                        "${user.phone}",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 10.sp,
                            color: MyColors.grey
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 3.w,),
                Icon(IconBroken.Arrow___Right_2,size: 12.sp,color: Colors.grey,)
              ],
            ),
          ),
        ),
      );
    }else{
      return const DefaultNullWidget();
    }
  }
}

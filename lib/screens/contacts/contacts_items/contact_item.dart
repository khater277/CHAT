import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';

class ContactItem extends StatelessWidget {
  final UserModel user;
  const ContactItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // String name = contact.displayName??"unknown";
    // String phoneNumber = contact.phones!.isNotEmpty?
    // contact.phones![0].value!:"unknown";
    return Row(
      children: [
        if(user.image=="")
        Icon(
          IconBroken.Profile,
          size: 20.sp,
          color: MyColors.blue,
        )
        else
          CircleAvatar(
            radius: 17.sp,
            backgroundColor: MyColors.blue,
            backgroundImage: CachedNetworkImageProvider(
              "${user.image}"
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
        GestureDetector(
          onTap: (){},
          child: Icon(IconBroken.Arrow___Right_2,size: 12.sp,color: Colors.grey,),
        )
      ],
    );
  }
}

import 'package:chat/styles/icons_broken.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/colors.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;
  const ContactItem({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String name = contact.displayName??"unknown";
    String phoneNumber = contact.phones!.isNotEmpty?
    contact.phones![0].value!:"unknown";



    return Row(
      children: [
        Icon(
          IconBroken.Profile,
          size: 21.sp,
          color: MyColors.blue,
        ),
        SizedBox(width: 3.w,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                name,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 16.5.sp
              ),
            ),
            SizedBox(height: 0.5.h,),
            Text(
              phoneNumber,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 14.sp,
                color: MyColors.grey
              ),
            ),
          ],
        )
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/colors.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
            radius: 20.sp,
            backgroundColor: MyColors.blue.withOpacity(0.2),
            backgroundImage: const CachedNetworkImageProvider(
                "https://img.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg?size=626&ext=jpg&uid=R42465912&ga=GA1.2.1541729706.1648353663")
        ),
        SizedBox(width: 3.w,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Ahmed Khater",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 16.5.sp
              ),
            ),
            SizedBox(height: 0.5.h,),
            Text(
              "01000482644",
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

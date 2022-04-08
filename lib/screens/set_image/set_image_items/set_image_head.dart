import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/colors.dart';

class SetImageHead extends StatelessWidget {
  final String phone;

  const SetImageHead({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
                text: "Hey ",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 17.5.sp, color: MyColors.grey, height: 1.5),
                children: [
                  TextSpan(
                      text: phone,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 17.sp, color: MyColors.blue)
                  ),
              TextSpan(
                  text:
                      " , please select profile image",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: 18.sp, color: MyColors.grey, height: 1.5))
            ])),
      ],
    );
  }
}

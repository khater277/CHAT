import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CallContentCalling extends StatelessWidget {
  const CallContentCalling({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "calling...",
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: 12.sp,
          color: MyColors.grey
      ),
    );
  }
}

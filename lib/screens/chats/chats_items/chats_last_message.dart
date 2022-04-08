import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatsLastMessage extends StatelessWidget {
  const ChatsLastMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
              "hello there, can you help me ?",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 10.5.sp,
                color: MyColors.grey
              ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.4.w),
          child: CircleAvatar(
            radius: 2.5.sp,
            backgroundColor: MyColors.blue,
          ),
        )
      ],
    );
  }
}

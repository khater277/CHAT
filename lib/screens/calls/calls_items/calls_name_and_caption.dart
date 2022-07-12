import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CallsNameAndCaption extends StatelessWidget {
  const CallsNameAndCaption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mahmoud",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 12.sp
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.4.h,),
          Text(
            "inbound - 4:00 PM",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 10.5.sp,
                color: MyColors.grey
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

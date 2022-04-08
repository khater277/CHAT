import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';

class ChatsName extends StatelessWidget {
  const ChatsName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Ahmed Khater",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 12.sp
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          "now",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 10.8.sp,
              color: MyColors.grey
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

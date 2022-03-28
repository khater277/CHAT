import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
              fontSize: 16.5.sp
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          "now",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 15.sp,
              color: MyColors.grey
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

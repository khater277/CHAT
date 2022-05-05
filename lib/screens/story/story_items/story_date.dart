import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';

class StoryDate extends StatelessWidget {
  const StoryDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "yesterday, 9:00 PM",
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: 10.5.sp,
          color: MyColors.grey
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

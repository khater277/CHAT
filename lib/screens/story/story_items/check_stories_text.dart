import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';

class CheckStoriesText extends StatelessWidget {
  final String text;
  const CheckStoriesText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyText2!
          .copyWith(fontSize: 11.0.sp, color: MyColors.grey),
      overflow: TextOverflow.ellipsis,
    );
  }
}

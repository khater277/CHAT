import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../shared/date_format.dart';

class StoryDate extends StatelessWidget {
  final String storyDate;
  const StoryDate({Key? key, required this.storyDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream stream = Stream.periodic(const Duration(seconds: 1),(a)=>a);
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          String text = DateFormatter().storyDate(storyDate);
          return Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontSize: 10.5.sp, color: MyColors.grey),
            overflow: TextOverflow.ellipsis,
          );
        }
    );
  }
}

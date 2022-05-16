import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';

class MyStoryViewers extends StatelessWidget {
  final int viewersNumber;
  const MyStoryViewers({Key? key, required this.viewersNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Padding(
          padding:  EdgeInsets.only(bottom: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.visibility_outlined,
                color: MyColors.grey,
                size: 19.sp,
              ),
              Text(
                "$viewersNumber",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(
                  fontSize: 11.5.sp,
                  color: MyColors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ));
  }
}

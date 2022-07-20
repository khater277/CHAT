import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NoStoriesFounded extends StatelessWidget {
  const NoStoriesFounded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/2,
      child: NoItemsFounded(
          text: "No stories yet",
          widget: Icon(
            IconBroken.Paper_Fail,
            size: 100.sp,
            color: Colors.grey.withOpacity(0.5),
          )
      ),
    );
  }
}

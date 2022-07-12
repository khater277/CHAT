import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CallContentFriendName extends StatelessWidget {
  final String name;
  const CallContentFriendName({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 16.sp
      ),
    );
  }
}

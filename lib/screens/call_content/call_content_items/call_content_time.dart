import 'dart:async';

import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CallContentTime extends StatefulWidget {
  const CallContentTime({Key? key}) : super(key: key);

  @override
  State<CallContentTime> createState() => _CallContentTimeState();
}

class _CallContentTimeState extends State<CallContentTime> {

  final Stream _stream = Stream.periodic(const Duration(seconds: 1),(a)=>a);

  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  int total = 0;

  String timeFormat(int time){
    return time.toString().length==1?"0$time":"$time";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {

          total = snapshot.data!=null?
          int.parse(snapshot.data.toString()):0;

          seconds = total%60;
          minutes = (total/60).floor()%60;
          hours = (total/3600).floor()%3600;

          String text = "${timeFormat(hours)!="00"?
          "${timeFormat(hours)}:":""}${timeFormat(minutes)}:${timeFormat(seconds)}";

          return Text(text,
            // "$seconds : $minutes : $hours",
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

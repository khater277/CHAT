import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CallContentCalling extends StatefulWidget {
  const CallContentCalling({Key? key}) : super(key: key);

  @override
  State<CallContentCalling> createState() => _CallContentCallingState();
}

class _CallContentCallingState extends State<CallContentCalling> {
  final Stream _stream = Stream.periodic(const Duration(seconds: 1),(a)=>a);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if(snapshot.data==30){
          AppCubit.get(context).updateInCallStatus(isTrue: false);
        }
        return Text(
          "calling...",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 12.sp,
              color: MyColors.grey
          ),
        );
      }
    );
  }
}

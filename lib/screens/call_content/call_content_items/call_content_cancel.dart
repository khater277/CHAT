import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';

class CancelCallButton extends StatelessWidget {
  const CancelCallButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        AppCubit.get(context).updateInCallStatus(isTrue: false);
      },
      backgroundColor: Colors.red,
      child: const Icon(
        IconBroken.Call_Missed,
        color: Colors.white,
      ),
    );
  }
}

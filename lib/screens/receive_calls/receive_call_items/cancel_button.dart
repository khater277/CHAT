import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CancelButton extends StatelessWidget {
  final AppCubit cubit;
  final String callType;
  const CancelButton({Key? key, required this.cubit, required this.callType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
            heroTag: "cancel",
            onPressed: () {
              cubit.updateInCallStatus(isTrue: false);
            },
            backgroundColor: Colors.red,
            child: callType == 'voice'
                ? const Icon(
                    IconBroken.Call_Missed,
                    color: Colors.white,
                  )
                : const ImageIcon(
                    AssetImage("assets/images/missed-video-call.png"),
                    color: Colors.white,
                  )),
        SizedBox(
          height: 0.5.h,
        ),
        Text("cancel",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontSize: 12.sp, color: MyColors.grey))
      ],
    );
  }
}

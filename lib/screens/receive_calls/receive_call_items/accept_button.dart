import 'package:chat/screens/call_content/voice_call/voice_call_content_screen.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AcceptButton extends StatelessWidget {
  final String senderID;
  final String token;
  final String channelName;
  final String callID;
  final String callType;
  const AcceptButton(
      {Key? key,
      required this.senderID,
      required this.token,
      required this.channelName,
      required this.callID,
      required this.callType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: "accept",
          onPressed: () {
            // cubit.updateInCallStatus(isTrue: true);
            Get.off(() => CallContentScreen(
                  // receiverID: null,
                  senderID: senderID,
                  token: token,
                  channelName: channelName,
                  callID: callID,
                ));
            // _engine.leaveChannel();
            // Get.back();
          },
          backgroundColor: Colors.green,
          child: Icon(
            callType == 'voice' ? IconBroken.Call : IconBroken.Video,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        Text("accept",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontSize: 12.sp, color: MyColors.grey)),
      ],
    );
  }
}

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/call_content/agora_manager.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_calling.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_friends_name.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_profile_image.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_time.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

/// Define App ID and Token


class CallContentScreen extends StatefulWidget {
  const CallContentScreen({Key? key}) : super(key: key);

  @override
  State<CallContentScreen> createState() => _CallContentScreenState();
}

class _CallContentScreenState extends State<CallContentScreen> {

  late int _remoteUid = 0;
  late RtcEngine _engine;
  bool joined = false;

  @override
  void initState() {
    initAgora();
    super.initState();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    super.dispose();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = await RtcEngine.create(AgoraManager.appId);
    _engine.enableVideo();
    // _engine.enableAudio();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          setState(() => joined = true);
          print("‘local user $uid joined successfully’");
        },
        userJoined: (int uid, int elapsed) {
          print("‘remote user $uid joined successfully’");
          setState(() => _remoteUid = uid);
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("‘remote user $uid left call’");
          setState(() => _remoteUid = 0);
          Navigator.of(context).pop(true);
        },
      ),
    );
    await _engine.joinChannel(
        AgoraManager.token, AgoraManager.channelName, null, 0);
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(20.sp),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CallContentProfileImage(image: cubit.userModel!.image!),
                    SizedBox(height: 5.h,),
                    const CallContentFriendName(name: "Ahmed Khater"),
                    SizedBox(height: 1.h,),
                    if(!joined)
                    const CallContentCalling()
                    else
                      const CallContentTime()
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                // _engine.leaveChannel();
                Get.back();
              },
              backgroundColor: Colors.red,
              child: const Icon(IconBroken.Call,
              color: Colors.white,),
            ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          ),
        );
      },
    );
  }
}

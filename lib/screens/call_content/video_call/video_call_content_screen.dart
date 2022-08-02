import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_cancel.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_time.dart';
import 'package:chat/screens/call_content/video_call/video_call_items/back_button.dart';
import 'package:chat/screens/call_content/video_call/video_call_items/friend_view.dart';
import 'package:chat/screens/call_content/video_call/video_call_items/my_view.dart';
import 'package:chat/services/agora/agora_server.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class VideoCallContentScreen extends StatefulWidget {
  final String senderID;
  final String callID;
  final String? friendImage;
  final String? friendName;
  final String token;
  final String channelName;
  const VideoCallContentScreen(
      {Key? key,
      required this.senderID,
      required this.callID,
      required this.token,
      required this.channelName,
      this.friendImage,
      this.friendName})
      : super(key: key);

  @override
  State<VideoCallContentScreen> createState() => _VideoCallContentScreenState();
}

class _VideoCallContentScreenState extends State<VideoCallContentScreen> {
  late int _remoteID = 0;
  late RtcEngine _engine;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = await RtcEngine.create(AgoraServer.appId);
    _engine.enableVideo();
    _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print("joinChannelSuccess to $channel id $uid elapsed $elapsed");
    }, userJoined: (int uid, int elapsed) {
      print("userJoined id $uid elapsed $elapsed");
      setState(() {
        _audioPlayer.stop();
        _remoteID = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print("userOffline id $uid reason ${reason.toString()}");
      setState(() => _remoteID = 0);
      Navigator.of(context).pop();
    }));

    await _engine.joinChannel(
        widget.token, widget.channelName, null, widget.senderID == uId ? 0 : 1);
  }

  void playRingtone() async {
    await _audioPlayer.play(AssetSource('assets/sounds/sender-ringtone.ogg'));
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void initState() {
    initAgora();
    if (widget.senderID == uId) {
      playRingtone();
    } else {
      AppCubit.get(context).updateCallData(
        callID: widget.callID,
        friendID: widget.senderID,
        myCallStatus: "incoming",
        friendCallStatus: "outcoming",
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppUpdateInCallStatusFalseState) {
          Get.back();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Align(
                  alignment: AlignmentDirectional.center,
                  child: FriendView(
                    image: widget.friendImage!,
                    name: widget.friendName!,
                    senderID: widget.senderID,
                    remoteID: _remoteID,
                  )),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      VideoBackButton(),
                      MyView(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: widget.senderID != uId && _remoteID != 0
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      const CancelCallButton(),
                      if (widget.senderID != uId && _remoteID != 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 2.w),
                          decoration: BoxDecoration(
                            color: MyColors.lightBlack,
                            borderRadius: BorderRadius.circular(4.sp),
                          ),
                          child: const CallContentTime(),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

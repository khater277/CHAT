import 'package:audioplayers/audioplayers.dart';
import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_calling.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_friends_name.dart';
import 'package:chat/screens/call_content/call_content_items/call_content_profile_image.dart';
import 'package:chat/screens/call_content/call_content_screen.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

/// Define App ID and Token


class ReceiveCallScreen extends StatefulWidget {
  final String senderID;
  final String token;
  final String channelName;
  const ReceiveCallScreen({Key? key, required this.senderID, required this.token, required this.channelName,}) : super(key: key);

  @override
  State<ReceiveCallScreen> createState() => _ReceiveCallScreenState();
}

class _ReceiveCallScreenState extends State<ReceiveCallScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();


  @override
  void initState() {
    playRingtone();
    AppCubit.get(context).updateInCallStatus(isTrue: true);
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void playRingtone()async{
    await _audioPlayer.play(
        AssetSource('sounds/receiver-ringtone.ogg'));
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // if(state is AppUpdateInCallStatusTrueState){
        //   Get.off(()=>CallContentScreen(
        //     senderID: widget.senderID,
        //     token: widget.token,
        //     channelName: widget.channelName,
        //   ));
        // }

        if(state is AppUpdateInCallStatusFalseState){
          Get.back();
        }
      },
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
                    const CallContentCalling(),
                    SizedBox(height: 5.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            FloatingActionButton(
                              heroTag: "cancel",
                              onPressed: (){
                                cubit.updateInCallStatus(isTrue: false);
                              },
                              backgroundColor: Colors.red,
                              child: const Icon(IconBroken.Call_Missed,
                                color: Colors.white,),
                            ),
                            SizedBox(height: 0.5.h,),
                            Text(
                              "cancel",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontSize: 12.sp,
                                  color: MyColors.grey
                              ))
                          ],
                        ),
                        Column(
                          children: [
                            FloatingActionButton(
                              heroTag: "accept",
                              onPressed: (){
                                cubit.updateInCallStatus(isTrue: true);
                                // _engine.leaveChannel();
                                // Get.back();
                              },
                              backgroundColor: Colors.green,
                              child: const Icon(IconBroken.Call,
                                color: Colors.white,),
                            ),
                            SizedBox(height: 0.5.h,),
                            Text(
                                "accept",
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 12.sp,
                                    color: MyColors.grey
                                )),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          ),
        );
      },
    );
  }
}

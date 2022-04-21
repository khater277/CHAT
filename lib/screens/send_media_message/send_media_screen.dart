import 'dart:io';
import 'package:chat/screens/send_media_message/send_media_items/veiw_video.dart';
import 'package:chat/screens/send_media_message/send_media_items/view_image.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../cubit/app/app_cubit.dart';
import '../../cubit/app/app_states.dart';

class SendMediaScreen extends StatelessWidget {
  final String receiverID;
  final File file;
  final MediaSource mediaSource;
  final bool isFirstMessage;
  const SendMediaScreen({Key? key,required this.file,required this.receiverID,
    required this.mediaSource, required this.isFirstMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is AppSendMediaMessageState){
          Get.back();
        }
      },
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Text(
              "Send Media",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            leading: const DefaultBackButton(),
            actions: [
              IconButton(
                icon:  Icon(IconBroken.Send,color: Colors.blue,size: 20.sp),
                onPressed: state is! AppSendMediaMessageLoadingState?(){
                  cubit.sendMediaMessage(
                    friendID: receiverID,
                    mediaSource: mediaSource,
                    isFirstMessage: isFirstMessage,
                  );
                }:null,
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 2.w),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if(state is AppSendMediaMessageLoadingState)
                    const DefaultLinerIndicator(),
                  if(mediaSource==MediaSource.image)
                    ViewImage(file: file)
                  else
                    ViewVideo(file: file),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}

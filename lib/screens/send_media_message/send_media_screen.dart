import 'dart:io';
import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/screens/send_media_message/send_media_items/veiw_video.dart';
import 'package:chat/screens/send_media_message/send_media_items/view_image.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../cubit/app/app_states.dart';
import '../../shared/colors.dart';

class SendMediaScreen extends StatelessWidget {
  final AppCubit cubit;
  final AppStates state;
  final String receiverID;
  final File file;
  final MediaSource mediaSource;
  final bool isFirstMessage;
  const SendMediaScreen({Key? key,required this.cubit,required this.state,required this.file,required this.receiverID,
    required this.mediaSource, required this.isFirstMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Container(
          width: double.infinity,
          height: 25.h,
          decoration: BoxDecoration(
              color: MyColors.lightBlack,
              borderRadius: BorderRadius.circular(10.sp)),
          child: Padding(
            padding: EdgeInsets.only(top: 0.5.h,left: 1.w,right: 1.w,bottom: 1.h),
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if(mediaSource==MediaSource.image)
                        ViewImage(file: file)
                      else
                        ViewVideo(file: file),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                   if(state is AppSendMediaMessageLoadingState)
                    DefaultUploadIndicator(percentage: cubit.percentage!),
                    SizedBox(width: 2.w,),
                    CircleAvatar(
                      radius: 13.sp,
                      backgroundColor: MyColors.grey,
                      child: IconButton(
                        onPressed: (){
                          cubit.cancelSelectFile();
                        },
                        icon: Icon(Icons.close,color: Colors.red,size: 12.sp,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


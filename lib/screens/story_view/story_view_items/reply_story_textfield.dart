import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../shared/constants.dart';
import '../../../styles/icons_broken.dart';

class ReplyStoryTextField extends StatelessWidget {
  final AppCubit cubit;
  final AppStates state;
  final TextEditingController messageController;
  final String userID;
  final String userToken;
  final String storyMedia;
  final String storyDate;
  final MediaSource? mediaSource;
  const ReplyStoryTextField({Key? key, required this.messageController,
    required this.cubit, required this.state, required this.userID,
    required this.storyMedia, required this.mediaSource, required this.storyDate, required this.userToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: TextField(
        autofocus: true,
        // inputFormatters: [NoLeadingSpaceFormatter()],
        cursorColor: MyColors.grey.withOpacity(0.7),
        controller: messageController,
        keyboardType: TextInputType.text,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: 13.sp,
        ),
        decoration: InputDecoration(
          hintText: "type your reply...",
          hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 11.sp,
              color: MyColors.grey.withOpacity(0.6)
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: messageController,
            builder: (BuildContext context, value, Widget? child) {
                return IconButton(
                  onPressed: value.text.isNotEmpty?() {
                    String finalMessage = messageController.text.trimLeft().trimRight();
                      cubit.sendMessage(
                        friendToken: userToken,
                        friendID: userID,
                        message: finalMessage,
                        isStoryReply: true,
                        isStoryVideoReply: mediaSource==MediaSource.video?true:null,
                        storyMedia: storyMedia,
                        storyDate: storyDate,
                      );

                    messageController.clear();
                  }:null,
                  icon: state is AppSendStoryReplyLoadingState?
                    SizedBox(
                        width: 16.sp,height: 16.sp,
                        child: CircularProgressIndicator(strokeWidth: 2.sp,)
                    )
                      :
                  Icon(
                    IconBroken.Send,
                    size: 18.sp,
                    color: value.text.isEmpty?Colors.grey:MyColors.blue,
                  ),
                );
            },
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: 2.0.h, horizontal: 4.w),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.sp),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.sp),
              borderSide: const BorderSide(color: MyColors.blue)
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.sp),
              borderSide: const BorderSide(color: MyColors.blue)
          ),
        ),
      ),
    );
  }
}

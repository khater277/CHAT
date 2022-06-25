import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../cubit/app/app_states.dart';
import '../../../styles/icons_broken.dart';




class SendMessageButton extends StatelessWidget {
  final AppCubit cubit;
  final AppStates state;
  final bool isFirstMessage;
  final TextEditingController messageController;
  final String friendToken;
  final String friendID;
  const SendMessageButton({Key? key, required this.messageController,
    required this.cubit, required this.state, required this.friendID,
    required this.isFirstMessage, required this.friendToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: messageController,
      builder: (context, value, child) {
        bool sendCondition = value.text.isNotEmpty || state is AppSelectFileState
            || state is AppSelectMessageImageState || state is AppSelectMessageVideoState;
        return GestureDetector(
          onTap: sendCondition? () {
            int endCnt=0;
            if(value.text.endsWith(" ")){
              for(int i=value.text.length-1;i>=0;i--){
                if(value.text[i]==" "){
                  endCnt++;
                }else{
                  break;
                }
              }
            }
            //scrollDown(scrollController);
            if(state is AppSelectFileState) {
              cubit.sendMediaMessage(
                friendToken: friendToken,
                  friendID: friendID,
                  mediaSource: MediaSource.doc,
                  isFirstMessage: isFirstMessage,
              );
            }else if(state is AppSelectMessageImageState){
              cubit.sendMediaMessage(
                friendToken:friendToken,
                  friendID: friendID,
                  mediaSource: MediaSource.image,
                  isFirstMessage: isFirstMessage,
              );
            }else if(state is AppSelectMessageVideoState){
              cubit.sendMediaMessage(
                friendToken:friendToken,
                  friendID: friendID,
                  mediaSource: MediaSource.video,
                  isFirstMessage: isFirstMessage,
              );
            }else{
              cubit.sendMessage(
                  friendToken:friendToken,
                  friendID: friendID,
                  isFirstMessage: isFirstMessage,
                  message: messageController.text.substring(
                      0,messageController.text.length-endCnt)
              );
            }
            messageController.clear();
          } : null,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: CircleAvatar(
                radius: 18.sp,
                backgroundColor: sendCondition?
                MyColors.blue.withOpacity(0.8):Colors.grey.withOpacity(0.4),
                child: Icon(IconBroken.Send,size: 17.sp,
                  color: sendCondition?Colors.white:Colors.grey,
                )
            ),
          ),
        );
      },
    );
  }

}

// ignore: must_be_immutable
class SendMessageTextFiled extends StatelessWidget {
  final AppCubit cubit;
  final AppStates state;
  final bool isFirstMessage;
  final TextEditingController messageController;
  final ValueNotifier showAnimatedContainer;
  final String friendID;
  final String friendToken;
  const SendMessageTextFiled(
      {Key? key,required this.messageController, required this.cubit,
        required this.friendID, required this.isFirstMessage,
        required this.showAnimatedContainer, required this.state, required this.friendToken, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: languageFun(ar: 2.0.w, en: 0.0),
              left: languageFun(ar: 0.0, en: 2.0.w),
            ),
            child: TextField(
              enabled: state is! AppSelectFileState || state is! AppSendMediaMessageLoadingState,
              inputFormatters: [NoLeadingSpaceFormatter()],
              cursorColor: MyColors.grey.withOpacity(0.7),
              controller: messageController,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 13.sp,
              ),
              decoration: InputDecoration(
                hintText: state is! AppSelectFileState?
                "type your message...":"Send ${cubit.docName}",
                hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 11.sp,
                    color: MyColors.grey.withOpacity(0.6)
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: messageController,
                  builder: (BuildContext context, value, Widget? child) {
                    if (value.text.isEmpty) {
                      return SendMediaRow(cubit: cubit,state: state,);
                    } else {
                      return ValueListenableBuilder(
                        valueListenable: showAnimatedContainer,
                        builder: (BuildContext context, value, Widget? child) {
                          return IconButton(
                              onPressed: (){
                                showAnimatedContainer.value =! showAnimatedContainer.value;
                              },
                              icon: Icon(
                                !showAnimatedContainer.value?
                                IconBroken.Arrow___Up_Circle:IconBroken.Arrow___Down_Circle
                                ,size: 20.sp,color: MyColors.blue,)
                          );
                      },
                      );
                    }
                  },
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 2.0.h, horizontal: 4.w),
                filled: true,
                fillColor: MyColors.lightBlack,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.sp),
                  borderSide: const BorderSide(color: MyColors.lightBlack)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                    borderSide: const BorderSide(color: MyColors.lightBlack)
                ),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                    borderSide: const BorderSide(color: MyColors.lightBlack)
                ),
              ),
            ),
          ),
        ),
        SendMessageButton(
          cubit: cubit,
            state: state,
            messageController: messageController,
          isFirstMessage: isFirstMessage,
          friendID: friendID,
          friendToken: friendToken,
        )
      ],
    );
  }
}

class SendMediaRow extends StatelessWidget {
  final AppCubit cubit;
  final AppStates state;
  const SendMediaRow({Key? key, required this.cubit, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: GestureDetector(
            onTap: state is! AppSendMediaMessageLoadingState?(){
              cubit.selectMessageImage(mediaSource: MediaSource.image);
            }:null,
            child: Icon(
              IconBroken.Image,size: 18.sp,
              color: MyColors.blue.withOpacity(0.8),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: GestureDetector(
            onTap: state is! AppSendMediaMessageLoadingState? (){
              cubit.selectMessageImage(mediaSource: MediaSource.video);
            }:null,
            child: Icon(
              IconBroken.Video,size: 18.sp,
              color: MyColors.blue.withOpacity(0.8),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Padding(
            padding: EdgeInsets.only(
                left: languageFun(ar: 2.w, en: 0.0.w),
                right: languageFun(ar: 0.0.w, en: 2.w)
            ),
            child: GestureDetector(
              onTap: state is! AppSendMediaMessageLoadingState? (){
                cubit.selectFile();
              }:null,
              child: Icon(
                IconBroken.Folder,size: 18.sp,
                color: MyColors.blue.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../styles/icons_broken.dart';




class SendMessageButton extends StatelessWidget {
  final AppCubit cubit;
  final bool isFirstMessage;
  final TextEditingController messageController;
  final ScrollController scrollController;
  final String friendID;
  const SendMessageButton({Key? key, required this.messageController,
    required this.cubit, required this.friendID, required this.isFirstMessage, required this.scrollController,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: messageController,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: value.text.isNotEmpty ? () {
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
            scrollDown(scrollController);
            cubit.sendMessage(
                friendID: friendID,
                isFirstMessage: isFirstMessage,
                message: messageController.text.substring(0,messageController.text.length-endCnt)
            );
            messageController.clear();
          } : null,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: CircleAvatar(
                radius: 18.sp,
                backgroundColor: value.text.isNotEmpty?
                MyColors.blue.withOpacity(0.8):Colors.grey.withOpacity(0.4),
                child: Icon(IconBroken.Send,size: 17.sp,
                  color: value.text.isNotEmpty?Colors.white:Colors.grey,
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
  final bool isFirstMessage;
  final TextEditingController messageController;
  final ScrollController scrollController;
  final ValueNotifier showAnimatedContainer;
  final String friendID;
  const SendMessageTextFiled(
      {Key? key,required this.messageController, required this.cubit,
        required this.friendID, required this.isFirstMessage,
        required this.scrollController, required this.showAnimatedContainer, }) : super(key: key);

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
              inputFormatters: [NoLeadingSpaceFormatter()],
              cursorColor: MyColors.grey.withOpacity(0.7),
              controller: messageController,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 13.sp,
              ),
              decoration: InputDecoration(
                hintText: "type your message...",
                hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 11.sp,
                    color: MyColors.grey.withOpacity(0.6)
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: messageController,
                  builder: (BuildContext context, value, Widget? child) {
                    if (value.text.isEmpty) {
                      return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: GestureDetector(
                            onTap: (){
                              cubit.selectMessageImage(mediaSource: MediaSource.image);
                              },
                            child: Icon(
                              IconBroken.Image,size: 18.sp,
                              color: MyColors.blue.withOpacity(0.8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: GestureDetector(
                            onTap: (){
                              cubit.selectMessageImage(mediaSource: MediaSource.video);
                              },
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
                              onTap: (){
                                //cubit.selectMessageImage();
                              },
                              child: Icon(
                                IconBroken.Folder,size: 18.sp,
                                color: MyColors.blue.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
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
              ),
            ),
          ),
        ),
        SendMessageButton(
          cubit: cubit,
            messageController: messageController,
          scrollController: scrollController,
          isFirstMessage: isFirstMessage,
          friendID: friendID,
        )
      ],
    );
  }
}


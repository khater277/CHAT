import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../styles/icons_broken.dart';

class SendMessageButton extends StatelessWidget {
  final TextEditingController messageController;
  const SendMessageButton({Key? key, required this.messageController,}) : super(key: key);

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
          } : null,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: CircleAvatar(
                radius: 6.w,
                backgroundColor: value.text.isNotEmpty?
                MyColors.blue.withOpacity(0.8):Colors.grey.withOpacity(0.4),
                child: Icon(IconBroken.Send,size: 5.5.w,
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
  final TextEditingController controller;

  const SendMessageTextFiled(
      {Key? key,required this.controller,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: languageFun(ar: 1.0.w, en: 0.0),
              left: languageFun(ar: 0.0, en: 1.0.w),
            ),
            child: TextField(
              inputFormatters: [NoLeadingSpaceFormatter()],
              cursorColor: MyColors.grey.withOpacity(0.7),
              controller: controller,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 5.w,
              ),
              decoration: InputDecoration(
                hintText: "type your message...",
                hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 3.8.w,
                    color: MyColors.grey.withOpacity(0.6)
                ),
                suffixIcon: IconButton(
                  onPressed: (){},
                    icon: Icon(IconBroken.Image,size: 6.w,color: MyColors.blue,)),
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
        SendMessageButton(messageController: controller)
      ],
    );
  }
}

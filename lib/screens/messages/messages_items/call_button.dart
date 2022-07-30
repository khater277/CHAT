import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/MessageModel.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CallButton extends StatelessWidget {
  final UserModel user;
  final String type;
  final IconData icon;
  const CallButton(
      {Key? key, required this.user, required this.type, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void test() {
      MessageModel myMessageModel = MessageModel(
        senderID: user.uId!, //////
        receiverID: uId, ///////
        message: "message",
        media: "",
        storyMedia: "",
        isStoryReply: false,
        isStoryVideoReply: false,
        isImage: false,
        isVideo: false,
        isDoc: false,
        isDeleted: false,
        date: DateTime.now().toString(),
        storyDate: null,
      );

      // add new message to my database and then to my friend
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(user.uId!)
          .collection('messages')
          .add(myMessageModel.toJson())
          .then((value) {
        debugPrint(value.id);
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uId!)
            .collection('chats')
            .doc(uId)
            .collection('messages')
            .doc(value.id)
            .set(myMessageModel.toJson())
            .then((value) {
          AppCubit.get(context).sendLastMessage(
              friendID: user.uId!,
              message: "message",
              file: null,
              mediaSource: null);
          // don't send notification when friend's token is similar to my token
          // if(friendToken!=userModel!.token) { ///////
          AppCubit.get(context).sendNotification(
              userToken: AppCubit.get(context).userModel!.token!,
              userID: user.uId!);
          // }
          debugPrint("MESSAGE SENT");
        }).catchError((error) {
          printError("sendMessage", error.toString());
        });
      }).catchError((error) {
        printError("sendMessage", error.toString());
      });
    }

    return IconButton(
        onPressed: () {
          AppCubit.get(context)
              .updateInCallStatus(isTrue: true, isOpening: true);
          AppCubit.get(context).generateChannelToken(
            receiverId: user.uId!,
            friendPhone: user.phone!,
            callType: type,
            myCallStatus: "no response",
            friendCallStatus: "missed",
            userToken: user.token!,
          );
        },
        icon: Icon(
          icon,
          color: MyColors.blue,
          size: 18.sp,
        ));
  }
}

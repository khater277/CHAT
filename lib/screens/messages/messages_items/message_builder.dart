import 'dart:io';

import 'package:chat/models/MessageModel.dart';
import 'package:chat/screens/messages/messages_items/friend_message.dart';
import 'package:chat/screens/messages/messages_items/my_message.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/date_format.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../../cubit/app/app_cubit.dart';
import '../../../models/LastMessageModel.dart';
import '../../../shared/constants.dart';
import '../../../styles/icons_broken.dart';

class MessageBuilder extends StatelessWidget {
  final AppCubit cubit;
  final MessageModel message;
  final MessageModel previousMessage;
  final int index;
  final String friendID;
  final String friendName;
  final String messageID;
  final LastMessageModel? lastMessageModel;
  const MessageBuilder({Key? key, required this.cubit,required this.message, required this.index,
    required this.previousMessage, required this.friendID, required this.messageID,
    required this.lastMessageModel, required this.friendName,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool showDay = DateFormatter().messageDate(message.date!)!=DateFormatter().messageDate(previousMessage.date!);


    return Column(
      children: [
        if(showDay||index==0)
          Padding(
            padding: EdgeInsets.only(top: index==0?1.h:3.h,),
            child: Card(
              color: MyColors.lightBlack,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.sp)
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.8.h,horizontal: 3.w),
                child: Text(
                  DateFormatter().messageDate(message.date!),
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: 11.sp,
                      letterSpacing: 1,
                      color: Colors.grey
                  ),
                ),
              ),
            ),
          ),
        if (message.senderID==uId)
          Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(message.isDoc==true||message.isImage==true||message.isVideo==true)
                  DownloadButton(
                    message: message,
                    //downloadFileIndicator: downloadFileIndicator,
                  ),
                MyMessage(
                  messageModel: message,
                  index: index,
                  cubit: cubit,
                  messageID: messageID,
                  lastMessageModel: lastMessageModel,
                  friendID: friendID,
                ),

              ],
            ),
          )
        else Padding(
          padding: EdgeInsets.only(top: 1.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FriendMessage(
                messageModel: message,
                index: index,
                cubit: cubit,
                messageID: messageID,
                lastMessageModel: lastMessageModel,
                friendID: friendID,
                name: friendName,
              ),
              if(message.isDoc==true||message.isImage==true||message.isVideo==true)
                DownloadButton(
                  message: message,
                  //downloadFileIndicator: downloadFileIndicator,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class DownloadButton extends StatefulWidget {
  final MessageModel message;
  const DownloadButton({Key? key, required this.message}) : super(key: key);

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}
class _DownloadButtonState extends State<DownloadButton> {

  ValueNotifier downloadFileIndicator = ValueNotifier<double?>(0.0);
  bool isRunning = false;


  @override
  void initState() {

    super.initState();
  }

  void _saveNetworkImage({required String url}) async {
    GallerySaver.saveImage(url).then((value) {
      debugPrint('Image is saved $value');
    });
  }

  void download()async{
    final directory = await getExternalStorageDirectory();
    final filePath = "${directory!.path}/${widget.message.message!}";
    final file = File(filePath);
    debugPrint(filePath);
    FirebaseStorage.instance.ref()
        .child("media/${widget.message.message!}")
        .writeToFile(file)
        .snapshotEvents
        .listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          setState(() {
            isRunning = true;
          });
          double percentage = taskSnapshot.bytesTransferred/taskSnapshot.totalBytes;
          downloadFileIndicator.value = percentage;
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          AppCubit cubit = AppCubit.get(context);
          String fileName = widget.message.isVideo==true?"video":
          widget.message.isVideo==true?"photo":"${widget.message.message}";
          showSnackBar(
              context: context,
              title: "success",
              content: "$fileName downloaded successfully",
              color: MyColors.white,
              fontColor: MyColors.black,
              icon: IconBroken.Danger
          );
          if(widget.message.isVideo==true||widget.message.isImage==true) {
            _saveNetworkImage(url: widget.message.media!);
          }
          cubit.test();
          setState(() {
            isRunning = false;
          });
          debugPrint("${file.parent}");
          break;
        case TaskState.canceled:
          break;
        case TaskState.error:
          String fileName = widget.message.isVideo==true?"video":
          widget.message.isVideo==true?"photo":"${widget.message.message}";
          setState(() {
            isRunning = false;
          });
          showSnackBar(
              context: context,
              title: "warning",
              content: "failed to download $fileName",
              color: MyColors.white,
              fontColor: MyColors.black,
              icon: IconBroken.Danger
          );
          debugPrint("TaskState.error");
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: downloadFileIndicator,
      builder: (BuildContext context, value, Widget? child) {
      return FutureBuilder<Directory?>(
        future: AppCubit.get(context).future??getExternalStorageDirectory(),
        builder: (BuildContext context, AsyncSnapshot<Directory?> snapshot) {
          if(snapshot.hasData){
            bool isSaved = File("${snapshot.data!.path}/${widget.message.message!}").existsSync();
            if(!isSaved) {
              if(isRunning) {
                return SizedBox(
                  width: 16.sp,height: 16.sp,
                  child: CircularProgressIndicator(
                    value: downloadFileIndicator.value!=0?downloadFileIndicator.value:null,
                    strokeWidth: 2.sp,
                  )
              );
              }else{
                return GestureDetector(
                  onTap: () {download();},
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child:
                      Icon(IconBroken.Download,size: 16.sp,color: Colors.grey,)
                  ),
                );
              }
            }else{
              return const DefaultNullWidget();
            }
          }else{
            return const DefaultNullWidget();
          }
        },
      );
      },
    );
  }
}


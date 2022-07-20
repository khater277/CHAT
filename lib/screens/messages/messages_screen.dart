import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/models/LastMessageModel.dart';
import 'package:chat/screens/messages/messages_items/animated_container_builder.dart';
import 'package:chat/screens/messages/messages_items/call_button.dart';
import 'package:chat/screens/messages/messages_items/message_builder.dart';
import 'package:chat/screens/messages/messages_items/send_file_message.dart';
import 'package:chat/screens/send_media_message/send_media_screen.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../models/MessageModel.dart';
import '../../models/UserModel.dart';
import 'messages_items/message_filed.dart';
import 'messages_items/scroll_down_floating_button.dart';

class MessagesScreen extends StatefulWidget {
  final UserModel user;
  final bool isFirstMessage;
  const MessagesScreen({Key? key, required this.user, required this.isFirstMessage}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ValueNotifier valueNotifier = ValueNotifier<bool?>(null);
  ValueNotifier showAnimatedContainer = ValueNotifier<bool?>(false);
  ValueNotifier canScroll = ValueNotifier<bool>(true);

  @override
  void initState() {
    AppCubit.get(context).changeCurrentChat(id: widget.user.uId);
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    valueNotifier.dispose();
    showAnimatedContainer.dispose();
    canScroll.dispose();
    super.dispose();
  }

  void readMessages() {
    FirebaseFirestore.instance.collection('users')
        .doc(uId)
        .collection('chats')
        .doc(widget.user.uId!)
        .update({"isRead":true})
        .then((value){
      debugPrint("UPDATED");
    }).catchError((error){
      debugPrint(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users')
          .doc(uId).collection('chats').doc(widget.user.uId)
          .collection('messages').orderBy('date').snapshots(),
      builder: (context, snapshot) {
        bool hasData = false;
        List<MessageModel> messages = [];
        List<String> messagesID = [];
        if(snapshot.hasData){
          for (var element in snapshot.data!.docs) {
            MessageModel messageModel = MessageModel.fromJson(element.data());
            messagesID.add(element.id);
            messages.add(messageModel);
          }
          readMessages();
          if(canScroll.value) {
            Future.delayed(const Duration(milliseconds: 300)).then((value){
              scrollDown(_scrollController);
            });
          }
          hasData = true;
          canScroll.value=false;
        }
        return BlocConsumer<AppCubit,AppStates>(
          listener: (context,state){
            if(state is AppSendMediaMessageState || state is AppSendMessageState){
              Future.delayed(const Duration(milliseconds: 300)).then((value){
                scrollDown(_scrollController);
              });
            }

            if(state is AppDeleteMessageState && messages.isEmpty){
              AppCubit.get(context).deleteChat(chatID: widget.user.uId!);
              Get.back();
            }

            if(state is AppConnectTimeOutErrorState){
              AppCubit.get(context).updateInCallStatus(isTrue: false,isOpening: true);
              showSnackBar(
                  context: context,
                  duration: 5,
                  title: "connection failed",
                  content: "connection timeout , please check your internet connection and try again",
                  color: MyColors.white,
                  fontColor: MyColors.black,
                  icon: Icons.error_outline_outlined);
            }

            if(state is AppGenerateTokenErrorState){
              AppCubit.get(context).updateInCallStatus(isTrue: false,isOpening: true);
              showSnackBar(
                  context: context,
                  duration: 5,
                  title: "connection failed",
                  content: "failed to connect server , please check your connection with token generator server and try again",
                  color: MyColors.white,
                  fontColor: MyColors.black,
                  icon: Icons.error_outline_outlined);
            }

          },
          builder: (context,state){
            AppCubit cubit = AppCubit.get(context);
            return SafeArea(
                child: WillPopScope(
                  onWillPop: () async{
                    cubit.cancelSelectFile();
                    cubit.changeCurrentChat(id: null);
                    return true;
                  },
                  child: ValueListenableBuilder(
                    valueListenable: showAnimatedContainer,
                    builder: (BuildContext context, value, Widget? child) {
                      return GestureDetector(
                        onTap: (){
                          showAnimatedContainer.value = false;
                        },
                        child: Scaffold(
                            appBar: AppBar(
                              toolbarHeight: 10.h,
                              backgroundColor: MyColors.darkBlack,
                              centerTitle: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.sp),
                                    bottomRight: Radius.circular(20.sp),
                                  )
                              ),
                              title: Text(
                                "${widget.user.name}",
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 14.sp
                                ),
                              ),
                              leading: IconButton(
                                onPressed: (){
                                  Get.back();
                                  cubit.changeCurrentChat(id: null);
                                  cubit.cancelSelectFile();
                                  },
                                icon: Icon(
                                  languageFun(ar: IconBroken.Arrow___Right_2, en: IconBroken.Arrow___Left_2),
                                  size: 15.sp,
                                ),
                              ),
                              actions: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: state is! AppGenerateChannelTokenLoadingState?
                                  Row(
                                    children: [
                                      CallButton(
                                        user: widget.user,
                                        type: 'video',
                                        icon: IconBroken.Video,
                                      ),
                                      CallButton(
                                        user: widget.user,
                                        type: 'voice',
                                        icon: IconBroken.Call,
                                      ),
                                    ],
                                  )
                                      :
                                  Align(
                                    alignment: AlignmentDirectional.center,
                                      child: Text(
                                        "connecting..",
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                            fontSize: 12.sp,
                                            color: MyColors.blue
                                        ),
                                      )),
                                )
                              ],
                            ),
                            body: messages.isNotEmpty || hasData?
                            Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: valueNotifier,
                                        builder: (BuildContext context, value, Widget? child) {
                                          return NotificationListener(
                                            onNotification: (notification) {
                                              if (notification is ScrollEndNotification) {
                                                if(_scrollController.position.maxScrollExtent
                                                    ==_scrollController.position.pixels){
                                                  valueNotifier.value = true;
                                                }else{
                                                  valueNotifier.value = false;
                                                }
                                              }
                                              return true;
                                            },
                                            child: ListView.builder(
                                                physics: const BouncingScrollPhysics(),
                                                controller: _scrollController,
                                                shrinkWrap: true,
                                                itemBuilder:(context,index){
                                                  LastMessageModel? lastMessageModel = index!=0 && index==messages.length-1?
                                                  LastMessageModel(
                                                    senderID: messages[index-1].senderID,
                                                    receiverID: messages[index-1].receiverID,
                                                    message: messages[index-1].message,
                                                    media: messages[index-1].media,
                                                    isImage: messages[index-1].isImage,
                                                    isVideo: messages[index-1].isVideo,
                                                    isDoc: messages[index-1].isDoc,
                                                    isRead: true,
                                                    date: messages[index-1].date,
                                                    isDeleted: messages[index-1].isDeleted
                                                  ):null;
                                                  return Column(
                                                    children: [
                                                      MessageBuilder(
                                                        cubit: cubit,
                                                        message: messages[index],
                                                        previousMessage: index!=0?
                                                        messages[index-1]:messages[index],
                                                        index: index,
                                                        lastMessageModel: lastMessageModel,
                                                        messageID: messagesID[index],
                                                        friendID: widget.user.uId!,
                                                        friendName: widget.user.name!,
                                                      ),
                                                      if(messages.length-1==index)
                                                        SizedBox(height: 2.h,)
                                                    ],
                                                  );
                                                },
                                                itemCount: messages.length
                                            ),
                                          );
                                        },
                                      ),
                                      ScrollDownFloatingButton(
                                          valueNotifier: valueNotifier,
                                          scrollController: _scrollController
                                      ),
                                       if(state is AppSelectMessageImageState || cubit.isImage)
                                         SendMediaScreen(
                                           cubit: cubit,
                                           state: state,
                                           mediaSource: MediaSource.image,
                                           file: AppCubit.get(context).file!,
                                           receiverID: widget.user.uId!,
                                           isFirstMessage: widget.isFirstMessage,
                                         ),
                                      if(state is AppSelectMessageVideoState || cubit.isVideo)
                                        SendMediaScreen(
                                          cubit: cubit,
                                          state: state,
                                          mediaSource: MediaSource.video,
                                          file: AppCubit.get(context).file!,
                                          receiverID: widget.user.uId!,
                                          isFirstMessage: widget.isFirstMessage,
                                        ),
                                      SendFileMessage(cubit: cubit,state: state),
                                      AnimatedControllerBuilder(
                                        cubit: cubit,
                                        showAnimatedContainer: showAnimatedContainer,
                                        messageController: _messageController,
                                      )
                                    ],
                                  ),
                                ),
                                SendMessageTextFiled(
                                  messageController: _messageController,
                                  showAnimatedContainer: showAnimatedContainer,
                                  isFirstMessage: messages.isEmpty,
                                  cubit: cubit,
                                  state: state,
                                  friendID: widget.user.uId!,
                                  friendToken: widget.user.token!,
                                )
                              ],
                            )
                                :const DefaultProgressIndicator(icon: IconBroken.Message)
                        ),
                      );
                    },
                  ),
                )
            );
          },
        );
      }
    );
  }
}

import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/messages/messages_items/message_builder.dart';
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
  bool? isEnd;


  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is AppSelectMessageImageState){
          Get.to(()=>SendMediaScreen(
            mediaSource: MediaSource.image,
              file: AppCubit.get(context).file!,
              receiverID: widget.user.uId!,
            isFirstMessage: widget.isFirstMessage,
          )
          );
        }else if(state is AppSelectMessageVideoState){
          Get.to(()=>SendMediaScreen(
              mediaSource: MediaSource.video,
              file: AppCubit.get(context).file!,
              receiverID: widget.user.uId!,
            isFirstMessage: widget.isFirstMessage,
          )
          );
        }
      },
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
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
                leading: const DefaultBackButton(),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: IconButton(
                        onPressed: (){
                          //cubit.getContacts();
                        },
                        icon: Icon(IconBroken.Call,color: MyColors.blue,size: 18.sp,)
                    ),
                  )
                ],
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users')
                  .doc(uId).collection('chats').doc(widget.user.uId)
                    .collection('messages').orderBy('date').snapshots(),
                builder: (context, snapshot) {
                  bool hasData = false;
                  List<MessageModel> messages = [];
                  if(snapshot.hasData){
                    for (var element in snapshot.data!.docs) {
                      MessageModel messageModel = MessageModel.fromJson(element.data());
                      messages.add(messageModel);
                    }
                    Future.delayed(const Duration(milliseconds: 300)).then((value){
                      scrollDown(_scrollController);
                    });
                    hasData = true;
                  }
                  return messages.isNotEmpty || hasData?
                    Column(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: valueNotifier,
                              builder: (BuildContext context, value, Widget? child) {
                                return NotificationListener(
                                  onNotification: (notification) {
                                    if (notification is ScrollUpdateNotification) {
                                      if(_scrollController.position.maxScrollExtent
                                          ==_scrollController.position.pixels){
                                        valueNotifier.value=true;
                                      }else{
                                        valueNotifier.value=false;
                                      }
                                    }
                                    return true;
                                  },
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      controller: _scrollController,
                                      shrinkWrap: true,
                                      itemBuilder:(context,index)=>
                                          Column(
                                            children: [
                                              MessageBuilder(message: messages[index]),
                                              if(messages.length-1==index)
                                                SizedBox(height: 2.h,)
                                            ],
                                          ),
                                      itemCount: messages.length
                                  ),
                                );
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable: valueNotifier,
                              builder: (BuildContext context, value, Widget? child) {
                                return value!=true?
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.5.w,vertical: 1.5.h),
                                  child: SizedBox(
                                    width: 27.sp,height: 27.sp,
                                    child: FloatingActionButton(
                                      onPressed: (){scrollDown(_scrollController);},
                                      shape: const CircleBorder(),
                                      backgroundColor: MyColors.lightBlack,
                                      child: Icon(IconBroken.Arrow___Down_2,size: 13.sp,color: MyColors.blue,),
                                    ),
                                  ),
                                )
                                :
                                const DefaultNullWidget();
                              },
                            ),
                          ],
                        ),
                      ),
                      SendMessageTextFiled(
                          messageController: _messageController,
                        scrollController: _scrollController,
                        isFirstMessage: messages.isEmpty,
                        cubit: cubit,
                        friendID: widget.user.uId!,
                      )
                    ],
                  )
                      :const DefaultProgressIndicator(icon: IconBroken.Message);
                }
              )
            )
        );
      },
    );
  }
}

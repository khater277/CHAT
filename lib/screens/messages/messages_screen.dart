import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/messages/messages_items/message_builder.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../models/MessageModel.dart';
import '../../models/UserModel.dart';
import 'messages_items/message_filed.dart';

class MessagesScreen extends StatefulWidget {
  final UserModel user;
  const MessagesScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {

  final TextEditingController _messageController = TextEditingController();
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
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
                  List<MessageModel> messages = [];
                  if(snapshot.hasData){
                    for (var element in snapshot.data!.docs) {
                      MessageModel messageModel = MessageModel.fromJson(element.data());
                      messages.add(messageModel);
                    }
                  }
                  return messages.isNotEmpty?
                    Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemBuilder:(context,index)=>
                                MessageBuilder(message: messages[index]),
                            itemCount: messages.length
                        ),
                      ),
                      SendMessageTextFiled(
                          messageController: _messageController,
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

import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/models/LastMessageModel.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/chats/chats_items/chats_last_message.dart';
import 'package:chat/screens/chats/chats_items/chats_name.dart';
import 'package:chat/screens/chats/chats_items/chats_profile_Image.dart';
import 'package:chat/screens/home/home_app_bar.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../messages/messages_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users')
                  .doc(uId).collection('chats').orderBy('date').snapshots(),
            builder: (context, snapshot) {
              bool hasData = false;
              List<LastMessageModel> lastMessages = [];
              List<UserModel> chats = [];
              if(snapshot.hasData){
                for (int i=0;i<snapshot.data!.size;i++) {
                  var element = snapshot.data!.docs[i];
                  lastMessages.add(LastMessageModel.fromJson(element.data()));
                  chats.add(cubit.chats.firstWhere((user) =>
                  user.uId==element.id));
                }
                lastMessages = lastMessages.reversed.toList();
                chats = chats.reversed.toList();
                hasData = true;
              }
              return hasData?
                cubit.chats.isNotEmpty?
              Scaffold(
                body: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const HomeAppBar(),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 5.w,
                          left: 5.w,
                          top: 3.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context,index){
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Get.to(()=> MessagesScreen(
                                              user: chats[index],
                                              isFirstMessage: false,
                                            ));
                                          },
                                          child: Container(
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                              child: Row(
                                                children: [
                                                  ChatsProfileImage(userModel: chats[index],),
                                                  SizedBox(width: 4.w,),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ChatsName(
                                                          userModel: chats[index],
                                                          date: lastMessages[index].date!,),
                                                        SizedBox(height: 0.4.h,),
                                                        ChatsLastMessage(lastMessage: lastMessages[index],)
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if(index==chats.length)
                                          SizedBox(height: 2.h,)
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context,index)=>Divider(
                                    color: MyColors.grey.withOpacity(0.08),
                                  ),
                                  itemCount: chats.length
                              ),
                            )
                          ],
                        )
                      ),
                    )
                  ],
                )
              ) :
              Scaffold(
                appBar: AppBar(
                  toolbarHeight: 12.h,
                  titleSpacing: 0,
                  leading: IconButton(
                      onPressed: (){},
                      icon: Icon(IconBroken.Edit_Square,size: 18.sp,color: MyColors.grey,)
                  ),
                  centerTitle: true,
                  title: Text(
                    "NUNTIUS",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        letterSpacing: 2,
                        fontSize: 17.sp,
                        color: MyColors.blue.withOpacity(0.7)
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: (){},
                        icon: Icon(IconBroken.Search,size: 18.sp,color: MyColors.grey,)
                    )
                  ],
                ),
                body: NoItemsFounded(
                    text: "Start now new conversations with your friends",
                    widget: Icon(IconBroken.Message,
                      color: Colors.grey.withOpacity(0.7),size: 150.sp,)),
              ) :
              const DefaultProgressIndicator(icon: IconBroken.Chat);
            }
          );
      },
    );
  }
}

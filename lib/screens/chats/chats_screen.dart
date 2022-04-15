import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/chats/chats_items/chats_last_message.dart';
import 'package:chat/screens/chats/chats_items/chats_name.dart';
import 'package:chat/screens/chats/chats_items/chats_profile_Image.dart';
import 'package:chat/screens/home/home_app_bar.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../messages/messages_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return cubit.chats.isNotEmpty?
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
                                        Get.to(()=> MessagesScreen(user: cubit.chats[index],))!.then((value){
                                          scrollDown();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          ChatsProfileImage(userModel: cubit.chats[index],),
                                          SizedBox(width: 4.w,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ChatsName(
                                                  userModel: cubit.chats[index],
                                                date: cubit.chatsLastMessages[index].date!,),
                                                SizedBox(height: 0.4.h,),
                                                ChatsLastMessage(lastMessage: cubit.chatsLastMessages[index],)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if(index==cubit.chats.length)
                                      SizedBox(height: 2.h,)
                                  ],
                                );
                              },
                              separatorBuilder: (context,index)=>Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                child: Divider(
                                  color: MyColors.grey.withOpacity(0.08),
                                ),
                              ),
                              itemCount: cubit.chats.length
                          ),
                        )
                      ],
                    )
                  ),
                )
              ],
            )
        ):Scaffold(
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
        );
      },
    );
  }
}

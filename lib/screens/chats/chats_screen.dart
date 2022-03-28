import 'package:chat/screens/chats/chats_items/chats_last_message.dart';
import 'package:chat/screens/chats/chats_items/chats_name.dart';
import 'package:chat/screens/chats/chats_items/chats_profile_Image.dart';
import 'package:chat/screens/home/home_app_bar.dart';
import 'package:chat/screens/messages/messages_screen.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                    Get.to(()=>const MessagesScreen());
                                  },
                                  child: Row(
                                    children: [
                                      const ChatsProfileImage(),
                                      SizedBox(width: 4.w,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const ChatsName(),
                                            SizedBox(height: 0.4.h,),
                                            const ChatsLastMessage()
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                if(index==19)
                                  SizedBox(height: 2.h,)
                              ],
                            );
                          },
                          separatorBuilder: (context,index)=>Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Divider(
                              color: MyColors.grey.withOpacity(0.08),
                            ),
                          ),
                          itemCount: 20
                      ),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}

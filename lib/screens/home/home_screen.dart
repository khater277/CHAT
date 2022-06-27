import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/add_text_story/add_text_story_screen.dart';
import 'package:chat/screens/home/stories_fab.dart';
import 'package:chat/screens/messages/messages_screen.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../notifications/local_notifications.dart';
import '../add_media_story/add_media_story_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    AppCubit cubit = AppCubit.get(context);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.body}');
      }

      UserModel? userModel = cubit.users.firstWhereOrNull((element) =>
      element.uId==message.data['senderID']);
      String? name = userModel!=null?userModel.name!
          :message.data['phoneNumber'];
      int id = (DateTime.now().millisecondsSinceEpoch/1000).floor();
      print("current=================>${cubit.currentChat}");
      print("sender=================>${message.data['senderID']}");
      if(cubit.currentChat != message.data['senderID']) {
        NotificationsHelper.showNotification(id: id,name: name!,senderID: message.data['senderID']);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Detect your current screen if you wish when "onResume" called.
      UserModel? userModel = cubit.chats.firstWhereOrNull((element) =>
      element.uId==message.data['senderID']);
      if(userModel==null){
        cubit.getChats();
        userModel = cubit.chats.firstWhereOrNull((element) =>
        element.uId==message.data['senderID']);
        Get.to(()=>MessagesScreen(user: userModel!, isFirstMessage: false));
      }else {
        Get.to(()=>MessagesScreen(user: userModel!, isFirstMessage: false));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is AppPickStoryImageState){
          Get.to(const AddMediaStoryScreen(mediaSource: MediaSource.image,));
        }
        if(state is AppPickStoryVideoState){
          Get.to(const AddMediaStoryScreen(mediaSource: MediaSource.video,));
        }
      },
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: state is! AppLoadingState?
          Scaffold(
            body: cubit.screens[cubit.navBarIndex],
            extendBody: true,
            floatingActionButton:cubit.navBarIndex==1?
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StoriesFAB(
                    onPressed: (){Get.to(()=>const AddTextStoryScreen());},
                    icon: IconBroken.Edit,
                  tag: "btn1",
                ),
                SizedBox(height: 1.h,),
                StoriesFAB(
                    onPressed: (){
                      cubit.pickStoryImage();
                    },
                    icon: IconBroken.Image,
                  tag: "btn2",
                ),
                SizedBox(height: 1.h,),
                StoriesFAB(
                    onPressed: (){
                      cubit.pickStoryVideo();
                    },
                    icon: IconBroken.Video,
                  tag: "btn3",
                ),
              ],
            )
                :
            null,

            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: DotNavigationBar(
                //curve: Curves.ease,
                currentIndex: cubit.navBarIndex,
                onTap: (index) {
                  cubit.changeNavBar(index);
                },
                marginR: EdgeInsets.symmetric(horizontal: 3.w),
                dotIndicatorColor: Colors.transparent,
                selectedItemColor: MyColors.blue,
                unselectedItemColor: MyColors.white.withOpacity(0.7),
                backgroundColor: MyColors.lightBlack,
                itemPadding: EdgeInsets.only(
                  left: 7.w,
                  right: 7.w,
                  top: 1.h,
                  bottom: 1.6.h,
                ),
                borderRadius: 50.sp,
                items: [
                  DotNavigationBarItem(
                    icon: Icon(IconBroken.Chat,size: 19.sp,),
                  ),
                  DotNavigationBarItem(
                    icon: Icon(IconBroken.Camera,size: 19.sp,),
                  ),
                  DotNavigationBarItem(
                    icon: Icon(IconBroken.Call,size: 19.sp,),
                  ),
                  DotNavigationBarItem(
                    icon: Icon(IconBroken.User1,size: 19.sp,),
                  ),
                ],
              ),
            ),
          )
              :
          const Scaffold(
            body: DefaultProgressIndicator(icon: IconBroken.Chat),
          ),
        );
      },
    );
  }
}



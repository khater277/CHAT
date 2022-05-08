import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/add_new_story/add_new_story_screen.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is AppPickStoryImageState){
          Get.to(const AddNewStoryScreen());
        }
      },
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: state is! AppLoadingState?
          Scaffold(
            body: cubit.screens[cubit.navBarIndex],
            extendBody: true,
            floatingActionButton:cubit.navBarIndex==1?SizedBox(
              width: 38.sp,
              height: 38.sp,
              child: FloatingActionButton(
                onPressed: (){
                  cubit.pickStoryImage();
                },
                backgroundColor: Colors.grey.shade800,
                child: Icon(
                  Icons.add,
                  color: MyColors.white,
                  size: 16.sp,
                ),
              ),
            ):null,

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



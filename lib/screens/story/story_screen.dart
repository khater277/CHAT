import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/screens/add_new_story/add_new_story_screen.dart';
import 'package:chat/screens/home/home_app_bar.dart';
import 'package:chat/screens/story/story_items/my_story.dart';
import 'package:chat/screens/story/story_items/story_date.dart';
import 'package:chat/screens/story/story_items/story_profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../cubit/app/app_states.dart';
import '../../models/UserModel.dart';
import '../../shared/colors.dart';
import '../../shared/constants.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is AppPickStoryImageState){
          Get.to(()=> const AddNewStoryScreen());
        }
      },
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
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
                      top: 1.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('users')
                                .doc(uId!).snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData) {
                               UserModel myData = UserModel.fromJson(snapshot.data!.data());
                               cubit.userModel = myData;
                              return Column(
                                children: [
                                  MyStory(image: "${myData.image}",),
                                ],
                              );
                            }else{
                             return SizedBox(
                               width: 12.w,
                               height: 6.h,
                               child: CircularProgressIndicator(
                                 strokeWidth: 2.sp,
                               ),
                             );
                            }
                          }
                        ),
                        SizedBox(height: 1.h,),
                        Divider(color: MyColors.grey.withOpacity(0.5),),
                        SizedBox(height: 1.h,),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index){
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){},
                                      child: Container(
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                          child: Row(
                                            children: [
                                              const StoryProfileImage(),
                                              SizedBox(width: 4.w,),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Ahmed Khater",
                                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                          fontSize: 12.sp
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 0.5.h,),
                                                    const StoryDate()
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // if(index==chats.length)
                                    //   SizedBox(height: 2.h,)
                                  ],
                                );
                              },
                              itemCount: 10
                          ),
                        )
                      ],
                    )
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

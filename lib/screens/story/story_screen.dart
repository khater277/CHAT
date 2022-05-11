import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/StoryModel.dart';
import 'package:chat/screens/home/home_app_bar.dart';
import 'package:chat/screens/story/story_items/my_story.dart';
import 'package:chat/screens/story/story_items/story_date.dart';
import 'package:chat/screens/story/story_items/story_profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../cubit/app/app_states.dart';
import '../../shared/colors.dart';
import '../../shared/constants.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);

  void deleteStory(QueryDocumentSnapshot<Object?> element) {
    FirebaseFirestore.instance.collection("stories").doc(uId)
        .collection("currentStories")
        .doc(element.id)
        .delete()
        .then((value){
      debugPrint("STORY DELETED");
    }).catchError((error){
      debugPrint("============>${error.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        // if(state is AppPickStoryImageState){
        //   Get.to(()=> const AddNewStoryScreen());
        // }
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
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection("stories").doc(uId)
                                  .collection("currentStories").orderBy('date').snapshots(),
                              builder: (context, snapshot) {
                                List<StoryModel> stories = [];
                                if(snapshot.hasData){
                                  for (var element in snapshot.data!.docs) {
                                    StoryModel storyModel = StoryModel.fromJson(element.data());
                                    DateTime validStoryDate = DateTime.parse(storyModel.date!)
                                        .add(const Duration(days: 1));
                                    DateTime nowDate = DateTime.now();
                                    bool condition = nowDate.isBefore(validStoryDate);
                                    if(condition){
                                      stories.add(storyModel);
                                    }
                                    else{
                                      cubit.deleteStory(id: element.id);
                                      // deleteStory(element);
                                    }
                                  }
                                }
                                return Column(
                                  children: [
                                    // Text("${stories.length}"),
                                    MyStory(
                                      image:cubit.userModel==null?null:"${cubit.userModel!.image}",
                                      stories:stories,
                                    ),
                                  ],
                                );
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
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

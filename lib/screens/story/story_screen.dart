import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/StoryModel.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/home/home_app_bar.dart';
import 'package:chat/screens/story/story_items/check_stories_text.dart';
import 'package:chat/screens/story/story_items/contact_story.dart';
import 'package:chat/screens/story/story_items/my_story.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../cubit/app/app_states.dart';
import '../../shared/colors.dart';
import '../../shared/constants.dart';
import 'story_items/recent_or_viewed_story.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);

  void deleteStory(QueryDocumentSnapshot<Object?> element) {
    FirebaseFirestore.instance
        .collection("stories")
        .doc(uId)
        .collection("currentStories")
        .doc(element.id)
        .delete()
        .then((value) {
      debugPrint("STORY DELETED");
    }).catchError((error) {
      debugPrint("============>${error.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // if(state is AppPickStoryImageState){
        //   Get.to(()=> const AddNewStoryScreen());
        // }
      },
      builder: (context, state) {
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
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("stories")
                                .doc(uId)
                                .collection("currentStories")
                                .orderBy('date')
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<StoryModel> stories = [];
                              List<String> storiesIDs = [];
                              if (snapshot.hasData) {
                                for (var element in snapshot.data!.docs) {
                                  storiesIDs.add(element.id);
                                  StoryModel storyModel =
                                      StoryModel.fromJson(element.data());
                                  DateTime validStoryDate =
                                      DateTime.parse(storyModel.date!)
                                          .add(const Duration(days: 1));
                                  DateTime nowDate = DateTime.now();
                                  bool condition =
                                      nowDate.isBefore(validStoryDate);
                                  if (condition) {
                                    stories.add(storyModel);
                                  } else {
                                    cubit.deleteStory(
                                      userID: uId!,
                                        storyID: element.id,
                                    media: storyModel.media==""?null:storyModel.media);
                                    // deleteStory(element);
                                  }
                                }
                              }
                              return Column(
                                children: [
                                  // Text("${stories.length}"),
                                  MyStory(
                                    image: cubit.userModel == null
                                        ? null
                                        : "${cubit.userModel!.image}",
                                    stories: stories,
                                  ),
                                ],
                              );
                            }),
                        SizedBox(height: 1.h,),
                        Divider(color: MyColors.grey.withOpacity(0.5),),
                        SizedBox(height: 1.h,),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection("stories")
                                .where("phone", whereIn: cubit.phones).orderBy('date',descending: true).snapshots(),
                            builder: (context, snapshot) {
                              List<UserModel> contactsInfo = [];
                              List<UserModel> viewedInfo = [];
                              List<UserModel> recentInfo = [];
                              List<StoryModel> contactsStories = [];
                              List<StoryModel> recentStories = [];
                              List<StoryModel> viewedStories = [];
                              if(snapshot.hasData){
                                for (var element in snapshot.data!.docs) {
                                  UserModel contactUser = cubit.users.firstWhere((user)=>
                                  user.uId==element.id);
                                  StoryModel contactStory = StoryModel.fromJson(element.data());
                                  // element.
                                  if(contactUser.uId!=uId){
                                    if (checkValidStory(storyModel: contactStory)
                                        &&contactStory.canView!.contains(uId)
                                    ) {
                                      if(contactStory.viewers!.contains(uId)){
                                        viewedStories.add(contactStory);
                                        viewedInfo.add(contactUser);
                                      }else{
                                        recentStories.add(contactStory);
                                        recentInfo.add(contactUser);
                                      }
                                      // viewedStories.add(contactStory);
                                      // recentStories.add(contactStory);
                                      // viewedInfo.add(contactUser);
                                      // recentInfo.add(contactUser);
                                      contactsStories.add(contactStory);
                                      contactsInfo.add(contactUser);
                                    }
                                  }
                                }
                                if(contactsStories.isNotEmpty) {
                                  return Flexible(
                                    fit: FlexFit.loose,
                                    child: Column(
                                      children: [
                                        if(recentStories.isNotEmpty)
                                        RecentOrViewedStories(
                                            storyList: recentStories,
                                            infoList: recentInfo,
                                          isViewed: false,
                                        ),
                                        if(viewedStories.isNotEmpty)
                                          RecentOrViewedStories(
                                              storyList: viewedStories,
                                              infoList: viewedInfo,
                                            isViewed: true,
                                          ),
                                      ],
                                    ),
                                );
                                }else{
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height/2,
                                    child: NoItemsFounded(
                                        text: "No stories yet",
                                        widget: Icon(
                                            IconBroken.Paper_Fail,
                                          size: 100.sp,
                                          color: Colors.grey.withOpacity(0.5),
                                        )
                                    ),
                                  );
                                }
                                }
                              else {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height/2,
                                  child: const DefaultProgressIndicator(icon: IconBroken.Camera),
                              );
                              }
                            })
                      ],
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
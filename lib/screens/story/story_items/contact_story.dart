import 'package:chat/models/StoryModel.dart';
import 'package:chat/screens/story/story_items/story_date.dart';
import 'package:chat/screens/story/story_items/story_profile_image.dart';
import 'package:chat/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../cubit/app/app_cubit.dart';
import '../../story_view/story_view_screen.dart';

class ContactStory extends StatelessWidget {
  final String name;
  final String image;
  final String storyDate;
  final String userID;
  final bool isViewed;
  const ContactStory({Key? key, required this.image, required this.storyDate,
    required this.name, required this.userID, required this.isViewed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('stories')
        .doc(userID).collection('currentStories').orderBy("date").snapshots(),
      builder: (context, snapshot) {
        List<StoryModel> stories = [];
        List<String> storiesIDs = [];
        if(snapshot.hasData){
          for (var element in snapshot.data!.docs) {
            StoryModel storyModel = StoryModel.fromJson(element.data());
            if (checkValidStory(storyModel: storyModel)
                &&storyModel.canView!.contains(uId)) {
              storiesIDs.add(element.id);
              stories.add(storyModel);
            }
          }
        }
        return GestureDetector(
          onTap: stories.isNotEmpty?(){
              AppCubit.get(context).zeroStoryIndex();
              Get.to(()=>StoryViewScreen(
                stories: stories,
                profileImage: image,
                name: "My Story",
                userID: userID,
                storiesIDs: storiesIDs,
              ));
          }:null,
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                StoryProfileImage(image: image,isViewed: isViewed,),
                SizedBox(
                  width: 4.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 13.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    StoryDate(storyDate: storyDate,),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/StoryModel.dart';
import '../../../models/UserModel.dart';
import 'check_stories_text.dart';
import 'contact_story.dart';

class RecentOrViewedStories extends StatelessWidget {
  final List<StoryModel> storyList;
  final List<UserModel> infoList;
  final bool isViewed;
  const RecentOrViewedStories({Key? key, required this.storyList, required this.infoList,
    required this.isViewed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CheckStoriesText(text: "Viewed stories"),
        SizedBox(height: 1.5.h,),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index)=>ContactStory(
            userToken: infoList[index].token!,
              userID: infoList[index].uId!,
              name: infoList[index].name!,
              image: infoList[index].image!,
              storyDate: storyList[index].date!,
          isViewed: isViewed,),
          separatorBuilder: (BuildContext context, int index)=> SizedBox(height: 2.5.h,),
          itemCount: storyList.length,
        ),

      ],
    );
  }
}

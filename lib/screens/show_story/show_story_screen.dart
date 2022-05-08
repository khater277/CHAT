import 'package:chat/models/StoryModel.dart';
import 'package:chat/screens/show_story/show_story_image.dart';
import 'package:chat/screens/show_story/story_loader.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShowStoryScreen extends StatelessWidget {
  final List<StoryModel> stories;
  const ShowStoryScreen({Key? key, required this.stories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<int> list = [1,2,3,4,5,6];
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: stories.map((StoryModel story){
                  return SizedBox(
                    width: MediaQuery.of(context).size.width/stories.length,
                      // height: 10,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.2.w),
                        child: StoryLoader(length: stories.length,),
                      )
                  );
                }).toList(),
              ),
            ),
            // ShowStoryImage(imgUrl: stories[0].media!),
          ],
        ),
      ),
    );
  }
}


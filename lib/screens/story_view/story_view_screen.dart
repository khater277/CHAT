import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/models/StoryModel.dart';
import 'package:chat/screens/story_view/show_story_head.dart';
import 'package:chat/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:story_view/story_view.dart';


class StoryViewScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final String profileImage;
  final String name;
  final String userID;
  final String? storyID;
  const StoryViewScreen({Key? key, required this.stories, required this.profileImage,
    required this.name, required this.userID, required this.storyID}) : super(key: key);

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  @override
  Widget build(BuildContext context) {

    final controller = StoryController();
    AppCubit cubit = AppCubit.get(context);
    List<StoryItem> storyItems = [];
    for(int i=0;i<widget.stories.length;i++){
      if(widget.stories[i].media!=""){
        if(widget.stories[i].isImage==true){
          storyItems.add(
              StoryItem.pageImage(
                  url: widget.stories[i].media!,
                  controller: controller,
                caption: widget.stories[i].text!,
              )
              );
        }else{
          storyItems.add(
              StoryItem.pageVideo(
                  widget.stories[i].media!,
                  controller: controller,
                  caption: widget.stories[i].text!,
              ));
        }
      }else{
        storyItems.add(
            StoryItem.text(title: widget.stories[i].text!, backgroundColor: Theme.of(context).scaffoldBackgroundColor,));
      }
    }

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          body: Stack(
            children: [
              StoryView(
                  storyItems: storyItems,
                  controller: controller, // pass controller here too
                  repeat: true, // should the stories be slid forever
                  onStoryShow: (s) {
                    int index = storyItems.indexOf(s);
                    print(index);
                    if(widget.storyID!=null){
                      FirebaseFirestore.instance.collection('stories')
                          .doc(widget.userID)
                          .collection("currentStories")
                          .doc(widget.storyID)
                          .collection('viewers')
                          .doc(uId)
                          .set({"read":true})
                          .then((value){
                         print("STORY VIEWED");
                      }).catchError((error){
                        print(error.toString());
                      });

                    }
                    cubit.changeStoryIndex(index: index,);
                    // print(s.duration);
                  },
                  onComplete: () {Get.back();},
                  onVerticalSwipeComplete: (direction) {
                    // print("asd");
                    if (direction == Direction.down) {
                      Navigator.pop(context);
                    }
                  }
              ),
              Padding(
                padding: EdgeInsets.only(top: 6.5.h),
                child: ShowStoryHead(
                    cubit: cubit,
                    profileImage: widget.profileImage,
                    name: widget.name,
                    story: widget.stories[cubit.storyCurrentIndex]
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

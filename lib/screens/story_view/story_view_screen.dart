import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/models/StoryModel.dart';
import 'package:chat/screens/story_view/show_story_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:story_view/story_view.dart';


class StoryViewScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final String profileImage;
  const StoryViewScreen({Key? key, required this.stories, required this.profileImage}) : super(key: key);

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
        storyItems.add(StoryItem.text(title: widget.stories[cubit.storyCurrentIndex].text!, backgroundColor: Colors.red,));
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
                    cubit.changeStoryIndex(index: index,);
                    // print(s.duration);
                  },
                  onComplete: () {Get.back();},
                  onVerticalSwipeComplete: (direction) {
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

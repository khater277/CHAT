import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/models/StoryModel.dart';
import 'package:chat/models/ViewerModel.dart';
import 'package:chat/screens/story_view/story_view_items/show_story_head.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/duration_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:story_view/story_view.dart';

import 'story_view_items/contact_story_items/reply_to_story.dart';
import 'story_view_items/my_story_items/my_story_viewers.dart';


class StoryViewScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final List<String>? storiesIDs;
  final String profileImage;
  final String name;
  final String userID;
  final String userToken;
  // final String? storyID;
  const StoryViewScreen({Key? key, required this.stories, required this.storiesIDs,
    required this.profileImage, required this.name, required this.userID, required this.userToken,}) : super(key: key);

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {

  @override
  Widget build(BuildContext context) {
    StoryController controller = StoryController();
    AppCubit cubit = AppCubit.get(context);
    List<StoryItem> storyItems = [];

    for(int i=0;i<widget.stories.length;i++){
      // id
      if(widget.stories[i].media!=""){
        if(widget.stories[i].isImage==true){
          storyItems.add(
              StoryItem.pageImage(
                  url: widget.stories[i].media!,
                  controller: controller,
                // caption: widget.stories[i].text!,
              )
              );
        }else{
          storyItems.add(
              StoryItem.pageVideo(
                  widget.stories[i].media!,
                  controller: controller,
                  duration: durationParser(duration: widget.stories[i].videoDuration!)
                  // caption: widget.stories[i].text!,
              ));
        }
      }else{
        storyItems.add(
            StoryItem.text(title: widget.stories[i].text!, backgroundColor: Theme.of(context).scaffoldBackgroundColor,));
      }
    }

    int index = 0;

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is AppSendStoryReplyState){
          Get.back();
        }
      },
      builder: (context,state){
        return Scaffold(
          body: Stack(
            children: [
              StoryView(
                  storyItems: storyItems,
                  controller: controller,
                  onStoryShow: (s) {
                    index = storyItems.indexOf(s);
                    debugPrint(index.toString());
                    if(widget.storiesIDs!=null){
                      List<ViewerModel> viewers = widget.stories[index].viewers!;
                      //contains(viewers.firstWhere((element) => element.id==uId))==false
                      if(viewers.firstWhereOrNull((element) => element.id==uId)==null){
                        viewers.add(ViewerModel(
                          id: uId,
                          phoneNumber: cubit.userModel!.phone,
                          dateTime: DateTime.now().toString()
                        ));
                        cubit.viewStory(
                            userID: widget.userID,
                            storyID: widget.storiesIDs![index],
                            viewers: viewers,
                            isLast: index==storyItems.length-1
                        );
                      }
                      debugPrint("${index==storyItems.length-1}");
                      debugPrint(widget.storiesIDs![index]);
                    }
                    cubit.changeStoryIndex(index: index,);
                    // print(s.duration);
                  },
                  onComplete: (){
                    debugPrint("COMPLETED");
                    Get.back();
                  },
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
                    name: widget.name,
                    story: widget.stories[cubit.storyCurrentIndex]
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        // height: 20.h,
                        margin: EdgeInsets.only(
                          bottom: 1.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        color: widget.stories[index].media != "" && widget.stories[index].text != "" ?
                        Colors.black54 : Colors.transparent,
                        child: widget.stories[index].media != "" && widget.stories[index].text != ""
                            ? Text(
                          widget.stories[index].text!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                            : const SizedBox(),
                      ),
                    ),
                  ),

                  if(widget.userID==uId)
                    MyStoryViewers(
                      viewers: widget.stories[index].viewers!,
                      storyController: controller,)
                  else
                    ReplyToStory(
                      cubit: cubit,
                      state: state,
                      storyController: controller,
                    userToken: widget.userToken,
                    userID: widget.userID,
                    name: widget.name,
                    text: widget.stories[index].text!,
                    storyMedia: widget.stories[index].media!,
                    storyDate: widget.stories[index].date!,
                    mediaSource: widget.stories[index].isImage==true?
                    MediaSource.image:widget.stories[index].isVideo==true?
                    MediaSource.video:null,),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}